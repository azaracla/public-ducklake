import * as duckdb from "@duckdb/duckdb-wasm";
import wasmUrl from "@duckdb/duckdb-wasm/dist/duckdb-eh.wasm?url";
import DuckDBWorker from "@duckdb/duckdb-wasm/dist/duckdb-browser-eh.worker.js?worker";
import annualUrl from "../data/finances_publiques/v2026-08-01/apu_annuel.parquet?url";
import quarterlyUrl from "../data/finances_publiques/v2026-08-01/dette_trimestrielle.parquet?url";
import oatUrl from "../data/finances_publiques/v2026-08-01/oat.parquet?url";

const COMMANDE_PUBLIQUE = "https://static.data.gouv.fr/resources/donnees-essentielles-de-la-commande-publique-fichiers-consolides/20260605-091141/decp-global.parquet";

const CATALOG = "https://raw.githubusercontent.com/azaracla/public-ducklake/main/data_gouv_catalog.ducklake";
let connection: duckdb.AsyncDuckDBConnection | undefined;

export class DataError extends Error {
  constructor(public kind: "catalogue" | "source" | "requete", cause: unknown) {
    super(`${kind === "requete" ? "La requête" : kind === "source" ? "Une source de données" : "Le catalogue"} a échoué : ${cause instanceof Error ? cause.message : String(cause)}`);
  }
}

export async function connect() {
  if (connection) return connection;
  const worker = new DuckDBWorker();
  const db = new duckdb.AsyncDuckDB(new duckdb.ConsoleLogger(), worker);
  await db.instantiate(wasmUrl);
  await db.open({ filesystem: { allowFullHTTPReads: true, reliableHeadRequests: true, forceFullHTTPReads: false } });
  const candidate = await db.connect();
  try {
    await Promise.all([
      db.registerFileURL("apu_annuel.parquet", annualUrl, duckdb.DuckDBDataProtocol.HTTP, false),
      db.registerFileURL("dette_trimestrielle.parquet", quarterlyUrl, duckdb.DuckDBDataProtocol.HTTP, false),
      db.registerFileURL("oat.parquet", oatUrl, duckdb.DuckDBDataProtocol.HTTP, false),
      db.registerFileURL("commande_publique.parquet", COMMANDE_PUBLIQUE, duckdb.DuckDBDataProtocol.HTTP, false),
    ]);
    await candidate.query(`
      CREATE SCHEMA finances_publiques;
      CREATE VIEW finances_publiques.apu_annuel AS FROM read_parquet('apu_annuel.parquet');
      CREATE VIEW finances_publiques.dette_trimestrielle AS FROM read_parquet('dette_trimestrielle.parquet');
      CREATE VIEW finances_publiques.oat AS FROM read_parquet('oat.parquet');
      CREATE SCHEMA economie;
      CREATE VIEW economie.commande_publique AS FROM read_parquet('commande_publique.parquet');
    `);
  } catch (error) {
    throw new DataError("source", error);
  }
  connection = candidate;
  void db.connect().then(async (catalogueConnection) => {
    try {
      await catalogueConnection.query(`ATTACH '${CATALOG}' AS dg (TYPE ducklake, READ_ONLY true)`);
      window.dispatchEvent(new CustomEvent("catalogue-status", { detail: "Catalogue DuckLake accessible" }));
    } catch (error) {
      window.dispatchEvent(new CustomEvent("catalogue-status", { detail: new DataError("catalogue", error).message }));
    } finally {
      await catalogueConnection.close();
    }
  });
  return connection;
}

export async function query(sql: string): Promise<Record<string, unknown>[]> {
  try {
    const result = await (await connect()).query(sql);
    return result.toArray().map((row) =>
      Object.fromEntries(Object.entries(row.toJSON()).map(([key, value]) => [key, typeof value === "bigint" ? Number(value) : value])),
    );
  } catch (error) {
    if (error instanceof DataError) throw error;
    throw new DataError("requete", error);
  }
}

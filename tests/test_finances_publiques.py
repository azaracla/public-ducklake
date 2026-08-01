import json
import io
import unittest
import zipfile

from scripts.build_finances_publiques import parse_apu_history, parse_aft, parse_annual, parse_eurostat


class ParserTests(unittest.TestCase):
    def test_insee_excerpt(self):
        sheets = {
            "Figure 3": [["Ensemble des administrations publiques", 0, 0, 0, 0, -152.5]],
            "Figure 4": [["Charges d'intérêts", 0, 0, 0, 0, 0, 0, 64.7]],
            "Figure 5": [
                ["État", 0, 0, 2822.7],
                ["Organismes divers d'administration centrale", 0, 0, 69.0],
                ["Administrations publiques locales", 0, 0, 275.7],
                ["Administrations de sécurité sociale", 0, 0, 293.1],
                ["Ensemble des administrations publiques", 3306.1, 0, 3460.5],
                ["En % du PIB", 112.6, 0, 115.7],
            ],
        }
        self.assertEqual(parse_annual(sheets)["debt_end"], 3460.5)

    def test_eurostat_excerpt(self):
        body = json.dumps(
            {
                "dimension": {"time": {"category": {"index": {"2025-01": 0}}}},
                "value": {"0": 3.32},
            }
        ).encode()
        self.assertEqual(parse_eurostat(body), [("2025-01", 3.32)])

    def test_apu_history_excerpt(self):
        rows = ["STO;REF_SECTOR;TIME_PERIOD;OBS_VALUE;CONSOLIDATION;UNIT_MEASURE;FREQ;ACCOUNTING_ENTRY"]
        for year in range(2019, 2026):
            rows.extend((f"B9;S13;{year};-10;C;XDC;A;B", f"D41;S13;{year};3;C;XDC;A;D"))
        body = io.BytesIO()
        with zipfile.ZipFile(body, "w") as archive:
            archive.writestr("DD_CNA_APU_data.csv", "\n".join(rows))
        self.assertEqual(parse_apu_history(body.getvalue())[2025], {"deficit": 10.0, "interest": 3.0})

    def test_aft_excerpt(self):
        body = b"| [FR001400FYQ4](https://www.aft.gouv.fr/fr/titre/x) | OAT 2,50 % 24 septembre 2026 | 24 030 000 000 |"
        row = parse_aft(body, "nominale", "2026-08-01")[0]
        self.assertEqual((row["coupon_pct"], row["encours_euros"]), (2.5, 24_030_000_000))


if __name__ == "__main__":
    unittest.main()

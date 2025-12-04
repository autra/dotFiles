#!/usr/bin/env python3
import argparse
import subprocess
import datetime
from collections import defaultdict
from tabulate import tabulate

ALLOWED_URLS = {
    "0000_19_rtt",
    "0000_20_cp",
    "0000_21_jnt",
    "0000_22_css",
    "0000_23_cm",
    "0000_24_jem",
    "0000_25_cpat",
    "0000_26_cnaiss",
    "0000_27_cpacs",
    "0000_28_cmar",
    "0000_32_cobs",
    "0000_37_cmat",
    "0000_40_cpar",
}

FORMAT = "{title} | {url} | {start} | {description}"


def last_day_of_month(year: int, month: int) -> int:
    if month == 12:
        return 31
    first = datetime.date(year, month, 1)
    next_month = datetime.date(year, month + 1, 1)
    return (next_month - first).days


def parse_event_line(line: str):
    parts = [p.strip() for p in line.split("|", 3)]
    if len(parts) != 4:
        return None
    return parts  # title, code_proj, date, description


def extract_duration(desc: str) -> float:
    import re

    m = re.search(r":clock1:\s*([0-9.]+)d", desc)
    return float(m.group(1)) if m else 1.0


def fetch_events(year: int, month: int | None):
    """Return a list of parsed events (title, code_proj, date, desc) with a single khal call."""

    if month:  # Single-month mode
        start = datetime.date(year, month, 1)
        end = datetime.date(year, month, last_day_of_month(year, month))
    else:  # Whole-year mode
        start = datetime.date(year, 1, 1)
        end = datetime.date(year, 12, 31)

    cmd = [
        "khal",
        "list",
        "--format",
        FORMAT,
        start.isoformat(),
        end.isoformat(),
    ]

    out = subprocess.check_output(cmd, text=True).splitlines()

    events = []
    for line in out:
        p = parse_event_line(line)
        if not p:
            continue
        title, code_proj, date, desc = p
        if code_proj in ALLOWED_URLS:
            events.append(p)

    return events


def main():
    parser = argparse.ArgumentParser(
        formatter_class=argparse.RawTextHelpFormatter,
        description=(
            "Liste les événements de congé du mois ou de l'année, en affichant "
            "les sommes d'imputation par type de congé.\n\n"
            "Dépendances:\n"
            "- python3 :-)\n"
            "- khal\n"
        ),
    )

    parser.add_argument("--year", required=True, help="Année à traiter (ex: 2025)")
    parser.add_argument(
        "--month", help="Mois à traiter (01–12). Si omis, traite l'année entière."
    )
    parser.add_argument(
        "-s", "--summary", action="store_true", help="Skip the first table display"
    )

    args = parser.parse_args()

    year = int(args.year)
    month = int(args.month) if args.month else None

    events = fetch_events(year, month)

    # table output
    if not args.summary:
        print(tabulate(events, headers=["title", "code_proj", "date", "description"], tablefmt="pretty"))

    # Summary
    totals = defaultdict(float)
    for _, code, _, desc in events:
        totals[code] += extract_duration(desc)

    print("Total duration per code_proj:")
    for code, total in sorted(totals.items()):
        print(f"{code} | {total} days")


if __name__ == "__main__":
    main()

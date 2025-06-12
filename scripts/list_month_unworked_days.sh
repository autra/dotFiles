#!/usr/bin/env bash

# Constants: Allowed URLs
ALLOWED_URLS=(
  "0000_19_rtt"
  "0000_20_cp" 
  "0000_21_jnt"
  "0000_22_css" 
  "0000_23_cm" 
  "0000_24_jem" 
  "0000_25_cpat" 
  "0000_26_cnaiss" 
  "0000_27_cpacs" 
  "0000_28_cmar" 
  "0000_32_cobs" 
  "0000_37_cmat"
  "0000_40_cpar" 
)
# Custom format for khal list: Extract title, URL, dates, and description
FORMAT="{title} | {url} | {start} | {description}"

# Show help message
if [[ "$1" == "--help" || "$1" == "-h" || -z "$1" ]]; then
    echo "Usage: $0 YYYY-MM"
    echo "Liste les événements de congé du mois, en affichant les sommes d'imputation par type de congé."
    echo
    echo "  YYYY-MM     Month to process (e.g., 2025-06)"
    echo "  -h, --help  Show this help message"
    echo
    echo "Dépendances:"
    echo "- bash :-)"
    echo "- coreutils ou busybox pour date, grep et xargs"
    echo "- column"
    echo "- khal"
    echo "- bc"
    exit 0
fi

# Extract year and month
YEAR=${1%-*}
MONTH=${1#*-}

# Compute last day of the month
LAST_DAY=$(date -d "$YEAR-$MONTH-01 +1 month -1 day" +"%d")

# Prepare the grep filter
grep_filter=$(IFS='|'; echo "${ALLOWED_URLS[*]}")

# Get events from khal and filter by allowed URLs using grep
EVENTS=$(khal list --format "$FORMAT" "$YEAR-$MONTH-01" "$YEAR-$MONTH-$LAST_DAY" | grep -E "$grep_filter")

# Filter by allowed URLs
{
  echo "title | code_proj | date | description"
  echo " ---- | ---- | ---- | ---- "
  echo "$EVENTS"
} | column -t -s '|' -o '|'

# Sum grouped by code_proj
declare -A SUMS

IFS=$'\n'
for line in $EVENTS; do
    IFS='|' read -r _ code_proj _ description <<< "$line"
    code_proj=$(echo "$code_proj" | xargs)  # Trim spaces
    description=$(echo "$description" | xargs)

    # Extract duration or default to 1
    if [[ $description =~ :clock1:\ ([0-9.]+)d ]]; then
        duration="${BASH_REMATCH[1]}"
    else
        duration=1
    fi

    # Sum durations
    SUMS["$code_proj"]=$(echo "${SUMS["$code_proj"]:-0} + $duration" | bc)
done

# Display summary
echo -e "\nTotal duration per code_proj:"
for code in "${!SUMS[@]}"; do
    echo "$code | ${SUMS[$code]} days"
done | column -t -s '|'

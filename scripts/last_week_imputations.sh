#!/usr/bin/env bash
set -e

if [ -z $AFFAIRES_REPERTOIRE ]; then
  echo "Please set AFFAIRES_REPERTOIRE variable"
  exit 1
fi

codeproj () {
  pushd $AFFAIRES_REPERTOIRE > /dev/null
  # yeah, I know, but find is less easy to use and I don't really care ;-)
	# shellcheck disable=SC2012
  ls | fzf --query="$1" --preview="grep -v '^#' {}/project.meta | grep -v '^$' | bat --color=always --language=ini" | tr -d '\n'
  popd > /dev/null
}

# Enable dry-run mode if -n is passed
DRY_RUN=false
if [[ "$1" == "-n" ]]; then
    DRY_RUN=true
    echo "Dry run mode activated"
fi

# Get last week's Monday and Friday
if [ -z "$MONDAY" ]; then
  MONDAY=$(date -d "monday last week" +%Y-%m-%d)
fi
if [ -z "$FRIDAY" ]; then
  FRIDAY=$(date -d "friday last week" +%Y-%m-%d)
fi
echo "Reviewing from $MONDAY to $FRIDAY"

# Generate dates from Monday to Friday
DATES=()
CURRENT_DAY="$MONDAY"
while [[ "$CURRENT_DAY" != "$(date -d "$FRIDAY +1 day" +%Y-%m-%d)" ]]; do
    DATES+=("$CURRENT_DAY")
    CURRENT_DAY=$(date -d "$CURRENT_DAY +1 day" +%Y-%m-%d)
done

for DAY in "${DATES[@]}"; do
    echo -e "\nChecking events for $DAY..."
    
    # Display existing events and replace ":clock1:" with ⏰
    khal list "$DAY" "$DAY" --format "{start} {title} {url} {description}" | sed 's/:clock1:/⏰/g' || echo "No full-day events found."

    read -rp "Is this day okay? (y/n) " OK
    if [[ "$OK" == "y" ]]; then
        continue
    fi

    read -rp "Create 1 or 2 events? (1/2) " COUNT

    for _ in $(seq 1 "$COUNT"); do
        read -rp "Enter event title: " TITLE
        URL=$(codeproj "$TITLE")

        DESC=""
        if [[ "$COUNT" == "2" ]]; then
            DESC=":clock1: 0.5d"
        fi

        CMD="khal new \"$DAY\" \"$TITLE\" --url \"$URL\" :: \"$DESC\""

        if $DRY_RUN; then
            echo "[DRY-RUN] $CMD"
        else
            eval "$CMD"
            echo "Created $DAY: $TITLE ($URL) $DESC"
        fi
    done
done

echo "Current state of last week:"
khal list "$MONDAY" "$FRIDAY"

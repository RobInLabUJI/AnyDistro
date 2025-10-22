DISTRO=iron

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

CALLER="${BASH_SOURCE[1]}"

if [[ -z "$CALLER" ]]; then
    source "$SCRIPT_DIR/../setup.bash"
    return 0
fi

CALLER_PATH="$(readlink -f "$CALLER")"
SOURCE_LINE=$(grep -n "source .*iron/setup\.bash" "$CALLER_PATH" | head -n 1 | cut -d: -f1)

TMP_SCRIPT=$(mktemp /tmp/inside-docker.XXXXXX.sh)
tail -n +$((SOURCE_LINE + 1)) "$CALLER_PATH" > "$TMP_SCRIPT"
chmod +x "$TMP_SCRIPT"

source "$SCRIPT_DIR/../setup.bash" "$TMP_SCRIPT"

rm -f "$TMP_SCRIPT"

kill -INT $$


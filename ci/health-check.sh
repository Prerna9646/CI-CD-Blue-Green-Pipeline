# ci/health-check.sh
#!/usr/bin/env bash
set -euo pipefail

URL="$1"
TIMEOUT="${2:-120}"   # total seconds to wait
INTERVAL="${3:-5}"    # seconds between tries

end=$((SECONDS + TIMEOUT))
while [ $SECONDS -lt $end ]; do
  echo "Checking $URL/health ..."
  code=$(curl -s -o /dev/null -w "%{http_code}" "$URL/health" || echo "000")
  if [ "$code" = "200" ]; then
    echo "Health OK: $URL"
    exit 0
  fi
  echo "Not ready (status $code). Waiting $INTERVAL s..."
  sleep "$INTERVAL"
done

echo "Health check failed after ${TIMEOUT}s for $URL"
exit 1
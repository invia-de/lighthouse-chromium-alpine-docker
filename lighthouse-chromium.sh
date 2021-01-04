#!/bin/sh
set -e

CURDATE=$(date +%Y-%m-%d_%H_%M_%S)
REPORTFILE="${OUTPUT_PATH}/${CURDATE}.lighthouse.report.json"
/usr/local/bin/lighthouse --chrome-flags="--no-sandbox --headless --disable-gpu" --no-enable-error-reporting --output json --output-path=${REPORTFILE} "$@"
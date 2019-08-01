#!/bin/sh
set -e

CURDATE=$(date +%Y-%m-%d_%H_%M_%S)
REPORTFILE="${OUTPUT_PATH}/${CURDATE}.lighthouse.report.json"
/usr/local/bin/lighthouse --chrome-flags="--no-sandbox --headless --disable-gpu" --no-enable-error-reporting --output json --output-path=${REPORTFILE} "$@"
if [ "$?" == "0" ]; then
   echo "Uploading to github gists"
   GISTS="$(gists new 1 "Report from ${CURDATE}" ${REPORTFILE})"
   if [ "$?" == "0" ]; then
      GISTID="$(echo ${GISTS} | cut -d "'" -f2)"
   fi
   echo ${GISTS}
   echo "Report available under https://googlechrome.github.io/lighthouse/viewer/?gist=${GISTID}"
fi

#!/bin/sh
set -e

CURDATE=$(date +%Y-%m-%d_%H_%M_%S)
REPORTFILE="${OUTPUT_PATH}/${CURDATE}.lighthouse.report.json"
/usr/local/bin/lighthouse --chrome-flags="--no-sandbox --headless --disable-gpu" --no-enable-error-reporting --output json --output-path=${REPORTFILE} "$@"
if [ "$?" == "0" ]; then
   echo "Uploading to github gists"
   gh auth login --scopes gists --with-token < ~/.git-credentials
   if [ "$?" != "0" ]; then
      echo "Unable to login"
      exit 1
   fi
   GISTS="$(gh gist create --public --desc "Report from ${CURDATE}" ${REPORTFILE})"
   if [ "$?" == "0" ]; then
      GISTID="$(echo ${GISTS} | cut -d "/" -f4)"
   fi
   echo ${GISTS}
   echo "Report available under https://googlechrome.github.io/lighthouse/viewer/?gist=${GISTID}"
fi

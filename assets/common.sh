payload=$(mktemp $TMPDIR/alertmanager-resource-request.XXXXXX)

cat > ${payload} <&0

url=$(jq -r '.source.url // ""' < ${payload})
if [[ -z "${url}" ]]; then
  echo >&2 "must specify 'url' source"
  exit 1
fi

operation="$(jq -r '.params.operation // ""' < ${payload})"
matchers="$(jq -r '.params.matchers // ""' < ${payload})"
creator="$(jq -r '.params.creator // ""' < ${payload})"
comments="$(jq -r ".params.comments // \"Silence added by CI pipeline ${ATC_EXTERNAL_URL}/teams/${BUILD_TEAM_NAME}/pipelines/${BUILD_PIPELINE_NAME}/jobs/${BUILD_JOB_NAME}/builds/${BUILD_NAME}\"" < ${payload})"
expires="$(jq -r '.params.expires // "1h"' < ${payload})"
silence="$(jq -r '.params.silence // ""' < ${payload})"

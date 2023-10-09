#!/bin/bash
set -euo pipefail
SOURCE_DIR=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)

GH="gh"

RELEASE_NAME=$(git describe --tags)
echo "Logging in to GitHub with access token"
if [ -z "${GITHUB_ACCESS_TOKEN:-}" ]
then
  echo "GITHUB_ACCESS_TOKEN not set"
  exit 1
fi
echo "${GITHUB_ACCESS_TOKEN}" | $GH auth login --with-token

cd "${SOURCE_DIR}"
echo "Creating release. Note: Job can only run once per tag, to rerun create a new tag or manually delete the existing release."
$GH release create --latest --title "${RELEASE_NAME}" --notes "Chain test data ${RELEASE_NAME}" "${RELEASE_NAME}"

echo "Uploading chain data to release"
$GH release upload "${RELEASE_NAME}" ${SOURCE_DIR}/optimism/op-program/compat-tests/*.tar.bz

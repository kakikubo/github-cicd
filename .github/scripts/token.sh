#!/usr/bin/env bash
set -euo pipefail

base64url() {
  openssl enc -base64 -A | tr '+/' '-_' | tr -d '='
}

sign() {
  openssl dgst -binary -sha256 -sign <(printf '%s' "${PRIVATE_KEY}")
}

# 取得値が空または null の場合はエラー終了する
require_value() {
  local name="$1" value="$2"
  if [ -z "${value}" ] || [ "${value}" = "null" ]; then
    echo "::error::${name} の取得に失敗しました" >&2
    exit 1
  fi
}

# JWTの生成
header="$(printf '{"alg":"RS256","typ":"JWT"}' | base64url)"
now="$(date '+%s')"
iat="$((now - 60))"
exp="$((now + (3 * 60)))"
template='{"iss":"%s","iat":%s,"exp":%s}'
# shellcheck disable=SC2059 # テンプレート文字列をフォーマットとして使う
payload="$(printf "${template}" "${APP_ID}" "${iat}" "${exp}" | base64url)"
signature="$(printf '%s' "${header}.${payload}" | sign | base64url)"
echo "::add-mask::${signature}"
jwt="${header}.${payload}.${signature}"
echo "::add-mask::${jwt}"

# Installation APIの実行（--fail-with-body で HTTP エラー時は非ゼロ終了する）
repo="${GITHUB_REPOSITORY_OWNER}/${TARGET_REPO}"
installation_id="$(curl --fail-with-body --location --silent --show-error --request GET \
  --url "${GITHUB_API_URL}/repos/${repo}/installation" \
  --header "Accept: application/vnd.github+json" \
  --header "X-Github-Api-Version: 2022-11-28" \
  --header "Authorization: Bearer ${jwt}" \
  | jq -r '.id'
)"
require_value "installation ID" "${installation_id}"

# Access Tokens APIの実行
token="$(curl --fail-with-body --location --silent --show-error --request POST \
  --url "${GITHUB_API_URL}/app/installations/${installation_id}/access_tokens" \
  --header "Accept: application/vnd.github+json" \
  --header "X-Github-Api-Version: 2022-11-28" \
  --header "Authorization: Bearer ${jwt}" \
  --data "$(printf '{"repositories":["%s"]}' "${TARGET_REPO}")" \
  | jq -r '.token'
)"
require_value "installation access token" "${token}"
echo "::add-mask::${token}"
echo "token=${token}" >> "${GITHUB_OUTPUT}"

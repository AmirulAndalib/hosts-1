#!/usr/bin/env bats

load test_helper

# `hosts block` #################################################################

@test "\`block\` with no arguments exits with status 1." {
  run "${_HOSTS}" block
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ ${status} -eq 1 ]]
}

@test "\`block\` with no argument does not change the hosts file." {
  _original="$(cat "${HOSTS_PATH}")"

  run "${_HOSTS}" block
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ "$(cat "${HOSTS_PATH}")" == "${_original}" ]]
}

@test "\`block\` with no arguments prints help information." {
  run "${_HOSTS}" block
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ "${lines[0]}" == "Usage:" ]]
  [[ "${lines[1]}" == "  hosts block <hostname>" ]]
}

# `hosts block <hostname>` #################################################

@test "\`block <hostname>\` exits with status 0." {
  run "${_HOSTS}" block example.com
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ ${status} -eq 0 ]]
}

@test "\`block <hostname>\` adds entries to the hosts file." {
  _original="$(cat "${HOSTS_PATH}")"

  run "${_HOSTS}" block example.com
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  _compare "${_original}" "$(cat "${HOSTS_PATH}")"
  _compare '127.0.0.1	example.com' "$(sed -n '11p' "${HOSTS_PATH}")"
  [[ "$(cat "${HOSTS_PATH}")" != "${_original}" ]]
  [[ "$(sed -n '11p' "${HOSTS_PATH}")" == "127.0.0.1	example.com" ]]
}

@test "\`block <hostname>\` prints feedback." {
  run "${_HOSTS}" block example.com
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ "${lines[0]}" == "Added:" ]]
  [[ "${lines[1]}" == "127.0.0.1	example.com" ]]
  [[ "${lines[2]}" == "Added:" ]]
  [[ "${lines[3]}" == "fe80::1%lo0	example.com" ]]
  [[ "${lines[4]}" == "Added:" ]]
  [[ "${lines[5]}" == "::1	example.com" ]]
}

# help ########################################################################

@test "\`help block\` exits with status 0." {
  run "${_HOSTS}" help block
  [[ ${status} -eq 0 ]]
}

@test "\`help block\` prints help information." {
  run "${_HOSTS}" help block
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ "${lines[0]}" == "Usage:" ]]
  [[ "${lines[1]}" == "  hosts block <hostname>" ]]
}

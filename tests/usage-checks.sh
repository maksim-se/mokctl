cd e2e/crm114/ || exit 1

retval=0

for i in build create delete exec get; do
  crmthinks=$(crm usage_match.crm <<<"$(mokctl "${i}" -h)" | sed -n '2p' |
    grep -Eo '(BUILD_USAGE|CREATE_USAGE|DELETE_USAGE|EXEC_USAGE|GET_USAGE)')
  status="GOOD"
  [[ ${crmthinks} != "${i^^}_USAGE" ]] && {
    status="!! BAD !!"
    retval=1
  }
  printf '%s - CRM114 thinks output from '\''mokctl %s -h'\'' is %s.\n' \
    "${status}" "${i}" "${crmthinks}"
done

exit "${retval}"

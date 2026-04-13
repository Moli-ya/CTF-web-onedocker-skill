#!/bin/sh
set -eu

FLAG_VALUE=""
if [ -n "${FLAG:-}" ]; then
    FLAG_VALUE="${FLAG}"
elif [ -n "${A1CTF_FLAG:-}" ]; then
    FLAG_VALUE="${A1CTF_FLAG}"
elif [ -n "${GZCTF_FLAG:-}" ]; then
    FLAG_VALUE="${GZCTF_FLAG}"
else
    echo "error! please_call_admin"
    exit 1
fi

printf '%s' "${FLAG_VALUE}" > /flag
chmod 400 /flag

unset FLAG A1CTF_FLAG GZCTF_FLAG
FLAG_VALUE=""

php-fpm -D
exec nginx -g 'daemon off;'

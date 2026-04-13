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

if [ ! -d /var/lib/mysql/mysql ]; then
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql >/dev/null
fi

/usr/bin/mysqld --user=mysql --datadir=/var/lib/mysql --bind-address=127.0.0.1 &

for i in $(seq 1 30); do
    if mysqladmin ping -uroot --silent >/dev/null 2>&1; then
        break
    fi
    sleep 1
done

mysql -uroot <<'SQL'
CREATE DATABASE IF NOT EXISTS ctf;
CREATE USER IF NOT EXISTS 'ctf'@'127.0.0.1' IDENTIFIED BY 'ctfpass';
GRANT ALL PRIVILEGES ON ctf.* TO 'ctf'@'127.0.0.1';
FLUSH PRIVILEGES;
SQL

mysql -uroot ctf <<'SQL'
CREATE TABLE IF NOT EXISTS notes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(64) NOT NULL,
    content TEXT NOT NULL
);
INSERT INTO notes (title, content)
VALUES ('hello', 'mysql is ready')
ON DUPLICATE KEY UPDATE content = VALUES(content);
SQL

php-fpm -D
exec nginx -g 'daemon off;'

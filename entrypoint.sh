#!/bin/bash

echo "Starting rattic with $@"

# should be exported by linked postgres image
: "${POSTGRES_PORT_5432_TCP_ADDR:=postgres}"
: "${POSTGRES_PORT_5432_TCP_PORT:=5432}"

# configration for rattic
: "${DEBUG:=false}"
: "${LOGLEVEL:=ERROR}"
: "${HOSTNAME:=localhost}"
: "${TIMEZONE:=UTC}"
: "${SECRETKEY:=areallybadsecretkeypleasechangebeforeusinginproduction}"
: "${PASSWORD_EXPIRY_DAYS:=360}"
: "${POSTGRES_HOSTNAME:=$POSTGRES_PORT_5432_TCP_ADDR}"
: "${POSTGRES_PORT:=$POSTGRES_PORT_5432_TCP_PORT}"
: "${POSTGRES_DBNAME:=postgres}"
: "${POSTGRES_USERNAME:=postgres}"

cat > /opt/rattic/conf/local.cfg <<EOF
[ratticweb]
debug = $DEBUG
loglevel = $LOGLEVEL
hostname = $HOSTNAME
timezone = $TIMEZONE
secretkey = $SECRETKEY
passwordexpirydays = $PASSWORD_EXPIRY_DAYS

[filepaths]
static = /opt/rattic/static

[database]
engine = django.db.backends.postgresql_psycopg2
host = $POSTGRES_HOSTNAME
port = $POSTGRES_PORT
name = $POSTGRES_DBNAME
user = $POSTGRES_USERNAME
EOF

if [ -n "$POSTGRES_PASSWORD" ]; then
cat >> /opt/rattic/conf/local.cfg <<EOF
password = $POSTGRES_PASSWORD
EOF
fi

cd /opt/rattic
# for debugging config
[ 'false' != "$DEBUG" ] && cat conf/local.cfg

case "$1" in
    deploy)
        ./manage.py syncdb --noinput
        exec ./manage.py migrate --all # south
        ;;
    demosetup)
        exec ./manage.py demosetup
        ;;
    runserver)
        exec ./manage.py runserver --insecure 0.0.0.0:8000
        ;;
    serve)
        exec gunicorn -b 0.0.0.0:8000 ratticweb.wsgi
        ;;
    *)
        exec sh -c "$@"
        ;;
esac

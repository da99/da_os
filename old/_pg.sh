
export PG_VERSION="${PG_VERSION:-18}"
export PGUSER="${PGUSER:-www_app}"
export PGDATABASE="${PGDATABASE:-$(pg_default_db)}"

if is_dev ; then
  export PG_COLOR=auto
fi

if test -d /data ; then
  export PGDATA="${PGDATA:-/data/pgsql/data}"
  export PGHOST="${PGHOST:-/data/pgsql/tmp}"
else
  export PGDATA="${PGDATA:-/progs/pg/$PG_VERSION/data}"
  export PGHOST="${PGHOST:-/progs/pg/$PG_VERSION/tmp}"
  export PG_HOME="${PG_HOME:-/progs/pg}"
  if ! is_dev ; then
    if [[ ! -d /progs/ ]] ; then
      warn "/progs and /data do not exist."
    fi
  fi
fi

if [[ -d /home/postgres ]] ; then
  export PG_HOME="${PG_HOME:-/home/postgres}"
else
  export PG_HOME="${PG_HOME:-/progs/postgres}"
  if ! "$DA_OS_DIR"/base/is_dev ; then
    if [[ ! -d "$PG_HOME" ]] ; then
      warn "$PG_HOME do not exist."
    fi
  fi
fi

if test -e "/usr/pgsql-${PG_VERSION}/bin" ; then
  PATH="/usr/pgsql-${PG_VERSION}/bin:$PATH"
else
  if test -e /progs/pg ; then
    while read -r bin ; do
      PATH="${bin}:$PATH"
    done < <(find /progs/pg -maxdepth 2 -mindepth 2 -type d -name bin)
  fi
fi

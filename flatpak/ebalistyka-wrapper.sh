#!/bin/sh
APP=/app/ebalistyka
export LD_LIBRARY_PATH="$APP/lib:${LD_LIBRARY_PATH:-}"
export PATH="/app/bin:/usr/bin:/usr/local/bin:${PATH:-}"
exec "$APP/ebalistyka" "$@"

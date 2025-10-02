#!/usr/bin/sh
# makeself --nocrc --nomd5 --tar-quietly --xz . ~/bin/dsp-w215.run dsp-w215-hnap ./run.sh
exec node app.js "$@"

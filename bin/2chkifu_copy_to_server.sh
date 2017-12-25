#!/bin/sh
rsync -avzq --exclude=".git" --delete ~/src/shogi_web/README.org s:/tmp
ssh s ls -al /tmp/README.org

rsync -avzq --exclude=".git" --delete ~/src/2chkifu s:~/
ssh s ls -al "~/2chkifu"

echo "done"

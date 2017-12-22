#!/bin/sh
rsync -avz --delete ~/src/shogi_web/README.org s:/tmp
ssh s ls -al /tmp

rsync -avz --delete ~/src/2chkifu s:~/
ssh s ls -al

#!/bin/sh
cd $(dirname $0)/..
cd nuxt_side

# 無条件に更新していいもの
ncu /lodash/ -u
ncu /howl/ -u
ncu /buefy/ -u
ncu /bulma/ -u
ncu /actioncable/ -u
ncu /js-memory-record/ -u
ncu /shogi-player/ -u

# 更新するとやばいもの
# ncu /chart/ -u
# ncu /pug/ -u
# pnpm i

# Githubから取り込んでいる場合
npm install github:akicho8/shogi-player#main

npm install

grep shogi-player.git ~/src/shogi/shogi-extend/nuxt_side/package-lock.json

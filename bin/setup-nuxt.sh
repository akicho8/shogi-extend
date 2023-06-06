#!/bin/sh
cd $(dirname $0)/..
cd nuxt_side

# 無条件に更新していいもの
ncu /lodash/ -u
ncu /howl/ -u
ncu /buefy/ -u
ncu /bulma/ -u
ncu /actioncable/ -u
ncu /shogi-player/ -u
ncu /js-memory-record/ -u

# 更新するとやばいもの
# ncu /chart/ -u
# ncu /pug/ -u

npm i

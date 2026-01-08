# -*- coding: utf-8; compile-command: "scp custom_profile.sh i:/etc/profile.d" -*-

export NODENV_ROOT=/usr/local/nodenv
export PATH="$NODENV_ROOT/bin:$PATH"
eval "$(nodenv init -)"

export RBENV_ROOT=/usr/local/rbenv
export PATH="$RBENV_ROOT/bin:$PATH"
eval "$(rbenv init -)"

export PASSENGER_INSTANCE_REGISTRY_DIR=/var/run/passenger-instreg

# bundle binstubs --path .bin
export PATH=".bin:$PATH"

# for logrtate
export PATH="/usr/sbin:$PATH"

# rbenv install 4.0.0 を通すために必要
# 拡張ライブラリのインストール時に失敗しそうなので念のため gcc 4.8.5 -> 11.2.1 を固定化する
source scl_source enable devtoolset-11

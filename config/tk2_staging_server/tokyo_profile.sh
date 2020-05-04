# -*- coding: utf-8; compile-command: "scp tokyo_profile.sh s:/etc/profile.d" -*-

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


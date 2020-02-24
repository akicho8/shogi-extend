# -*- coding: utf-8; compile-command: "scp ishikari_profile.sh i:/etc/profile.d" -*-

export NODENV_ROOT=/usr/local/nodenv
export PATH="$NODENV_ROOT/bin:$PATH"
eval "$(nodenv init -)"

export RBENV_ROOT=/usr/local/rbenv
export PATH="$RBENV_ROOT/bin:$PATH"
eval "$(rbenv init -)"

export PASSENGER_INSTANCE_REGISTRY_DIR=/var/run/passenger-instreg

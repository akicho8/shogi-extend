#!/usr/bin/env ruby
require File.expand_path('../../../config/environment', __FILE__)
ForeignKey.disabled

# https://shogiwars.heroz.jp/games/tosssy-muaqua2023-20231101_204103?locale=ja

# tp Swars.info

info = Swars::Agent::Record.new(remote_run: true, key: Swars::BattleKey["tosssy-muaqua2023-20231101_204103"]).fetch
tp Swars::Agent::PropsAdapter.new(info).to_h
# >> |-----------+-----------------------------------|
# >> |   対局KEY | tosssy-muaqua2023-20231101_204103 |
# >> |  対局日時 | 2023-11-01 20:41:03               |
# >> |    ルール | 10分                              |
# >> |      種類 | 野良                              |
# >> |    手合割 | 平手                              |
# >> |      結末 | 投了                              |
# >> |  両者名前 | tosssy:三段 vs muaqua2023:五段    |
# >> |  勝った側 | △                                |
# >> | 対局後か? | true                              |
# >> | 対局中か? | false                             |
# >> | 正常終了? | true                              |
# >> | 棋譜有り? | true                              |
# >> |  棋譜手数 | 96                                |
# >> |-----------+-----------------------------------|

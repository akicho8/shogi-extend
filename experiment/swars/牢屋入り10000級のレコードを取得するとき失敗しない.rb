#!/usr/bin/env ruby
require File.expand_path('../../../config/environment', __FILE__)
ForeignKey.disabled
info = Swars::Agent::Record.new(remote_run: true, key: Swars::BattleKey["PawlWalker-aska_0826-20230301_223917"]).fetch
tp Swars::Agent::PropsAdapter.new(info).to_h
# >> |-----------+--------------------------------------|
# >> |   対局KEY | PawlWalker-aska_0826-20230301_223917 |
# >> |  対局日時 | 2023-03-01 22:39:17                  |
# >> |    ルール | 10分                                 |
# >> |      種類 | 友達                                 |
# >> |    手合割 | 平手                                 |
# >> |      結末 | 投了                                 |
# >> |  両者名前 | PawlWalker:10000級 vs aska_0826:30級 |
# >> |  勝った側 | △                                   |
# >> | 対局後か? | true                                 |
# >> | 対局中か? | false                                |
# >> | 正常終了? | true                                 |
# >> | 棋譜有り? | true                                 |
# >> |  棋譜手数 | 24                                   |
# >> |-----------+--------------------------------------|

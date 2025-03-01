#!/usr/bin/env ruby
require File.expand_path('../../../config/environment', __FILE__)

# PonaInfinity
# DM9
# H_Kirara

# agent = Swars::Agent::History.new(remote_run: true, user_key: "testarossa00", page_index: 0, rule_key: :ten_min)
# agent.history_url               # => "https://shogiwars.heroz.jp/games/history?gtype=&page=1&user_id=testarossa00"
# https://shogiwars.heroz.jp/games/history?gtype=&page=1&user_id=testarossa00

# https://shogiwars.heroz.jp/games/history?locale=ja&user_id=muaqua2023

# history_box = Swars::Agent::History.new(remote_run: true, user_key: "testarossa00", page_index: 0, rule_key: :ten_min).fetch
# tp history_box.all_keys

history_box = Swars::Agent::History.new(remote_run: true, user_key: "muaqua2023", page_index: 0, rule_key: :ten_min).fetch
tp history_box.all_keys

# tp history_box.all_keys.collect { |key| Swars::Agent::Record.new(remote_run: true, key: key).fetch }
# >> |-------------------------------------------|
# >> | tosssy-muaqua2023-20231101_204103         |
# >> | SuperBeber-muaqua2023-20231029_164245     |
# >> | aotamaaaa-muaqua2023-20231029_163103      |
# >> | nekonekowanwan-muaqua2023-20231029_162552 |
# >> | muaqua2023-70gogo-20231029_161655         |
# >> | pirokichikun-muaqua2023-20231029_120556   |
# >> | muaqua2023-Enfield-20231029_114914        |
# >> | muaqua2023-Sina123-20231029_112747        |
# >> | SUPER6DANN-muaqua2023-20231027_212928     |
# >> | muaqua2023-RealSaruin-20231027_212818     |
# >> |-------------------------------------------|

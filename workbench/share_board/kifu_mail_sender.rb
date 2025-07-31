require "#{__dir__}/setup"
tp ShareBoard::KifuMailSender.new(KifuMailAdapter.mock_params).call
# >> 2025-07-31T06:20:25.356Z pid=33444 tid=ris INFO: Sidekiq 7.3.9 connecting to Redis with options {size: 10, pool_name: "internal", url: "redis://localhost:6379/4"}
# >> |---------+---------------------------------------------|
# >> | message | shogi.extend+bot@gmail.com 宛に送信しました |
# >> |---------+---------------------------------------------|

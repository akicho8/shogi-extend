class SbxRuleInfo
  include ApplicationMemoryRecord
  memory_record [
    { key: "rule_self_0_10_60_0", members_count_max: 1, },
    { key: "rule_1vs1_0_10_60_0", members_count_max: 2, },
    { key: "rule_2vs2_0_10_60_0", members_count_max: 4, },
    { key: "rule_4vs4_0_10_60_0", members_count_max: 8, },
  ]

  class << self
    def sbx_info
      inject({}) do |a, e|
        sbx_members = redis.hvals(e.redis_key).collect { |e| JSON.parse(e) }
        a.merge(e.key => sbx_members)
      end
    end

    def redis
      ShareBoard::LobbyChannel.redis
    end
  end

  delegate :redis, to: "self.class"

  def member_add(data)
    # redis.flushdb
    # redis.hdel(redis_key, data["current_user_id"])

    self.class.each do |e|
      if e.key != key
        redis.hdel(e.redis_key, data["current_user_id"])
      end
    end

    redis.hset(redis_key, data["current_user_id"], data.to_json) # 初回なら true
    size = redis.hlen(redis_key)
    h = {}
    if size >= members_count_max
      h[:room_code] = SecureRandom.hex
      member_infos = redis.hvals(redis_key).collect { |e| JSON.parse(e) }
      member_names = member_infos.collect { |e| e["from_user_name"] } # シャッフル可
      h[:member_names] = member_names
    end
    h
  end

  def redis_key
    [self.class.name.underscore, key].join("/")
  end
end

# require "redis"
# r = Redis.new
# r.select(0)
# r.flushdb
# r.hset("key", "a", "v1") # => true
# r.hset("key", "b", "v2") # => true
# r.hset("key", "c", "-")  # => true
# r.hset("key", "c", "v3") # => false
# r.hlen("key")            # => 3
# r.hdel("key", "b")       # => 1
# r.hdel("key", "b")       # => 0
# r.hgetall("key")         # => {"a"=>"v1", "c"=>"v3"}
# r.hset("key", "b", "v2") # => true
# r.hvals("key")           # => ["v1", "v3", "v2"]
#
class XmatchRuleInfo
  include ApplicationMemoryRecord
  memory_record [
    # nuxt_side/components/models/xmatch_rule_info.js
    { key: "rule_1vs1_10_15_00_0",         members_count_max: 2, name: "10分",     },
    { key: "rule_1vs1_03_10_00_0",         members_count_max: 2, name: "3分",      },
    { key: "rule_1vs1_00_10_60_0",         members_count_max: 2, name: "10秒",     },

    { key: "rule_1vs1_05_00_00_5",         members_count_max: 2, name: "1 vs 1",   },
    { key: "rule_2vs2_05_00_00_5",         members_count_max: 4, name: "2 vs 2",   },
    { key: "rule_3vs3_05_00_00_5",         members_count_max: 6, name: "3 vs 3",   },
    { key: "rule_4vs4_05_00_00_5",         members_count_max: 8, name: "4 vs 4",   },

    { key: "rule_self_05_00_00_5",         members_count_max: 1, name: "対自分",   },
    { key: "rule_2vs2_05_00_00_5_pRvsB",   members_count_max: 4, name: "飛 vs 角", },

    { key: "rule_1vs1_05_00_00_5_pRvsB",   members_count_max: 2, name: "飛1vs1角", },
    { key: "rule_self_0_30_00_0_preset00", members_count_max: 1, name: "*☗視点",   },
    { key: "rule_self_0_30_00_0_preset19", members_count_max: 1, name: "*☖視点",   },
  ]

  class << self
    # rails r 'tp XmatchRuleInfo.xmatch_rules_members'
    def xmatch_rules_members
      inject({}) { |a, e| a.merge(e.key => e.values) }
    end

    # 特定のメンバーを全体から削除する
    def member_delete(data)
      if any? { |e| redis.hdel(e.redis_key, data["from_connection_id"]) == 1 }
        { delete_result: "deleted" }
      else
        { delete_result: "not_deleted" }
      end
    end

    def clear_all
      redis.flushdb
    end

    def redis
      ShareBoard::LobbyChannel.redis
    end
  end

  delegate :redis, :clear_all, to: "self.class"

  def member_add(data)
    raise ArgumentError, data.inspect if data["from_connection_id"].blank?
    raise ArgumentError, data.inspect if data["xmatch_redis_ttl"].blank?
    raise ArgumentError, data.inspect if data["performed_at"].blank?

    other_rule_delete(data) # 他のルールを選択している場合はいったん削除する
    redis.multi do |e|
      e.hset(redis_key, data["from_connection_id"], data.to_json) # 初回なら true
      e.expire(redis_key, data["xmatch_redis_ttl"])
    end

    h = {}
    if members_count >= members_count_max
      h[:room_key] = StringSupport.secure_random_urlsafe_base64_token
      h[:members] = matched_members
    end
    h
  end

  def redis_key
    [self.class.name.underscore, key].join("/")
  end

  def values
    redis.hvals(redis_key).collect { |e| JSON.parse(e) }
  end

  private

  # 他のルールを選択している場合はいったん削除する
  def other_rule_delete(data)
    self.class.each do |e|
      if e.key != key
        redis.hdel(e.redis_key, data["from_connection_id"])
      end
    end
  end

  # このルールを選択しているメンバー数
  def members_count
    redis.hlen(redis_key)
  end

  def matched_members
    keys = redis.hkeys(redis_key).take(members_count_max) # キーたちを members_count_max 件に絞る
    values = redis.hmget(redis_key, *keys)                # 値たちを取得
    redis.hdel(redis_key, *keys)                          # DBから削除
    members = values.collect { |e| JSON.parse(e) }
    members = members.sort_by { |e| e["performed_at"] }   # エントリー順にする
    if Rails.env.production? || Rails.env.staging?
      members = members.shuffle
    end
    members
  end
end

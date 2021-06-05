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
    # front_app/components/models/xmatch_rule_info.js
    { key: "rule_2vs2_0_10_60_0",          members_count_max: 4, },
    { key: "rule_3vs3_0_10_60_0",          members_count_max: 6, },
    { key: "rule_4vs4_0_10_60_0",          members_count_max: 8, },
    { key: "rule_1vs1_0_10_60_0",          members_count_max: 2, },
    { key: "rule_1vs1_0_10_60_0_pRvsB",    members_count_max: 2, },
    { key: "rule_self_0_03_60_0",          members_count_max: 1, },
    { key: "rule_self_0_30_00_0_preset00", members_count_max: 1, },
    { key: "rule_self_0_30_00_0_preset19", members_count_max: 1, },
  ]

  class << self
    # rails r 'tp XmatchRuleInfo.xmatch_rules_members'
    def xmatch_rules_members
      inject({}) { |a, e| a.merge(e.key => e.values) }
    end

    # 特定のメンバーを全体から削除する
    def member_delete(data)
      each { |e| redis.hdel(e.redis_key, data["from_connection_id"]) }
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
    redis.multi do
      redis.hset(redis_key, data["from_connection_id"], data.to_json) # 初回なら true
      redis.expire(redis_key, data["xmatch_redis_ttl"])
    end

    h = {}
    if members_count >= members_count_max
      h[:room_code] = ApplicationRecord.secure_random_urlsafe_base64_token
      h[:members] = matched_members
    end
    h[:xmatch_rules_members] = XmatchRuleInfo.xmatch_rules_members

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

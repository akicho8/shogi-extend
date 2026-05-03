# # 接続（Registry経由を想定）
# r = RedisClient.new
#
# # 初期化
# r.call("FLUSHDB")
#
# # HSET: 新規追加は 1、更新は 0 が返る
# r.call("HSET", "key", "a", "v1") # => 1 (旧 gem の true 相当)
# r.call("HSET", "key", "b", "v2") # => 1
# r.call("HSET", "key", "c", "-")  # => 1
# r.call("HSET", "key", "c", "v3") # => 0 (旧 gem の false 相当)
#
# # HLEN: 要素数(Integer)
# r.call("HLEN", "key")            # => 3
#
# # HDEL: 削除成功は 1、存在しなければ 0
# r.call("HDEL", "key", "b")       # => 1
# r.call("HDEL", "key", "b")       # => 0
#
# # HGETALL:
# # ここが重要！ redis-client の HGETALL は Hash ではなく「平坦な配列」を返す
# # ["a", "v1", "c", "v3"]
# res = r.call("HGETALL", "key")
# # Hash に変換する場合
# hash_res = Hash[*res]            # => {"a"=>"v1", "c"=>"v3"}
#
# # HSET 再開
# r.call("HSET", "key", "b", "v2") # => 1
#
# # HVALS: 値の配列
# r.call("HVALS", "key")           # => ["v1", "v3", "v2"]

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
      if any? { |e| redis.call("HDEL", e.redis_key, data["from_connection_id"]) == 1 }
        { delete_result: "deleted" }
      else
        { delete_result: "not_deleted" }
      end
    end

    def clear_all
      redis.call("FLUSHDB")
    end

    def redis
      @redis ||= RedisPool.client(AppConfig.fetch(:redis_db_for_share_board_lobby))
    end
  end

  delegate :redis, :clear_all, to: "self.class"

  def member_add(data)
    raise ArgumentError, data.inspect if data["from_connection_id"].blank?
    raise ArgumentError, data.inspect if data["xmatch_redis_ttl"].blank?
    raise ArgumentError, data.inspect if data["performed_at"].blank?

    other_rule_delete(data) # 他のルールを選択している場合はいったん削除する

    redis.multi do |e|
      e.call("HSET", redis_key, data["from_connection_id"], data.to_json) # 初回なら 1
      e.call("EXPIRE", redis_key, data["xmatch_redis_ttl"])
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
    redis.call("HVALS", redis_key).collect { |e| JSON.parse(e) }
  end

  private

  # 他のルールを選択している場合はいったん削除する
  def other_rule_delete(data)
    self.class.each do |e|
      if e.key != key
        redis.call("HDEL", e.redis_key, data["from_connection_id"])
      end
    end
  end

  # このルールを選択しているメンバー数
  def members_count
    redis.call("HLEN", redis_key)
  end

  def matched_members
    # HKEYS はキーの配列を返す
    keys = redis.call("HKEYS", redis_key).take(members_count_max) # キーたちを members_count_max 件に絞る

    # HMGET key field1 field2 ...
    # 引数は展開して渡す
    values = redis.call("HMGET", redis_key, *keys)

    # 取得したメンバーをDBから削除
    redis.call("HDEL", redis_key, *keys)

    members = values.collect { |e| JSON.parse(e) }
    members = members.sort_by { |e| e["performed_at"] } # エントリー順にする

    if Rails.env.production? || Rails.env.staging?
      members = members.shuffle
    end
    members
  end
end

# cap production rails:runner CODE='XyRuleInfo.redis_clear_all'
# cap production rails:runner CODE='XyRuleInfo.rebuild'
# cap production rails:runner CODE='XyRecord.entry_name_blank_scope.destroy_all'

class XyRuleInfo
  include ApplicationMemoryRecord
  memory_record [
    { key: "xy_rule1",   name: "1問",   o_count_max:  1,  },
    { key: "xy_rule10",  name: "10問",  o_count_max: 10,  },
    { key: "xy_rule30",  name: "30問",  o_count_max: 30,  },
    { key: "xy_rule100", name: "100問", o_count_max: 100, },
  ]

  cattr_accessor(:rank_max) { Rails.env.production? ? 100 : 5 }  # 位まで表示
  cattr_accessor(:per_page) { Rails.env.production? ? 20 : 2 }

  class << self
    def setup
      if Rails.env.development? || Rails.env.test?
        clear_all
      end
    end

    def rule_attrs_ary(params)
      collect do |e|
        e.attributes.merge(xy_records: e.xy_records(params))
      end
    end

    def clear_all
      if Rails.env.production?
        raise "must not happen"
      end
      redis_clear_all
      XyRecord.destroy_all
    end

    def redis_clear_all
      each(&:current_clean)
    end

    def rebuild
      each(&:aggregate)
    end

    def description
      Time.current.strftime("%-d日%-H時") + "の時点のランキング1位は" + values.reverse.collect { |e|
        names = e.top_xy_records.collect { |e| "#{e.entry_name} (#{e.spent_sec_time_format})"  }.join(" / ")
        "【#{e.name}】#{names}"
      }.join(" ") + " です"
    end
  end

  # 実際のスコア(のもとの時間)は XyRecord が持っているので取り出さない
  def xy_records(params)
    # current_clean
    # aggregate

    if ActiveRecord::Base.connection.adapter_name == "Mysql2"
      ids = redis.zrevrange(table_key_for(params), 0, rank_max - 1)
      if ids.empty?
        return []
      end
      records = XyRecord.where(id: ids).order("FIELD(#{XyRecord.primary_key}, #{ids.join(', ')})")
      records.collect { |e| e.attributes.merge(rank: e.rank(params)) }.as_json
    else
      redis.zrevrange(table_key_for(params), 0, rank_max - 1).collect do |id|
        record = XyRecord.where(id: ids)
        record.attributes.merge(rank: record.rank(params)).as_json
      end
    end
  end

  def top_xy_records
    redis.zrevrange(all_table_key, 0, 0).collect { |id|
      XyRecord.find(id)
    }
  end

  def rank_by_score(params, score)
    redis.zcount(table_key_for(params), score + 1, "+inf") + 1
  end

  def ranking_page(params, id)
    if index = redis.zrevrank(table_key_for(params), id)
      index.div(per_page).next
    end
  end

  def ranking_add(record)
    XyScopeInfo.each do |e|
      key = e.table_key_for[record, self]
      redis.zadd(key, record.score, record.id)
    end
  end

  def ranking_rem(record)
    XyScopeInfo.each do |e|
      key = e.table_key_for[record, self]
      redis.zrem(key, record.id)
    end
  end

  def current_clean
    redis.del(all_table_key)
  end

  def aggregate
    XyRecord.where(xy_rule_key: key).each do |e|
      ranking_add(e)
    end
  end

  def all_table_key
    [self.class.name.underscore, key].join("/")
  end

  def today_table_key
    time_table_key(Time.current)
  end

  def time_table_key(created_at)
    [self.class.name.underscore, key, created_at.strftime("%Y%m%d")].join("/")
  end

  private

  def table_key_for(params)
    xy_scope_info = XyScopeInfo.fetch(params[:xy_scope_key])
    send(xy_scope_info.key_method)
  end

  def redis
    @redis ||= Redis.new(host: "localhost", port: 6379, db: 2)
  end
end

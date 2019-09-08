# cap production rails:runner CODE='XyRuleInfo.redis_clear_all'
# cap production rails:runner CODE='XyRuleInfo.rebuild'
# cap production rails:runner CODE='XyRecord.entry_name_blank_scope.destroy_all'

class XyRuleInfo
  include ApplicationMemoryRecord
  memory_record [
    { key: "xy_rule1",   name: "1問",   o_count_max:  1,  development_only: false, },
    { key: "xy_rule10",  name: "10問",  o_count_max: 10,  development_only: false, },
    { key: "xy_rule30",  name: "30問",  o_count_max: 30,  development_only: false, },
    { key: "xy_rule100", name: "100問", o_count_max: 100, development_only: false, },
  ]

  cattr_accessor(:rank_max) { Rails.env.production? ? 100 : 5 }  # 位まで表示
  cattr_accessor(:per_page) { Rails.env.production? ? 20 : 2 }

  class << self
    def setup
      if Rails.env.development? || Rails.env.test?
        clear_all
      end
    end

    def rule_list
      reject { |e| !Rails.env.development? && e.development_only }.collect do |e|
        e.attributes.merge(xy_records: e.xy_records)
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
  def xy_records
    # current_clean
    # aggregate
    if ActiveRecord::Base.connection.adapter_name == "Mysql2"
      ids = redis.zrevrange(inside_key, 0, rank_max - 1)
      if ids.empty?
        return []
      end
      XyRecord.where(id: ids).order("FIELD(#{XyRecord.primary_key}, #{ids.join(', ')})").as_json(methods: [:rank]) # MySQL 依存
    else
      redis.zrevrange(inside_key, 0, rank_max - 1).collect do |id|
        XyRecord.where(id: ids).as_json(methods: [:rank])
      end
    end
  end

  def top_xy_records
    redis.zrevrange(inside_key, 0, 0).collect { |id|
      XyRecord.find(id)
    }
  end

  def rank_by_score(score)
    redis.zcount(inside_key, score + 1, "+inf") + 1
  end

  def ranking_page(id)
    if index = redis.zrevrank(inside_key, id)
      index.div(per_page).next
    end
  end

  def ranking_add(record)
    redis.zadd(inside_key, record.score, record.id)
  end

  def ranking_rem(record)
    redis.zrem(inside_key, record.id)
  end

  def current_clean
    redis.del(inside_key)
  end

  def aggregate
    XyRecord.where(xy_rule_key: key).each do |e|
      ranking_add(e)
    end
  end

  private

  def inside_key
    "#{self.class.name.underscore}/#{key}"
  end

  def redis
    @redis ||= Redis.new(host: "localhost", port: 6379, db: 2)
  end
end

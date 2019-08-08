class XyRuleInfo
  include ApplicationMemoryRecord
  memory_record [
    { key: "xy_rule1",   name: "1問",   o_count_max:  1,  development_only: false, },
    { key: "xy_rule10",  name: "10問",  o_count_max: 10,  development_only: false, },
    { key: "xy_rule30",  name: "30問",  o_count_max: 30,  development_only: false, },
    { key: "xy_rule50",  name: "50問",  o_count_max: 50,  development_only: false, },
    { key: "xy_rule100", name: "100問", o_count_max: 100, development_only: false, },
  ]

  cattr_accessor(:rank_limit) { Rails.env.production? ? 100 : 5 }  # 位まで表示
  cattr_accessor(:per_page) { Rails.env.production? ? 20 : 2 }

  class << self
    def rule_list
      reject { |e| !Rails.env.development? && e.development_only }.collect do |e|
        e.attributes.merge(xy_records: e.xy_records)
      end
    end

    def clear_all
      each(&:current_clean)
    end

    def rebuild
      each(&:aggregate)
    end
  end

  # 実際のスコア(のもとの時間)は XyRecord が持っているので取り出さない
  def xy_records
    # current_clean
    # aggregate
    redis.zrevrange(inside_key, 0, rank_limit - 1).collect do |id|
      XyRecord.find(id).as_json(methods: [:rank])
    end
  end

  def rank_by_score(score)
    redis.zcount(inside_key, score + 1, "+inf") + 1
  end

  def ranking_page(id)
    if index = redis.zrevrank(inside_key, id)
      index.div(per_page).next
    end
  end

  def ranking_store(record)
    redis.zadd(inside_key, record.score, record.id)
  end

  def current_clean
    redis.del(inside_key)
  end

  def aggregate
    XyRecord.where(xy_rule_key: key).each do |e|
      ranking_store(e)
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

class XyGameRanking
  include ApplicationMemoryRecord
  memory_record [
    { key: "xy_rule_1c", name: "1問", o_count_max: 1, },
    { key: "xy_rule_2c", name: "2問", o_count_max: 2, },
  ]

  cattr_accessor(:rank_limit) { 50 }  # 位まで表示

  class << self
    def rule_list
      collect { |e|
        e.attributes.merge(xy_records: e.all)
      }
    end
  end

  def all
    current_clean
    aggregate
    redis.zrevrange(inside_key, 0, rank_limit - 1, with_scores: true).collect do |xy_record_id, spent_msec|
      # rank = computed_rank(spent_msec)
      XyRecord.find(xy_record_id).as_json(methods: [:computed_rank])

      # { rank: rank, xy_record_id: xy_record_id, name: XyRecord.find(xy_record_id).name, spent_msec: -spent_msec }
      # { rank: rank, xy_record_id: xy_record_id, name: XyRecord.find(xy_record_id).name, spent_msec: -spent_msec }
    end
  end

  def computed_rank(score)
    redis.zcount(inside_key, score + 0.001, "+inf") + 1
  end

  private

  def aggregate
    XyRecord.where(rule_key: key).each do |record|
      redis.zadd(inside_key, -record.spent_msec || 0, record.id)
    end
  end

  def inside_key
    "#{self.class.name.underscore}/#{key}"
  end

  def current_clean
    redis.del(inside_key)
  end

  def redis
    @redis ||= Redis.new(host: "localhost", port: 6379, db: 2)
  end
end

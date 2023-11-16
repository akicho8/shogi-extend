# cap production rails:runner CODE='XyMaster::RuleInfo.rebuild'
# cap production rails:runner CODE='XyMaster::TimeRecord.entry_name_blank_scope.destroy_all'
# XyMaster::XyRecord.where.not(xy_rule_key: ["xy_rule100t","xy_rule100tw","xy_rule100","xy_rule100w"]).destroy_all
# XyMaster::RuleInfo.rebuild

module XyMaster
  class RuleInfo
    include ApplicationMemoryRecord
    memory_record [
      # { key: "rule1",     name: "1問",      o_count_max:   1, viewpoint: :black, },
      # { key: "rule10",    name: "10問",     o_count_max:  10, viewpoint: :black, },
      # { key: "rule30",    name: "30問",     o_count_max:  30, viewpoint: :black, },

      { key: "rule100t",  name: "☗100問TAP",  },
      { key: "rule100tw", name: "☖100問TAP",  },
      { key: "rule100",   name: "☗100問",     },
      { key: "rule100w",  name: "☖100問",     },
    ]

    cattr_accessor(:rank_max) { (Rails.env.production? || Rails.env.staging?) ? 100 : 100 }  # 位まで表示
    cattr_accessor(:per_page) { (Rails.env.production? || Rails.env.staging?) ? 20 : 20 }

    include ChartMethods

    class << self
      def setup(options = {})
        if Rails.env.local?
          rebuild
          # clear_all
        end
      end

      def time_records_hash(params)
        inject({}) { |a, e| a.merge(e.key => e.time_records(params)) }
      end

      # def clear_all
      #   if Rails.env.production? || Rails.env.staging?
      #     raise "must not happen"
      #   end
      #   redis_clear_all
      #   TimeRecord.destroy_all
      # end
      #
      # def redis_clear_all
      #   if Rails.env.production? || Rails.env.staging?
      #     raise "must not happen"
      #   end
      #   each(&:current_clean)
      # end

      # rails r 'XyMaster::RuleInfo.rebuild'
      def rebuild
        redis.flushdb
        each(&:aggregate)
      end

      # 全削除
      # rails r 'RuleInfo.reset_all'
      def reset_all
        if Rails.env.production?
          raise "must not happen"
        end
        TimeRecord.delete_all
        rebuild
      end

      def description
        body = values.collect { |e|
          records = e.top_time_records
          if records.present?
            names = records.collect { |e| "#{e.entry_name} (#{e.spent_sec_time_format})"  }.join(" / ")
            "【#{e.name}】#{names}"
          end
        }.compact.join(" ")

        time = Time.current.strftime("%-d日%-H時")
        if body.present?
          "#{time}時点の1位は#{body}"
        end
      end

      def redis
        @redis ||= Redis.new(db: AppConfig[:redis_db_for_xy_master])
      end
    end

    # 実際のスコア(のもとの時間)は TimeRecord が持っているので取り出さない
    def time_records(params)
      # current_clean
      # aggregate
      records = []
      if params[:entry_name_uniq_p].to_s == "true"
        entry_names = redis.zrevrange(key_select(params), 0, rank_max - 1)
        if entry_names.present?
          scope = TimeRecord.where(rule: Rule.fetch(key)).order(:spent_sec)

          scope_info = ScopeInfo.fetch(params[:scope_key])
          scope = scope_info.time_record_scope.call(scope)

          records = entry_names.collect { |e| scope.where(entry_name: e).take }
        end
      else
        ids = redis.zrevrange(table_key_for(params), 0, rank_max - 1)
        if ids.present?
          records = TimeRecord.where(id: ids).order(Arel.sql("FIELD(#{TimeRecord.primary_key}, #{ids.join(', ')})"))
        end
      end

      records.collect { |e| e.attributes.merge(rank: e.rank(params), rule_key: e.rule_key) }
    end

    # 今日のトップ
    def top_time_records
      redis.zrevrange(table_key_for_today, 0, 0).collect do |id|
        TimeRecord.find(id)
      end
    rescue ActiveRecord::RecordNotFound => error
      if Rails.env.production? || Rails.env.staging?
        raise error
      end
      []
    end

    def rank_by_score(params, score)
      redis.zcount(key_select(params), score + 1, "+inf") + 1
    end

    def ranking_page(params, id)
      if index = redis.zrevrank(key_select(params), id)
        index.div(per_page).next
      end
    end

    def ranking_add(record)
      ScopeInfo.each do |e|
        key = e.table_key_for[record, self]
        redis.zadd(key, record.score, record.id)

        # キー(entry_name) がユニークではないためスコアが大きいときだけ更新する処理を自力で書く必要がある
        # そうしないと後から設定した値で更新されてしまう。後の値の方が大きいとタイムがおかしくなる。
        update_p = true
        if max = redis.zscore(as_unique_key(key), record.entry_name)
          update_p = record.score > max
        end
        if update_p
          redis.zadd(as_unique_key(key), record.score, record.entry_name)
        end
      end
    end

    def ranking_remove(record)
      ScopeInfo.each do |e|
        key = e.table_key_for[record, self]
        redis.zrem(key, record.id)
        redis.zrem(as_unique_key(key), record.entry_name)
      end
    end

    def current_clean
      redis.del(table_key_for_all)
    end

    def aggregate
      TimeRecord.where(rule: Rule.fetch(key)).each do |e|
        ranking_add(e)
      end
    end

    def table_key_for_all
      [*prefix_keys, "all"].join("/")
    end

    def table_key_for_today
      ymd_table_key_for_time(Time.current)
    end

    def table_key_for_yesterday
      ymd_table_key_for_time(Time.current.yesterday)
    end

    def table_key_for_month
      ym_table_key_for_time(Time.current)
    end

    def table_key_for_prev_month
      ym_table_key_for_time(Time.current.prev_month)
    end

    def ymd_table_key_for_time(created_at)
      [*prefix_keys, created_at.strftime("%Y%m%d")].join("/")
    end

    def ym_table_key_for_time(created_at)
      [*prefix_keys, created_at.strftime("%Y%m")].join("/")
    end

    def prefix_keys
      [self.class.name.underscore, key]
    end

    private

    def table_key_for(params)
      scope_info = ScopeInfo.fetch(params[:scope_key])
      send(scope_info.key_method)
    end

    def key_select(params)
      key = table_key_for(params)
      if params[:entry_name_uniq_p].to_s == "true"
        key = as_unique_key(key)
      end
      key
    end

    def as_unique_key(key)
      "#{key}/unique"
    end

    def redis
      self.class.redis
    end
  end
end

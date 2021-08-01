# cap production rails:runner CODE='XyMaster::RuleInfo.rebuild'
# cap production rails:runner CODE='XyMaster::TimeRecord.entry_name_blank_scope.destroy_all'
# XyMaster::XyRecord.where.not(xy_rule_key: ["xy_rule100t","xy_rule100tw","xy_rule100","xy_rule100w"]).destroy_all
# XyMaster::RuleInfo.rebuild

module XyMaster
  class RuleInfo
    include ApplicationMemoryRecord
    memory_record [
      # { key: "rule1",     name: "1問",      o_count_max:   1, viewpoint: :black, input_mode: "keyboard", },
      # { key: "rule10",    name: "10問",     o_count_max:  10, viewpoint: :black, input_mode: "keyboard", },
      # { key: "rule30",    name: "30問",     o_count_max:  30, viewpoint: :black, input_mode: "keyboard", },

      { key: "rule100t",  name: "☗100問TAP", o_count_max: 100, viewpoint: :black,  input_mode: "tap",      time_limit: 60*3.5, },
      { key: "rule100tw", name: "☖100問TAP", o_count_max: 100, viewpoint: :white,  input_mode: "tap",      time_limit: 60*3.5, },
      { key: "rule100",   name: "☗100問",    o_count_max: 100, viewpoint: :black,  input_mode: "keyboard", time_limit: 60*3.5, },
      { key: "rule100w",  name: "☖100問",    o_count_max: 100, viewpoint: :white,  input_mode: "keyboard", time_limit: 60*3.5, },
    ]

    cattr_accessor(:rank_max) { (Rails.env.production? || Rails.env.staging?) ? 100 : 100 }  # 位まで表示
    cattr_accessor(:per_page) { (Rails.env.production? || Rails.env.staging?) ? 20 : 20 }

    class << self
      def setup(options = {})
        if Rails.env.development? || Rails.env.test?
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

    concerning :ChartMethods do
      included do
        cattr_accessor(:count_all_gteq) { 1 }
      end

      class_methods do
        def chartjs_datasets(params)
          DbCop.mysql_convert_tz_with_time_zone_validate!

          rule = Rule.fetch(params[:chart_rule_key])
          chart_scope_info = ChartScopeInfo.fetch(params[:chart_scope_key])

          scope = TimeRecord.all

          # 指定のルールに絞る
          scope = scope.where(rule: rule)

          # 最近 / 全体 スコープ適用
          if v = chart_scope_info.date_gteq
            scope = scope.where(TimeRecord.arel_table[:created_at].gteq(v.ago))
          end

          # 100問を8分以上かけたような記録を除外する
          # チャートに含めると本来見たい1分台が重なってしまってしまうため
          # if v = time_limit
          #   scope = scope.where(TimeRecord.arel_table[:spent_sec].lt(rule_info.o_count_max * v))
          # end

          # 指定のルールで今日プレイした人だけに絞る
          if true
            entry_names = TimeRecord.where(rule: rule).where(TimeRecord.arel_table[:created_at].gteq(Time.current.midnight)).group(:entry_name).count.keys
            scope = scope.where(entry_name: entry_names)
          end

          names_hash = scope.group("entry_name").order("count_all DESC").having("count_all >= #{count_all_gteq}").count
          result = scope.select("entry_name, DATE(#{DbCop.tz_adjust(:created_at)}) AS created_on, MIN(spent_sec) AS spent_sec").group("entry_name, created_on")

          names_hash.collect.with_index { |(name, _), i|
            palette = PaletteInfo.fetch(i.modulo(PaletteInfo.count))
            v = result.find_all { |e| e.entry_name == name }
            {
              label: name.truncate(14),
              data: v.collect { |e| {x: e.created_on, y: e.spent_sec } },
              backgroundColor: palette.background_color,
              borderColor: palette.border_color,
              # その他のパラメータは共通なので次のファイルで指定する
              # app/javascript/packs/application.js
              # app/javascript/xy_master_chart_mod.js
            }
          }.compact

          # v = TimeRecord.select("date(created_at) as created_on, min(spent_sec) as spent_sec").where(entry_name: "きなこもち").where(rule_key: "rule100").group("date(created_at)")
          # v = v.collect { |e| {x: e.created_on, y: e.spent_sec } }
          # puts v.to_json
          # # >> [{"x":"2019-08-10","y":171.772},{"x":"2019-08-11","y":161.548},{"x":"2019-08-12","y":157.918},{"x":"2019-08-13","y":146.687},{"x":"2019-08-14","y":142.752},{"x":"2019-08-15","y":139.364},{"x":"2019-08-16","y":133.889},{"x":"2019-08-17","y":130.848},{"x":"2019-08-18","y":130.095},{"x":"2019-08-19","y":123.119},{"x":"2019-08-20","y":131.65},{"x":"2019-08-21","y":120.522},{"x":"2019-08-22","y":118.307},{"x":"2019-08-23","y":114.063},{"x":"2019-08-24","y":113.073},{"x":"2019-08-25","y":109.149},{"x":"2019-08-26","y":108.687},{"x":"2019-08-27","y":110.269},{"x":"2019-08-28","y":104.478},{"x":"2019-08-29","y":105.316},{"x":"2019-08-30","y":105.476},{"x":"2019-08-31","y":103.375},{"x":"2019-09-01","y":105.116},{"x":"2019-09-02","y":100.815},{"x":"2019-09-03","y":100.654},{"x":"2019-09-04","y":98.631},{"x":"2019-09-05","y":97.019},{"x":"2019-09-06","y":99.751},{"x":"2019-09-07","y":99.185},{"x":"2019-09-08","y":103.74},{"x":"2019-09-09","y":97.968},{"x":"2019-09-10","y":95.1},{"x":"2019-09-11","y":94.568},{"x":"2019-09-12","y":94.953},{"x":"2019-09-13","y":92.09},{"x":"2019-09-14","y":89.048},{"x":"2019-09-15","y":89.181},{"x":"2019-09-16","y":93.073},{"x":"2019-09-17","y":89.913},{"x":"2019-09-18","y":86.798},{"x":"2019-09-19","y":83.755},{"x":"2019-09-20","y":86.758},{"x":"2019-09-21","y":86.481},{"x":"2019-09-22","y":83.531},{"x":"2019-09-23","y":89.281},{"x":"2019-09-24","y":85.422},{"x":"2019-09-25","y":89.183},{"x":"2019-09-26","y":85.196},{"x":"2019-09-27","y":88.264},{"x":"2019-09-28","y":88.116},{"x":"2019-09-29","y":91.133},{"x":"2019-09-30","y":85.814},{"x":"2019-10-01","y":84.215},{"x":"2019-10-02","y":86.432},{"x":"2019-10-03","y":89.516},{"x":"2019-10-04","y":84.116},{"x":"2019-10-06","y":92.616},{"x":"2019-10-07","y":88.281},{"x":"2019-10-08","y":81.199},{"x":"2019-10-09","y":89.332},{"x":"2019-10-10","y":85.231},{"x":"2019-10-11","y":89.032}]
          #
          # datasets: 1.times.collect { |i|
          #   {
          #     label: wl.name,
          #     data: memberships.find_all { |e| e.judge_key.to_sym == wl.key }.collect { |e| { t: e.battle.battled_at.midnight.to_s(:ymdhms), y: e.battle.battled_at.hour * 1.minute + e.battle.battled_at.min } },
          #     backgroundColor: wl.palette.background_color,
          #     borderColor: wl.palette.border_color,
          #     pointRadius: 4,           # 点半径
          #     borderWidth: 2,           # 点枠の太さ
          #     pointHoverRadius: 5,      # 点半径(アクティブ時)
          #     pointHoverBorderWidth: 3, # 点枠の太さ(アクティブ時)
          #     fill: false,
          #     showLine: false,          # 線で繋げない
          #   }
          # },
        end
      end
    end
  end
end

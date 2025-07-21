module XyMaster
  concern :ChartMethods do
    included do
      cattr_accessor(:count_all_gteq) { 1 }
    end

    class_methods do
      def chartjs_datasets(params)
        MysqlToolkit.mysql_convert_tz_with_time_zone_validate!

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
          entry_names = TimeRecord.where(rule: rule).where(TimeRecord.arel_table[:created_at].gteq(Time.current.beginning_of_day)).group(:entry_name).count.keys
          scope = scope.where(entry_name: entry_names)
        end

        names_hash = scope.group("entry_name").order("count_all DESC").having("count_all >= #{count_all_gteq}").count
        created_at = MysqlToolkit.column_tokyo_timezone_cast(:created_at)
        result = scope.select("entry_name, DATE(#{created_at}) AS created_on, MIN(spent_sec) AS spent_sec").group("entry_name, created_on")

        names_hash.collect.with_index { |(name, _), i|
          palette = PaletteInfo.fetch(i.modulo(PaletteInfo.count))
          v = result.find_all { |e| e.entry_name == name }
          {
            :label           => name.truncate(14),
            :data            => v.collect { |e| { x: e.created_on, y: e.spent_sec } },
            :backgroundColor => palette.background_color,
            :borderColor     => palette.border_color,
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
        #     data: memberships.find_all { |e| e.judge_key.to_sym == wl.key }.collect { |e| { t: e.battle.battled_at.beginning_of_day.to_fs(:ymdhms), y: e.battle.battled_at.hour * 1.minute + e.battle.battled_at.min } },
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

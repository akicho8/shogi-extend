module QuickScript
  module Swars
    class GradeHistogramScript < Base
      self.title = "将棋ウォーズ棋力偏差値"
      self.description = "将棋ウォーズの棋力帯ごとの人数から偏差値を求める"
      self.form_method = :post
      self.button_label = "集計"

      BATCH_SIZE       = 5000    # 一度に取得するサイズ
      MAX_DEFAULT      = 50000   # サンプル対局数の初期値
      MAX_LIMIT        = 300000  # 全体のサンプル対局数の限度
      CACHE_EXPIRES_IN = 1.days  # 集計を保持する期間

      def form_parts
        super + [
          {
            :label        => "ルール",
            :key          => :rule_key,
            :type         => :radio_button,
            :elems        => {"" => { el_label: "すべて" }}.merge(::Swars::RuleInfo.to_form_elems),
            :default      => rule_key || "",
          },
          {
            :label        => "戦法・囲い等",
            :key          => :tag,
            :type         => :select,
            :elems        => [""] + Bioshogi::Explain::TacticInfo.all_elements.collect(&:name),
            :default      => params[:tag],
          },
          {
            :label        => "対象",
            :key          => :scope_key,
            :type         => Rails.env.local? ? :radio_button : :hidden,
            :elems        => ScopeInfo.to_form_elems,
            :default      => scope_key,
            :help_message => "囚人の棋譜は保持していない場合もあるためグラフが偏っている可能性が高いので信用ならないので本番ではこれ出すな",
          },
          {
            :label        => "最大件数",
            :key          => :max,
            :type         => Rails.env.local? ? :integer : :hidden,
            :default      => current_max,
            :help_message => "#{BATCH_SIZE}単位で処理する",
          },
        ]
      end

      def call
        if request_post?
          if total_count.zero?
            return "その条件では直近 #{current_max} 件のなかに一件も見つかりません"
          end
        end
        if total_count.positive?
          if request_post?
            flash[:notice] = "集計完了"
          end
          values = [
            { _component: "CustomChart", _v_bind: { params: custom_chart_params, }, style: {"max-width" => "800px", margin: "auto"}, :class => "is-unselectable is-centered", },
            simple_table(table_rows, always_table: true),
            status,
          ]
          { _component: "QuickScriptViewValueAsV", _v_bind: { value: values, }, style: {"gap" => "1rem"} }
        end
      end

      def table_rows
        internal_rows.collect do |e|
          {}.tap do |h|
            h["棋力"]   = e["階級"]
            h["人数"]   = e["度数"]
            h["割合"]   = e["相対度数"].try { "%.2f %%" % (self * 100.0) }
            h["上位"]   = e["累計相対度数"].try { "%.2f %%" % (self * 100.0) }
            h["偏差値"] = e["偏差値"].try { "%.0f" % self }
          end
        end
      end

      def counts_hash
        @counts_hash ||= yield_self do
          loop_index = 0
          counts_hash = {}
          scope_info.scope[::Swars::Membership].in_batches(of: BATCH_SIZE, order: :desc) do |scope|
            if loop_index >= loop_max
              break
            end
            scope = condition_add(scope)
            sub_counts_hash = scope.group(:grade_id).count
            counts_hash.update(sub_counts_hash) { |_, a, b| a + b }
            loop_index += 1
          end
          counts_hash
        end
      end

      def cache_key
        [self.class.name, current_max, rule_key, tag, scope_info.key].join("/")
      end

      def aggregate
        @aggregate ||= yield_self do
          Rails.cache.fetch(cache_key, expires_in: Rails.env.local? ? 0 : CACHE_EXPIRES_IN) do
            start_time = Time.current

            list = target_grades.collect do |grade|
              {
                "階級" => grade.key,
                "度数" => counts_hash.fetch(grade.id, 0),
              }
            end

            if Rails.env.local? && false
              list = list.collect { |e| e.merge("度数" => categoy_data_for_development[e["階級"]] || 0) }
            end

            total_count = list.sum { |e| e["度数"] }                                               # => 48014
            list = list.collect { |e| e.merge("相対度数" => e["度数"].fdiv(total_count) ) }
            t = 0; list = list.collect { |e| t += e["相対度数"]; e.merge("累計相対度数" => t) }
            list = list.collect.with_index { |e, i| e.merge("階級値" => -i) }
            score_total = list.sum { |e| e["度数"] * e["階級値"] }                                     # => 378281
            score_average = score_total.fdiv(total_count)                                          # => 7.878556254425792
            variance = list.sum { |e| (e["階級値"] - score_average)**2 * e["度数"] } / total_count.pred # => 5.099197349097279
            standard_deviation = Math.sqrt(variance)                                                  # => 2.258140241237749
            list = list.collect { |e| e.merge("基準値" => (e["階級値"] - score_average).fdiv(standard_deviation) ) }
            standard_value_average = list.sum { |e| e["基準値"] } / list.count
            list = list.collect { |e| e.merge("偏差値" => (e["基準値"] * 10 + 50)) }

            {
              :internal_rows => list,
              :status => {
                "集計日時"            => Time.current.to_fs(:ymdhms),
                "処理時間(秒)"        => Time.current - start_time,
                "最大件数"            => current_max,
                "サンプル対局数"      => total_count,
                "除外件数"            => current_max - total_count,
                "[条件] ルール"       => rule_info&.name,
                "[条件] 戦法・囲い等" => tag,
                "[条件] 対象"         => scope_info.name,
                "平均"                => score_average,
                "不偏分散"            => variance,
                "標準偏差"            => standard_deviation,
                "基準値平均"          => standard_value_average,
                **(Rails.env.local? ? {"キャッシュキー" => cache_key} : {}),
              },
            }
          end
        end
      end

      def total_count
        @total_count = internal_rows.sum { |e| e["度数"] }
      end

      def internal_rows
        @internal_rows ||= aggregate[:internal_rows]
      end

      def status
        @status ||= aggregate[:status]
      end

      def custom_chart_params
        e = internal_rows.reverse
        {
          data: {
            labels: e.collect { |e| e["階級"].remove(/[段級]/) },
            datasets: [
              {
                label: nil,
                data: e.collect { |e| e["度数"] },
              },
            ],
          },
          scales_y_axes_ticks: nil,
          scales_y_axes_display: false,
        }
      end

      def condition_add(s)
        s = s.where(grade: target_grades.unscope(:order))
        if v = rule_info
          s = s.rule_eq(v)
        end
        if v = tag.presence
          s = s.tagged_with(v)
        end
        s
      end

      def categoy_data_for_development
        {
          "九段" => 0, # 22,
          "八段" => 39,
          "七段" => 0, # 141,
          "六段" => 444,
          "五段" => 549,
          "四段" => 1163,
          "三段" => 2927,
          "二段" => 5032,
          "初段" => 7843,
          "1級" =>  9562,
          "2級" =>  8249,
          "3級" =>  5650,
          "4級" =>  3149,
          "5級" =>  1743,
          "6級" =>  754,
          "7級" =>  353,
          "8級" =>  153,
          "9級" =>  92,
        }
      end

      ################################################################################

      def tag
        @tag ||= params[:tag]
      end

      ################################################################################

      def rule_key
        params[:rule_key].presence # presence 必須。必ず "" を nil 化しないと RuleInfo[""] で10分が引けてしまうため
      end

      def rule_info
        ::Swars::RuleInfo.fetch_if(rule_key)
      end

      ################################################################################

      def scope_key
        params[:scope_key] || ScopeInfo.first.key
      end

      def scope_info
        ScopeInfo.fetch(scope_key)
      end

      ################################################################################

      def loop_max
        @loop_max ||= current_max.ceildiv(BATCH_SIZE)
      end

      def current_max
        @current_max ||= [(params[:max].presence || MAX_DEFAULT).to_i.ceildiv(BATCH_SIZE) * BATCH_SIZE, MAX_LIMIT].min
      end

      ################################################################################

      def target_grades
        @target_grades ||= ::Swars::Grade.where(key: ::Swars::GradeInfo.find_all(&:visualize).pluck(:key))
      end

      ################################################################################

      def title
        "#{super} (#{total_count}件)"
      end
    end
  end
end

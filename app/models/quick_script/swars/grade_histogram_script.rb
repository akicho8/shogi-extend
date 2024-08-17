# ~/src/shogi-extend/app/models/swars/histogram/grade.rb

module QuickScript
  module Swars
    class GradeHistogramScript < Base
      self.title = "[WIP] 将棋ウォーズ棋力分布(新)"
      self.description = "将棋ウォーズの棋力分布を集計する"
      self.form_method = :post
      self.button_label = "集計"
      # self.router_push_failed_then_fetch = true
      # self.button_click_loading = true

      BATCH_SIZE       = 5000    # 一度に取得するサイズ
      MAX_LIMIT        = 100000  # 全体のサンプル数の限度
      MAX_DEFAULT      = 50000   # サンプル数の初期値
      CACHE_EXPIRES_IN = 1.day   # 集計を保持する期間

      def form_parts
        super + [
          {
            :label   => "ルール",
            :key     => :rule_key,
            :type    => :radio_button,
            :elems   => {"" => "すべて"}.merge(::Swars::RuleInfo.to_form_elems),
            :default => params[:rule_key] || "",
          },
          {
            :label   => "戦法・囲い等",
            :key     => :tag,
            :type    => :select,
            :elems   => [""] + Bioshogi::Explain::TacticInfo.all_elements.collect(&:name),
            :default => params[:tag],
          },
        ]
      end

      def call
        if request_post?
          if records.sum { |e| e["度数"] }.zero?
            return "その条件では直近 #{current_max} 件のなかに一件も見つかりません"
          end
        end
        if total_count.positive?
          values = [
            { _component: "CustomChart", _v_bind: { params: custom_chart_params, }, style: {"max-width" => "800px", margin: "auto"}, :class => "is-unselectable is-centered", },
            simple_table(human_rows, always_table: true),
          ]
          { _component: "QuickScriptViewValueAsV", _v_bind: { value: values, }, style: {"gap" => "0rem"} }
        end
      end

      def human_rows
        records.collect do |e|
          {}.tap do |h|
            if Rails.env.local? && false
              h.update(e)
            else
              h["棋力"]   = e["階級"]
              h["人数"]   = e["度数"]
              h["割合"]   = e["相対度数"].try { "%.2f %%" % (self * 100.0) }
              h["上位"]   = e["累計相対度数"].try { "%.2f %%" % (self * 100.0) }
              h["偏差値"] = e["偏差値"].try { "%.0f" % self }
            end
          end
        end
      end

      def aggregate!
        Rails.cache.fetch(cache_key, expires_in: Rails.env.local? ? 0 : CACHE_EXPIRES_IN) do
          loop_index = 0
          hv = {}
          ::Swars::Membership.in_batches(of: BATCH_SIZE, order: :desc) do |scope|
            if loop_index >= loop_max
              break
            end
            scope = condition_add(scope)
            hv.update(scope.group(:grade_id).count) { |_, a, b| a + b }
            loop_index += 1
          end
          hv
        end
      end

      def cache_key
        [self.class.name, current_max, tag, rule_key].join("/")
      end

      def total_count
        @total_count ||= records.sum { |e| e["度数"] }
      end

      def records
        @records ||= yield_self do
          counts_hash = aggregate!

          list = current_grades.collect do |grade|
            {
              "階級" => grade.key,
              "度数" => counts_hash.fetch(grade.id, 0),
            }
          end

          if Rails.env.local? && false
            list = list.collect { |e| e.merge("度数" => categoy_data_for_development[e["階級"]] || 0) }
          end

          frequency_total = list.sum { |e| e["度数"] }                                               # => 48014
          list = list.collect { |e| e.merge("相対度数" => e["度数"].fdiv(frequency_total) ) }
          t = 0; list = list.collect { |e| t += e["相対度数"]; e.merge("累計相対度数" => t) }
          list = list.collect.with_index { |e, i| e.merge("階級値" => -i) }
          score_total = list.sum { |e| e["度数"] * e["階級値"] }                                     # => 378281
          score_average = score_total.fdiv(frequency_total)                                          # => 7.878556254425792
          variance = list.sum { |e| (e["階級値"] - score_average)**2 * e["度数"] } / frequency_total.pred # => 5.099197349097279
          standard_deviation = Math.sqrt(variance)                                                  # => 2.258140241237749
          list = list.collect { |e| e.merge("基準値" => (e["階級値"] - score_average).fdiv(standard_deviation) ) }
          standard_value_average = list.sum { |e| e["基準値"] } / list.count
          list = list.collect { |e| e.merge("偏差値" => (e["基準値"] * 10 + 50)) }
        end
      end

      def custom_chart_params
        e = records.reverse
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
          scales_yAxes_ticks: nil,
          scales_yAxes_display: false,
        }
      end

      def condition_add(s)
        s = s.where(grade: current_grades.unscope(:order)) # 9級から九段に絞る
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
        params[:rule_key]
      end

      def rule_info
        ::Swars::RuleInfo[rule_key]
      end

      ################################################################################

      def loop_max
        @loop_max ||= current_max.ceildiv(BATCH_SIZE)
      end

      def current_max
        @current_max ||= [(params[:max].presence || MAX_DEFAULT).to_i, MAX_LIMIT].min
      end

      ################################################################################

      # 調査対象段級位
      def current_grades
        @current_grades ||= ::Swars::Grade.where(key: ::Swars::GradeInfo.find_all(&:visualize).pluck(:key))
      end

      ################################################################################
    end
  end
end

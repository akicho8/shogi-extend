# frozen-string-literal: true

# 一次集計
# rails r QuickScript::Swars::TacticStatScript.new.cache_write
# rails r 'QuickScript::Swars::TacticStatScript.new({}, batch_size: 1, batch_limit: 1).cache_write'
# rails r 'QuickScript::Swars::TacticStatScript.new({}, batch_size: 1, batch_limit: 100).cache_write'
# rails r 'QuickScript::Swars::TacticStatScript.new({}, batch_size: Float::INFINITY).cache_write'
# rails r 'QuickScript::Swars::TacticStatScript.new({}, batch_limit: 1).cache_write'

module QuickScript
  module Swars
    class TacticStatScript < Base
      include BatchMethods
      include SwarsSearchHelperMethods
      include HelperMethods

      self.title        = "将棋ウォーズ戦法ランキング"
      self.description  = "戦法・囲いなどの勝率・出現率を調べる"
      self.form_method  = :get
      self.button_label = "集計"
      self.debug_mode   = Rails.env.local?
      self.json_link    = true

      def header_link_items
        super + [
          { name: "棋力別", _v_bind: { tag: "nuxt-link", to: { path: "/lab/swars/tactic-cross" }, }, },
          { name: "分布図", icon: "chart-box", _v_bind: { href: "/lab/swars/tactic-stat.html", target: "_self", }, },
        ]
      end

      concerning :ShareMethods do
        def form_parts
          super + [
            {
              :label        => "種類",
              :key          => :scope_key,
              :type         => :radio_button,
              :session_sync => true,
              :dynamic_part => -> {
                {
                  :elems   => ScopeInfo.form_part_elems,
                  :default => scope_key,
                }
              },
            },
            {
              :label        => "ランキング",
              :key          => :order_key,
              :type         => :radio_button,
              :session_sync => true,
              :dynamic_part => -> {
                {
                  :elems   => OrderInfo.form_part_elems,
                  :default => order_info.key,
                }
              },
            },
            {
              :label        => "勝率ランキング参加条件 出現率X以上",
              :key          => :freq_ratio_gteq,
              :type         => :numeric,
              :session_sync => true,
              :dynamic_part => -> {
                {
                  :options      => { min: 0, step: 0.0001 },
                  :default      => freq_ratio_gteq,
                  :help_message => "初期値: #{freq_ratio_gteq_default}",
                }
              },
            },
          ]
        end

        ################################################################################

        def scope_key
          ScopeInfo.lookup_key_or_first(params[:scope_key])
        end

        def scope_info
          ScopeInfo.fetch(scope_key)
        end

        ################################################################################

        def order_key
          OrderInfo.lookup_key_or_first(params[:order_key])
        end

        def order_info
          OrderInfo.fetch(order_key)
        end

        ################################################################################

        def freq_ratio_gteq
          @freq_ratio_gteq ||= (params[:freq_ratio_gteq].presence || freq_ratio_gteq_default).to_f
        end

        def freq_ratio_gteq_default
          0.0005
        end

        ################################################################################

        def ua_key
          UaInfo.lookup_key_or_first(params[:user_agent_key])
        end

        def ua_info
          UaInfo.fetch(ua_key)
        end

        ################################################################################

        def initial_fields(e)
          {
            :"名前"     => e.name,
            :"種類"     => e.human_name,
            :"スタイル" => e.style_info.name,

            :"勝率"     => nil,
            :"出現率"   => 0,
            :"人気度"   => 0,

            :"勝ち"     => 0,
            :"負け"     => 0,
            :"引分"     => 0,

            :"出現回数" => 0,
            :"使用人数" => 0,
          }
        end
      end

      def form_parts
        super + [
          {
            :label        => "期間直近",
            :key          => :period_key,
            :type         => :radio_button,
            :session_sync => true,
            :dynamic_part => -> {
              {
                :elems   => PeriodInfo.form_part_elems,
                :default => period_info.key,
              }
            },
          },
        ]
      end

      def as_general_json
        if false
          current_items
        else
          aggregate
        end
      end

      def call
        if current_items.present?
          values = [
            { _component: "CustomChart", _v_bind: { params: custom_chart_params }, style: { "max-width" => ua_info.max_width, margin: "auto" }, :class => "is-unselectable is-centered" },
            simple_table(human_rows, always_table: true),
          ]
          v_stack(values, style: { "gap" => "1rem" })
        end
      end

      def human_rows
        current_items.collect.with_index do |e, i|
          {}.tap do |row|
            row["#"]        = ranks[i]
            row["名前"]     = item_name_search_link(e[:"名前"])

            OrderInfo.each do |o|
              row[o.attr_key] = e[o.attr_key].try { "%.*f" % [o.float_width, self] } || "?"
            end

            JudgeInfo.each do |o|
              row[o.short_name] = e[o.short_name.to_sym]
            end

            row["使用人数"] = e[:"使用人数"]
            row["出現回数"] = e[:"出現回数"]

            row["スタイル"] = e[:"スタイル"]
            row["種類"]     = e[:"種類"]

            if AppConfig[:encyclopedia_link]
              row[header_blank_column(0)] = { _nuxt_link: "判定局面", _v_bind: { to: { path: "/lab/general/encyclopedia", query: { tag: e[:"名前"] }, }, }, }
            end
            row[header_blank_column(1)] = { _nuxt_link: "横断棋譜検索", _v_bind: { to: { path: "/lab/swars/cross-search",   query: { x_tags: e[:"名前"] }, }, }, }
          end
        end
      end

      def ranks
        @ranks ||= RankMapper.ranks(rank_values, base_rank: 1)
      end

      def rank_values
        @rank_values ||= current_items.collect { |e| -(e[order_info.attr_key] || -1) }
      end

      def title
        "将棋ウォーズ#{scope_info.name}#{order_info.name}ランキング"
      end

      def current_items
        @current_items ||= yield_self do
          items = scope_info.items.collect do |e|
            initial_fields(e).merge(period_agg_hash[e.key] || {})
          end
          items = fliter_process(items)
          items = items.sort_by { |e| -(e[order_info.attr_key] || -1) }
        end
      end

      def fliter_process(items)
        if order_info.key == :win_rate
          # 勝率条件出現回数N%以上
          if freq_ratio_gteq
            pivot = freq_ratio_gteq
            items = items.find_all { |e| (e[:"出現率"] || 0) >= pivot }
          end
        end
        items
      end

      # 指定期間の一次集計情報
      def period_agg
        @period_agg ||= aggregate.fetch(period_info.key)
      end

      def period_agg_hash
        @period_agg_hash ||= period_agg.index_by { it[:"名前"].to_sym }
      end

      ################################################################################

      def chart_bar_max
        (params[:chart_bar_max].presence || ua_info.chart_bar_max).to_i
      end

      def custom_chart_params
        items = current_items.take(chart_bar_max)
        {
          data: {
            labels: items.collect { |e| e[:"名前"].to_s.tr("→ー", "↓｜").chars }, # NOTE: 配列にすることで無理矢理縦表記にする
            datasets: [
              {
                label: nil,
                data: items.collect { |e| e[order_info.attr_key] },
              },
            ],
          },
          scales_y_axes_ticks: nil,
          scales_y_axes_display: false,
          aspect_ratio: ua_info.aspect_ratio,
        }
      end

      ################################################################################

      def period_key
        PeriodInfo.lookup_key_or_first(params[:period_key])
      end

      def period_info
        PeriodInfo.fetch(period_key)
      end

      ################################################################################

      concerning :AggregateMethods do
        # 戦法一覧 (TacticListScript) 用の戦法名をキーにしたハッシュ
        # 期間は決め打ちでよい
        def tactics_hash
          @tactics_hash ||= yield_self do
            if aggregate.present?
              if records = aggregate.dig(:infinite)
                records.index_by { it[:"名前"].to_sym }
              end
            end
          end
        end

        # {:term1 => [ { :"名前" => "棒銀", ... } ] } の型に変換する
        def aggregate_now
          PeriodInfo.inject({}) do |a, period_info|
            a.merge(period_info.key => aggregate_now_by_period_info(period_info))
          end
        end

        def aggregate_now_by_period_info(period_info)
          judge_counts_hash = {}
          memberships_count = 0
          user_ids_hash = Hash.new { |h, k| h[k] = Set[] }

          progress_start(main_scope.count.ceildiv(batch_size))
          main_scope.in_batches(of: batch_size).each.with_index do |scope, batch_index|
            progress_next(period_info)

            if batch_index >= batch_limit
              break
            end

            scope = condition_add(scope, period_info)

            # 勝敗
            judge_counts_hash.update(judge_hash_from(scope)) { |_, a, b| a + b }

            # 出現率の分母
            memberships_count += scope.count

            # 使用人数
            uniq_user_ids_query(scope).each do |tag_name, user_id|
              user_ids_hash[tag_name.to_sym] << user_id
            end
          end

          aggregate_result_merge(judge_counts_hash, memberships_count, user_ids_hash)
        end

        def aggregate_result_merge(judge_counts_hash, memberships_count, user_ids_hash)
          uniq_user_count = user_ids_hash.values.inject(Set[], &:+).size

          judge_counts_hash_normalize(judge_counts_hash).collect { |tag_name, e|
            judge_calc = JudgeCalc.new(e)
            if info = Bioshogi::Analysis::TagIndex.lookup(tag_name)
              {
                **initial_fields(info),

                :"勝率"     => judge_calc.ratio,
                **JudgeInfo.inject({}) { |a, o| a.merge(o.short_name => e[o.key]) },

                :"出現回数" => judge_calc.count,
                :"出現率"   => judge_calc.count.fdiv(memberships_count), # 分母は memberships 数でよい。freq_count を分母にしてはいけない

                :"使用人数" => user_ids_hash[tag_name].size,
                :"人気度"   => user_ids_hash[tag_name].size.fdiv(uniq_user_count), # 分母は全体のユニークユーザー数でないとだめ
              }
            end
          }.compact
        end

        ################################################################################

        def condition_add(scope, period_info)
          scope = scope.joins(:battle => [:imode, :xmode])
          scope = scope.where(::Swars::Imode.arel_table[:key].eq(:normal))
          if v = period_info.period_second
            scope = scope.where(::Swars::Battle.arel_table[:battled_at].gteq(v.ago))
          end
          scope
        end

        def uniq_user_ids_query(scope)
          scope = scope.joins(:taggings => :tag)
          scope.distinct.pluck([
              ActsAsTaggableOn::Tag.arel_table[:name],
              ::Swars::Membership.arel_table[:user_id],
            ])
        end

        def judge_hash_from(scope)
          scope = scope.joins(:taggings => :tag)
          scope = scope.joins(:judge)
          scope = scope.group(ActsAsTaggableOn::Tag.arel_table[:name])
          scope = scope.group(Judge.arel_table[:key])
          scope.count
        end

        ################################################################################

        def judge_counts_hash_normalize(judge_counts_hash)
          Hash.new { |h, k| h[k] = JudgeInfo.zero_default_hash.dup }.tap do |acc|
            judge_counts_hash.each do |(tag_name, judge_key), count|
              acc[tag_name.to_sym][judge_key.to_sym] += count
            end
          end
        end
      end
    end
  end
end

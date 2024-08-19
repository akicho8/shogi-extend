# ~/src/shogi-extend/app/models/swars/histogram/grade.rb

module QuickScript
  module Swars
    class TacticHistogramScript < Base
      self.title = "将棋ウォーズ戦術頻出度"
      self.description = "対局に付与しているタグの頻出度を調べる"
      self.form_method = :post
      self.button_label = "集計"

      BATCH_SIZE       = 5000    # 一度に取得するサイズ
      MAX_DEFAULT      = 50000   # サンプル数の初期値
      MAX_LIMIT        = 300000  # 全体のサンプル数の限度
      CACHE_EXPIRES_IN = 1.days  # 集計を保持する期間

      def form_parts
        super + [
          {
            :label        => "種類",
            :key          => :tactic_key,
            :type         => :radio_button,
            :elems        => TacticInfo.to_form_elems,
            :default      => tactic_key,
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
            { _component: "CustomChart", _v_bind: { params: custom_chart_params, }, style: {"max-width" => ua_info.max_width, margin: "auto"}, :class => "is-unselectable is-centered", },
            simple_table(table_rows, always_table: true),
            status,
          ]
          { _component: "QuickScriptViewValueAsV", _v_bind: { value: values, }, style: {"gap" => "0rem"} }
        end
      end

      def table_rows
        internal_rows.collect do |e|
          {}.tap do |h|
            h["項目"] = e[:name]
            h["個数"] = e[:count]
            h["割合"] = e[:ratio].try { "%.3f %%" % (self * 100.0) }
          end
        end
      end

      def title
        "将棋ウォーズ#{tactic_info.name}頻出度(#{total_count})"
      end

      def total_count
        @total_count = internal_rows.sum { |e| e[:count] }
      end

      def internal_rows
        @internal_rows ||= aggregate[:internal_rows]
      end

      def status
        @status ||= aggregate[:status]
      end

      def aggregate
        @aggregate ||= yield_self do
          Rails.cache.fetch(cache_key, expires_in: Rails.env.local? ? 0 : CACHE_EXPIRES_IN) do
            start_time = Time.current
            sdc = StandardDeviation.new(counts_hash.values)
            list = counts_hash.collect do |name, count|
              {
                :name  => name,
                :count => count,
                :ratio => sdc.appear_ratio(count),
              }
            end

            if tactic_info.key == :note
              model = tactic_info.ancestor_info.model
              list = list.sort_by { |e| model[e[:name]].code }
            else
              list = list.sort_by { |e| -e[:count] }
            end

            total_count = list.sum { |e| e[:count] }
            {
              :internal_rows => list,
              :status => {
                "集計日時"     => Time.current.to_fs(:ymdhms),
                "処理時間(秒)" => Time.current - start_time,
                "最大件数"     => current_max,
                "抽出タグ数"   => total_count,
                "種類"         => tactic_info.name,
                **(Rails.env.local? ? {"キャッシュキー" => cache_key} : {}),
              },
            }
          end
        end
      end

      def counts_hash
        @counts_hash ||= yield_self do
          counts_hash = {}
          loop_index = 0
          ::Swars::Membership.in_batches(of: BATCH_SIZE, order: :desc) do |scope|
            if loop_index >= loop_max
              break
            end
            tags = scope.tag_counts_on(tactic_info.tag_table)
            tags.each do |e|
              counts_hash[e.name] ||= 0
              counts_hash[e.name] += e.count
            end
            loop_index += 1
          end
          counts_hash
        end
      end

      ################################################################################

      def chart_bar_max
        (params[:chart_bar_max].presence || ua_info.chart_bar_max).to_i
      end

      def custom_chart_params
        e = internal_rows.take(chart_bar_max)
        {
          data: {
            labels: e.collect { |e| e[:name].tr("→ー", "↓｜").chars }, # NOTE: 配列にすることで無理矢理縦表記にする
            datasets: [
              {
                label: nil,
                data: e.collect { |e| e[:count] },
              },
            ],
          },
          scales_y_axes_ticks: nil,
          scales_y_axes_display: false,
          aspect_ratio: ua_info.aspect_ratio,
        }
      end

      ################################################################################

      def cache_key
        [self.class.name, tactic_info.key, current_max].join("/")
      end

      ################################################################################

      def tactic_key
        params[:tactic_key].presence || :attack
      end

      def tactic_info
        TacticInfo.fetch(tactic_key)
      end

      ################################################################################

      def ua_key
        params[:user_agent_key].presence || :mobile
      end

      def ua_info
        UaInfo.fetch(ua_key)
      end

      ################################################################################

      def loop_max
        @loop_max ||= current_max.ceildiv(BATCH_SIZE)
      end

      def current_max
        @current_max ||= [(params[:max].presence || MAX_DEFAULT).to_i.ceildiv(BATCH_SIZE) * BATCH_SIZE, MAX_LIMIT].min
      end

      ################################################################################
    end
  end
end

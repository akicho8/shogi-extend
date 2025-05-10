# frozen-string-literal: true

#
# 戦法一覧
#
# 一次集計: rails r QuickScript::Swars::TacticListScript.new.cache_write
#
module QuickScript
  module Swars
    class TacticListScript < Base
      include LinkToNameMethods
      include HelperMethods

      class << self
        def mock_setup
          ::Swars::Battle.create!(strike_plan: "原始棒銀")
        end
      end

      self.title        = "戦法一覧"
      self.description  = "特定の戦法に対応する棋譜に飛べる"
      self.form_method  = :get
      self.button_label = "絞り込み"
      self.debug_mode   = Rails.env.development?
      self.general_json_link_show = true

      def form_parts
        super + [
          {
            :label        => "部分一致",
            :key          => :query,
            :type         => :string,
            :dynamic_part => -> {
              {
                :default     => query,
                :placeholder => "戦 アヒル -裏",
              }
            },
          },
        ]
      end

      def call
        simple_table(table_rows, always_table: true)
      end

      # http://localhost:3000/api/lab/swars/tactic-list.json?json_type=general
      def as_general_json
        current_items.collect do |item|
          {}.tap do |row|
            row["名称"]     = item.name
            row["勝率"]     = tactics_hash.dig(item.key, :win_ratio)
            row["相対頻度"] = tactics_hash.dig(item.key, :freq_ratio) || 0.0
            row["勝ち"]     = tactics_hash.dig(item.key, :win_count) || 0
            row["負け"]     = tactics_hash.dig(item.key, :lose_count) || 0
            row["引き分け"] = tactics_hash.dig(item.key, :draw_count) || 0
            row["棋風"]     = item.style_info.name
            row["種類"]     = item.human_name
            row["親"]       = item.parent&.name
            row["別名"]     = item.alias_names
          end
        end
      end

      def table_rows
        current_items.collect do |item|
          {}.tap do |row|
            row["名前"] = row_name(item)
            row["勝率"] = tactics_hash.dig(item.key, :win_ratio).try { "%.3f" % self } || ""
            row["頻度"] = tactics_hash.dig(item.key, :freq_ratio).try { "%.4f" % self } || "0" # 0 は文字列にしておかないと b-table の並び替えがバグる
            row["ｽﾀｲﾙ"] = item.style_info.name
            row["種類"] = item.human_name
            row["発掘"] = row_battle_ids(item)
            row[header_blank_column(0)] = { _nuxt_link: { name: "判定局面", to: { path: "/lab/general/encyclopedia", query: { tag: item.name }, }, }, }
            row[header_blank_column(1)] = { _nuxt_link: { name: "棋力帯",   to: { path: "/lab/swars/grade-stat",     query: { tag: item.name }, }, }, }
            row[header_blank_column(2)] = { _nuxt_link: { name: "横断棋譜検索", to: { path: "/lab/swars/cross-search",   query: { x_tags: item.name }, }, }, }
            row["親"] = item.parent ? { _nuxt_link: { name: item.parent.name, to: { path: "/lab/swars/tactic-list", query: { query: item.parent.name, __prefer_url_params__: 1 }, }, }, } : ""
            row["別名"] = { _v_html: tag.small(item.alias_names * ", ") }
          end
        end
      end

      private

      ################################################################################

      # |----------------------+-----------+---------------------+------------+------------+----------------------+------------+----------------|
      # | tag_name             | win_count | win_ratio           | draw_count | freq_count | freq_ratio           | lose_count | win_lose_count |
      # |----------------------+-----------+---------------------+------------+------------+----------------------+------------+----------------|
      # | 力戦                 |         7 |  0.5833333333333334 |          0 |         12 |   0.2307692307692308 |          5 |             12 |
      # | 居玉                 |         6 |  0.4615384615384616 |          0 |         13 |                 0.25 |          7 |             13 |
      # | 名人に定跡なし       |         7 |                 1.0 |          0 |          7 |   0.1346153846153846 |          0 |              7 |
      # |----------------------+-----------+---------------------+------------+------------+----------------------+------------+----------------|
      def tactics_hash
        @tactics_hash ||= TacticJudgeAggregator.new.tactics_hash
      end

      concerning :FilterFunction do
        def query
          params[:query].to_s
        end

        def current_items
          @current_items ||= yield_self do
            av = Bioshogi::Analysis::TacticInfo.all_elements.collect { |e| SearchableItem.new(e) }
            g = SimpleQueryParser.parse(query)
            Array(g[true]).each do |m|
              av = av.find_all { |e| e.to_s.include?(m) }
            end
            Array(g[false]).each do |m|
              av = av.reject { |e| e.to_s.include?(m) }
            end
            av.collect(&:item).sort_by(&:key)
          end
        end

        class SearchableItem
          attr_reader :item

          def initialize(item)
            @item = item
          end

          def to_s
            @to_s ||= [
              @item.name,            # セメント囲い
              *@item.alias_names,    # カタツムリ
              @item.human_name,      # 囲い or 戦法 or 手筋 or 備考
              @item.style_info.name, # 王道
            ].join(" ")
          end
        end
      end
    end
  end
end

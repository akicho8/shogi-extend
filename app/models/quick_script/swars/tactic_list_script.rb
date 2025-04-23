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
      include ZatuyouMethods

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

      def form_parts
        super + [
          {
            :label        => "部分一致",
            :key          => :query,
            :type         => :string,
            :dynamic_part => -> {
              {
                :default     => query,
                :placeholder => "四枚 変態 囲い",
              }
            },
          },
        ]
      end

      def call
        simple_table(table_rows, always_table: true)
      end

      def table_rows
        filtered_items.collect do |item|
          {}.tap do |row|
            row["名前"] = row_name(item)
            row["勝率"] = tactics_hash.dig(item.key, :win_ratio).try { "%.3f" % self } || ""
            row["頻度"] = tactics_hash.dig(item.key, :freq_ratio).try { "%.4f" % self } || "0" # 0 は文字列にしておかないと b-table の並び替えがバグる
            row["ｽﾀｲﾙ"] = item.style_info.name
            row["種類"] = item.human_name
            row["発掘"] = row_battle_ids(item)
            row[header_blank_column(0)] = { _nuxt_link: { name: "判定条件", to: { path: "/lab/general/encyclopedia", query: { tag: item.name }, }, }, }
            row[header_blank_column(1)] = { _nuxt_link: { name: "棋力帯",   to: { path: "/lab/swars/grade-stat",     query: { tag: item.name }, }, }, }
            row[header_blank_column(2)] = { _nuxt_link: { name: "横断検索", to: { path: "/lab/swars/cross-search",   query: { x_tags: item.name }, }, }, }
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
        @tactics_hash ||= TacticAggregator.new.tactics_hash
      end

      concerning :FilterFunction do
        def query
          params[:query].to_s
        end

        def filtered_items
          @filtered_items ||= yield_self do
            av = searchable_items
            StringToolkit.split(query).each do |q|
              av = av.find_all { |item, str| str.include?(q) }
            end
            av.collect { |item, str| item }.sort_by(&:key)
          end
        end

        # [
        #   [<セメント囲い>, "セメント囲い|カタツムリ"],
        #   [<ヒラメ戦法>,   "ヒラメ戦法|平目"],
        # ]
        def searchable_items
          @searchable_items ||= yield_self do
            items = Bioshogi::Analysis::TacticInfo.all_elements
            items.collect { |e| [e, [e.name, *searchable_strings(e)].join("|")] }
          end
        end

        def searchable_strings(e)
          [
            e.name,             # セメント囲い
            *e.alias_names,     # カタツムリ
            e.human_name, # 囲い or 戦法 or 手筋 or 備考
            e.style_info.name,  # 王道
          ]
        end
      end
    end
  end
end

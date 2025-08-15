# frozen-string-literal: true

#
# 戦法一覧
#
# 一次集計: rails r QuickScript::Swars::TacticListScript.new.cache_write
#
module QuickScript
  module Swars
    class TacticListScript < Base
      include SwarsSearchHelperMethods
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
      self.json_link = true

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
        simple_table(human_rows, always_table: true)
      end

      # http://localhost:3000/api/lab/swars/tactic-list.json?json_type=general
      def as_general_json
        rows
      end

      def human_rows
        current_items.collect do |item|
          {}.tap do |row|
            row["名前"] = item_search_link(item)
            row["勝率"] = tactics_hash.dig(item.key, :"勝率").try { "%.3f" % self } || "?"
            row["出現率"] = "%.4f" % (tactics_hash.dig(item.key, :"出現率") || 0.0)
            row["人気度"] = "%.4f" % (tactics_hash.dig(item.key, :"人気度") || 0.0)
            row["出現回数"] = tactics_hash.dig(item.key, :"出現回数") || 0
            row["使用人数"] = tactics_hash.dig(item.key, :"使用人数") || 0
            row["スタイル"] = item.style_info.name
            row["種類"] = item.human_name
            row["発掘"] = battle_id_collector.tactic_battle_ids_count(item)
            if AppConfig[:encyclopedia_link]
              row[header_blank_column(0)] = { _nuxt_link: "判定局面", _v_bind: { to: { path: "/lab/general/encyclopedia", query: { tag: item.name }, }, }, }
            end
            if Rails.env.local?
              row[header_blank_column(1)] = { _nuxt_link: "横断棋譜検索", _v_bind: { to: { path: "/lab/swars/cross-search",   query: { x_tags: item.name }, }, }, }
              row["親"] = item.parent ? { _nuxt_link: item.parent.name, _v_bind: { to: { path: "/lab/swars/tactic-list", query: { query: item.parent.name, __prefer_url_params__: 1 }, }, }, } : ""
            end
            row["別名"] = { _v_html: tag.small(item.alias_names * ", ") }
          end
        end
      end

      def rows
        current_items.collect do |item|
          {}.tap do |row|
            row["種類"]     = item.human_name
            row["スタイル"] = item.style_info.name
            row["名前"]     = item.name
            row["親"]       = item.parent&.name
            row["別名"]     = item.alias_names

            row["勝率"]     = tactics_hash.dig(item.key, :"勝率")
            row["出現率"]   = tactics_hash.dig(item.key, :"出現率") || 0.0
            row["人気度"]   = tactics_hash.dig(item.key, :"人気度") || 0.0

            JudgeInfo.each do |e|
              row[e.short_name] = tactics_hash.dig(item.key, e.short_name.to_sym) || 0
            end

            row["出現回数"] = tactics_hash.dig(item.key, :"出現回数") || 0
            row["使用人数"] = tactics_hash.dig(item.key, :"使用人数") || 0
          end
        end
      end

      private

      ################################################################################

      def tactics_hash
        @tactics_hash ||= TacticStatScript.new.tactics_hash
      end

      def battle_id_collector
        @battle_id_collector ||= BattleIdCollector.new
      end

      concerning :FilterFunction do
        def query
          params[:query].to_s
        end

        def current_items
          @current_items ||= yield_self do
            av = Bioshogi::Analysis::TagIndex.values.collect { |e| SearchableItem.new(e) }
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

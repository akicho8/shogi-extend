module QuickScript
  module Swars
    module LinkToNameMethods
      # 棋譜検索へのリンク
      def link_to_search_by_item(item)
        link_to_search_by_name(item.name)
      end

      def link_to_search_by_name(name, options = {})
        link_to_search_by_name_query(name, name, options)
      end

      def link_to_search_by_name_query(name, query, options = {})
        { _nuxt_link2: name, _v_bind: { to: { path: "/swars/search", query: { query: query } }, **options } }
      end

      # 発掘数
      def battle_ids_found_count(item)
        (battle_ids_hash[item.key] || []).size
      end

      def battle_ids_hash
        @battle_ids_hash ||= TacticBattleAggregator.new.aggregate || {}
      end
    end
  end
end

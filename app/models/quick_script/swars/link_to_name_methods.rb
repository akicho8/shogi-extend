module QuickScript
  module Swars
    module LinkToNameMethods
      def row_name(item)
        link_to_name(item, item.name)
      end

      def row_battle_ids(item)
        if false
          link_to_name(item, item_battle_ids(item).size)
        else
          item_battle_ids(item).size.to_s
        end
      end

      def link_to_name(item, name)
        ids = item_battle_ids(item)
        if ids.empty?
          name
        else
          { _nuxt_link: { name: name, to: { path: "/swars/search", query: { query: "id:" + ids.join(",") } } } }
        end
      end

      def item_battle_ids(item)
        item_battle_ids_hash[item.key] || []
      end

      def item_battle_ids_hash
        @item_battle_ids_hash ||= TacticBattleAggregator.new.aggregate
      end
    end
  end
end

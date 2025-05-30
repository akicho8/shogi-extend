module QuickScript
  module Swars
    module SwarsSearchHelperMethods
      def item_search_link(item)
        item_name_search_link(item.name)
      end

      def item_name_search_link(name, options = {})
        item_name_query_search_link(name, name, options)
      end

      def item_name_query_search_link(name, query, options = {})
        { _nuxt_link: name, _v_bind: { to: { path: "/swars/search", query: { query: query } }, **options } }
      end
    end
  end
end

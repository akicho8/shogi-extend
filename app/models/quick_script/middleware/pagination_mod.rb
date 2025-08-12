module QuickScript
  module Middleware
    concern :PaginationMod do
      prepended do
        class_attribute :per_page_default, default: 100
        class_attribute :per_page_max, default: 500
      end

      def pagination_scope(scope)
        scope.page(current_page).per(current_per, max_per_page: per_page_max)
      end

      def pagination_for(scope, options = {}, &block)
        scope = pagination_scope(scope)
        if block
          rows = block.call(scope)
        else
          rows = scope
        end
        {
          :_component => "QuickScriptViewValueAsTable",
          :_v_bind => {
            :value => {
              :rows         => rows,
              :paginated    => true,
              :total        => scope.total_count,
              :current_page => scope.current_page,
              :per_page     => current_per,
              :always_table => false,
              :header_hide  => false,
              **options,
            },
          }
        }
      end

      def simple_table(rows, options = {})
        {
          :_component => "QuickScriptViewValueAsTable",
          :_v_bind => {
            :value => {
              :rows         => rows,
              # :always_table => true,
              # :header_hide  => true,
              **options,
            },
          },
        }
      end

      def current_page
        (params[:page] || 1).to_i
      end

      def current_per
        [(params[:per_page].presence || per_page_default).to_i, per_page_max].min
      end

      # [KEYWORD] __COLUMN_NAME_PREFIX__ column_name_prefix
      def column_name_prefix
        "_"
      end
    end
  end
end

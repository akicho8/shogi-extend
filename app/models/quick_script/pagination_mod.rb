module QuickScript
  concern :PaginationMod do
    prepended do
      class_attribute :per_page_default, default: 100
      class_attribute :per_page_max, default: 1000
    end

    def pagination_for(scope, options = {}, &block)
      scope = scope.page(current_page).per(current_per)
      if block
        rows = block.call(scope)
      else
        rows = scope
      end
      {
        :_component   => "QuickScriptViewValueAsTable",
        :rows         => rows,
        :paginated    => true,
        :total        => scope.total_count,
        :current_page => scope.current_page,
        :per_page     => current_per,
        :always_table => false,
        :header_hide  => false,
        **options,
      }
    end

    def current_page
      (params[:page] || 1).to_i
    end

    def current_per
      [(params[:per_page].presence || per_page_default).to_i, per_page_max].min
    end
  end
end

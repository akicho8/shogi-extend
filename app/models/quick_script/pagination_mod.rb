module QuickScript
  concern :PaginationMod do
    prepended do
      class_attribute :per_page_default, default: 100
      class_attribute :per_page_max, default: 1000
      # class_attribute :pagination_p, default: false
    end

    attr_accessor :page_params

    def initialize(...)
      super

      @page_params = {
        :paginated    => false,
        :total        => 0,
        :current_page => 1,
        :per_page     => 100,
      }
    end

    def as_json(*)
      super.merge(page_params: @page_params)
    end

    def with_paginate(scope)
      if scope.respond_to?(:page)
        scope = scope.page(current_page).per(current_per)
        @page_params[:paginated]    = true
        @page_params[:total]        = scope.total_count
        @page_params[:current_page] = scope.current_page
        @page_params[:per_page]     = current_per
      end
      scope
    end

    def current_page
      (params[:page] || 1).to_i
    end

    def current_per
      [(params[:per_page].presence || per_page_default).to_i, per_page_max].min
    end
  end
end

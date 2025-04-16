module Api
  module Kiwi
    class TopsController < ApplicationController
      # http://localhost:3000/api/kiwi/tops/index.json
      # http://localhost:3000/api/kiwi/tops/index.json?query=a&tag=b,c
      def index
        retv = {}
        retv[:bananas] = current_bananas.as_json(::Kiwi::Banana.json_struct_for_top)
        retv[:xpage_info] = xpage_info(current_bananas)
        retv[:meta]  = AppEntryInfo.fetch(:kiwi_lemon_index).og_meta
        render json: retv
      end

      # http://localhost:3000/api/kiwi/tops/sitemap.json
      # http://localhost:4000/sitemap.xml
      def sitemap
        retv = {}
        retv[:bananas] = ::Kiwi::Banana.public_only.order(updated_at: :desc).limit(1000).as_json(only: [:key])
        render json: retv
      end

      private

      def current_bananas
        @current_bananas ||= page_scope(::Kiwi::Banana.general_search(params.merge(current_user: current_user)).order(created_at: :desc))
      end

      # PageMethods override
      def default_per
        100
      end
    end
  end
end

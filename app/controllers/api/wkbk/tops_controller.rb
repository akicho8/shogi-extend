module Api
  module Wkbk
    class TopsController < ApplicationController
      # http://localhost:3000/api/wkbk/tops/index.json
      # http://localhost:3000/api/wkbk/tops/index.json?query=a&tag=b,c
      def index
        retval = {}
        retval[:books] = current_books.as_json(::Wkbk::Book.json_struct_for_top)
        retval[:xpage_info] = xpage_info(current_books)
        retval[:meta]  = AppEntryInfo.fetch(:wkbk).og_meta
        render json: retval
      end

      # http://localhost:3000/api/wkbk/tops/sitemap.json
      # http://localhost:4000/sitemap.xml
      def sitemap
        retval = {}
        retval[:books]    = ::Wkbk::Book.public_only.order(updated_at: :desc).limit(1000).as_json(only: [:key])
        retval[:articles] = ::Wkbk::Article.public_only.order(updated_at: :desc).limit(1000).as_json(only: [:key])
        render json: retval
      end

      private

      def current_books
        @current_books ||= page_scope(::Wkbk::Book.general_search(params.merge(current_user: current_user)).order(created_at: :desc))
      end

      # PageMethods override
      def default_per
        100
      end
    end
  end
end

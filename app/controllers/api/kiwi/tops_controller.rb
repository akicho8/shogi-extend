# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Book (kiwi_books as Kiwi::Book)
#
# |----------------+--------------------+--------------+---------------------+--------------+-------|
# | name           | desc               | type         | opts                | refs         | index |
# |----------------+--------------------+--------------+---------------------+--------------+-------|
# | id             | ID                 | integer(8)   | NOT NULL PK         |              |       |
# | key            | ユニークなハッシュ | string(255)  | NOT NULL            |              | A     |
# | user_key        | User               | integer(8)   | NOT NULL            | => ::User#id | B     |
# | folder_key      | Folder             | integer(8)   | NOT NULL            |              | C     |
# | sequence_key    | Sequence           | integer(8)   | NOT NULL            |              | D     |
# | title          | タイトル           | string(255)  |                     |              |       |
# | description    | 説明               | string(1024) |                     |              |       |
# | articles_count | Articles count     | integer(4)   | DEFAULT(0) NOT NULL |              |       |
# | created_at     | 作成日時           | datetime     | NOT NULL            |              |       |
# | updated_at     | 更新日時           | datetime     | NOT NULL            |              |       |
# |----------------+--------------------+--------------+---------------------+--------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# User.has_one :profile
#--------------------------------------------------------------------------------

module Api
  module Kiwi
    class TopsController < ApplicationController
      # http://localhost:3000/api/kiwi/tops/index.json
      # http://localhost:3000/api/kiwi/tops/index.json?query=a&tag=b,c
      def index
        retv = {}
        retv[:books] = current_books.as_json(::Kiwi::Book.json_struct_for_top)
        retv[:meta]  = AppEntryInfo.fetch(:kiwi_lemon_index).og_meta
        render json: retv
      end

      # http://localhost:3000/api/kiwi/tops/sitemap.json
      # http://localhost:4000/sitemap.xml
      def sitemap
        retv = {}
        retv[:books]    = ::Kiwi::Book.public_only.order(updated_at: :desc).limit(1000).as_json(only: [:key])
        # retv[:articles] = ::Kiwi::Article.public_only.order(updated_at: :desc).limit(1000).as_json(only: [:key])
        render json: retv
      end

      private

      def current_books
        @current_books ||= -> {
          # s = ::Kiwi::Book.all
          s = ::Kiwi::Book.general_search(params.merge(current_user: current_user))
          # s = s.order(created_at: :desc)
          # s = page_scope(s)       # page_methods.rb
        }.call
      end

      # PageMethods override
      def default_per
        50
      end
    end
  end
end

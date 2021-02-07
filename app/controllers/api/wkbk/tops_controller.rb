# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Book (wkbk_books as Wkbk::Book)
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
  module Wkbk
    class TopsController < ApplicationController
      # http://0.0.0.0:3000/api/wkbk/tops/index.json
      def index
        retv = {}
        retv[:books] = current_books.as_json(::Wkbk::Book.index_json_type5)
        retv[:meta]  = ServiceInfo.fetch(:wkbk).og_meta
        render json: retv
      end

      private

      def current_books
        @current_books ||= -> {
          s = ::Wkbk::Book.public_only
          if current_user
            s = s.or(current_user.wkbk_books.joins(:folder))
          end
          s = s.order(updated_at: :desc)
          s = page_scope(s)       # page_mod.rb
        }.call
      end

      # PageMod override
      def default_per
        50
      end
    end
  end
end

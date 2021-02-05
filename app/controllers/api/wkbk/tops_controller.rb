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
# | user_id        | User               | integer(8)   | NOT NULL            | => ::User#id | B     |
# | folder_id      | Folder             | integer(8)   | NOT NULL            |              | C     |
# | sequence_id    | Sequence           | integer(8)   | NOT NULL            |              | D     |
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
            # 本当は↓としたいけど or するときは両方同じ join が必要らしいのでしかたなく private_only している
            # s = s.or(::Wkbk::Book.where(user: current_user))
            s = s.or(::Wkbk::Book.private_only.where(user: current_user))
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

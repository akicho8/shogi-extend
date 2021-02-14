# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Book (wkbk_books as Wkbk::Book)
#
# |-----------------+--------------------+--------------+---------------------+--------------+-------|
# | name            | desc               | type         | opts                | refs         | index |
# |-----------------+--------------------+--------------+---------------------+--------------+-------|
# | id              | ID                 | integer(8)   | NOT NULL PK         |              |       |
# | key             | ユニークなハッシュ | string(255)  | NOT NULL            |              | A!    |
# | user_id         | User               | integer(8)   | NOT NULL            | => ::User#id | B     |
# | folder_id       | Folder             | integer(8)   | NOT NULL            |              | C     |
# | sequence_id     | Sequence           | integer(8)   | NOT NULL            |              | D     |
# | title           | タイトル           | string(100)  | NOT NULL            |              |       |
# | description     | 説明               | string(5000) | NOT NULL            |              |       |
# | bookships_count | Bookships count    | integer(4)   | DEFAULT(0) NOT NULL |              |       |
# | created_at      | 作成日時           | datetime     | NOT NULL            |              |       |
# | updated_at      | 更新日時           | datetime     | NOT NULL            |              |       |
# |-----------------+--------------------+--------------+---------------------+--------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# User.has_one :profile
#--------------------------------------------------------------------------------

module Api
  module Wkbk
    class AnswerLogsController < ApplicationController
      before_action :api_login_required, only: [:create]

      # POST http://0.0.0.0:3000/api/wkbk/answer_logs/create
      def create
        book = ::Wkbk::Book.find(params[:book_id])
        show_can!(book)
        article = book.articles.find(params[:article_id])
        show_can!(article)
        answer_kind = ::Wkbk::AnswerKind.fetch(params[:answer_kind_key])
        wkbk_answer_log = current_user.wkbk_answer_logs.create!(article: article, answer_kind: answer_kind, book: book)
        render json: wkbk_answer_log
      end
    end
  end
end

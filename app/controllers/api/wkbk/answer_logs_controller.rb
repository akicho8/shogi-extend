# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Answer log (wkbk_answer_logs as Wkbk::AnswerLog)
#
# |----------------+-------------+------------+-------------+--------------+-------|
# | name           | desc        | type       | opts        | refs         | index |
# |----------------+-------------+------------+-------------+--------------+-------|
# | id             | ID          | integer(8) | NOT NULL PK |              |       |
# | article_id     | Article     | integer(8) | NOT NULL    |              | A     |
# | answer_kind_id | Answer kind | integer(8) | NOT NULL    |              | B     |
# | book_id        | Book        | integer(8) | NOT NULL    |              | C     |
# | user_id        | User        | integer(8) | NOT NULL    | => ::User#id | D     |
# | spent_sec      | Spent sec   | integer(4) | NOT NULL    |              | E     |
# | created_at     | 作成日時    | datetime   | NOT NULL    |              | F     |
# |----------------+-------------+------------+-------------+--------------+-------|
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
        answer_log = current_user.wkbk_answer_logs.create!(article: article, answer_kind: answer_kind, book: book, spent_sec: params[:spent_sec])
        render json: answer_log
      end

      rescue_from "ActiveRecord::RecordNotFound" do |error|
        render json: { message: "問題を解いている最中に問題または問題集が削除されてしまいました" }
      end
    end
  end
end

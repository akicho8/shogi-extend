# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Article (wkbk_articles as Wkbk::Article)
#
# |---------------------+---------------------+--------------+---------------------+--------------+-------|
# | name                | desc                | type         | opts                | refs         | index |
# |---------------------+---------------------+--------------+---------------------+--------------+-------|
# | id                  | ID                  | integer(8)   | NOT NULL PK         |              |       |
# | key                 | ユニークなハッシュ  | string(255)  | NOT NULL            |              | A     |
# | user_key             | User                | integer(8)   | NOT NULL            | => ::User#id | B     |
# | lineage_key          | Lineage             | integer(8)   | NOT NULL            |              | C     |
# | book_key             | Book                | integer(8)   |                     |              | D     |
# | init_sfen           | Init sfen           | string(255)  | NOT NULL            |              | E     |
# | viewpoint           | Viewpoint           | string(255)  | NOT NULL            |              |       |
# | title               | タイトル            | string(255)  |                     |              |       |
# | description         | 説明                | string(1024) |                     |              |       |
# | turn_max            | 手数                | integer(4)   |                     |              | F     |
# | mate_skip           | Mate skip           | boolean      |                     |              |       |
# | direction_message   | Direction message   | string(255)  |                     |              |       |
# | moves_answers_count | Moves answers count | integer(4)   | DEFAULT(0) NOT NULL |              |       |
# | created_at          | 作成日時            | datetime     | NOT NULL            |              |       |
# | updated_at          | 更新日時            | datetime     | NOT NULL            |              |       |
# |---------------------+---------------------+--------------+---------------------+--------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# User.has_one :profile
#--------------------------------------------------------------------------------

module Api
  module Wkbk
    class ArticlesController < ApplicationController
      before_action :api_login_required, only: [:edit, :save]

      # http://0.0.0.0:3000/api/wkbk/articles
      # http://0.0.0.0:3000/api/wkbk/articles?scope=everyone
      # http://0.0.0.0:3000/api/wkbk/articles?scope=public
      # http://0.0.0.0:3000/api/wkbk/articles?scope=private
      # http://0.0.0.0:3000/api/wkbk/articles?sort_column=id&sort_order=desc
      def index
        retv = {}
        retv[:articles]       = sort_scope_for_articles(current_articles).as_json(::Wkbk::Article.json_type5)
        retv[:article_counts] = article_counts
        retv[:total]          = current_articles.total_count
        retv[:meta]           = ServiceInfo.fetch(:wkbk).og_meta
        render json: retv
      end

      # http://0.0.0.0:3000/api/wkbk/articles/show
      # http://0.0.0.0:3000/api/wkbk/articles/show?article_key=1
      # http://0.0.0.0:3000/api/wkbk/articles/show?article_key=1&_user_key=1
      def show
        retv = {}
        retv[:config] = ::Wkbk::Config
        article = ::Wkbk::Article.find_by!(key: params[:article_key])
        show_permission_valid!(article)
        retv[:article] = article.as_json(::Wkbk::Article.show_json_struct)
        retv[:meta] = article.og_meta
        render json: retv
      end

      # http://0.0.0.0:3000/api/wkbk/articles/edit.json
      # http://0.0.0.0:3000/api/wkbk/articles/edit.json?book_key=1
      # http://0.0.0.0:3000/api/wkbk/articles/edit.json?book_key=1&_user_key=1
      def edit
        retv = {}
        retv[:config] = ::Wkbk::Config
        retv[:LineageInfo] = ::Wkbk::LineageInfo.as_json(only: [:key, :name, :type, :mate_validate_on])
        retv[:books] = current_books

        if v = params[:article_key]
          article = current_user.wkbk_articles.find_by!(key: v)
          # edit_permission_valid!(article)
        else
          # article = current_user.wkbk_articles.build()
          article = current_user.wkbk_articles.build
          article.default_assign
          # retv[:article] = ::Wkbk::Article.default_attributes.merge(book_key: default_book_key)
          # retv[:meta] = ::Wkbk::Article.new_og_meta
        end
        retv[:article] = article.as_json(::Wkbk::Article.json_type5)
        retv[:meta] = article.og_meta
        render json: retv
      end

      # POST http://0.0.0.0:3000/api/wkbk/articles/save
      def save
        retv = {}
        if v = params[:article][:key]
          article = current_user.wkbk_articles.find_by!(key: v)
        else
          article = current_user.wkbk_articles.build
        end
        begin
          article.update_from_js(params.to_unsafe_h[:article])
          retv[:article] = article.as_json(::Wkbk::Article.json_type5)
        rescue ActiveRecord::RecordInvalid => error
          retv[:form_error_message] = error.message
        end
        render json: retv
      end

      private

      def article_counts
        ::Wkbk::ArticleIndexScopeInfo.inject({}) do |a, e|
          a.merge(e.key => e.query_func[current_user].count)
        end
      end

      def current_articles
        @current_articles ||= -> {
          s = current_article_scope_info.query_func[current_user]
          if v = params[:tag].to_s.split(/[,\s]+/).presence
            s = s.tagged_with(v)
          end
          s = page_scope(s)       # page_mod.rb
        }.call
      end

      def sort_scope_for_articles(s)
        if sort_column && sort_order
          columns = sort_column.to_s.scan(/\w+/)
          case columns.first
          when "user"
            s = s.joins(:user).merge(User.reorder(columns.last => sort_order))
          when "book"
            s = s.joins(:book).merge(::Wkbk::Book.reorder(columns.last => sort_order))
          when "lineage"
            s = s.joins(:lineage).merge(::Wkbk::Lineage.reorder(columns.last => sort_order)) # position の order を避けるため reorder
          else
            s = sort_scope(s)
          end
        end
        s
      end

      def current_article_scope_info
        ::Wkbk::ArticleIndexScopeInfo.fetch(current_scope)
      end

      def current_scope
        (params[:scope].presence || :everyone).to_sym
      end

      def current_book
        if current_user
          if v = params[:book_key]
            current_user.wkbk_books.find_by!(key: v)
          end
        end
      end

      def default_book_key
        current_book&.key
      end

      # PageMod override
      def default_per
        ::Wkbk::Config[:api_articles_fetch_per]
      end

      # プルダウン選択用
      def current_books
        if current_user
          current_user.wkbk_books.order(:created_at).as_json(::Wkbk::Book.json_type7)
        else
          []
        end
      end
    end
  end
end

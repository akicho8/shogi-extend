# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Article (wkbk_articles as Wkbk::Article)
#
# |---------------------+---------------------+--------------+---------------------+--------------+-------|
# | name                | desc                | type         | opts                | refs         | index |
# |---------------------+---------------------+--------------+---------------------+--------------+-------|
# | id                  | ID                  | integer(8)   | NOT NULL PK         |              |       |
# | key                 | ユニークなハッシュ  | string(255)  | NOT NULL            |              | A!    |
# | user_id             | User                | integer(8)   | NOT NULL            | => ::User#id | B     |
# | folder_id           | Folder              | integer(8)   | NOT NULL            |              | C     |
# | lineage_id          | Lineage             | integer(8)   | NOT NULL            |              | D     |
# | init_sfen           | Init sfen           | string(255)  | NOT NULL            |              | E     |
# | viewpoint           | Viewpoint           | string(255)  | NOT NULL            |              |       |
# | title               | タイトル            | string(100)  | NOT NULL            |              |       |
# | description         | 解説                | string(5000) | NOT NULL            |              |       |
# | direction_message   | Direction message   | string(100)  | NOT NULL            |              |       |
# | turn_max            | 手数                | integer(4)   | NOT NULL            |              | F     |
# | mate_skip           | Mate skip           | boolean      | NOT NULL            |              |       |
# | moves_answers_count | Moves answers count | integer(4)   | DEFAULT(0) NOT NULL |              |       |
# | difficulty          | Difficulty          | integer(4)   | NOT NULL            |              | G     |
# | answer_logs_count   | Answer logs count   | integer(4)   | DEFAULT(0) NOT NULL |              |       |
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
      before_action :api_login_required, only: [:edit, :save, :destroy]

      # http://0.0.0.0:3000/api/wkbk/articles/index?_user_id=1
      # http://0.0.0.0:3000/api/wkbk/articles/index?_user_id=1&sort_column=id&sort_order=desc
      def index
        retv = {}
        retv[:articles]       = sort_scope_for_articles(current_articles).as_json(::Wkbk::Article.json_struct_for_index)
        # retv[:article_counts] = article_counts
        retv[:total]          = current_articles.total_count
        retv[:meta]           = ServiceInfo.fetch(:wkbk).og_meta
        render json: retv
      end

      # http://0.0.0.0:3000/api/wkbk/articles/show
      # http://0.0.0.0:3000/api/wkbk/articles/show?article_key=1
      # http://0.0.0.0:3000/api/wkbk/articles/show?article_key=1&_user_id=1
      def show
        retv = {}
        retv[:config] = ::Wkbk::Config
        article = ::Wkbk::Article.find_by!(key: params[:article_key])
        show_can!(article)
        retv[:article] = article.as_json(::Wkbk::Article.json_struct_for_show)
        retv[:meta] = article.og_meta
        render json: retv
      end

      # http://0.0.0.0:3000/api/wkbk/articles/edit.json
      # http://0.0.0.0:3000/api/wkbk/articles/edit.json?book_key=1
      # http://0.0.0.0:3000/api/wkbk/articles/edit.json?book_key=1&_user_id=1
      # http://0.0.0.0:3000/api/wkbk/articles/edit.json?article_key=1&_user_id=1
      def edit
        retv = {}
        retv[:config] = ::Wkbk::Config
        retv[:LineageInfo] = ::Wkbk::LineageInfo.as_json(only: [:key, :name, :type, :mate_validate_on])

        if v = params[:article_key]
          article = current_user.wkbk_articles.find_by!(key: v) # 本人しかアクセスできないため権限チェックは不要
          # edit_permission_valid!(article)
        else
          # article = current_user.wkbk_articles.build
          article = current_user.wkbk_articles.build
          article.default_assign
          if default_book
            article.books = [default_book]
            article.folder_key = default_book.folder_key
          end
          # retv[:article] = ::Wkbk::Article.default_attributes.merge(book_key: default_book_key)
          # retv[:meta] = ::Wkbk::Article.new_og_meta
        end

        retv[:article] = article.as_json(::Wkbk::Article.json_struct_for_edit)
        retv[:meta] = article.og_meta

        # チェックしたものが上に来るようにする
        books = [
          default_book,                                     # 引数で指定したものが一番上
          article.books.order(updated_at: :desc),           # 現在のレコードで選択したもの
          current_user.wkbk_books.order(updated_at: :desc), # その他全部
        ].flatten.compact.uniq
        retv[:books] = books.as_json(::Wkbk::Book.json_struct_for_article_edit_form)

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
          retv[:article] = article.as_json(::Wkbk::Article.json_struct_for_edit)
        rescue ActiveRecord::RecordInvalid => error
          retv[:form_error_message] = error.message
        end
        render json: retv
      end

      # DELETE http://0.0.0.0:3000/api/wkbk/books/destroy
      def destroy
        current_user.wkbk_articles.find(params[:article_id]).destroy!
        render json: {}
      end

      private

      def article_counts
        ::Wkbk::ArticleIndexScopeInfo.inject({}) do |a, e|
          a.merge(e.key => e.query_func[current_user].count)
        end
      end

      def current_articles
        @current_articles ||= -> {
          # s = current_article_scope_info.query_func[current_user]
          if current_user
            s = current_user.wkbk_articles
          else
            s = ::Wkbk::Article.none
          end
          if v = params[:tag].to_s.split(/[,\s]+/).presence
            s = s.tagged_with(v)
          end
          s = page_scope(s)       # page_mod.rb
        }.call
      end

      # FIXME: model に移動
      def sort_scope_for_articles(s)
        if sort_column && sort_order
          columns = sort_column.to_s.scan(/\w+/)
          case columns.first
          when "user"
            s = s.joins(:user).merge(User.reorder(columns.last => sort_order))
          when "books"
            s = s.joins(:books).merge(::Wkbk::Book.reorder(columns.last => sort_order))
          when "lineage"
            s = s.joins(:lineage).merge(::Wkbk::Lineage.reorder(columns.last => sort_order)) # position の order を避けるため reorder
          when "folder"
            s = s.joins(:folder).merge(::Wkbk::Folder.reorder(columns.last => sort_order)) # position の order を避けるため reorder
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

      def default_book
        if v = params[:book_key]
          current_user.wkbk_books.find_by!(key: v)
        end
      end

      # def default_book_key
      #   default_book&.key
      # end

      # PageMod override
      def default_per
        ::Wkbk::Config[:api_articles_fetch_per]
      end
    end
  end
end

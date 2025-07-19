# -*- coding: utf-8 -*-

# == Schema Information ==
#
# Article (wkbk_articles as Wkbk::Article)
#
# |---------------------+---------------------+-------------+---------------------+------+-------|
# | name                | desc                | type        | opts                | refs | index |
# |---------------------+---------------------+-------------+---------------------+------+-------|
# | id                  | ID                  | integer(8)  | NOT NULL PK         |      |       |
# | key                 | キー                | string(255) | NOT NULL            |      | A!    |
# | user_id             | User                | integer(8)  | NOT NULL            |      | B     |
# | folder_id           | Folder              | integer(8)  | NOT NULL            |      | C     |
# | lineage_id          | Lineage             | integer(8)  | NOT NULL            |      | D     |
# | init_sfen           | Init sfen           | string(255) | NOT NULL            |      | E     |
# | viewpoint           | Viewpoint           | string(255) | NOT NULL            |      |       |
# | title               | タイトル            | string(100) | NOT NULL            |      |       |
# | description         | 説明                | text(65535) | NOT NULL            |      |       |
# | direction_message   | Direction message   | string(100) | NOT NULL            |      |       |
# | turn_max            | 手数                | integer(4)  | NOT NULL            |      | F     |
# | mate_skip           | Mate skip           | boolean     | NOT NULL            |      |       |
# | moves_answers_count | Moves answers count | integer(4)  | DEFAULT(0) NOT NULL |      |       |
# | difficulty          | Difficulty          | integer(4)  | NOT NULL            |      | G     |
# | answer_logs_count   | Answer logs count   | integer(4)  | DEFAULT(0) NOT NULL |      |       |
# | created_at          | 作成日時            | datetime    | NOT NULL            |      |       |
# | updated_at          | 更新日時            | datetime    | NOT NULL            |      |       |
# |---------------------+---------------------+-------------+---------------------+------+-------|
#
# - Remarks ----------------------------------------------------------------------
# [Warning: Need to add relation] Wkbk::Article モデルに belongs_to :lineage を追加してください
# [Warning: Need to add relation] Wkbk::Article モデルに belongs_to :user を追加してください
# --------------------------------------------------------------------------------

module Api
  module Wkbk
    class ArticlesController < ApplicationController
      before_action :api_login_required, only: [:edit, :save, :destroy]

      # http://localhost:3000/api/wkbk/articles/index?_user_id=1
      # http://localhost:3000/api/wkbk/articles/index?_user_id=1&sort_column=id&sort_order=desc
      def index
        retval = {}
        retval[:articles] = current_articles.sorted(sort_info).as_json(::Wkbk::Article.json_struct_for_index)
        retval[:total]    = current_articles.total_count
        retval[:meta]     = AppEntryInfo.fetch(:wkbk).og_meta
        render json: retval
      end

      # http://localhost:3000/api/wkbk/articles/show
      # http://localhost:3000/api/wkbk/articles/show?article_key=1
      # http://localhost:3000/api/wkbk/articles/show?article_key=1&_user_id=1
      def show
        retval = {}
        retval[:config] = ::Wkbk::Config
        article = ::Wkbk::Article.find_by!(key: params[:article_key])
        show_can!(article)
        retval[:article] = article.as_json(::Wkbk::Article.json_struct_for_show)
        retval[:meta] = article.og_meta
        render json: retval
      end

      # http://localhost:3000/api/wkbk/articles/edit.json
      # http://localhost:3000/api/wkbk/articles/edit.json?book_key=1
      # http://localhost:3000/api/wkbk/articles/edit.json?book_key=1&_user_id=1
      # http://localhost:3000/api/wkbk/articles/edit.json?article_key=1&_user_id=1
      def edit
        retval = {}
        retval[:config] = ::Wkbk::Config
        retval[:LineageInfo] = ::Wkbk::LineageInfo.as_json(only: [:key, :name, :type, :mate_validate_on])

        if v = params[:article_key]
          article = current_user.wkbk_articles.find_by!(key: v) # 本人しかアクセスできないため権限チェックは不要
          # edit_permission_valid!(article)
        else
          # article = current_user.wkbk_articles.build
          article = current_user.wkbk_articles.build
          article.form_values_default_assign(params.merge(source_article: source_article, books: default_books))
          # retval[:article] = ::Wkbk::Article.default_attributes.merge(book_key: default_book_key)
          # retval[:meta] = ::Wkbk::Article.new_og_meta
        end

        retval[:article] = article.as_json(::Wkbk::Article.json_struct_for_edit)
        retval[:meta] = article.og_meta

        # チェックしたものが上に来るようにする
        books = [
          default_books,                                     # 引数で指定したものが一番上
          article.books.order(updated_at: :desc),           # 現在のレコードで選択したもの
          current_user.wkbk_books.order(updated_at: :desc), # その他全部
        ].flatten.compact.uniq
        retval[:books] = books.as_json(::Wkbk::Book.json_struct_for_article_edit_form)

        render json: retval
      end

      # POST http://localhost:3000/api/wkbk/articles/save
      def save
        retval = {}
        if v = params[:article][:key]
          article = current_user.wkbk_articles.find_by!(key: v)
        else
          article = current_user.wkbk_articles.build
        end
        begin
          article.update_from_action(params.to_unsafe_h[:article])
          retval[:article] = article.as_json(::Wkbk::Article.json_struct_for_edit)
        rescue ActiveRecord::RecordInvalid => error
          retval[:form_error_message] = error.message
        end
        render json: retval
      end

      # DELETE http://localhost:3000/api/wkbk/books/destroy
      def destroy
        current_user.wkbk_articles.find(params[:article_id]).destroy!
        render json: {}
      end

      private

      def current_articles
        @current_articles ||= yield_self do
          # s = current_article_scope_info.query_func[current_user]
          if current_user
            s = current_user.wkbk_articles
          else
            s = ::Wkbk::Article.none
          end
          if v = params[:tag].to_s.split(/[,\s]+/).presence
            s = s.tagged_with(v)
          end
          s = page_scope(s)       # page_methods.rb
        end
      end

      def current_article_scope_info
        ::Wkbk::ArticleIndexScopeInfo.fetch(current_scope)
      end

      def current_scope
        (params[:scope].presence || :everyone).to_sym
      end

      def default_books
        (params[:book_key] || params[:book_keys]).to_s.scan(/\w+/).collect { |key|
          current_user.wkbk_books.find_by!(key: key)
        }
      end

      # PageMethods override
      def default_per
        ::Wkbk::Config[:api_articles_fetch_per]
      end

      # コピー元は編集権限と同じスコープで取得する
      def source_article
        if v = params[:source_article_key]
          current_user.wkbk_articles.find_by!(key: v)
        end
      end
    end
  end
end

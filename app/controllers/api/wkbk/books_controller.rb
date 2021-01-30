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
    class BooksController < ApplicationController
      # http://0.0.0.0:3000/api/wkbk/books.json
      # http://0.0.0.0:3000/api/wkbk/books.json?scope=everyone
      # http://0.0.0.0:3000/api/wkbk/books.json?scope=public
      # http://0.0.0.0:3000/api/wkbk/books.json?scope=private
      def index
        retv = {}
        retv[:books]       = sort_scope_for_books(current_books).as_json(::Wkbk::Book.json_type5)
        retv[:book_counts] = book_counts
        retv[:total]          = current_books.total_count
        render json: retv
      end

      # http://0.0.0.0:3000/api/wkbk/books/show.json?book_id=1
      def show
        retv = {}
        retv[:config] = ::Wkbk::Config
        book = ::Wkbk::Book.find(params[:book_id])
        if book.owner_editable_p(current_user)
          v = book.as_json(::Wkbk::Book.show_json_struct)
          v[:articles] = book.ordered_articles.as_json(::Wkbk::Book.show_articles_json_struct)
          retv[:book] = v
          retv[:meta] = book_meta(book)
          # else
          #   retv[:ogp_meta_hash] = {
          #     :title                 => "#{book.user.name}さんの問題集(非公開)",
          #     :description           => "",
          #     :og_image_key          => "library-books",
          #     :twitter_card_is_small => true,
          #   }
        else
          retv[:error] = { statusCode: 403, message: "非公開" }
        end

        # sleep(3)
        render json: retv
      end

      # 問題編集用
      # 管理者が他者の問題を編集することもあるため current_user のスコープをつけてはいけない
      #
      # http://0.0.0.0:4000/library/books/new
      # http://0.0.0.0:4000/library/books/1/edit
      #
      def edit
        retv = {}
        if current_user
          retv[:config] = ::Wkbk::Config
          if params[:book_id]
            # 編集
            book = ::Wkbk::Book.find(params[:book_id])
            if book.owner_editable_p(current_user)
              retv[:book] = book.as_json(::Wkbk::Book.json_type5)
              retv[:meta] = book_meta(book)
            else
              retv[:error] = { statusCode: 403, message: "所有者ではありません" }
            end
          else
            # 新規
            retv[:book] = ::Wkbk::Book.default_attributes
          end
        else
          retv[:error] = { statusCode: 403, message: "ログインしてください" }
        end
        render json: retv
      end

      # POST http://0.0.0.0:3000/api/wkbk/books/save
      def save
        retv = {}
        if current_user
          if id = params[:book][:id]
            book = current_user.wkbk_books.find(id)
          else
            book = current_user.wkbk_books.build
          end
          begin
            book.update_from_js(params.to_unsafe_h[:book])
            retv[:book] = book.as_json(::Wkbk::Book.json_type5)
          rescue ActiveRecord::RecordInvalid => error
            retv[:form_error_message] = error.message
          end
        end
        render json: retv
      end

      private

      def book_counts
        ::Wkbk::BookIndexScopeInfo.inject({}) do |a, e|
          a.merge(e.key => e.query_func[current_user].count)
        end
      end

      def current_books
        @current_books ||= -> {
          s = current_book_scope_info.query_func[current_user]
          if v = params[:tag].presence # TODO: 複数タグ
            s = s.tagged_with(v)
          end
          s = page_scope(s)       # page_mod.rb
        }.call
      end

      def sort_scope_for_books(s)
        if sort_column && sort_order
          columns = sort_column.to_s.scan(/\w+/)
          case columns.first
          when "user"
            s = s.joins(:user).merge(User.reorder(columns.last => sort_order))
          else
            s = sort_scope(s)
          end
        end
        s
      end

      def current_book_scope_info
        ::Wkbk::BookIndexScopeInfo.fetch(current_scope)
      end

      def current_scope
        (params[:scope].presence || :everyone).to_sym
      end

      # PageMod override
      def default_per
        ::Wkbk::Config[:api_books_fetch_per]
      end

      def book_meta(book)
        {
          :title       => [book.title, book.user.name].join(" - "),
          :description => book.description || "",
          :og_image    => book.og_image_path || "library-books",
        }
      end
    end
  end
end

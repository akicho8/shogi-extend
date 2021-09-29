# -*- coding: utf-8 -*-
# == Schema Information ==
#
# アーカイブ (kiwi_books as Kiwi::Book)
#
# |---------------------+---------------------+-------------+---------------------+--------------+-------|
# | name                | desc                | type        | opts                | refs         | index |
# |---------------------+---------------------+-------------+---------------------+--------------+-------|
# | id                  | ID                  | integer(8)  | NOT NULL PK         |              |       |
# | key                 | ユニークなハッシュ  | string(255) | NOT NULL            |              | A!    |
# | user_id             | User                | integer(8)  | NOT NULL            | => ::User#id | C     |
# | folder_id           | Folder              | integer(8)  | NOT NULL            |              | D     |
# | lemon_id            | Lemon               | integer(8)  | NOT NULL            |              | B!    |
# | title               | タイトル            | string(100) | NOT NULL            |              |       |
# | description         | 説明                | text(65535) | NOT NULL            |              |       |
# | book_messages_count | Book messages count | integer(4)  | DEFAULT(0) NOT NULL |              | E     |
# | created_at          | 作成日時            | datetime    | NOT NULL            |              |       |
# | updated_at          | 更新日時            | datetime    | NOT NULL            |              |       |
# |---------------------+---------------------+-------------+---------------------+--------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# User.has_one :profile
#--------------------------------------------------------------------------------

module Api
  module Kiwi
    class BooksController < ApplicationController
      before_action :api_login_required, only: [:edit, :save, :destroy, :download]

      # http://localhost:3000/api/kiwi/books.json
      # http://localhost:3000/api/kiwi/books.json?scope=everyone
      # http://localhost:3000/api/kiwi/books.json?scope=public
      # http://localhost:3000/api/kiwi/books.json?scope=private
      def index
        retv = {}
        retv[:books] = current_books.sorted(sort_info).as_json(::Kiwi::Book.json_struct_for_index)
        retv[:total] = current_books.total_count
        # retv[:meta]  = AppEntryInfo.fetch(:kiwi).og_meta
        render json: retv
      end

      # http://localhost:3000/api/kiwi/books/show.json?book_key=6&_user_id=1
      # http://localhost:3000/api/kiwi/books/show.json?book_key=5
      def show
        retv = {}
        retv[:config] = ::Kiwi::Config
        book = ::Kiwi::Book.find_by!(key: params[:book_key])
        show_can!(book)
        v = book.as_json(::Kiwi::Book.json_struct_for_show)
        # v[:xitems] = book.to_xitems(current_user)
        retv[:book] = v
        render json: retv
      end

      # 問題編集用
      #
      # http://localhost:3000/api/kiwi/books/edit.json
      # http://localhost:3000/api/kiwi/books/edit.json?book_key=1
      # http://localhost:4000/video/watch/new
      # http://localhost:4000/video/watch/1/edit
      def edit
        retv = {}
        retv[:config] = ::Kiwi::Config
        s = current_user.kiwi_books
        if v = params[:book_key]
          book = s.find_by!(key: v)
          # edit_permission_valid!(book)
        else
          book = s.build
          if current_lemon
            book.lemon = current_lemon
          end
          book.form_values_default_assign
        end
        retv[:book] = book.as_json(::Kiwi::Book.json_struct_for_edit)
        retv[:meta] = book.og_meta
        # sleep(3)
        render json: retv
      end

      # POST http://localhost:3000/api/kiwi/books/save
      # nginx の client_max_body_size を調整が必要
      def save
        retv = {}
        if v = params[:book][:key]
          book = current_user.kiwi_books.find_by!(key: v)
        else
          book = current_user.kiwi_books.build
        end
        begin
          book.update_from_js(params.to_unsafe_h[:book])
          retv[:book] = book.as_json(::Kiwi::Book.json_struct_for_edit)
        rescue ActiveRecord::RecordInvalid => error
          retv[:form_error_message] = error.message
        end
        render json: retv
      end

      # DELETE http://localhost:3000/api/kiwi/books/destroy
      def destroy
        current_user.kiwi_books.find(params[:book_id]).destroy!
        render json: {}
      end

      def download
        book = ::Kiwi::Book.find_by!(key: params[:book_key])
        show_can!(book)
        send_data(*book.to_send_data_params(params.merge(current_user: current_user)))
      end

      private

      # def book_counts
      #   ::Kiwi::BookIndexScopeInfo.inject({}) do |a, e|
      #     a.merge(e.key => e.query_func[current_user].count)
      #   end
      # end

      def current_books
        @current_books ||= -> {
          # s = current_book_scope_info.query_func[current_user]
          if current_user
            s = current_user.kiwi_books
          else
            s = ::Kiwi::Book.none
          end
          if v = params[:tag].to_s.split(/[,\s]+/).presence
            s = s.tagged_with(v)
          end
          s = page_scope(s)       # page_methods.rb
        }.call
      end

      # PageMethods override
      def default_per
        ::Kiwi::Config[:api_books_fetch_per]
      end

      def current_lemon
        if v = params[:source_id].presence
          if current_user
            current_user.kiwi_lemons.find(v)
          end
        end
      end
    end
  end
end

# -*- coding: utf-8 -*-

# == Schema Information ==
#
# Book (wkbk_books as Wkbk::Book)
#
# |-------------------+-------------------+-------------+---------------------+------+-------|
# | name              | desc              | type        | opts                | refs | index |
# |-------------------+-------------------+-------------+---------------------+------+-------|
# | id                | ID                | integer(8)  | NOT NULL PK         |      |       |
# | key               | キー              | string(255) | NOT NULL            |      | A!    |
# | user_id           | User              | integer(8)  | NOT NULL            |      | B     |
# | folder_id         | Folder            | integer(8)  | NOT NULL            |      | C     |
# | sequence_id       | Sequence          | integer(8)  | NOT NULL            |      | D     |
# | title             | タイトル          | string(100) | NOT NULL            |      |       |
# | description       | 説明              | text(65535) | NOT NULL            |      |       |
# | bookships_count   | Bookships count   | integer(4)  | DEFAULT(0) NOT NULL |      |       |
# | answer_logs_count | Answer logs count | integer(4)  | DEFAULT(0) NOT NULL |      |       |
# | created_at        | 作成日時          | datetime    | NOT NULL            |      |       |
# | updated_at        | 更新日時          | datetime    | NOT NULL            |      |       |
# | access_logs_count | Access logs count | integer(4)  | DEFAULT(0) NOT NULL |      | E     |
# |-------------------+-------------------+-------------+---------------------+------+-------|
#
# - Remarks ----------------------------------------------------------------------
# [Warning: Need to add relation] Wkbk::Book モデルに belongs_to :sequence を追加しよう
# [Warning: Need to add relation] Wkbk::Book モデルに belongs_to :user を追加しよう
# --------------------------------------------------------------------------------

module Api
  module Wkbk
    class BooksController < ApplicationController
      before_action :api_login_required, only: [:edit, :save, :destroy, :download]

      # http://localhost:3000/api/wkbk/books.json
      # http://localhost:3000/api/wkbk/books.json?scope=everyone
      # http://localhost:3000/api/wkbk/books.json?scope=public
      # http://localhost:3000/api/wkbk/books.json?scope=private
      def index
        retval = {}
        retval[:books] = current_books.sorted(sort_info).as_json(::Wkbk::Book.json_struct_for_index)
        retval[:total] = current_books.total_count
        retval[:meta]  = AppEntryInfo.fetch(:wkbk).og_meta
        render json: retval
      end

      # http://localhost:3000/api/wkbk/books/show.json?book_key=6&_user_id=1
      # http://localhost:3000/api/wkbk/books/show.json?book_key=5
      def show
        retval = {}
        retval[:config] = ::Wkbk::Config
        book = ::Wkbk::Book.find_by!(key: params[:book_key])
        show_can!(book)
        if force_access?
        else
          if axios_process_client? # 2度呼ばれるため仕方なく
            book.access_logs.create!(user: current_user)
          end
        end
        v = book.as_json(::Wkbk::Book.json_struct_for_show)
        v[:xitems] = book.to_xitems(current_user)
        retval[:book] = v
        render json: retval
      end

      # 問題編集用
      #
      # http://localhost:3000/api/wkbk/books/edit.json
      # http://localhost:3000/api/wkbk/books/edit.json?book_key=1
      # http://localhost:4000/rack/books/new
      # http://localhost:4000/rack/books/1/edit
      def edit
        retval = {}
        retval[:config] = ::Wkbk::Config
        s = current_user.wkbk_books
        if v = params[:book_key]
          book = s.find_by!(key: v)
        # edit_permission_valid!(book)
        else
          book = s.build
          book.form_values_default_assign
        end
        retval[:book] = book.as_json(::Wkbk::Book.json_struct_for_edit)
        retval[:meta] = book.og_meta
        # sleep(3)
        render json: retval
      end

      # POST http://localhost:3000/api/wkbk/books/save
      # nginx の client_max_body_size を調整が必要
      def save
        retval = {}
        if v = params[:book][:key]
          book = current_user.wkbk_books.find_by!(key: v)
        else
          book = current_user.wkbk_books.build
        end
        begin
          book.update_from_action(params.to_unsafe_h[:book])
          retval[:book] = book.as_json(::Wkbk::Book.json_struct_for_edit)
        rescue ActiveRecord::RecordInvalid => error
          retval[:form_error_message] = error.message
        end
        render json: retval
      end

      # DELETE http://localhost:3000/api/wkbk/books/destroy
      def destroy
        current_user.wkbk_books.find(params[:book_id]).destroy!
        render json: {}
      end

      def download
        book = ::Wkbk::Book.find_by!(key: params[:book_key])
        show_can!(book)
        send_data(*book.to_send_data_params(params.merge(current_user: current_user)))
      end

      private

      def book_counts
        ::Wkbk::BookIndexScopeInfo.inject({}) do |a, e|
          a.merge(e.key => e.query_func[current_user].count)
        end
      end

      def current_books
        @current_books ||= yield_self do
          # s = current_book_scope_info.query_func[current_user]
          if current_user
            s = current_user.wkbk_books
          else
            s = ::Wkbk::Book.none
          end
          if v = params[:tag].to_s.split(/[,\s]+/).presence
            s = s.tagged_with(v)
          end
          s = page_scope(s)       # page_methods.rb
        end
      end

      def current_book_scope_info
        ::Wkbk::BookIndexScopeInfo.fetch(current_scope)
      end

      def current_scope
        (params[:scope].presence || :everyone).to_sym
      end

      # PageMethods override
      def default_per
        ::Wkbk::Config[:api_books_fetch_per]
      end
    end
  end
end

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

      # http://0.0.0.0:3000/api/wkbk/books/show?book_id=2
      def show
        retv = {}
        retv[:config] = ::Wkbk::Config
        book = ::Wkbk::Book.find(params[:book_id])
        if book.owner_editable_p(current_user)
          retv[:book] = book.as_json(::Wkbk::Book.json_type5a)
        end
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
        retv[:config] = ::Wkbk::Config
        # retv[:LineageInfo] = ::Wkbk::LineageInfo.as_json(only: [:key, :name, :type, :mate_validate_on])
        # retv[:FolderInfo]  = ::Wkbk::FolderInfo.as_json(only: [:key, :name, :icon, :type])

        if params[:book_id]
          # 編集
          record = ::Wkbk::Book.find(params[:book_id])
          if record.owner_editable_p(current_user)
            retv[:book] = record.as_json(::Wkbk::Book.json_type5)
          end
        else
          # 新規
          retv[:book] = ::Wkbk::Book.default_attributes
        end

        render json: retv
      end

      # POST http://0.0.0.0:3000/api/wkbk/books/save
      def save
        retv = {}
        if id = params[:book][:id]
          book = ::Wkbk::Book.find(id)
        else
          book = current_user.wkbk_books.build
        end
        begin
          book.update_from_js(params.to_unsafe_h[:book])
          retv[:book] = book.as_json(::Wkbk::Book.json_type5)
        rescue ActiveRecord::RecordInvalid => error
          retv[:form_error_message] = error.message
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
    end
  end
end

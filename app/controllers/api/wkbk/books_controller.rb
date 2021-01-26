module Api
  module Wkbk
    class BooksController < ApplicationController
      # 問題一覧
      # http://localhost:3000/api/wkbk.json?remote_action=books_index_fetch
      # http://localhost:3000/api/wkbk.json?remote_action=books_index_fetch&folder_key=active
      # http://localhost:3000/api/wkbk.json?remote_action=books_index_fetch&sort_column=lineage_key&sort_order=desc
      # app/javascript/wkbk_app/models/book_column_info.js
      def books_index_fetch
        s = Wkbk::Book.all
        if v = params[:folder_key]
          if v == "everyone"
            s = s.public_only
          else
            if current_user
              s = s.where(user: current_user)
              s = s.folder_eq(v)
            else
              s = s.none
            end
          end
        end
        if v = params[:tag].presence
          s = s.tagged_with(v)
        end
        s = page_scope(s)       # page_mod.rb
        s = sort_scope_for_books(s)

        retv = {}
        retv[:books]       = s.as_json(Wkbk::Book.json_type5)
        retv[:book_counts] = {}
        if current_user
          retv[:book_counts].update(current_user.wkbk_books.group(:folder_id).count.transform_keys { |e| Wkbk::Folder.find(e).key })
        end
        retv[:book_counts].update(everyone: Wkbk::Book.public_only.count)
        retv[:page_info]       = {**page_info(s), **sort_info, folder_key: params[:folder_key], tag: params[:tag]}
        retv
      end

      # http://localhost:3000/api/wkbk.json?remote_action=book_show_fetch&book_id=2
      def book_show_fetch
        info = {}
        info[:config] = Wkbk::Config
        # info[:LineageInfo] = Wkbk::LineageInfo.as_json(only: [:key, :name, :type, :mate_validate_on])
        info[:FolderInfo]  = Wkbk::FolderInfo.as_json(only: [:key, :name, :icon, :type])
        # if params[:book_id]

        book = Wkbk::Book.find(params[:book_id])
        case book.folder_key
        when :public
          info[:book] = book.as_json(Wkbk::Book.json_type5a)
        when :private
          if book.user == current_user
            info[:book] = book.as_json(Wkbk::Book.json_type5a)
          else
            info[:book] = nil
          end
        else
          raise "must not happen"
        end

        # else
        #   info[:book_default_attributes] = Wkbk::Book.default_attributes
        # end
        info
      end

      # 問題編集用
      # 管理者が他者の問題を編集することもあるため current_user のスコープをつけてはいけない
      #
      # http://0.0.0.0:4000/library/books/new
      # http://0.0.0.0:4000/library/books/1/edit
      #
      def book_edit_fetch
        info = {}
        info[:config] = Wkbk::Config
        # info[:LineageInfo] = Wkbk::LineageInfo.as_json(only: [:key, :name, :type, :mate_validate_on])
        info[:FolderInfo]  = Wkbk::FolderInfo.as_json(only: [:key, :name, :icon, :type])

        if params[:book_id]
          book = Wkbk::Book.find(params[:book_id])
          info[:book] = book.as_json(Wkbk::Book.json_type5)

          case book.folder_key
          when :public
            info[:book] = book.as_json(Wkbk::Book.json_type5)
          when :private
            if book.user == current_user
              info[:book] = book.as_json(Wkbk::Book.json_type5)
            else
              info[:book] = nil
            end
          else
            raise "must not happen"
          end
        else
          info[:book_default_attributes] = Wkbk::Book.default_attributes
        end

        info
      end

      def sort_scope_for_books(s)
        if sort_column && sort_order
          columns = sort_column.scan(/\w+/)
          case columns.first
          when "ox_record"
            # { key: "o_rate",           name: "正解率",     short_name: "正率",     visible: true,  },
            # { key: "o_count",          name: "正解数",     short_name: "正解",     visible: false, },
            # { key: "x_count",          name: "誤答数",     short_name: "誤答",     visible: false, },
            order = Wkbk::OxRecord.order(columns.last => sort_order)
            s = s.joins(:ox_record).merge(order)
          when "user"
            order = User.order(columns.last => sort_order)
            s = s.joins(:user).merge(order)
          when "lineage_key"
            s = s.joins(:lineage).merge(Wkbk::Lineage.reorder(id: sort_order)) # position の order を避けるため reorder
          else
            s = sort_scope(s)
          end
        end
        s
      end

      def book_save_handle
        if id = params[:book][:id]
          book = Wkbk::Book.find(id)
        else
          book = current_user.wkbk_books.build
        end
        begin
          book.update_from_js(params.to_unsafe_h[:book])
        rescue ActiveRecord::RecordInvalid => error
          return { form_error_message: error.message }
        end
        { book: book.as_json(Wkbk::Book.json_type5) }
      end

      # PageMod override
      def default_per
        Wkbk::Config[:api_books_fetch_per]
      end
    end
  end
end

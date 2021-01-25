module Api
  class WkbkController
    concern :ArticleMod do
      # 問題一覧
      # http://0.0.0.0:3000/api/wkbk.json?remote_action=article_index
      # http://0.0.0.0:3000/api/wkbk.json?remote_action=article_index&scope=public
      # http://0.0.0.0:3000/api/wkbk.json?remote_action=article_index&scope=private
      # http://0.0.0.0:3000/api/wkbk.json?remote_action=article_index&sort_column=lineage_key&sort_order=desc
      # app/javascript/wkbk_app/models/article_column_info.js
      def article_index
        retv = {}
        # retv[:current_user] = current_user
        retv[:ArticleIndexScopeInfo] = Wkbk::ArticleIndexScopeInfo.as_json(only: [:key, :name])
        retv[:articles]         = sort_scope_for_articles(current_articles).as_json(Wkbk::Article.json_type5)
        retv[:article_counts]   = article_counts
        retv[:total]            = current_articles.total_count
        # retv[:page_info]        = {scope: params[:scope], tag: params[:tag]}
        retv
      end

      # 問題編集用
      # 管理者が他者の問題を編集することもあるため current_user のスコープをつけてはいけない
      #
      # http://0.0.0.0:4000/library/articles/new
      # http://0.0.0.0:4000/library/articles/1/edit
      #
      def article_edit
        retv = {}
        retv[:config] = Wkbk::Config
        retv[:LineageInfo] = Wkbk::LineageInfo.as_json(only: [:key, :name, :type, :mate_validate_on])
        retv[:FolderInfo]  = Wkbk::FolderInfo.as_json(only: [:key, :name, :icon, :type])

        retv[:books] = current_user ? current_user.wkbk_books.order(:created_at) : []

        if params[:article_id]
          # 編集
          record = Wkbk::Article.find(params[:article_id])
          if record.owner_editable_p(current_user)
            retv[:article] = record.as_json(Wkbk::Article.json_type5)
          end
        else
          # 新規
          retv[:article] = Wkbk::Article.default_attributes.merge(book_id: default_book_id)
        end
        retv
      end

      def article_save
        if id = params[:article][:id]
          article = Wkbk::Article.find(id)
        else
          article = current_user.wkbk_articles.build
        end
        begin
          article.update_from_js(params.to_unsafe_h[:article])
        rescue ActiveRecord::RecordInvalid => error
          return { form_error_message: error.message }
        end
        { article: article.as_json(Wkbk::Article.json_type5) }
      end

      private

      def article_counts
        Wkbk::ArticleIndexScopeInfo.inject({}) do |a, e|
          a.merge(e.key => e.query_func[current_user].count)
        end
      end

      def current_articles
        @current_articles ||= -> {
          s = current_article_scope_info.query_func[current_user]
          if v = params[:tag].presence # TODO: 複数タグ
            s = s.tagged_with(v)
          end
          s = page_scope(s)       # page_mod.rb
        }.call
      end

      def sort_scope_for_articles(s)
        if sort_column && sort_order
          columns = sort_column.scan(/\w+/)
          case columns.first
          when "book_title"
            s = s.joins(:book).merge(Wkbk::Book.order(:title))
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

      def current_article_scope_info
        Wkbk::ArticleIndexScopeInfo.fetch(current_scope)
      end

      def current_scope
        (params[:scope].presence || :everyone).to_sym

        # if v = params[:scope].presence
        #   v.to_sym
        # else
        #   if current_user
        #     :public
        #   else
        #     :everyone
        #   end
        # end
      end

      def current_book
        if v = params[:book_id]
          if current_user
            current_user.wkbk_books.find_by(id: v)
          end
        end
      end

      def default_book_id
        if v = current_book
          v.id
        end
      end

      # PageMod override
      def default_per
        Wkbk::Config[:api_articles_fetch_per]
      end
    end
  end
end

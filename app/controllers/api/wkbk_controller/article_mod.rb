module Api
  class WkbkController
    concern :ArticleMod do
      # 問題編集用
      # 管理者が他者の問題を編集することもあるため current_user のスコープをつけてはいけない
      #
      # http://0.0.0.0:4000/wkbk/articles/new
      # http://0.0.0.0:4000/wkbk/articles/1/edit
      #
      def article_edit_fetch
        info = {}
        info[:config] = Wkbk::Config
        info[:LineageInfo] = Wkbk::LineageInfo.as_json(only: [:key, :name, :type, :mate_validate_on])
        info[:FolderInfo]  = Wkbk::FolderInfo.as_json(only: [:key, :name, :icon, :type])

        if current_user
          info[:books] = current_user.wkbk_books.order(:created_at)
        end

        if params[:article_id]
          article = Wkbk::Article.find(params[:article_id])
          info[:article] = article.as_json(Wkbk::Article.json_type5)
        else
          info[:article_default_attributes] = Wkbk::Article.default_attributes

          if current_user
            if v = params[:book_id]
              if book = current_user.wkbk_books.find_by(id: v)
                info[:article_default_attributes][:book_id] = book.id
              end
            end
          end

        end
        info
      end

      # 問題一覧
      # http://localhost:3000/api/wkbk.json?remote_action=articles_fetch
      # http://localhost:3000/api/wkbk.json?remote_action=articles_fetch&folder_key=active
      # http://localhost:3000/api/wkbk.json?remote_action=articles_fetch&sort_column=lineage_key&sort_order=desc
      # app/javascript/wkbk_app/models/article_column_info.js
      def articles_index_fetch
        params[:per] ||= Wkbk::Config[:api_articles_fetch_per]

        s = Wkbk::Article.all
        if v = params[:folder_key]
          if v == "all"
            s = s.folder_eq(:active)
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
        s = sort_scope_for_articles(s)

        retv = {}
        retv[:articles]       = s.as_json(Wkbk::Article.json_type5)
        retv[:article_counts] = {}
        if current_user
          retv[:article_counts].update(current_user.wkbk_articles.group(:folder_id).count.transform_keys { |e| Wkbk::Folder.find(e).key })
        end
        retv[:article_counts].update(all: Wkbk::Article.active_only.count)
        retv[:page_info]       = {**page_info(s), **sort_info, folder_key: params[:folder_key], tag: params[:tag]}
        retv
      end

      def article_save_handle
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

      def sort_scope_for_articles(s)
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

      # http://localhost:3000/api/wkbk.json?remote_action=article_single_fetch&article_id=1
      def article_single_fetch
        raise
        article = Wkbk::Article.find(params[:article_id])
        retv = {}
        retv[:article] = article.as_json_type6
        # if current_user
        #   retv.update(current_user.good_bad_clip_flags_for(article))
        # end
        { ov_article_info: retv }
      end

      # http://localhost:3000/api/wkbk.json?remote_action=resource_fetch
      def resource_fetch
        raise
        {
          # RuleInfo: Wkbk::RuleInfo.as_json,
          # OxMarkInfo: Wkbk::OxMarkInfo.as_json(only: [:key, :name, :score, :sound_key, :delay_second]),
          # SkillInfo: Wkbk::SkillInfo.as_json(only: [:key, :name]),
          # EmotionInfo: Wkbk::EmotionInfo.as_json, # 元に戻す用
          # EmotionFolderInfo: Wkbk::EmotionFolderInfo.as_json,
        }
      end

      # http://localhost:3000/api/wkbk.json?remote_action=builder_form_resource_fetch
      def builder_form_resource_fetch
        raise
        # {
        #   LineageInfo: Wkbk::LineageInfo.as_json(only: [:key, :name, :type, :mate_validate_on]),
        #   FolderInfo:  Wkbk::FolderInfo.as_json(only: [:key, :name, :icon, :type]),
        # }
      end

    end
  end
end

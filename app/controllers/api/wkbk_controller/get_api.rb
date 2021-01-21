module Api
  class WkbkController
    concern :GetApi do
      concerning :SortMod do
        included do
          include ::SortMod
          include ::PageMod
        end

        def sort_column_default
          :updated_at
        end
      end

      # 問題編集用
      # 管理者が他者の問題を編集することもあるため current_user のスコープをつけてはいけない
      #
      # http://0.0.0.0:4000/wkbk/questions/new
      # http://0.0.0.0:4000/wkbk/questions/1/edit
      #
      def question_edit_fetch
        info = {}
        info[:config] = Wkbk::Config
        info[:LineageInfo] = Wkbk::LineageInfo.as_json(only: [:key, :name, :type, :mate_validate_on])
        info[:FolderInfo]  = Wkbk::FolderInfo.as_json(only: [:key, :name, :icon, :type])

        if params[:question_id]
          question = Wkbk::Question.find(params[:question_id])
          info[:question] = question.as_json(Wkbk::Question.json_type5)
        else
          info[:question_default_attributes] = Wkbk::Question.default_attributes
        end
        info
      end

      # 問題一覧
      # http://localhost:3000/api/wkbk.json?remote_action=questions_fetch
      # http://localhost:3000/api/wkbk.json?remote_action=questions_fetch&folder_key=active
      # http://localhost:3000/api/wkbk.json?remote_action=questions_fetch&sort_column=lineage_key&sort_order=desc
      # app/javascript/wkbk_app/models/question_column_info.js
      def questions_index_fetch
        params[:per] ||= Wkbk::Config[:api_questions_fetch_per]

        s = Wkbk::Question.all
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
        s = sort_scope_for_questions(s)

        retv = {}
        retv[:questions]       = s.as_json(Wkbk::Question.json_type5)
        retv[:question_counts] = {}
        if current_user
          retv[:question_counts].update(current_user.wkbk_questions.group(:folder_id).count.transform_keys { |e| Wkbk::Folder.find(e).key })
        end
        retv[:question_counts].update(all: Wkbk::Question.active_only.count)
        retv[:page_info]       = {**page_info(s), **sort_info, folder_key: params[:folder_key], tag: params[:tag]}
        retv
      end

      # http://localhost:3000/api/wkbk.json?remote_action=question_single_fetch&question_id=1
      def question_single_fetch
        question = Wkbk::Question.find(params[:question_id])
        retv = {}
        retv[:question] = question.as_json_type6
        # if current_user
        #   retv.update(current_user.good_bad_clip_flags_for(question))
        # end
        { ov_question_info: retv }
      end

      # http://localhost:3000/api/wkbk.json?remote_action=resource_fetch
      def resource_fetch
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
        {
          LineageInfo: Wkbk::LineageInfo.as_json(only: [:key, :name, :type, :mate_validate_on]),
          FolderInfo:  Wkbk::FolderInfo.as_json(only: [:key, :name, :icon, :type]),
        }
      end

      private

      def sort_scope_for_questions(s)
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
    end
  end
end

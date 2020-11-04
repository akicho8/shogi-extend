module Api
  class EmoxController
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

      # 問題一覧
      # http://localhost:3000/api/emox.json?remote_action=questions_fetch
      # http://localhost:3000/api/emox.json?remote_action=questions_fetch&folder_key=active
      # http://localhost:3000/api/emox.json?remote_action=questions_fetch&sort_column=lineage_key&sort_order=desc
      # app/javascript/emox_app/models/question_column_info.js
      def questions_fetch
        params[:per] ||= Emox::Config[:api_questions_fetch_per]

        s = Emox::Question.all
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
        retv[:questions]       = s.as_json(Emox::Question.json_type5)
        retv[:question_counts] = current_user.emox_questions.group(:folder_id).count.transform_keys { |e| Emox::Folder.find(e).key }
        retv[:question_counts].update(all: Emox::Question.active_only.count)
        retv[:page_info]       = {**page_info(s), **sort_info, folder_key: params[:folder_key], tag: params[:tag]}
        retv
      end

      # 問題編集用
      # 管理者が他者の問題を編集することもあるため current_user のスコープをつけてはいけない
      def question_edit_fetch
        question = Emox::Question.find(params[:question_id])
        { question: question.as_json(Emox::Question.json_type5) }
      end

      # http://localhost:3000/api/emox.json?remote_action=ranking_fetch&ranking_key=rating
      def ranking_fetch
        { rank_data: Emox::RankingCop.new(params.merge(current_user: current_user)) }
      end

      # http://localhost:3000/api/emox.json?remote_action=seasons_fetch
      def seasons_fetch
        { seasons: Emox::Season.newest_order.as_json(only: [:id, :generation, :name, :begin_at, :end_at]) }
      end

      # http://localhost:3000/api/emox.json?remote_action=history_records_fetch
      def history_records_fetch
        s = current_user.emox_histories.order(created_at: :desc).limit(Emox::Config[:api_history_fetch_max])
        { history_records: s.as_json(only: [:id], include: {:question => {include: {:user => {only: [:id, :key, :name], methods: [:avatar_path]}}}, :ox_mark => {only: :key}}, methods: [:good_p, :bad_p, :clip_p]) }
      end

      # http://localhost:3000/api/emox.json?remote_action=clip_records_fetch
      def clip_records_fetch
        s = current_user.emox_clip_marks.order(created_at: :desc).limit(Emox::Config[:api_clip_fetch_max])
        { clip_records: s.as_json(only: [:id], include: {:question => {include: {:user => {only: [:id, :key, :name], methods: [:avatar_path]}}}}, methods: [:good_p, :bad_p, :clip_p]) }
      end

      # http://localhost:3000/api/emox.json?remote_action=question_single_fetch&question_id=1
      def question_single_fetch
        question = Emox::Question.find(params[:question_id])
        retv = {}
        retv[:question] = question.as_json_type6
        if current_user
          retv.update(current_user.good_bad_clip_flags_for(question))
        end
        { ov_question_info: retv }
      end

      # 詳細
      def user_single_fetch
        user = User.find(params[:user_id])
        { ov_user_info: user.as_json_type7 }
      end

      # http://localhost:3000/api/emox.json?remote_action=resource_fetch
      def resource_fetch
        {
          RuleInfo: Emox::RuleInfo.as_json,
          OxMarkInfo: Emox::OxMarkInfo.as_json(only: [:key, :name, :score, :sound_key, :delay_second]),
          SkillInfo: Emox::SkillInfo.as_json(only: [:key, :name]),
          EmotionInfo: Emox::EmotionInfo.as_json, # 元に戻す用
          EmotionFolderInfo: Emox::EmotionFolderInfo.as_json,
        }
      end

      # http://localhost:3000/api/emox.json?remote_action=builder_form_resource_fetch
      def builder_form_resource_fetch
        {
          LineageInfo: Emox::LineageInfo.as_json(only: [:key, :name, :type, :mate_validate_on]),
          FolderInfo:  Emox::FolderInfo.as_json(only: [:key, :name, :icon, :type]),
        }
      end

      # http://localhost:3000/api/emox.json?remote_action=lobby_messages_fetch
      def lobby_messages_fetch
        lobby_messages = Emox::LobbyMessage.order(:created_at).includes(:user).last(Emox::Config[:api_lobby_message_max])
        lobby_messages = lobby_messages.collect(&:as_json_type8)
        { lobby_messages: lobby_messages }
      end

      # http://localhost:3000/api/emox.json?remote_action=notifications_fetch
      def notifications_fetch
        size = 10
        notifications = []
        if current_user
          notifications = current_user.notifications.where(opened_at: nil).order(created_at: :desc)
          if notifications.empty?
            # notifications = current_user.notifications.order(created_at: :desc).limit(size)
          end
        end
        notifications = notifications.collect(&:as_json_type11)
        { notifications: notifications }
      end

      # http://localhost:3000/api/emox.json?remote_action=revision_fetch
      def revision_fetch
        { revision: Emox::Config[:revision] }
      end

      # 作成した問題数を返す
      # http://localhost:3000/api/emox.json?remote_action=zip_dl_count_fetch
      def zip_dl_count_fetch
        count = 0
        if current_user
          count = zip_scope.count
        end
        { count: count }
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
            order = Emox::OxRecord.order(columns.last => sort_order)
            s = s.joins(:ox_record).merge(order)
          when "user"
            order = User.order(columns.last => sort_order)
            s = s.joins(:user).merge(order)
          when "lineage_key"
            s = s.joins(:lineage).merge(Emox::Lineage.reorder(id: sort_order)) # position の order を避けるため reorder
          else
            s = sort_scope(s)
          end
        end
        s
      end
    end
  end
end

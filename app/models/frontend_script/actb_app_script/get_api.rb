module FrontendScript
  class ActbAppScript

    concern :GetApi do
      # 問題一覧
      # http://localhost:3000/script/actb-app.json?remote_action=questions_fetch
      # http://localhost:3000/script/actb-app.json?remote_action=questions_fetch&folder_key=active
      # app/javascript/actb_app/models/question_column_info.js
      def questions_fetch
        params[:per] ||= Actb::Config[:api_questions_fetch_per]

        if current_user.sysop?
          s = Actb::Question.all
        else
          s = current_user.actb_questions
        end

        if v = params[:folder_key]
          # OPTIMIZE: folder_id を最初に特定して join せずにひくと速くなるはず
          s = s.joins(:folder).where(Actb::Folder.arel_table[:type].eq("actb/#{v}_box".classify))
        end
        s = page_scope(s)       # page_mod.rb
        s = sort_scope_for_questions(s)

        retv = {}
        retv[:questions]       = s.as_json(Actb::Question.json_type5)
        retv[:question_counts] = current_user.actb_questions.group(:folder_id).count.transform_keys { |e| Actb::Folder.find(e).key }
        retv[:page_info]       = {**page_info(s), **sort_info, folder_key: params[:folder_key]}
        retv
      end

      # http://localhost:3000/script/actb-app.json?remote_action=ranking_fetch&ranking_key=rating
      def ranking_fetch
        { rank_data: Actb::RankingCop.new(params.merge(current_user: current_user)) }
      end

      # http://localhost:3000/script/actb-app.json?remote_action=seasons_fetch
      def seasons_fetch
        { seasons: Actb::Season.newest_order.as_json(only: [:id, :generation, :name, :begin_at, :end_at]) }
      end

      # http://localhost:3000/script/actb-app.json?remote_action=history_records_fetch
      def history_records_fetch
        s = current_user.actb_histories.order(created_at: :desc).limit(Actb::Config[:api_history_fetch_max])
        { history_records: s.as_json(only: [:id], include: {:battle => {}, :membership => {}, :question => {include: {:user => {only: [:id, :key, :name], methods: [:avatar_path]}}}, :ox_mark => {only: :key}}, methods: [:good_p, :bad_p, :clip_p]) }
      end

      # http://localhost:3000/script/actb-app.json?remote_action=clip_records_fetch
      def clip_records_fetch
        s = current_user.actb_clip_marks.order(created_at: :desc).limit(Actb::Config[:api_clip_fetch_max])
        { clip_records: s.as_json(only: [:id], include: {:question => {include: {:user => {only: [:id, :key, :name], methods: [:avatar_path]}}}}, methods: [:good_p, :bad_p, :clip_p]) }
      end

      # http://localhost:3000/script/actb-app.json?remote_action=question_single_fetch&question_id=1
      def question_single_fetch
        question = Actb::Question.find(params[:question_id])
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

      # http://localhost:3000/script/actb-app.json?remote_action=resource_fetch
      def resource_fetch
        {
          RuleInfo: Actb::RuleInfo.as_json(only: [:key, :name, :display_p, :thinking_time_sec]),
          OxMarkInfo: Actb::OxMarkInfo.as_json(only: [:key, :name, :score, :sound_key, :delay_second]),
          SkillInfo: Actb::SkillInfo.as_json(only: [:key, :name]),
        }
      end

      # http://localhost:3000/script/actb-app.json?remote_action=builder_form_resource_fetch
      def builder_form_resource_fetch
        {
          LineageInfo: Actb::LineageInfo.as_json(only: [:key, :name, :type]),
          FolderInfo:  Actb::FolderInfo.as_json(only: [:key, :name, :icon, :type]),
        }
      end

      # http://localhost:3000/script/actb-app.json?remote_action=lobby_messages_fetch
      def lobby_messages_fetch
        lobby_messages = Actb::LobbyMessage.order(:created_at).includes(:user).last(Actb::Config[:api_lobby_message_max])
        lobby_messages = lobby_messages.as_json(only: [:body], include: {user: {only: [:id, :key, :name], methods: [:avatar_path]}})
        { lobby_messages: lobby_messages }
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
            order = Actb::OxRecord.order(columns.last => sort_order)
            s = s.joins(:ox_record).merge(order)
          when "user"
            order = User.order(columns.last => sort_order)
            s = s.joins(:user).merge(order)
          else
            s = sort_scope(s)
          end
        end
        s
      end
    end
  end
end

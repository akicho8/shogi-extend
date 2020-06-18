module FrontendScript
  class ActbAppScript

    concern :GetApi do
      included do
        QUESTIONS_FETCH_PER = 10
        LOBBY_MESSAGE_MAX   = 64

        HISTORY_FETCH_MAX   = 50
        CLIP_FETCH_MAX      = 50
      end

      # 問題一覧
      # http://localhost:3000/script/actb-app.json?remote_action=questions_fetch
      # app/javascript/actb_app/models/question_column_info.js
      def questions_fetch
        params[:per] ||= QUESTIONS_FETCH_PER

        s = current_user.actb_questions
        s = page_scope(s)       # page_mod.rb
        s = sort_scope_for_questions(s)

        retv = {**page_info(s), **sort_info}
        retv[:questions] = s.as_json(Actb::Question.json_type5)
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
        s = current_user.actb_histories.order(created_at: :desc).limit(HISTORY_FETCH_MAX)
        { history_records: s.as_json(only: [:id], include: {:battle => {}, :membership => {}, :question => {include: {:user => {only: [:id, :key, :name], methods: [:avatar_path]}}}, :ox_mark => {only: :key}}, methods: [:good_p, :bad_p, :clip_p]) }
      end

      # http://localhost:3000/script/actb-app.json?remote_action=clip_records_fetch
      def clip_records_fetch
        s = current_user.actb_clip_marks.order(created_at: :desc).limit(CLIP_FETCH_MAX)
        { clip_records: s.as_json(only: [:id], include: {:question => {include: {:user => {only: [:id, :key, :name], methods: [:avatar_path]}}}}, methods: [:good_p, :bad_p, :clip_p]) }
      end

      # http://localhost:3000/script/actb-app.json?remote_action=question_single_fetch
      def question_single_fetch
        question = Actb::Question.find(params[:question_id])
        retv = {}
        retv[:question] = question.as_json(include: {:user => {only: [:id, :key, :name], methods: [:avatar_path]}, :moves_answers => {}, :messages => {only: [:id, :body, :created_at], include: {:user => {only: [:id, :key, :name], methods: [:avatar_path]}}}})
        retv.update(current_user.good_bad_clip_flags_for(question))
        { ov_question_info: retv }
      end

      # 詳細
      def user_single_fetch
        user = User.find(params[:user_id])
        { ov_user_info: user.as_json(only: [:id, :key, :name], methods: [:avatar_path, :description], include: {actb_master_xrecord: { only: [:id, :rensho_count, :renpai_count, :rating, :rating_max, :rating_diff, :rensho_max, :renpai_max, :disconnect_count, :battle_count, :win_count, :lose_count, :win_rate, :udemae_point], methods: [:udemae_key] } }) }
      end

      # http://localhost:3000/script/actb-app.json?remote_action=resource_fetch
      def resource_fetch
        {
          RuleInfo: Actb::RuleInfo.as_json(only: [:key, :name]),
          OxMarkInfo: Actb::OxMarkInfo.as_json(only: [:key, :name, :score, :sound_key, :delay_second]),
          UdemaeInfo: Actb::UdemaeInfo.as_json(only: [:key, :name]),
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
        lobby_messages = Actb::LobbyMessage.order(:created_at).includes(:user).last(LOBBY_MESSAGE_MAX)
        lobby_messages = lobby_messages.as_json(only: [:body], include: {user: {only: [:id, :key, :name], methods: [:avatar_path]}})
        { lobby_messages: lobby_messages }
      end

      private

      def sort_scope_for_questions(s)
        if sort_column && sort_order
          columns = sort_column.scan(/\w+/)
          if columns.first == "ox_record"
            # { key: "o_rate",           name: "正解率",     short_name: "正率",     visible: true,  },
            # { key: "o_count",          name: "正解数",     short_name: "正解",     visible: false, },
            # { key: "x_count",          name: "誤答数",     short_name: "誤答",     visible: false, },
            order = Actb::OxRecord.order(columns.last => sort_order)
            s = s.joins(:ox_record).merge(order)
          else
            s = sort_scope(s)
          end
        end
        s
      end
    end
  end
end

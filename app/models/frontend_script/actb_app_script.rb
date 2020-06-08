# 将棋トレーニングバトル
#
# entry
#   app/models/frontend_script/actb_app_script.rb
#
# vue
#   app/javascript/actb_app/index.vue
#
# db
#   db/migrate/20200505135600_create_actb.rb
#
# test
#   experiment/0860_actb.rb
#
# model
#   app/models/actb/membership.rb
#   app/models/actb/battle.rb
#   app/models/actb.rb
#   app/models/colosseum/user_actb_mod.rb
#
#   question
#     app/models/actb/question.rb
#     app/models/actb/moves_answer.rb
#     app/models/actb/endpos_answer.rb
#
# channel
#   app/channels/actb/lobby_channel.rb
#   app/channels/actb/battle_channel.rb
#
# job
#   app/jobs/actb/lobby_broadcast_job.rb
#   app/jobs/actb/message_broadcast_job.rb
#
module FrontendScript
  class ActbAppScript < ::FrontendScript::Base
    include SortMod

    self.script_name = "将棋トレーニングバトル"
    self.page_title = ""
    self.form_position = :bottom
    self.column_wrapper_enable = false

    delegate :current_user, to: :h

    QUESTIONS_FETCH_PER = 10
    HISTORY_FETCH_MAX = 50
    CLIP_FETCH_MAX = 50
    MESSSAGE_LIMIT = 64

    def form_parts
      if Rails.env.development?
        [
          {
            :label   => "画面",
            :key     => :debug_scene,
            :elems   => {
              "ロビー"                       => nil,
              "プロフィール編集"             => :profile_edit,
              "プロフィール画像アップロード" => :profile_edit_image_crop,
              "対戦(マラソン)"               => :battle_marathon_rule,
              "対戦(シングルトン)"           => :battle_singleton_rule,
              "対戦(ハイブリッド)"           => :battle_hybrid_rule,
              "結果"                         => :result,
              "問題作成(一覧)"               => :builder,
              "問題作成(配置)"               => :builder_haiti,
              "問題作成(情報)"               => :builder_form,
              "ランキング"                   => :ranking,
              "履歴"                         => :history,
              "問題詳細"                     => :ov_question_info,
              "ユーザー詳細"                 => :ov_user_info,
              "ログインしていない状態"       => :no_login_lobby,
            },

            :type    => :select,
            :default => current_debug_scene,
          },
        ]
      end
    end

    def script_body
      # if current_debug_scene != :no_login_lobby
      #   if Rails.env.development?
      #     c.sysop_login_unless_logout
      #   end
      # end

      if v = params[:remote_action]
        return public_send(v)
      end

      # params = {
      #   "question" => {
      #     "init_sfen" => "4k4/9/4GG3/9/9/9/9/9/9 b 2r2b2g4s4n4l18p #{rand(1000000)}",
      #     "moves_answers"=>[{"moves_str"=>"4c5b"}],
      #     "time_limit_clock"=>"1999-12-31T15:03:00.000Z",
      #   },
      # }.deep_symbolize_keys
      #
      # question = current_user.actb_questions.find_or_initialize_by(id: params[:question][:id])
      # question.together_with_params_came_from_js_update(params)
      # return question.create_the_parameters_to_be_passed_to_the_js

      # question = current_user.actb_questions.create! do |e|
      #   e.assign_attributes(params[:question])
      #   # e.init_sfen = "4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l18p 1"
      #   e.moves_answers.build(moves_str: "G*5b")
      #   e.endpos_answers.build(end_sfen: "4k4/4G4/4G4/9/9/9/9/9/9 w 2r2b2g4s4n4l18p 2")
      # end

      # Actb.setup

      if params[:login_required]
        unless current_user
          h.session[:return_to] = h.url_for(:tb)
          c.redirect_to :new_xuser_session
          return
        end
      end

      out = ""

      # return ActionCable.server.open_connections_statistics
      # .map { |con| con[:subscriptions]
      #   .map { |sub| JSON.parse(sub)["url"] } } # ここのurlを変えれば特定の接続数を取得できるはず
      # .flatten
      # .select { |url| url == 'http:himakannet' } # ここで特定のチャネル一致
      # .size

      if request.format.json?
      end

      # if !current_battle
      #   out += Actb::Battle.order(:id).collect { |battle|
      #     {
      #       "チャットルーム" => h.link_to(battle.id, params.merge(battle_id: battle.id)),
      #     }
      #   }.to_html
      # end

      if current_battle
        #   messages = current_battle.messages.order(:id).last(10)
        #   rendered_messages = messages.collect { |message|
        #     ApplicationController.renderer.render partial: 'actb/messages/message', locals: { message: message }
        #   }
      end

      info = {}
      info[:config] = Actb::Config

      debug_scene_set(info)

      info[:mode] ||= "lobby"
      info[:put_path] = h.url_for(script_link_path)
      info[:question_default] = question_default

      if current_debug_scene != :no_login_lobby
        if current_user
          info[:current_user] = current_user_json
        end
      end

      # info[:battle] = current_battle
      # info[:messages] = rendered_messages
      if request.format.json?
        return info
      end
      #
      out += h.javascript_tag(%(document.addEventListener('DOMContentLoaded', () => { new Vue({}).$mount("#app") })))
      out += %(<div id="app"><actb_app :info='#{info.to_json}' /></div>)
      # out += h.tag.br
      # out += h.link_to("ロビー", params.merge(battle_id: nil), :class => "button is-small")
      # end

      c.layout_type = :raw

      out
    end

    # http://localhost:3000/script/actb-app.json?remote_action=questions_fetch
    def questions_fetch
      params[:per] ||= QUESTIONS_FETCH_PER

      s = current_user.actb_questions
      s = page_scope(s)       # page_mod.rb
      s = sort_scope(s)       # sort_mod.rb

      retv = {**page_info(s), **sort_info}
      retv[:questions] = s.as_json(question_as_json_params)
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
      { ov_user_info: user.as_json(only: [:id, :key, :name], methods: [:avatar_path, :description], include: {actb_current_xrecord: { only: [:id, :rensho_count, :renpai_count, :rating, :rating_max, :rating_last_diff, :rensho_max, :renpai_max, :disconnect_count, :battle_count, :win_count, :lose_count, :win_rate] } }) }
    end

    # http://localhost:3000/script/actb-app.json?remote_action=resource_fetch
    def resource_fetch
      {
        RuleInfo: Actb::RuleInfo.as_json(only: [:key, :name]),
        OxMarkInfo: Actb::OxMarkInfo.as_json(only: [:key, :name, :score, :sound_key, :delay_second]),
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
      lobby_messages = Actb::LobbyMessage.order(:created_at).includes(:user).last(MESSSAGE_LIMIT)
      lobby_messages = lobby_messages.as_json(only: [:body], include: {user: {only: [:id, :key, :name], methods: [:avatar_path]}})
      { lobby_messages: lobby_messages }
    end

    # http://localhost:3000/script/actb-app.json?remote_action=rule_key_set_handle
    def rule_key_set_handle
      current_user.actb_setting.update!(rule: Actb::Rule.fetch(params[:rule_key]))
      true
    end

    def put_action
      c.render json: public_send(params[:remote_action])
    end

    # 自分以外の誰かを指定ルールに参加させる
    def debug_matching_add_handle
      if user = User.where.not(id: params[:exclude_user_id]).first
        Actb::LobbyChannel.matching_list_rem(user)
        if rule_key = params[:rule_key]
          rule = Actb::Rule.fetch(rule_key)
        else
          rule = current_user.actb_setting.rule
        end
        user.actb_setting.update!(rule: rule)
        Actb::LobbyChannel.matching_list_add(user)
      end
      true
    end

    # 解散
    def matching_delete_all_handle
      Actb::Rule.matching_delete_all
      true
    end

    def vote_handle
      current_user.vote_handle(params)
    end

    def clip_handle
      current_user.clip_handle(params)
    end

    def save_handle
      question = current_user.actb_questions.find_or_initialize_by(id: params[:question][:id])
      begin
        question.together_with_params_came_from_js_update(params)
      rescue ActiveRecord::RecordInvalid => error
        c.render json: { form_error_message: error.message }
        return
      end
      { question: question.as_json(question_as_json_params) }
    end

    # curl -d _method=put -d user_name=a -d remote_action=profile_update -d _user_id=1 http://localhost:3000/script/actb-app
    def profile_update
      if v = params[:croped_image]
        bin = data_base64_body_to_binary(v)
        io = StringIO.new(bin)
        current_user.avatar.attach(io: io, filename: "user_icon.png")
      end

      if v = params[:user_name]
        current_user.update!(name: v)
      end

      if v = params[:user_description]
        current_user.profile.update!(description: v)
      end

      { current_user: current_user_json }
    end

    def question_as_json_params
      { include: [:user, :moves_answers, :lineage], only: Actb::Question.index_and_form_json_columns, methods: [:folder_key] }
    end

    def current_battle_id
      params[:battle_id].presence
    end

    def current_battle
      if v = current_battle_id
        Actb::Battle.find_by(id: v)
      end
    end

    def sort_column_default
      :updated_at
    end

    def current_debug_scene
      if v = params[:debug_scene].presence
        v.to_sym
      end
    end

    # リアクティブになるように空でもカラムは作っておくこと
    def question_default
      default = {
        # // init_sfen: "4k4/9/9/9/9/9/9/9/9 b 2r2b4g4s4n4l18p 1",
        # // init_sfen: "4k4/9/4GG3/9/9/9/9/9/9 b 2r2b2g4s4n4l18p 1",
        init_sfen: "position sfen 7gk/9/7GG/7N1/9/9/9/9/9 b 2r2bg4s3n4l18p 1",
        moves_answers: [
          moves_str: "1c1b",
          end_sfen: "7gk/8G/7G1/7N1/9/9/9/9/9 w 2r2bg4s3n4l18p 2",
        ],
        time_limit_sec: 3 * 60,
        difficulty_level: 1,
        title: "(title)",
        lineage: { key: "詰将棋" },
        folder_key: "active",

        # 他者が作者
        other_author: nil,
        source_media_name: nil,
        source_media_url: nil,
        source_published_on: nil,
      }

      if Rails.env.staging? || Rails.env.production?
        default[:title] = nil
        default[:time_limit_sec] = 60
        default[:moves_answers] = []
        default[:init_sfen] = "position sfen 4k4/9/9/9/9/9/9/9/9 b 2r2b4g4s4n4l18p 1"
      end

      default
    end

    def data_base64_body_to_binary(data_base64_body)
      md = data_base64_body.match(/\A(data):(?<content_type>.*?);base64,(?<base64_bin>.*)/)
      unless md
        raise "Data URL scheme 形式になっていません : #{data_base64_body.inspect}"
      end
      Base64.decode64(md["base64_bin"])
    end

    def current_user_json
      current_user.as_json(only: [:id, :key, :name], methods: [:avatar_path, :rating, :description])
    end

    def users
      [current_user, User.bot]
    end

    def debug_scene_set(info)
      info[:debug_scene] = current_debug_scene

      if current_debug_scene == :lobby
        c.sysop_login_unless_logout
      end

      if current_debug_scene == :battle_marathon_rule || current_debug_scene == :battle_singleton_rule || current_debug_scene == :battle_hybrid_rule
        c.sysop_login_unless_logout

        if current_debug_scene == :battle_marathon_rule
          rule_key = :marathon_rule
        end
        if current_debug_scene == :battle_singleton_rule
          rule_key = :singleton_rule
        end
        if current_debug_scene == :battle_hybrid_rule
          rule_key = :hybrid_rule
        end

        room = Actb::Room.create_with_members!(users, rule: Actb::Rule.fetch(rule_key))
        battle = room.battle_create_with_members!

        info[:room] = room.as_json(only: [:id], include: { memberships: { only: [:id], include: {user: { only: [:id, :name], methods: [:avatar_path] }} } }, methods: [])
        info[:battle] = battle.as_json_type1
      end

      if current_debug_scene == :result
        c.sysop_login_unless_logout

        room = Actb::Room.create_with_members!(users)
        battle = room.battle_create_with_members!(final: Actb::Final.fetch(:f_disconnect))
        battle.memberships[0].update!(judge: Actb::Judge.fetch(:win))
        battle.memberships[1].update!(judge: Actb::Judge.fetch(:lose))
        battle.reload

        info[:room] = room.as_json(only: [:id], include: { memberships: { only: [:id], include: {user: { only: [:id, :name], methods: [:avatar_path] }} } }, methods: [])
        info[:battle] = battle.as_json_type2
      end

      if current_debug_scene == :edit
        c.sysop_login_unless_logout
      end

      if current_debug_scene == :ranking
        c.sysop_login_unless_logout
      end

      if current_debug_scene == :history
        c.sysop_login_unless_logout
      end

      if current_debug_scene == :ov_question_info
        c.sysop_login_unless_logout

        # Actb::Question.destroy_all
        # user = User.sysop
        # question = user.actb_questions.create! do |e|
        #   e.init_sfen = "4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l1p 1"
        #   e.moves_answers.build(moves_str: "G*4b")
        #   e.moves_answers.build(moves_str: "G*5b")
        #   e.moves_answers.build(moves_str: "G*6b")
        #   e.time_limit_sec        = 60 * 3
        #   e.difficulty_level      = 5
        #   e.title                 = "(title)"
        #   e.description           = "(description)"
        #   e.hint_desc      = "(hint_desc)"
        #   e.other_author           = "(other_author)"
        #   e.other_author_link = "(other_author_link)"
        # end

        info[:question_id] = Actb::Question.first&.id
      end
    end
  end
end

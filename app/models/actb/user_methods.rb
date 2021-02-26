module Actb
  module UserMethods
    extend ActiveSupport::Concern

    included do
      include ClipMethods
      include VoteMethods
      include FolderMethods

      # 対局
      has_many :actb_room_memberships, class_name: "Actb::RoomMembership", dependent: :destroy # 対局時の情報(複数)
      has_many :actb_rooms, class_name: "Actb::Room", through: :actb_room_memberships                       # 対局(複数)

      # 対局
      has_many :actb_battle_memberships, class_name: "Actb::BattleMembership", dependent: :destroy # 対局時の情報(複数)
      has_many :actb_battles, class_name: "Actb::Battle", through: :actb_battle_memberships                       # 対局(複数)

      # このユーザーが作成した問題(複数)
      has_many :actb_questions, class_name: "Actb::Question", dependent: :destroy do
        def create_mock1(attrs = {})
          create!(attrs) do |e|
            if e.moves_answer_validate_skip.nil?
              e.moves_answer_validate_skip = true
            end
            e.title ||= SecureRandom.hex
            e.init_sfen ||= "position sfen 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l18p 1"
            e.moves_answers.build(moves_str: "G*5b")
          end
        end
      end

      # このユーザーに出題した問題(複数)
      has_many :actb_histories, class_name: "Actb::History", dependent: :destroy

      # 自分がBOTになった部屋
      has_many :actb_bot_rooms, class_name: "Actb::Room", foreign_key: :bot_user_id, dependent: :destroy

      # 通知
      has_many :notifications, class_name: "Actb::Notification", dependent: :destroy # 自分が受信
    end

    concerning :OtherMethods do
      def page_url(options = {})
        UrlProxy.wrap2("/training?user_id=#{id}")
        # Rails.application.routes.url_helpers.url_for([:actb, {only_path: false, user_id: id}.merge(options)])
      end

      def linked_name(options = {})
        ApplicationController.helpers.link_to(name, page_url(only_path: true))
      end
    end

    concerning :OUcountNotifyMod do
      # rails r "tp User.first.straight_win_count_notify"
      def straight_win_count_notify
        User.bot.lobby_speak("#{linked_name}さんが#{actb_season_xrecord.straight_win_count}連勝しました")
      end

      # rails r "tp User.first.o_ucount_notify"
      def o_ucount_notify
        User.bot.lobby_speak("#{linked_name}さんが本日#{today_total_o_ucount}問解きました")
      end

      # rails dev:cache
      # rails r "tp User.first.o_ucount_notify_once"
      def o_ucount_notify_once
        Rails.cache.fetch(o_ucount_notify_key, expires_in: 1.days) do
          o_ucount_notify
          true
        end
      end

      # rails r "tp User.first.o_ucount_notify_key"
      def o_ucount_notify_key
        [
          self.class.name,
          __method__,
          id,
          Time.current.strftime("%y%m%d"),
          today_total_o_ucount,
        ].join("/")
      end
    end

    concerning :CurrentUserMethods do
      attr_accessor :session_lock_token

      def actb_session_lock_token_valid?(token)
        actb_setting.reload.session_lock_token == token
      end

      # rails r "tp User.first.actb_emotions_setup(reset: true)"
      def actb_emotions_setup(options = {})
        if options[:reset]
          emotions.destroy_all
        end
        if emotions.empty?
          EmotionInfo.each do |e|
            folder = EmotionFolder.fetch(e.folder_key)
            emotions.create!(folder: folder, name: e.name, message: e.message, voice: e.voice)
          end
        end
      end

      # for current_user, profile
      def as_json_type9x
        # 二つのブラウザで同期してしまう不具合回避のための値
        # 新しく開いた瞬間にトークンが変化するので古い方には送られなくなる(受信しても無視するしかなくなる)
        # ↑これはまずい、2連続アクセス(はてブ？などが後からGET)した場合に START できなくなる
        @session_lock_token = SecureRandom.hex
        as_json_type9
      end

      # rails r "tp User.first.emotions.destroy_all"
      # rails r "tp User.first.as_json_type9"
      # rails r "tp Actb::EmotionInfo.as_json"
      def as_json_type9
        as_json({
            only: [
              :id,
              :key,
              :name,
              :permit_tag_list,
              :name_input_at,
            ],
            include: {
              emotions: Actb::Emotion.json_type13,
            },
            methods: [
              :avatar_path,
              :rating,
              :skill_key,
              :description,
              :twitter_key,
              :actb_created_after_days,
              :session_lock_token,
            ],
          })
      end

      # アカウントを作ってからの日数
      # rails r "p User.first.actb_created_after_days"
      def actb_created_after_days
        ((Time.current - created_at) / 1.days).to_i
      end
    end

    concerning :MessageMethods do
      included do
        with_options dependent: :destroy do
          has_many :actb_room_messages,     class_name: "Actb::RoomMessage"
          has_many :actb_lobby_messages,    class_name: "Actb::LobbyMessage"
          has_many :actb_question_messages, class_name: "Actb::QuestionMessage"
        end
      end

      # rails r 'User.sysop.lobby_speak(Time.current)'
      def lobby_speak(message_body, options = {})
        actb_lobby_messages.create!({body: message_body}.merge(options))
      end

      # rails r 'User.sysop.room_speak(Actb::Room.first, Time.current)'
      def room_speak(room, message_body, options = {})
        actb_room_messages.create!({room: room, body: message_body}.merge(options))
      end

      # rails r 'User.sysop.question_speak(Actb::Question.first, Time.current)'
      def question_speak(question, message_body, options = {})
        actb_question_messages.create!({question: question, body: message_body}.merge(options))
      end
    end

    concerning :MainXrecordMod do
      included do
        has_one :actb_main_xrecord, class_name: "Actb::MainXrecord", dependent: :destroy

        delegate :rating, :straight_win_count, :straight_win_max, :skill, :skill_key, :skill_point, to: :actb_main_xrecord

        after_create do
          create_actb_main_xrecord!
        end
      end

      def create_actb_main_xrecord_if_blank
        actb_main_xrecord || create_actb_main_xrecord!
      end

      # 両方に同じ処理を行う
      def both_xrecord_each
        [:actb_main_xrecord, :actb_latest_xrecord].each do |e|
          yield public_send(e)
        end
      end
    end

    concerning :SeasonXrecordMod do
      included do
        # プロフィール
        with_options class_name: "Actb::SeasonXrecord", dependent: :destroy do
          has_one :actb_season_xrecord, -> { newest_order }
          has_many :actb_season_xrecords
        end

        after_create do
          create_actb_season_xrecord_if_blank
        end
      end

      def create_actb_season_xrecord_if_blank
        actb_latest_xrecord
      end

      def create_actb_main_xrecord_if_blank
        actb_main_xrecord || create_actb_main_xrecord!
      end

      # 必ず存在する最新シーズンのプロフィール
      def actb_latest_xrecord
        actb_season_xrecords.find_or_create_by!(season: Season.newest)
      end
    end

    concerning :SettingMod do
      included do
        has_one :actb_setting, class_name: "Actb::Setting", dependent: :destroy

        after_create do
          create_actb_setting!
        end
      end

      def create_actb_setting_if_blank
        actb_setting || create_actb_setting!
      end
    end

    concerning :EmotionMod do
      included do
        # rails r "tp User.first.emotions"
        has_many :emotions, class_name: "Actb::Emotion", dependent: :destroy
      end
    end

    concerning :UserInfoMethods do
      def statistics
        [
          :active_questions_count,
          :questions_good_rate_average,
          :questions_good_marks_total,
          :questions_bad_marks_total,
          :total_o_count,
          :total_x_count,
        ].inject({}) {|a, e| a.merge(e => public_send(e)) }
      end

      def active_questions_count
        actb_questions.active_only.count
      end

      def questions_good_rate_average
        actb_questions.average(:good_rate)
      end

      def questions_good_marks_total
        actb_questions.sum(:good_marks_count)
      end

      def questions_bad_marks_total
        actb_questions.sum(:bad_marks_count)
      end

      def total_o_count
        actb_histories.with_o.count
      end

      def total_x_count
        actb_histories.with_ox_mark(:mistake).count
      end

      def today_total_o_count
        actb_histories.with_today.with_o.count
      end

      def today_total_x_count
        actb_histories.with_today.with_ox_mark(:mistake).count
      end

      def today_total_o_ucount
        actb_histories.with_today.with_o.distinct.count(:question_id)
      end

      def today_total_x_ucount
        actb_histories.with_today.with_ox_mark(:mistake).distinct.count(:question_id)
      end

      # rails r "tp User.first.actb_info"
      def info
        {
          "ID"                 => id,
          "名前"               => name,
          "名前確定日時"       => name_input_at&.to_s(:distance),
          "メールアドレス"     => email,
          "プロバイダ"         => auth_infos.collect(&:provider).join(" "),
          "Twitterアカウント"  => twitter_key,
          "ログイン回数"       => sign_in_count,
          "最終ログイン日時"   => current_sign_in_at&.to_s(:distance),
          "登録日時"           => created_at&.to_s(:distance),
          "IP"                 => current_sign_in_ip,
          "タグ"               => permit_tag_list,

          "オンライン"         => Actb::SchoolChannel.active_users.include?(self) ? "○" : "",
          "対戦中"             => Actb::RoomChannel.active_users.include?(self) ? "○" : "",
          "最終選択ルール"     => actb_setting.rule.pure_info.name,

          "レーティング"       => rating,
          "クラス"             => skill_key,
          "最新シーズン情報ID" => actb_latest_xrecord.id,
          "永続的プロフ情報ID" => actb_main_xrecord.id,
          "部屋入室数"         => actb_room_memberships.count,
          "対局数"             => actb_battle_memberships.count,
          "問題履歴数"         => actb_histories.count,
          "バトル中発言数"     => actb_room_messages.count,
          "ロビー発言数"       => actb_lobby_messages.count,
          "問題コメント数"     => actb_question_messages.count,

          "作成問題数"         => actb_questions.count,
          "問題高評価率"       => actb_questions.average(:good_rate),
          "問題高評価数"       => actb_questions.sum(:good_marks_count),
          "問題低評価数"       => actb_questions.sum(:bad_marks_count),

          "問題正解数"         => total_o_count,
          "問題不正解数"       => total_x_count,

          "問題正解数(本日)"   => today_total_o_count,
          "問題不正解数(本日)" => today_total_x_count,

          "ユニーク問題正解数(本日)"   => today_total_o_ucount,
          "ユニーク問題不正解数(本日)" => today_total_x_ucount,
        }
      end
    end

    # ユーザー詳細
    def as_json_type7
      as_json({
          only: [
            :id,
            :key,
            :name,
          ],
          methods: [
            :avatar_path,
            :description,
            :twitter_key,
            :statistics,
          ],
          include: {
            actb_main_xrecord: {
              only: [
                :id,
                :straight_win_count,
                :straight_lose_count,
                :rating,
                :rating_max,
                :rating_diff,
                :straight_win_max,
                :straight_lose_max,
                :disconnect_count,
                :battle_count,
                :win_count,
                :lose_count,
                :win_rate,
                :skill_point,
              ],
              methods: [
                :skill_key,
              ],
            },
          },
        })
    end
  end
end

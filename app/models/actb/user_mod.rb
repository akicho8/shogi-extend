module Actb
  module UserMod
    extend ActiveSupport::Concern

    included do
      include ClipMod
      include VoteMod
      include FolderMod

      # 対局
      has_many :actb_room_memberships, class_name: "Actb::RoomMembership", dependent: :restrict_with_exception # 対局時の情報(複数)
      has_many :actb_rooms, class_name: "Actb::Room", through: :actb_room_memberships                       # 対局(複数)

      # 対局
      has_many :actb_battle_memberships, class_name: "Actb::BattleMembership", dependent: :restrict_with_exception # 対局時の情報(複数)
      has_many :actb_battles, class_name: "Actb::Battle", through: :actb_battle_memberships                       # 対局(複数)

      # このユーザーが作成した問題(複数)
      has_many :actb_questions, class_name: "Actb::Question", dependent: :destroy do
        def create_mock1
          create! do |e|
            e.title = "(title#{Actb::Question.count.next})"
            e.init_sfen = "position sfen 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l#{Actb::Question.count.next}p 1"
            e.moves_answers.build(moves_str: "G*5b")
          end
        end
      end

      # このユーザーに出題した問題(複数)
      has_many :actb_histories, class_name: "Actb::History", dependent: :destroy

      # 自分がBOTになった部屋
      has_many :actb_bot_rooms, class_name: "Actb::Room", foreign_key: :bot_user_id, dependent: :restrict_with_exception
    end

    concerning :CurrentUserMethods do
      def session_lock_token_valid?(token)
        actb_setting.reload.session_lock_token == token
      end

      def as_json_type9
        attrs = as_json({
            only: [
              :id,
              :key,
              :name,
              :permit_tag_list,
            ],
            methods: [
              :avatar_path,
              :rating,
              :skill_key,
              :description,
              :twitter_key,
              :regular_p,
            ],
          })

        # 二つのブラウザで同期してしまう不具合回避のための値
        # 新しく開いた瞬間にトークンが変化するので古い方には送られなくなる(受信しても無視するしかなくなる)
        # ↑これはまずい、2連続アクセス(はてブ？などが後からGET)した場合に START できなくなる
        token = SecureRandom.hex
        # actb_setting.update!(session_lock_token: token)
        attrs[:session_lock_token] = token

        attrs
      end

      # レギュラー条件
      def regular_p
        actb_room_memberships.count >= 1 || actb_questions.active_only.count >= 1
      end
    end

    concerning :MessageMethods do
      included do
        with_options(dependent: :destroy) do |o|
          has_many :actb_room_messages, class_name: "Actb::RoomMessage"
          has_many :actb_lobby_messages, class_name: "Actb::LobbyMessage"
          has_many :actb_question_messages, class_name: "Actb::QuestionMessage"
        end
      end

      def lobby_speak(message_body, options = {})
        actb_lobby_messages.create!({body: message_body}.merge(options))
      end

      def room_speak(room, message_body, options = {})
        actb_room_messages.create!({room: room, body: message_body}.merge(options))
      end

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
        with_options(class_name: "Actb::SeasonXrecord", dependent: :destroy) do
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

    concerning :UserInfoMethods do
      def statistics
        [
          :active_questions_count,
          :questions_good_rate_average,
          :questions_good_marks_total,
          :questions_bad_marks_total,
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

      def info_hash
        {
          "ID"                 => id,
          "名前"               => name,
          "プロバイダ"         => auth_infos.collect(&:provider).join(" "),

          "オンライン"         => Actb::SchoolChannel.active_users.include?(self) ? "○" : "",
          "対戦中"             => Actb::RoomChannel.active_users.include?(self) ? "○" : "",
          "ルール"             => actb_setting.rule.pure_info.name,

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
        }
      end

      def info
        out = ""
        out += info_hash.to_t
        out
      end
    end

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

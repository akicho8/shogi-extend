module Actb
  concern :UserMod do
    included do
      include UserMod::ClipMod
      include UserMod::VoteMod
      include UserMod::FolderMod

      # 対局
      has_many :actb_room_memberships, class_name: "Actb::RoomMembership", dependent: :restrict_with_exception # 対局時の情報(複数)
      has_many :actb_rooms, class_name: "Actb::Room", through: :actb_room_memberships                       # 対局(複数)

      # 対局
      has_many :actb_battle_memberships, class_name: "Actb::BattleMembership", dependent: :restrict_with_exception # 対局時の情報(複数)
      has_many :actb_battles, class_name: "Actb::Battle", through: :actb_battle_memberships                       # 対局(複数)

      # このユーザーが作成した問題(複数)
      has_many :actb_questions, class_name: "Actb::Question", dependent: :destroy

      # このユーザーに出題した問題(複数)
      has_many :actb_histories, class_name: "Actb::History", dependent: :destroy

      # チャット関連
      with_options(dependent: :destroy) do |o|
        has_many :actb_room_messages, class_name: "Actb::RoomMessage"
        has_many :actb_lobby_messages, class_name: "Actb::LobbyMessage"
        has_many :actb_question_messages, class_name: "Actb::QuestionMessage"
      end

      # Good/Bad
      has_many :actb_favorites, class_name: "Actb::Favorite", dependent: :destroy
    end

    def good_bad_clip_flags_for(question)
      [:good_p, :bad_p, :clip_p].inject({}) do |a, e|
        a.merge(e => public_send(e, question))
      end
    end

    concerning :XrecordMod do
      included do
        # プロフィール
        with_options(class_name: "Actb::Xrecord", dependent: :destroy) do
          has_one :actb_xrecord, -> { newest_order }
          has_many :actb_xrecords
        end

        after_create do
          create_actb_xrecord_if_blank
        end

        delegate :rating, :rensho_count, :rensho_max, to: :actb_newest_xrecord
      end

      def create_actb_xrecord_if_blank
        actb_newest_xrecord
      end

      # 必ず存在する最新シーズンのプロフィール
      def actb_newest_xrecord
        actb_xrecords.find_or_create_by!(season: Season.newest)
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
  end
end

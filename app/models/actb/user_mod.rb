module Actb
  concern :UserMod do
    included do
      include UserMod::ClipMod
      include UserMod::VoteMod

      # 対局
      has_many :actb_rooms, class_name: "Room", through: :memberships                           # 対局(複数)
      has_many :actb_memberships, class_name: "Membership", dependent: :restrict_with_exception # 対局時の情報(複数)

      # このユーザーが作成した問題(複数)
      has_many :actb_questions, class_name: "Question", dependent: :destroy

      # このユーザーに出題した問題(複数)
      has_many :actb_histories, class_name: "History", dependent: :destroy

      # チャット関連
      with_options(dependent: :destroy) do |o|
        has_many :actb_room_messages, class_name: "RoomMessage"
        has_many :actb_lobby_messages, class_name: "LobbyMessage"
      end

      # Good/Bad
      has_many :actb_favorites, class_name: "Favorite", dependent: :destroy
    end

    def good_bad_clip_flags_for(question)
      [:good_p, :bad_p, :clip_p].inject({}) do |a, e|
        a.merge(e => public_send(e, question))
      end
    end

    concerning :ProfileMod do
      included do
        # プロフィール
        with_options(class_name: "Profile", dependent: :destroy) do
          has_one :actb_profile, -> { newest_order }
          has_many :actb_profiles
        end

        after_create do
          actb_newest_profile
        end

        delegate :rating, :rensho_count, :rensho_max, to: :actb_newest_profile
      end

      # 必ず存在する最新シーズンのプロフィール
      def actb_newest_profile
        actb_profiles.find_or_create_by!(season: Season.newest)
      end
    end
  end
end

module Colosseum
  concern :UserActfMod do
    included do
      has_many :actf_memberships, class_name: "Actf::Membership", dependent: :restrict_with_exception # 対局時の情報(複数)
      has_many :actf_rooms, class_name: "Actf::Room", through: :memberships           # 対局(複数)

      has_one :actf_profile, class_name: "Actf::Profile", dependent: :destroy # プロフィール

      has_many :actf_questions, class_name: "Actf::Question", :dependent => :destroy

      has_many :actf_room_messages, class_name: "Actf::RoomMessage", :dependent => :destroy
      has_many :actf_lobby_messages, class_name: "Actf::LobbyMessage", :dependent => :destroy

      after_create do
        actf_profile || create_actf_profile!
      end

      delegate :rating, :rensho_count, :rensho_max, to: :actf_profile
    end
  end
end

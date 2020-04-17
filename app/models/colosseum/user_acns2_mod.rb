module Colosseum
  concern :UserAcns2Mod do
    included do
      has_many :acns2_memberships, class_name: "Acns2::Membership", dependent: :destroy # 対局時の情報(複数)
      has_many :acns2_rooms, class_name: "Acns2::Room", through: :memberships   # 対局(複数)

      has_one :acns2_profile, class_name: "Acns2::Profile", dependent: :destroy # プロフィール

      after_create do
        acns2_profile || create_acns2_profile!
      end
    end
  end
end

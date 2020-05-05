module Colosseum
  concern :UserAcns3Mod do
    included do
      has_many :acns3_memberships, class_name: "Acns3::Membership", dependent: :restrict_with_exception # 対局時の情報(複数)
      has_many :acns3_rooms, class_name: "Acns3::Room", through: :memberships           # 対局(複数)

      has_one :acns3_profile, class_name: "Acns3::Profile", dependent: :destroy # プロフィール

      has_many :acns3_questions, class_name: "Acns3::Question", :dependent => :destroy

      after_create do
        acns3_profile || create_acns3_profile!
      end
    end
  end
end

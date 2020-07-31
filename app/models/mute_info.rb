class MuteInfo < ApplicationRecord
  belongs_to :user
  belongs_to :target_user, class_name: "::User"

  with_options presence: true do
    validates :user_id
    validates :target_user_id
  end

  with_options allow_blank: true do
    validates :user_id, uniqueness: { scope: :target_user_id }
  end
end

class Preset < ApplicationRecord
  include MemoryRecordBind::Basic

  with_options dependent: :destroy do
    has_many :swars_battles, class_name: "Swars::Battle"
    has_many :swars_memberships, through: :swars_battles
  end

  with_options dependent: :destroy do
    has_many :free_battles
    has_many :free_memberships, through: :free_battles
  end
end

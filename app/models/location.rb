class Location < ApplicationRecord
  include MemoryRecordBind::Basic

  with_options dependent: :destroy do
    has_many :swars_memberships, class_name: "Swars::Membership"
    has_many :swars_battles, through: :swars_memberships
  end
end

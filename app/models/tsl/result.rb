module Tsl
  class Result < ApplicationRecord
    include MemoryRecordBind::Basic

    has_many :memberships, class_name: "Tsl::Membership", dependent: :destroy
  end
end

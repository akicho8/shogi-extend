module Swars
  class Final < ApplicationRecord
    include MemoryRecordBind::Basic

    delegate :short_name, :long_name, :real_life_time, to: :pure_info

    with_options dependent: :destroy do
      has_many :battles
      has_many :memberships, through: :battles
    end
  end
end

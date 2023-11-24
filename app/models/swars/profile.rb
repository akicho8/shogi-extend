module Swars
  class Profile < ApplicationRecord
    belongs_to :user

    before_validation do
      self.ban_crowl_count ||= 0
    end

    before_save do
      if changes_to_save[:ban_crowled_at]
        if ban_crowled_at
          self.ban_crowl_count += 1
        else
          self.ban_crowl_count = 0
        end
      end
    end
  end
end

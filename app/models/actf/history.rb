module Actf
  class History < ApplicationRecord
    belongs_to :user, class_name: "Colosseum::User"
    belongs_to :room
    belongs_to :membership
    belongs_to :question
    belongs_to :ans_result

    before_validation do
      if membership
        self.room ||= membership.room
        self.user ||= membership.user
      end
      self.ans_result ||= AnsResult.fetch(:mistake)
    end
  end
end

module Actf
  class History < ApplicationRecord
    include ClipMark::ShareWithHistoryMethods

    belongs_to :ans_result

    # room と membership ない方がいいか検討
    # room と membership はビューでまったく使ってない
    belongs_to :room
    belongs_to :membership

    before_validation do
      if membership
        self.room ||= membership.room
        self.user ||= membership.user
      end
      self.ans_result ||= AnsResult.fetch(:mistake)
    end
  end
end

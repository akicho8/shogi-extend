module Swars
  class Profile < ApplicationRecord
    belongs_to :user

    scope :ban_crowl_count_lteq, -> c { where(arel_table[:ban_crowl_count].lteq(c)) }                                # 垢BANチェック指定回数以下
    scope :ban_crowled_at_lt, -> time { where(ban_crowled_at: nil).or(where(arel_table[:ban_crowled_at].lt(time))) } # 垢BANチェックの前回が指定日時より過去

    before_validation do
      self.ban_crowl_count ||= 0
      self.ban_crowled_at ||= Time.current
    end

    # before_save do
    #   # p persisted?
    #   # p changes_to_save[:ban_crowled_at]
    #   # if persisted?
    #   #   if changes_to_save[:ban_crowled_at]
    #   #     self.ban_crowl_count += 1
    #   #   end
    #   # end
    # end
  end
end

module Swars
  class Profile < ApplicationRecord
    belongs_to :user

    scope :ban_crawled_count_lteq, -> c { where(arel_table[:ban_crawled_count].lteq(c)) }                                # 垢BANチェック指定回数以下
    scope :ban_crawled_at_lt, -> time { where(ban_crawled_at: nil).or(where(arel_table[:ban_crawled_at].lt(time))) } # 垢BANチェックの前回が指定日時より過去

    before_validation do
      self.ban_crawled_count ||= 0
      self.ban_crawled_at ||= Time.current
    end

    with_options presence: true do
      validates :ban_crawled_count
      validates :ban_crawled_at
    end

    # before_save do
    #   # p persisted?
    #   # p changes_to_save[:ban_crawled_at]
    #   # if persisted?
    #   #   if changes_to_save[:ban_crawled_at]
    #   #     self.ban_crawled_count += 1
    #   #   end
    #   # end
    # end
  end
end

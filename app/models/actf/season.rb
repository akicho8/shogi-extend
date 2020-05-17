module Actf
  class Season < ApplicationRecord
    scope :newest_order, -> { order(generation: :desc) }
    scope :oldest_order, -> { order(generation: :asc)  }

    class << self
      def setup(options = {})
        unless Season.exists?
          Season.create!
        end
      end

      def latest
        newest_order.first
      end
    end

    before_validation do
      self.generation ||= Season.count.next
      self.name = "シーズン#{generation}"
    end
  end
end

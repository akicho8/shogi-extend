module Actb
  class OxRecord < ApplicationRecord
    belongs_to :question

    before_validation do
      self.o_count  ||= 0
      self.x_count  ||= 0
      self.ox_total ||= 0
      self.o_rate   ||= 0

      if changes_to_save[:o_count] || changes_to_save[:x_count]
        if o_count && x_count
          self.ox_total = o_count + x_count
          if ox_total.positive?
            self.o_rate = o_count.fdiv(ox_total)
          end
        end
      end
    end

    with_options presence: true do
      validates :o_count
      validates :x_count
      validates :ox_total
      validates :o_rate
    end

    with_options allow_blank: true do
      validates :question_id, uniqueness: true
    end
  end
end

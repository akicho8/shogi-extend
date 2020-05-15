module Actf
  class Favorite < ApplicationRecord
    belongs_to :user, class_name: "Colosseum::User" # , foreign_key: "colosseum_user_id"
    belongs_to :question, counter_cache: true

    before_validation do
      self.score ||= 1
    end

    with_options presence: true do
      validates :score
    end

    with_options allow_blank: true do
      validates :score, inclusion: [-1, 0, 1]
    end

    # question.increment_counter(:good_count)
    after_save do
      if v = saved_changes[:score]
        counters = {}
        ov, nv = v
        if ov
          if ov.positive?
            counters.update(good_count: -1) # 1 => ?
          elsif ov.negative?
            counters.update(bad_count: -1)  # -1 => ?
          end
        end
        if nv.positive?
          counters.update(good_count: 1) # ? => 1
        elsif nv.negative?
          counters.update(bad_count: 1)  # ? => -1
        end
        if counters.present?
          Question.update_counters(question.id, counters)
        end
        if nv.zero?
          destroy!
        end
      end
    end

    after_destroy do
      if score.positive?
        Question.update_counters(question.id, good_count: -1)
      elsif score.negative?
        Question.update_counters(question.id, bad_count: -1)
      end
    end
  end
end

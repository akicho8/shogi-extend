module Actf
  class Clip < ApplicationRecord
    concerning :ShareWithHistoryMethods do
      included do
        belongs_to :user, class_name: "Colosseum::User" # , foreign_key: "colosseum_user_id"
        belongs_to :question, counter_cache: true
      end

      def good_p
        user.actf_good_marks.where(question: question).exists?
      end

      def bad_p
        user.actf_bad_marks.where(question: question).exists?
      end

      def clip_p
        user.actf_clips.where(question: question).exists?
      end
    end
  end
end

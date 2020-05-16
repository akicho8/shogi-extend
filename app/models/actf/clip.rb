module Actf
  class Clip < ApplicationRecord
    concerning :ShareWithHistoryMethods do
      included do
        belongs_to :user, class_name: "Colosseum::User" # , foreign_key: "colosseum_user_id"
        belongs_to :question, counter_cache: true
      end

      def good_p
        user.good_p(question)
      end

      def bad_p
        user.bad_p(question)
      end

      def clip_p
        user.clip_p(question)
      end
    end
  end
end

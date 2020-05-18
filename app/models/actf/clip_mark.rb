module Actf
  class ClipMark < ApplicationRecord
    concerning :ShareWithHistoryMethods do
      included do
        include VoteMod
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

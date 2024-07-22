module QuickScript
  module Swars
    class PrisonAllScript < Base
      self.title = "将棋ウォーズ囚人一覧"
      self.description = "囚人をアルファベット順ですべて表示する"

      def call
        { :_v_text => users.sort.join(" "), :class => "is_word_break_off" }
      end

      def users
        @users ||= [].tap do |av|
          ::Swars::User.ban_only.in_batches do |group|
            av.concat group.pluck(:user_key)
          end
        end
      end

      def title
        "#{super}(#{users.size})"
      end
    end
  end
end

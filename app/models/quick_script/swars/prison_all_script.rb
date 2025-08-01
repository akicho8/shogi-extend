module QuickScript
  module Swars
    class PrisonAllScript < Base
      self.title = "将棋ウォーズ囚人一覧"
      self.description = "囚人をアルファベット順ですべて表示する"
      self.json_link = true

      def call
        AppLog.info(subject: "[囚人][一覧]")
        { :_v_text => users.sort.join(" "), :class => "is_word_break_off" }
      end

      def as_general_json
        users.sort
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

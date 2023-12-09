module ShareBoard
  module ChatAi
    class Topic < Array
      def debug_log!
        AppLog.info(subject: "topic", body: to_t)
      end

      def to_gpt_messages
        collect(&:to_gpt)
      end

      def to_t
        collect(&:to_h).to_t
      end
    end
  end
end

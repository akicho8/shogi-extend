module ShareBoard
  module ChatAi
    class Topic < Array
      def debug_log!
        AppLog.info(subject: "topic", body: to_t)
      end

      def to_api_messages
        collect(&:to_api)
      end

      def to_t
        collect(&:to_h).to_t
      end
    end
  end
end

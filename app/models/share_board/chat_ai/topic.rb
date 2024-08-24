module ShareBoard
  module ChatAi
    class Topic < Array
      def debug_log!
        AppLog.info(subject: "topic", body: to_t)
      end

      def to_api_messages
        collect(&:to_api)
      end

      def to_t(options = {})
        collect(&:to_h).to_t(options)
      end
    end
  end
end

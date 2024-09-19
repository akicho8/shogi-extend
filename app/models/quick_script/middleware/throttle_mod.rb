module QuickScript
  module Middleware
    concern :ThrottleMod do
      prepended do
        class_attribute :throttle_expires_in, default: 1.0
        class_attribute :throttle_delayed_again, default: true # 連打するとさらに延期するモード
      end

      def throttle
        @throttle ||= Throttle.new(key: throttle_key, expires_in: throttle_expires_in, delayed_again: throttle_delayed_again)
      end

      def throttle_key
        if controller
          "#{self.class.name}/#{session.id}"
        else
          "#{self.class.name}/#{SecureRandom.hex}"
        end
      end
    end
  end
end

module QuickScript
  module Middleware
    concern :ThrottleMod do
      prepended do
        class_attribute :throttle_expires_in, default: 1.0
      end

      def throttle
        @throttle ||= Throttle.new(key: throttle_key, expires_in: throttle_expires_in)
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

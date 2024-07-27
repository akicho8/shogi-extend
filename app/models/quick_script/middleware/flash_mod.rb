module QuickScript
  module Middleware
    concern :FlashMod do
      def as_json(*)
        super.merge(flash: flash)
      end

      def flash
        @flash ||= {}
      end
    end
  end
end

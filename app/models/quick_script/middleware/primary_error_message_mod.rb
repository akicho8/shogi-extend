module QuickScript
  module Middleware
    # http://localhost:4000/lab/chore/status_code?status_code=404&primary_error_message=hello
    concern :PrimaryErrorMessageMod do
      prepended do
        class_attribute :primary_error_message, default: nil
        class_attribute :status_code, default: nil
      end

      # CSR 用
      def as_json(*)
        super.merge({
            :primary_error_message => primary_error_message,
          })
      end

      # SSR 用
      def meta
        super.merge({
            :primary_error_message => primary_error_message,
          })
      end
    end
  end
end

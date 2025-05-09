module QuickScript
  module Middleware
    concern :GeneralApiMod do
      prepended do
        class_attribute :general_json_link_show, default: false # JSON のリンクを表示するか？
      end

      def as_json(*)
        if params[:json_type] == "general"
          return as_general_json
        end

        super.merge({
            :general_json_link_show => general_json_link_show,
          })
      end

      def as_general_json
        raise NotImplementedError, "#{__method__} is not implemented"
      end
    end
  end
end

module QuickScript
  module Swars
    class PrisonPostScript < Base
      self.title = "将棋ウォーズ囚人登録"
      self.description = "指定のウォーズIDが牢獄に入っていたら囚人とする"
      self.form_method = :post

      def form_parts
        super + [
          {
            :label   => "将棋ウォーズIDs",
            :key     => :swars_user_keys,
            :type    => :string,
            :default => params[:swars_user_keys],
          },
        ]
      end

      def call
        if request_post?
          current_swars_user_keys.inspect
          swars_user_key = current_swars_user_keys.first
          ::Swars::Agent
          
          swars_user_key
          
          

          
        end
      end

      def current_swars_user_keys
        params[:swars_user_keys].to_s.scan(/\w+/)
      end
    end
  end
end

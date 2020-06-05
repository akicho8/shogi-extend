module Colosseum
  class ApplicationController < ::ApplicationController
    # before_action :authenticate_action
    #
    # def authenticate_action
    #   if !current_user
    #     authenticate_xuser!
    #   end
    # end

    def js_global
      @js_global ||= super.merge({
          :current_user => current_user && current_user.as_json(only: [:id, :name], methods: [:show_path, :avatar_path]),
        })
    end
  end
end

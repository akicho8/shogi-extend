module Colosseum
  class ApplicationController < ::ApplicationController
    before_action :authenticate_action

    def authenticate_action
      if !current_user
        authenticate_xuser!
      end
    end
  end
end

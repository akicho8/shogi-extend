module Colosseum
  class ApplicationController < ::ApplicationController
    before_action do
      if !current_user
        authenticate_xuser!
      end
    end
  end
end

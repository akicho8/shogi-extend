module Fanta
  class ApplicationController < ::ApplicationController
    unless Rails.env.test?
      before_action do
        if !current_user
          authenticate_xuser!
        end
      end
    end
  end
end

module Fanta
  class ApplicationController < ::ApplicationController
    unless Rails.env.test?
      before_action :authenticate_xuser!
    end
  end
end

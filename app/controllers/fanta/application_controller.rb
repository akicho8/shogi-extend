module Fanta
  class ApplicationController < ::ApplicationController
    before_action :authenticate_xuser!
  end
end

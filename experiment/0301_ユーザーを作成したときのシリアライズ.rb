#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

module Fanta
  User.create!
end
# >> I, [2018-07-02T14:31:24.729002 #5833]  INFO -- : Rendered Fanta::ChatUserSerializer with ActiveModelSerializers::Adapter::Attributes (2408.9ms)

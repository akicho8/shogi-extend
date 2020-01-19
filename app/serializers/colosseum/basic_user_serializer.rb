require File.expand_path('../../../../config/environment', __FILE__) if $0 == __FILE__

module Colosseum
  class BasicUserSerializer < ApplicationSerializer
    attributes :name
  end

  if $0 == __FILE__
    pp ams_sr(User.first, serializer: BasicUserSerializer)
  end
end
# >> {:id=>1, :name=>"運営"}

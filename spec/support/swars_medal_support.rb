module SwarsMedalSupport
  extend self
end

RSpec::Rails::ModelExampleGroup.module_eval do
  include SwarsMedalSupport
end

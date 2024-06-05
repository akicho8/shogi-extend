module SwarsBadgeSupport
  extend self
end

RSpec::Rails::ModelExampleGroup.module_eval do
  include SwarsBadgeSupport
end

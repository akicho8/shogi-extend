require File.expand_path('../../../../config/environment', __FILE__) if $0 == __FILE__

module Fanta
  class LobbyMessageSerializer < ApplicationSerializer
    attributes :message, :created_at
    belongs_to :user, serializer: SimpleUserSerializer
  end

  if $0 == __FILE__
    pp ams_sr(LobbyMessage.first, serializer: LobbyMessageSerializer)
  end
end
# ~> /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/active_model_serializers-0.10.7/lib/active_model/serializer.rb:381:in `read_attribute_for_serialization': undefined method `read_attribute_for_serialization' for nil:NilClass (NoMethodError)
# ~> 	from /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/active_model_serializers-0.10.7/lib/active_model/serializer/field.rb:23:in `value'
# ~> 	from /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/active_model_serializers-0.10.7/lib/active_model/serializer.rb:332:in `block in attributes'
# ~> 	from /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/active_model_serializers-0.10.7/lib/active_model/serializer.rb:329:in `each'
# ~> 	from /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/active_model_serializers-0.10.7/lib/active_model/serializer.rb:329:in `each_with_object'
# ~> 	from /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/active_model_serializers-0.10.7/lib/active_model/serializer.rb:329:in `attributes'
# ~> 	from /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/active_model_serializers-0.10.7/lib/active_model/serializer.rb:392:in `attributes_hash'
# ~> 	from /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/active_model_serializers-0.10.7/lib/active_model/serializer.rb:360:in `serializable_hash'
# ~> 	from /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/active_model_serializers-0.10.7/lib/active_model_serializers/adapter/attributes.rb:7:in `serializable_hash'
# ~> 	from /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/active_model_serializers-0.10.7/lib/active_model_serializers/adapter/base.rb:59:in `as_json'
# ~> 	from /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/active_model_serializers-0.10.7/lib/active_model_serializers/serializable_resource.rb:8:in `as_json'
# ~> 	from /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/active_model_serializers-0.10.7/lib/active_model_serializers/logging.rb:69:in `block (3 levels) in notify'
# ~> 	from /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/activesupport-5.2.0/lib/active_support/callbacks.rb:109:in `block in run_callbacks'
# ~> 	from /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/active_model_serializers-0.10.7/lib/active_model_serializers/logging.rb:22:in `block (3 levels) in instrument_rendering'
# ~> 	from /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/active_model_serializers-0.10.7/lib/active_model_serializers/logging.rb:79:in `block in notify_render'
# ~> 	from /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/activesupport-5.2.0/lib/active_support/notifications.rb:168:in `block in instrument'
# ~> 	from /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/activesupport-5.2.0/lib/active_support/notifications/instrumenter.rb:23:in `instrument'
# ~> 	from /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/activesupport-5.2.0/lib/active_support/notifications.rb:168:in `instrument'
# ~> 	from /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/active_model_serializers-0.10.7/lib/active_model_serializers/logging.rb:78:in `notify_render'
# ~> 	from /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/active_model_serializers-0.10.7/lib/active_model_serializers/logging.rb:21:in `block (2 levels) in instrument_rendering'
# ~> 	from /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/active_model_serializers-0.10.7/lib/active_model_serializers/logging.rb:97:in `tag_logger'
# ~> 	from /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/active_model_serializers-0.10.7/lib/active_model_serializers/logging.rb:20:in `block in instrument_rendering'
# ~> 	from /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/activesupport-5.2.0/lib/active_support/callbacks.rb:118:in `instance_exec'
# ~> 	from /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/activesupport-5.2.0/lib/active_support/callbacks.rb:118:in `block in run_callbacks'
# ~> 	from /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/activesupport-5.2.0/lib/active_support/callbacks.rb:136:in `run_callbacks'
# ~> 	from /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/active_model_serializers-0.10.7/lib/active_model_serializers/logging.rb:68:in `block (2 levels) in notify'
# ~> 	from /Users/ikeda/src/shogi_web/config/initializers/0180_active_model_serializers.rb:13:in `ams_sr'
# ~> 	from -:10:in `<module:Fanta>'
# ~> 	from -:3:in `<main>'
# >> ["/Users/ikeda/src/shogi_web/config/initializers/0180_active_model_serializers.rb:11", nil, :ams_sr]
# >> I, [2018-06-14T17:41:02.417027 #47289]  INFO -- : Rendered Fanta::LobbyMessageSerializer with ActiveModelSerializers::Adapter::Attributes (4.15ms)

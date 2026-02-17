require "./setup"

redis = Rails.cache.redis.with(&:itself)

session_data = {}

controller = Api::QuickScriptsController.new
controller.params = ActionController::Parameters.new({ foo: 1 })

request = ActionDispatch::TestRequest.create
controller.request = request
controller.request.session = ActionDispatch::Request::Session.new(request.env, request.session_options)

session_key = SecureRandom.hex(16)
redis.set("session:#{session_key}", session_data.to_json)

controller.request.session["session_id"] = session_key

# request = ActionDispatch::TestRequest.create
# controller.request = request
# controller.request.session = ActionDispatch::Request::Session.create(store: ActiveSupport::Cache::MemoryStore.new)
# session_data.each { |k, v| controller.request.session[k] = v }
#
# session_script = QuickScript::Dev::SessionScript.new({}, controller: controller)
# session_script.call             # =>
# ~> /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/actionpack-7.1.3.4/lib/action_dispatch/request/session.rb:230:in `exists?': undefined method `session_exists?' for {"rack.version"=>[1, 3], "rack.input"=>#<StringIO:0x0000000108eb4700>, "rack.errors"=>#<StringIO:0x0000000108eb4868>, "rack.multithread"=>true, "rack.multiprocess"=>true, "rack.run_once"=>false, "REQUEST_METHOD"=>"GET", "SERVER_NAME"=>"example.org", "SERVER_PORT"=>"80", "QUERY_STRING"=>"", "PATH_INFO"=>"/", "rack.url_scheme"=>"http", "HTTPS"=>"off", "SCRIPT_NAME"=>"", "CONTENT_LENGTH"=>"0", "HTTP_HOST"=>"test.host", "REMOTE_ADDR"=>"0.0.0.0", "HTTP_USER_AGENT"=>"Rails Testing", "action_dispatch.parameter_filter"=>[], "action_dispatch.redirect_filter"=>[], "action_dispatch.secret_key_base"=>"17e4ee8443b38cb8acc83069cf36db8f48d3689fa014914541179722163f9204e0e5886137ff5e0767273d183cf091bc1be78a964ffb01a1fa02f4e21da43473", "action_dispatch.show_exceptions"=>:all, "action_dispatch.show_detailed_exceptions"=>true, "action_dispatch.log_rescued_responses"=>true, "action_dispatch.debug_exception_log_level"=>4, "action_dispatch.logger"=>#<ActiveSupport::BroadcastLogger:0x0000000107efabe8 @broadcasts=[#<ActiveSupport::Logger:0x0000000107e93a88 @level=0, @progname=nil, @default_formatter=#<Logger::Formatter:0x0000000107efb160 @datetime_format=nil>, @formatter=#<ActiveSupport::Logger::SimpleFormatter:0x0000000107efae90 @datetime_format=nil, @thread_key="activesupport_tagged_logging_tags:19820">, @logdev=#<Logger::LogDevice:0x0000000107e93b28 @shift_period_suffix="%Y%m%d", @shift_size=1048576, @shift_age=0, @filename="/Users/ikeda/src/shogi/shogi-extend/log/development.log", @dev=#<File:/Users/ikeda/src/shogi/shogi-extend/log/development.log>, @binmode=false, @mon_data=#<Monitor:0x0000000107efb0c0>, @mon_data_owner_object_id=8000>, @local_level_key=:logger_thread_safe_level_19800>], @progname="Broadcast", @formatter=#<ActiveSupport::Logger::SimpleFormatter:0x0000000107efae90 @datetime_format=nil, @thread_key="activesupport_tagged_logging_tags:19820">>, "action_dispatch.backtrace_cleaner"=>#<Rails::BacktraceCleaner:0x00000001081f2508 @silencers=[#<Proc:0x00000001081f2170 /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/activesupport-7.1.3.4/lib/active_support/backtrace_cleaner.rb:120>, #<Proc:0x00000001081f20f8 /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/activesupport-7.1.3.4/lib/active_support/backtrace_cleaner.rb:124>, #<Proc:0x00000001081f1fe0 /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/railties-7.1.3.4/lib/rails/backtrace_cleaner.rb:24>], @filters=[#<Proc:0x00000001081f2210 /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/activesupport-7.1.3.4/lib/active_support/backtrace_cleaner.rb:116>, #<Proc:0x00000001081f2030 /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/railties-7.1.3.4/lib/rails/backtrace_cleaner.rb:14>, #<Proc:0x00000001081f2008 /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/railties-7.1.3.4/lib/rails/backtrace_cleaner.rb:17>], @root="/Users/ikeda/src/shogi/shogi-extend/">, "action_dispatch.key_generator"=>#<ActiveSupport::CachingKeyGenerator:0x00000001085b2f30 @key_generator=#<ActiveSupport::KeyGenerator:0x0000000000afa0>, @cache_keys=#<Concurrent::Map:0x00000001085b2ee0 entries=3 default_proc=nil>>, "action_dispatch.http_auth_salt"=>"http authentication", "action_dispatch.signed_cookie_salt"=>"signed cookie", "action_dispatch.encrypted_cookie_salt"=>"encrypted cookie", "action_dispatch.encrypted_signed_cookie_salt"=>"signed encrypted cookie", "action_dispatch.authenticated_encrypted_cookie_salt"=>"authenticated encrypted cookie", "action_dispatch.use_authenticated_cookie_encryption"=>true, "action_dispatch.encrypted_cookie_cipher"=>nil, "action_dispatch.signed_cookie_digest"=>nil, "action_dispatch.cookies_serializer"=>:json, "action_dispatch.cookies_digest"=>nil, "action_dispatch.cookies_rotations"=>#<ActiveSupport::Messages::RotationConfiguration:0x000000010476f980 @signed=[], @encrypted=[]>, "action_dispatch.cookies_same_site_protection"=>#<Proc:0x0000000108eb35a8 /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/railties-7.1.3.4/lib/rails/application.rb:705>, "action_dispatch.use_cookies_with_metadata"=>true, "action_dispatch.content_security_policy"=>nil, "action_dispatch.content_security_policy_report_only"=>false, "action_dispatch.content_security_policy_nonce_generator"=>nil, "action_dispatch.content_security_policy_nonce_directives"=>nil, "action_dispatch.permissions_policy"=>nil, "rack.request.cookie_hash"=>{}, "rack.session.options"=>{}, "rack.session"=>#<ActionDispatch::Request::Session:0xafc8 not yet loaded>}:Hash (NoMethodError)
# ~>
# ~>         @exists = @by.send(:session_exists?, @req)
# ~>                      ^^^^^
# ~> 	from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/actionpack-7.1.3.4/lib/action_dispatch/request/session.rb:270:in `load!'
# ~> 	from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/actionpack-7.1.3.4/lib/action_dispatch/request/session.rb:258:in `load_for_write!'
# ~> 	from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/actionpack-7.1.3.4/lib/action_dispatch/request/session.rb:153:in `[]='
# ~> 	from -:17:in `<dispatcher>'

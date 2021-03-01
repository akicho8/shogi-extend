require 'rails_helper'

RSpec.describe Api::BlindfoldsController, type: :controller do
  it "works" do
    get :show

    pp response

    assert { response.success == 200 }
  end
end
# >> Run options: exclude {:slow_spec=>true}
# >> #<ActionDispatch::TestResponse:0x00007fe531853838
# >>  @cache_control={},
# >>  @committed=true,
# >>  @cv=
# >>   #<MonitorMixin::ConditionVariable:0x00007fe531853720
# >>    @cond=#<Thread::ConditionVariable:0x00007fe5318536f8>,
# >>    @monitor=#<ActionDispatch::TestResponse:0x00007fe531853838 ...>>,
# >>  @header=
# >>   {"X-Frame-Options"=>"ALLOWALL",
# >>    "X-XSS-Protection"=>"1; mode=block",
# >>    "X-Content-Type-Options"=>"nosniff",
# >>    "X-Download-Options"=>"noopen",
# >>    "X-Permitted-Cross-Domain-Policies"=>"none",
# >>    "Referrer-Policy"=>"strict-origin-when-cross-origin",
# >>    "Content-Type"=>"application/json; charset=utf-8"},
# >>  @mon_count=0,
# >>  @mon_mutex=#<Thread::Mutex:0x00007fe5318537e8>,
# >>  @mon_mutex_owner_object_id=70311177526300,
# >>  @mon_owner=nil,
# >>  @request=
# >>   #<ActionController::TestRequest:0x00007fe5318539a0
# >>    @controller_class=Api::BlindfoldsController,
# >>    @custom_param_parsers=
# >>     {:xml=>
# >>       #<Proc:0x00007fe531853900@/usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/actionpack-6.0.3.2/lib/action_controller/test_case.rb:61 (lambda)>},
# >>    @env=
# >>     {"rack.version"=>[1, 3],
# >>      "rack.input"=>#<StringIO:0x00007fe531853a18>,
# >>      "rack.errors"=>#<StringIO:0x00007fe52a913478>,
# >>      "rack.multithread"=>true,
# >>      "rack.multiprocess"=>true,
# >>      "rack.run_once"=>false,
# >>      "REQUEST_METHOD"=>"GET",
# >>      "SERVER_NAME"=>"example.org",
# >>      "SERVER_PORT"=>"80",
# >>      "QUERY_STRING"=>"",
# >>      "rack.url_scheme"=>"http",
# >>      "HTTPS"=>"off",
# >>      "SCRIPT_NAME"=>"",
# >>      "HTTP_HOST"=>"test.host",
# >>      "REMOTE_ADDR"=>"0.0.0.0",
# >>      "HTTP_USER_AGENT"=>"Rails Testing",
# >>      "action_dispatch.parameter_filter"=>[:password],
# >>      "action_dispatch.redirect_filter"=>[],
# >>      "action_dispatch.secret_key_base"=>
# >>       "2e090a8b2a4af445e4b3ebd84b00ac53d238c406bc35bcf3066912a453839889c351fc99e16483d01a1b183a6c2d6f242da29623127db63cb2da23cc79e92b75",
# >>      "action_dispatch.show_exceptions"=>false,
# >>      "action_dispatch.show_detailed_exceptions"=>true,
# >>      "action_dispatch.logger"=>
# >>       #<ActiveSupport::Logger:0x00007fe529db24a8
# >>        @default_formatter=
# >>         #<Logger::Formatter:0x00007fe529db2598 @datetime_format=nil>,
# >>        @formatter=
# >>         #<ActiveSupport::Logger::SimpleFormatter:0x00007fe529db2458
# >>          @datetime_format=nil,
# >>          @thread_key="activesupport_tagged_logging_tags:70311113232940">,
# >>        @level=0,
# >>        @logdev=
# >>         #<Logger::LogDevice:0x00007fe529db2548
# >>          @dev=#<File:/Users/ikeda/src/shogi-extend/log/test.log>,
# >>          @filename=nil,
# >>          @mon_count=0,
# >>          @mon_mutex=#<Thread::Mutex:0x00007fe529db24f8>,
# >>          @mon_mutex_owner_object_id=70311113233060,
# >>          @mon_owner=nil,
# >>          @shift_age=nil,
# >>          @shift_period_suffix=nil,
# >>          @shift_size=nil>,
# >>        @progname=nil>,
# >>      "action_dispatch.backtrace_cleaner"=>
# >>       #<Rails::BacktraceCleaner:0x00007fe52e4be478
# >>        @filters=
# >>         [#<Proc:0x00007fe52e4be158@/usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activesupport-6.0.3.2/lib/active_support/backtrace_cleaner.rb:96>,
# >>          #<Proc:0x00007fe52e4be018@/usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/railties-6.0.3.2/lib/rails/backtrace_cleaner.rb:16>,
# >>          #<Proc:0x00007fe52e4bdff0@/usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/railties-6.0.3.2/lib/rails/backtrace_cleaner.rb:17>,
# >>          #<Proc:0x00007fe52e4bdfc8@/usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/railties-6.0.3.2/lib/rails/backtrace_cleaner.rb:18>],
# >>        @root="/Users/ikeda/src/shogi-extend/",
# >>        @silencers=
# >>         [#<Proc:0x00007fe52e4be108@/usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activesupport-6.0.3.2/lib/active_support/backtrace_cleaner.rb:100>,
# >>          #<Proc:0x00007fe52e4be0b8@/usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activesupport-6.0.3.2/lib/active_support/backtrace_cleaner.rb:104>,
# >>          #<Proc:0x00007fe52e4bdfa0@/usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/railties-6.0.3.2/lib/rails/backtrace_cleaner.rb:19>]>,
# >>      "action_dispatch.key_generator"=>
# >>       #<ActiveSupport::CachingKeyGenerator:0x00007fe52e53c170
# >>        @cache_keys=
# >>         #<Concurrent::Map:0x00007fe52e53c148 entries=3 default_proc=nil>,
# >>        @key_generator=
# >>         #<ActiveSupport::KeyGenerator:0x00007fe52e53c198
# >>          @iterations=1000,
# >>          @secret=
# >>           "2e090a8b2a4af445e4b3ebd84b00ac53d238c406bc35bcf3066912a453839889c351fc99e16483d01a1b183a6c2d6f242da29623127db63cb2da23cc79e92b75">>,
# >>      "action_dispatch.http_auth_salt"=>"http authentication",
# >>      "action_dispatch.signed_cookie_salt"=>"signed cookie",
# >>      "action_dispatch.encrypted_cookie_salt"=>"encrypted cookie",
# >>      "action_dispatch.encrypted_signed_cookie_salt"=>"signed encrypted cookie",
# >>      "action_dispatch.authenticated_encrypted_cookie_salt"=>
# >>       "authenticated encrypted cookie",
# >>      "action_dispatch.use_authenticated_cookie_encryption"=>true,
# >>      "action_dispatch.encrypted_cookie_cipher"=>nil,
# >>      "action_dispatch.signed_cookie_digest"=>nil,
# >>      "action_dispatch.cookies_serializer"=>:json,
# >>      "action_dispatch.cookies_digest"=>nil,
# >>      "action_dispatch.cookies_rotations"=>
# >>       #<ActiveSupport::Messages::RotationConfiguration:0x00007fe529a02ad8
# >>        @encrypted=[],
# >>        @signed=[]>,
# >>      "action_dispatch.use_cookies_with_metadata"=>true,
# >>      "action_dispatch.content_security_policy"=>nil,
# >>      "action_dispatch.content_security_policy_report_only"=>false,
# >>      "action_dispatch.content_security_policy_nonce_generator"=>nil,
# >>      "action_dispatch.content_security_policy_nonce_directives"=>nil,
# >>      "rack.session"=>{},
# >>      "rack.session.options"=>
# >>       {:key=>"rack.session",
# >>        :path=>"/",
# >>        :domain=>nil,
# >>        :expire_after=>nil,
# >>        :secure=>false,
# >>        :httponly=>true,
# >>        :defer=>false,
# >>        :renew=>false,
# >>        :sidbits=>128,
# >>        :cookie_only=>true,
# >>        :secure_random=>SecureRandom},
# >>      "action_controller.instance"=>
# >>       #<Api::BlindfoldsController:0x00007fe5318426c8
# >>        @_action_has_layout=true,
# >>        @_action_name="show",
# >>        @_config={},
# >>        @_db_runtime=4.917001351714134,
# >>        @_lookup_context=
# >>         #<ActionView::LookupContext:0x00007fe5318533b0
# >>          @cache=true,
# >>          @details=
# >>           {:locale=>[:ja],
# >>            :formats=>[:html],
# >>            :variants=>[],
# >>            :handlers=>
# >>             [:raw, :erb, :html, :builder, :ruby, :slim, :coffee, :jbuilder]},
# >>          @details_key=nil,
# >>          @digest_cache=nil,
# >>          @prefixes=["api/blindfolds", "api/application", "application"],
# >>          @view_paths=
# >>           #<ActionView::PathSet:0x00007fe5318531f8
# >>            @paths=
# >>             [#<ActionView::OptimizedFileSystemResolver:0x00007fe52e43d1e8
# >>               @cache=
# >>                #<ActionView::Resolver::Cache:0x7fe52e43d120 keys=0 queries=0>,
# >>               @path="/Users/ikeda/src/shogi-extend/app/views",
# >>               @pattern=
# >>                ":prefix/:action{.:locale,}{.:formats,}{+:variants,}{.:handlers,}",
# >>               @unbound_templates=
# >>                #<Concurrent::Map:0x00007fe52e43d1c0 entries=0 default_proc=nil>>,
# >>              #<ActionView::OptimizedFileSystemResolver:0x00007fe52e43d620
# >>               @cache=
# >>                #<ActionView::Resolver::Cache:0x7fe52e43d558 keys=0 queries=0>,
# >>               @path=
# >>                "/usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/devise-i18n-views-0.3.7/app/views",
# >>               @pattern=
# >>                ":prefix/:action{.:locale,}{.:formats,}{+:variants,}{.:handlers,}",
# >>               @unbound_templates=
# >>                #<Concurrent::Map:0x00007fe52e43d5f8 entries=0 default_proc=nil>>,
# >>              #<ActionView::OptimizedFileSystemResolver:0x00007fe52e43daf8
# >>               @cache=
# >>                #<ActionView::Resolver::Cache:0x7fe52e43da08 keys=0 queries=0>,
# >>               @path=
# >>                "/usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/devise-i18n-1.9.0/app/views",
# >>               @pattern=
# >>                ":prefix/:action{.:locale,}{.:formats,}{+:variants,}{.:handlers,}",
# >>               @unbound_templates=
# >>                #<Concurrent::Map:0x00007fe52e43dad0 entries=0 default_proc=nil>>,
# >>              #<ActionView::OptimizedFileSystemResolver:0x00007fe52e43e188
# >>               @cache=
# >>                #<ActionView::Resolver::Cache:0x7fe52e43dff8 keys=0 queries=0>,
# >>               @path=
# >>                "/usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/devise-4.7.1/app/views",
# >>               @pattern=
# >>                ":prefix/:action{.:locale,}{.:formats,}{+:variants,}{.:handlers,}",
# >>               @unbound_templates=
# >>                #<Concurrent::Map:0x00007fe52e43e160 entries=0 default_proc=nil>>,
# >>              #<ActionView::OptimizedFileSystemResolver:0x00007fe52e43eb88
# >>               @cache=
# >>                #<ActionView::Resolver::Cache:0x7fe52e43e9a8 keys=0 queries=0>,
# >>               @path=
# >>                "/usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/kaminari-core-1.2.1/app/views",
# >>               @pattern=
# >>                ":prefix/:action{.:locale,}{.:formats,}{+:variants,}{.:handlers,}",
# >>               @unbound_templates=
# >>                #<Concurrent::Map:0x00007fe52e43eae8 entries=0 default_proc=nil>>,
# >>              #<ActionView::OptimizedFileSystemResolver:0x00007fe52e43f830
# >>               @cache=
# >>                #<ActionView::Resolver::Cache:0x7fe52e43f6a0 keys=0 queries=0>,
# >>               @path=
# >>                "/usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/actiontext-6.0.3.2/app/views",
# >>               @pattern=
# >>                ":prefix/:action{.:locale,}{.:formats,}{+:variants,}{.:handlers,}",
# >>               @unbound_templates=
# >>                #<Concurrent::Map:0x00007fe52e43f7b8 entries=0 default_proc=nil>>,
# >>              #<ActionView::OptimizedFileSystemResolver:0x00007fe52e4703b8
# >>               @cache=
# >>                #<ActionView::Resolver::Cache:0x7fe52e4701d8 keys=0 queries=0>,
# >>               @path=
# >>                "/usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/actionmailbox-6.0.3.2/app/views",
# >>               @pattern=
# >>                ":prefix/:action{.:locale,}{.:formats,}{+:variants,}{.:handlers,}",
# >>               @unbound_templates=
# >>                #<Concurrent::Map:0x00007fe52e470340 entries=0 default_proc=nil>>]>>,
# >>        @_params=
# >>         <ActionController::Parameters {"controller"=>"api/blindfolds", "action"=>"show"} permitted: false>,
# >>        @_request=#<ActionController::TestRequest:0x00007fe5318539a0 ...>,
# >>        @_response=#<ActionDispatch::TestResponse:0x00007fe531853838 ...>,
# >>        @_response_body=
# >>         ["{\"record\":{\"turn_max\":0,\"sfen_body\":\"position startpos\"}}"],
# >>        @_routes=nil,
# >>        @_url_options=nil,
# >>        @_view_runtime=0.28400029987096786,
# >>        @current_record=
# >>         #<FreeBattle:0x00007fe53196b3b0
# >>          id: 7,
# >>          key: "free_battle1",
# >>          kifu_url: nil,
# >>          title: "",
# >>          kifu_body: "position startpos",
# >>          turn_max: 0,
# >>          meta_info:
# >>           {:black=>
# >>             {:defense=>[],
# >>              :attack=>[],
# >>              :technique=>[],
# >>              :note=>[:居飛車, :相居飛車, :居玉, :相居玉]},
# >>            :white=>
# >>             {:defense=>[],
# >>              :attack=>[],
# >>              :technique=>[],
# >>              :note=>[:居飛車, :相居飛車, :居玉, :相居玉]}},
# >>          battled_at: Mon, 01 Jan 0001 00:00:00 LMT +09:18,
# >>          use_key: "share_board",
# >>          accessed_at: Mon, 01 Mar 2021 16:29:54 JST +09:00,
# >>          user_id: nil,
# >>          preset_key: "平手",
# >>          description: "",
# >>          sfen_body: "position startpos",
# >>          sfen_hash: "d3c5be51f1d024db54df870a6ebca2a3",
# >>          start_turn: nil,
# >>          critical_turn: nil,
# >>          outbreak_turn: nil,
# >>          image_turn: nil,
# >>          created_at: Mon, 01 Mar 2021 16:29:54 JST +09:00,
# >>          updated_at: Mon, 01 Mar 2021 16:29:54 JST +09:00,
# >>          defense_tag_list: nil,
# >>          attack_tag_list: nil,
# >>          technique_tag_list: nil,
# >>          note_tag_list: nil,
# >>          other_tag_list: nil,
# >>          kifu_file: nil>,
# >>        @current_user=nil,
# >>        @current_xuser=nil,
# >>        @marked_for_same_origin_verification=true,
# >>        @rendered_format=nil>,
# >>      "warden"=>
# >>       Warden::Proxy:70311177487200 @config={:default_scope=>:xuser, :scope_defaults=>{}, :default_strategies=>{:xuser=>[:rememberable, :database_authenticatable]}, :intercept_401=>false, :failure_app=>#<Devise::Delegator:0x00007fe52e2d6db8>},
# >>      "HTTP_COOKIE"=>"",
# >>      "PATH_INFO"=>"/api/blindfold",
# >>      "action_dispatch.request.path_parameters"=>
# >>       {:controller=>"api/blindfolds", :action=>"show"},
# >>      "action_dispatch.request.flash_hash"=>
# >>       #<ActionDispatch::Flash::FlashHash:0x00007fe53186a600
# >>        @discard=#<Set: {}>,
# >>        @flashes={},
# >>        @now=nil>,
# >>      "action_dispatch.request.content_type"=>nil,
# >>      "action_dispatch.request.request_parameters"=>{},
# >>      "rack.request.query_string"=>"",
# >>      "rack.request.query_hash"=>{},
# >>      "action_dispatch.request.query_parameters"=>{},
# >>      "action_dispatch.request.parameters"=>
# >>       {"controller"=>"api/blindfolds", "action"=>"show"},
# >>      "action_dispatch.request.formats"=>
# >>       [#<Mime::Type:0x00007fe52a784a80
# >>         @hash=-3262232890630131071,
# >>         @string="text/html",
# >>         @symbol=:html,
# >>         @synonyms=["application/xhtml+xml"]>],
# >>      "rack.request.cookie_hash"=>{},
# >>      "rack.request.cookie_string"=>"",
# >>      "action_dispatch.cookies"=>
# >>       #<ActionDispatch::Cookies::CookieJar:0x00007fe5318869e0
# >>        @committed=false,
# >>        @cookies={},
# >>        @delete_cookies={},
# >>        @request=#<ActionController::TestRequest:0x00007fe5318539a0 ...>,
# >>        @set_cookies={},
# >>        @signed=
# >>         #<ActionDispatch::Cookies::SignedKeyRotatingCookieJar:0x00007fe5318868f0
# >>          @parent_jar=
# >>           #<ActionDispatch::Cookies::CookieJar:0x00007fe5318869e0 ...>,
# >>          @verifier=
# >>           #<ActiveSupport::MessageVerifier:0x00007fe531886788
# >>            @digest="SHA1",
# >>            @options=
# >>             {:digest=>"SHA1",
# >>              :serializer=>ActiveSupport::MessageEncryptor::NullSerializer},
# >>            @rotations=[],
# >>            @secret=
# >>             "\x80\xC7\xB8\x90\xB4N\x99\x1A\x85\x90\xED\xF1\xFB \xC4\xFC\x88\xC7\x99b8$(>\x84Q\x85Ey\xFC\x8E\xD7b\xAE\xA3\x18m6\xD3\xB5\xA0HS*\x19\x8C\x89m\xE0/\xA6~<|\xBEy(\n" +
# >>             "\xAE\xB3t<?\x1C",
# >>            @serializer=ActiveSupport::MessageEncryptor::NullSerializer>>>,
# >>      "exception_notifier.exception_data"=>{:current_user_id=>nil}},
# >>    @filtered_env=nil,
# >>    @filtered_parameters={"controller"=>"api/blindfolds", "action"=>"show"},
# >>    @filtered_path=nil,
# >>    @fullpath="/api/blindfold",
# >>    @headers=
# >>     #<ActionDispatch::Http::Headers:0x00007fe53187bd60
# >>      @req=#<ActionController::TestRequest:0x00007fe5318539a0 ...>>,
# >>    @ip=nil,
# >>    @method=nil,
# >>    @original_fullpath=nil,
# >>    @port=80,
# >>    @protocol="http://",
# >>    @remote_ip=nil,
# >>    @request_method="GET",
# >>    @variant=[]>,
# >>  @sending=false,
# >>  @sent=true,
# >>  @status=200,
# >>  @stream=
# >>   #<ActionDispatch::Response::Buffer:0x00007fe531acece8
# >>    @buf=["{\"record\":{\"turn_max\":0,\"sfen_body\":\"position startpos\"}}"],
# >>    @closed=false,
# >>    @response=#<ActionDispatch::TestResponse:0x00007fe531853838 ...>,
# >>    @str_body=nil>>
# >> F
# >> 
# >> Failures:
# >> 
# >>   1) Api::BlindfoldsController works
# >>      Failure/Error: Unable to find - to read failed line
# >> 
# >>      NoMethodError:
# >>        undefined method `success' for #<ActionDispatch::TestResponse:0x00007fe531853838>
# >>        Did you mean?  successful?
# >>      # -:9:in `block (3 levels) in <main>'
# >>      # <internal:prelude>:137:in `__enable'
# >>      # <internal:prelude>:137:in `enable'
# >>      # <internal:prelude>:137:in `__enable'
# >>      # <internal:prelude>:137:in `enable'
# >>      # -:9:in `block (2 levels) in <main>'
# >>      # ./spec/support/database_cleaner.rb:18:in `block (3 levels) in <main>'
# >>      # ./spec/support/database_cleaner.rb:18:in `block (2 levels) in <main>'
# >> 
# >> Finished in 0.96534 seconds (files took 2.77 seconds to load)
# >> 1 example, 1 failure
# >> 
# >> Failed examples:
# >> 
# >> rspec -:4 # Api::BlindfoldsController works
# >> 

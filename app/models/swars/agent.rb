# -*- frozen_string_literal: true -*-

if $0 == __FILE__
  require File.expand_path('../../../../config/environment', __FILE__)
end

module Swars
  module Agent
    class OfficialFormatChanged < StandardError
      def initialize(message = nil)
        super(message || "将棋ウォーズの構造が変わったので取り込めません")
      end
    end

    class Base
      AGENT_TYPE = :faraday     # faraday or curl

      BASE_URL   = "https://shogiwars.heroz.jp"
      USER_AGENT = "Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.163 Mobile Safari/537.36"

      class << self
        def fetch(*args)
          new(*args).fetch
        end

        def agent
          @agent ||= Faraday.new(url: BASE_URL) do |conn|
            raise if OpenSSL::SSL::VERIFY_PEER != OpenSSL::SSL::VERIFY_NONE
            if Rails.env.development? && false
              conn.response :logger
            end
            conn.use FaradayMiddleware::Instrumentation # config/initializers/0260_faraday_logger.rb
            conn.headers[:user_agent] = USER_AGENT
            conn.headers[:cookie] = Rails.application.credentials.swars_agent_cookie
          end
        end

        # 2020-05-30
        # --insecure をつけないと動作しない
        # https://qiita.com/shimpeiws/items/10e2b150c6ff41d69013
        def curl_command(url)
          [
            "curl",
            "-H 'authority: shogiwars.heroz.jp'",
            "-H 'pragma: no-cache'",
            "-H 'cache-control: no-cache'",
            "-H 'upgrade-insecure-requests: 1'",
            "-H 'user-agent: #{USER_AGENT}'",
            "-H 'accept: text/html'",
            "-H 'accept-encoding: gzip, deflate, br'",
            "-H 'accept-language: ja'",
            "-H 'cookie: #{Rails.application.credentials.swars_agent_cookie}'",
            "--silent",
            "--compressed",
            "--insecure",
            "'#{BASE_URL}#{url}'",
          ].join(" ")
        end

        def html_fetch(url)
          case AGENT_TYPE
          when :faraday
            agent.get(url).body
          when :curl
            `#{curl_command(url)}`
          end
        end
      end

      delegate :html_fetch, to: "self.class"

      attr_accessor :params

      def initialize(params)
        @params = default_params.merge(params)
      end

      def run_remote?
        if Rails.env.test?
          return false
        end

        params[:run_remote] || ENV["RUN_REMOTE"].in?(["1", "true"]) || Rails.env.production? || Rails.env.staging?
      end

      def mock_html(name)
        Pathname(File.dirname(__FILE__)).join("mock_html/#{name}.html").read
      end
    end

    class Index < Base
      cattr_accessor(:items_per_page) { 10 }

      def default_params
        {
          gtype: "",    # "":10分 "sb":3分 "s1":10秒
          user_key: nil,
          page_index: 0,
        }
      end

      def fetch
        url = url_build

        if run_remote?
          html = html_fetch(url)
        else
          html = mock_html("index")
        end

        html.scan(/game_id=([\w-]+)/).flatten
      end

      private

      def url_build
        q = {
          user_id: params[:user_key],
          gtype: params[:gtype],
        }

        if v = params[:page_index]
          q[:page] = v.next
        end

        if params[:verbose]
          tp q.inspect
        end

        "/games/history?#{q.to_query}"
      end
    end

    class Record < Base
      def default_params
        {
          key: nil,
        }
      end

      def fetch
        info = { key: key }

        url = key_to_url(key)

        url_info = battle_key_split(key)
        info[:battled_at] = url_info[:battled_at]

        if params[:verbose]
          tp "record: #{info[:url]}"
        end

        if run_remote?
          html = html_fetch(url)
        else
          html = mock_html("show")
        end

        md = html.match(/data-react-props="(.*?)"/)
        md or raise OfficialFormatChanged
        props = JSON.parse(CGI.unescapeHTML(md.captures.first))
        if params[:show_props]
          pp props
        end

        game_hash = props["gameHash"]

        info[:rule_key] = game_hash["gtype"]

        # 手合割
        info[:preset_dirty_code] = game_hash["handicap"]

        # 詰み・投了・切断などの結果がわかるキー(対局中はキーがない)
        if game_hash["result"]
          info[:__final_key] = game_hash["result"]

          info[:user_infos] = [
            { user_key: url_info[:black], grade_key: signed_number_to_grade_key(game_hash["sente_dan"]), },
            { user_key: url_info[:white], grade_key: signed_number_to_grade_key(game_hash["gote_dan"]),  },
          ]

          # moves がない場合がある
          if game_hash["moves"]
            # CSA形式の棋譜
            # 開始直後に切断している場合は空文字列になる
            # だから空ではないチェックをしてはいけない
            info[:csa_seq] = game_hash["moves"].collect { |e| [e["m"], e["t"]] }

            # 対局完了
            info[:fetch_successed] = true
          end
        end

        info
      end

      def key
        params[:key] or raise "must not happen"
      end

      # -2 → "2級"
      # -1 → "1級"
      #  0 → "初段"
      #  1 → "二段"
      #  2 → "三段"
      def signed_number_to_grade_key(v)
        if v.negative?
          "#{v.abs}級"
        else
          "初二三四五六七八九十"[v] + "段"
        end
      end

      def key_to_url(key)
        "/games/#{key}"
      end

      def battle_key_split(key)
        [:black, :white, :battled_at].zip(key.split("-")).to_h
      end
    end
  end
end

if $0 == __FILE__
  # tp Swars::Agent::Index.fetch(run_remote: true, gtype: "", user_key: "shuei299792458", page_index: 0)
  # tp Swars::Agent::Index.fetch(run_remote: true, gtype: "",   user_key: "kinakom0chi", page_index: 0)
  # tp Swars::Agent::Index.fetch(run_remote: true, gtype: "sb", user_key: "kinakom0chi", page_index: 0)
  # tp Swars::Agent::Index.fetch(run_remote: true, gtype: "s1", user_key: "kinakom0chi", page_index: 0)
  p Swars::Agent::Record.fetch(run_remote: true, key: "patrick0169-Shogochandrsu-20210612_060155")[:csa_seq]
end
# ~> /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/zeitwerk-2.4.2/lib/zeitwerk/loader.rb:558:in `rescue in block in set_autoloads_in_dir': wrong constant name Xmptmp-in22UoRJ inferred by Module from file (Zeitwerk::NameError)
# ~> 
# ~>   /Users/ikeda/src/shogi-extend/app/models/swars/xmptmp-in22UoRJ.rb
# ~> 
# ~> Possible ways to address this:
# ~> 
# ~>   * Tell Zeitwerk to ignore this particular file.
# ~>   * Tell Zeitwerk to ignore one of its parent directories.
# ~>   * Rename the file to comply with the naming conventions.
# ~>   * Modify the inflector to handle this case.
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/zeitwerk-2.4.2/lib/zeitwerk/loader.rb:534:in `block in set_autoloads_in_dir'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/zeitwerk-2.4.2/lib/zeitwerk/loader.rb:733:in `block in ls'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/zeitwerk-2.4.2/lib/zeitwerk/loader.rb:725:in `foreach'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/zeitwerk-2.4.2/lib/zeitwerk/loader.rb:725:in `ls'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/zeitwerk-2.4.2/lib/zeitwerk/loader.rb:533:in `set_autoloads_in_dir'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/zeitwerk-2.4.2/lib/zeitwerk/loader/callbacks.rb:71:in `block in on_namespace_loaded'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/zeitwerk-2.4.2/lib/zeitwerk/loader/callbacks.rb:70:in `each'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/zeitwerk-2.4.2/lib/zeitwerk/loader/callbacks.rb:70:in `on_namespace_loaded'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/zeitwerk-2.4.2/lib/zeitwerk/explicit_namespace.rb:68:in `tracepoint_class_callback'
# ~> 	from /Users/ikeda/src/shogi-extend/app/models/swars.rb:2:in `<module:Swars>'
# ~> 	from /Users/ikeda/src/shogi-extend/app/models/swars.rb:1:in `<main>'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/bootsnap-1.4.6/lib/bootsnap/load_path_cache/core_ext/kernel_require.rb:23:in `require'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/bootsnap-1.4.6/lib/bootsnap/load_path_cache/core_ext/kernel_require.rb:23:in `block in require_with_bootsnap_lfi'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/bootsnap-1.4.6/lib/bootsnap/load_path_cache/loaded_features_index.rb:92:in `register'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/bootsnap-1.4.6/lib/bootsnap/load_path_cache/core_ext/kernel_require.rb:22:in `require_with_bootsnap_lfi'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/bootsnap-1.4.6/lib/bootsnap/load_path_cache/core_ext/kernel_require.rb:31:in `require'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/zeitwerk-2.4.2/lib/zeitwerk/kernel.rb:26:in `require'
# ~> 	from /Users/ikeda/src/shogi-extend/spec/factories/swars_battles.rb:2:in `block in <main>'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/factory_bot-5.1.1/lib/factory_bot/syntax/default.rb:49:in `instance_eval'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/factory_bot-5.1.1/lib/factory_bot/syntax/default.rb:49:in `run'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/factory_bot-5.1.1/lib/factory_bot/syntax/default.rb:7:in `define'
# ~> 	from /Users/ikeda/src/shogi-extend/spec/factories/swars_battles.rb:1:in `<main>'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/bootsnap-1.4.6/lib/bootsnap/load_path_cache/core_ext/kernel_require.rb:55:in `load'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/bootsnap-1.4.6/lib/bootsnap/load_path_cache/core_ext/kernel_require.rb:55:in `load'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/factory_bot-5.1.1/lib/factory_bot/find_definitions.rb:20:in `block (2 levels) in find_definitions'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/factory_bot-5.1.1/lib/factory_bot/find_definitions.rb:19:in `each'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/factory_bot-5.1.1/lib/factory_bot/find_definitions.rb:19:in `block in find_definitions'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/factory_bot-5.1.1/lib/factory_bot/find_definitions.rb:15:in `each'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/factory_bot-5.1.1/lib/factory_bot/find_definitions.rb:15:in `find_definitions'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/factory_bot-5.1.1/lib/factory_bot/reload.rb:6:in `reload'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/factory_bot_rails-5.1.1/lib/factory_bot_rails/railtie.rb:26:in `block in <class:Railtie>'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activesupport-6.0.3.7/lib/active_support/lazy_load_hooks.rb:68:in `block in execute_hook'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activesupport-6.0.3.7/lib/active_support/lazy_load_hooks.rb:61:in `with_execution_control'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activesupport-6.0.3.7/lib/active_support/lazy_load_hooks.rb:66:in `execute_hook'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activesupport-6.0.3.7/lib/active_support/lazy_load_hooks.rb:52:in `block in run_load_hooks'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activesupport-6.0.3.7/lib/active_support/lazy_load_hooks.rb:51:in `each'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activesupport-6.0.3.7/lib/active_support/lazy_load_hooks.rb:51:in `run_load_hooks'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/railties-6.0.3.7/lib/rails/application/finisher.rb:129:in `block in <module:Finisher>'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/railties-6.0.3.7/lib/rails/initializable.rb:32:in `instance_exec'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/railties-6.0.3.7/lib/rails/initializable.rb:32:in `run'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/railties-6.0.3.7/lib/rails/initializable.rb:61:in `block in run_initializers'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/2.6.0/tsort.rb:228:in `block in tsort_each'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/2.6.0/tsort.rb:350:in `block (2 levels) in each_strongly_connected_component'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/2.6.0/tsort.rb:431:in `each_strongly_connected_component_from'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/2.6.0/tsort.rb:349:in `block in each_strongly_connected_component'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/2.6.0/tsort.rb:347:in `each'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/2.6.0/tsort.rb:347:in `call'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/2.6.0/tsort.rb:347:in `each_strongly_connected_component'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/2.6.0/tsort.rb:226:in `tsort_each'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/2.6.0/tsort.rb:205:in `tsort_each'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/railties-6.0.3.7/lib/rails/initializable.rb:60:in `run_initializers'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/railties-6.0.3.7/lib/rails/application.rb:363:in `initialize!'
# ~> 	from /Users/ikeda/src/shogi-extend/config/environment.rb:5:in `<top (required)>'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/2.6.0/rubygems/core_ext/kernel_require.rb:54:in `require'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/2.6.0/rubygems/core_ext/kernel_require.rb:54:in `require'
# ~> 	from -:4:in `<main>'
# ~> /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/zeitwerk-2.4.2/lib/zeitwerk/loader.rb:777:in `const_defined?': wrong constant name Xmptmp-in22UoRJ (NameError)
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/zeitwerk-2.4.2/lib/zeitwerk/loader.rb:777:in `cdef?'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/zeitwerk-2.4.2/lib/zeitwerk/loader.rb:678:in `strict_autoload_path'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/zeitwerk-2.4.2/lib/zeitwerk/loader.rb:656:in `autoload_for?'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/zeitwerk-2.4.2/lib/zeitwerk/loader.rb:596:in `autoload_file'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/zeitwerk-2.4.2/lib/zeitwerk/loader.rb:538:in `block in set_autoloads_in_dir'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/zeitwerk-2.4.2/lib/zeitwerk/loader.rb:733:in `block in ls'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/zeitwerk-2.4.2/lib/zeitwerk/loader.rb:725:in `foreach'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/zeitwerk-2.4.2/lib/zeitwerk/loader.rb:725:in `ls'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/zeitwerk-2.4.2/lib/zeitwerk/loader.rb:533:in `set_autoloads_in_dir'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/zeitwerk-2.4.2/lib/zeitwerk/loader/callbacks.rb:71:in `block in on_namespace_loaded'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/zeitwerk-2.4.2/lib/zeitwerk/loader/callbacks.rb:70:in `each'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/zeitwerk-2.4.2/lib/zeitwerk/loader/callbacks.rb:70:in `on_namespace_loaded'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/zeitwerk-2.4.2/lib/zeitwerk/explicit_namespace.rb:68:in `tracepoint_class_callback'
# ~> 	from /Users/ikeda/src/shogi-extend/app/models/swars.rb:2:in `<module:Swars>'
# ~> 	from /Users/ikeda/src/shogi-extend/app/models/swars.rb:1:in `<main>'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/bootsnap-1.4.6/lib/bootsnap/load_path_cache/core_ext/kernel_require.rb:23:in `require'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/bootsnap-1.4.6/lib/bootsnap/load_path_cache/core_ext/kernel_require.rb:23:in `block in require_with_bootsnap_lfi'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/bootsnap-1.4.6/lib/bootsnap/load_path_cache/loaded_features_index.rb:92:in `register'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/bootsnap-1.4.6/lib/bootsnap/load_path_cache/core_ext/kernel_require.rb:22:in `require_with_bootsnap_lfi'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/bootsnap-1.4.6/lib/bootsnap/load_path_cache/core_ext/kernel_require.rb:31:in `require'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/zeitwerk-2.4.2/lib/zeitwerk/kernel.rb:26:in `require'
# ~> 	from /Users/ikeda/src/shogi-extend/spec/factories/swars_battles.rb:2:in `block in <main>'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/factory_bot-5.1.1/lib/factory_bot/syntax/default.rb:49:in `instance_eval'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/factory_bot-5.1.1/lib/factory_bot/syntax/default.rb:49:in `run'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/factory_bot-5.1.1/lib/factory_bot/syntax/default.rb:7:in `define'
# ~> 	from /Users/ikeda/src/shogi-extend/spec/factories/swars_battles.rb:1:in `<main>'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/bootsnap-1.4.6/lib/bootsnap/load_path_cache/core_ext/kernel_require.rb:55:in `load'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/bootsnap-1.4.6/lib/bootsnap/load_path_cache/core_ext/kernel_require.rb:55:in `load'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/factory_bot-5.1.1/lib/factory_bot/find_definitions.rb:20:in `block (2 levels) in find_definitions'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/factory_bot-5.1.1/lib/factory_bot/find_definitions.rb:19:in `each'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/factory_bot-5.1.1/lib/factory_bot/find_definitions.rb:19:in `block in find_definitions'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/factory_bot-5.1.1/lib/factory_bot/find_definitions.rb:15:in `each'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/factory_bot-5.1.1/lib/factory_bot/find_definitions.rb:15:in `find_definitions'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/factory_bot-5.1.1/lib/factory_bot/reload.rb:6:in `reload'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/factory_bot_rails-5.1.1/lib/factory_bot_rails/railtie.rb:26:in `block in <class:Railtie>'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activesupport-6.0.3.7/lib/active_support/lazy_load_hooks.rb:68:in `block in execute_hook'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activesupport-6.0.3.7/lib/active_support/lazy_load_hooks.rb:61:in `with_execution_control'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activesupport-6.0.3.7/lib/active_support/lazy_load_hooks.rb:66:in `execute_hook'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activesupport-6.0.3.7/lib/active_support/lazy_load_hooks.rb:52:in `block in run_load_hooks'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activesupport-6.0.3.7/lib/active_support/lazy_load_hooks.rb:51:in `each'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activesupport-6.0.3.7/lib/active_support/lazy_load_hooks.rb:51:in `run_load_hooks'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/railties-6.0.3.7/lib/rails/application/finisher.rb:129:in `block in <module:Finisher>'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/railties-6.0.3.7/lib/rails/initializable.rb:32:in `instance_exec'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/railties-6.0.3.7/lib/rails/initializable.rb:32:in `run'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/railties-6.0.3.7/lib/rails/initializable.rb:61:in `block in run_initializers'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/2.6.0/tsort.rb:228:in `block in tsort_each'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/2.6.0/tsort.rb:350:in `block (2 levels) in each_strongly_connected_component'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/2.6.0/tsort.rb:431:in `each_strongly_connected_component_from'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/2.6.0/tsort.rb:349:in `block in each_strongly_connected_component'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/2.6.0/tsort.rb:347:in `each'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/2.6.0/tsort.rb:347:in `call'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/2.6.0/tsort.rb:347:in `each_strongly_connected_component'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/2.6.0/tsort.rb:226:in `tsort_each'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/2.6.0/tsort.rb:205:in `tsort_each'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/railties-6.0.3.7/lib/rails/initializable.rb:60:in `run_initializers'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/railties-6.0.3.7/lib/rails/application.rb:363:in `initialize!'
# ~> 	from /Users/ikeda/src/shogi-extend/config/environment.rb:5:in `<top (required)>'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/2.6.0/rubygems/core_ext/kernel_require.rb:54:in `require'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/2.6.0/rubygems/core_ext/kernel_require.rb:54:in `require'
# ~> 	from -:4:in `<main>'

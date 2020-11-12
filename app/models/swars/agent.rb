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
  tp Swars::Agent::Index.fetch(run_remote: true, gtype: "", user_key: "shuei299792458", page_index: 0)
  tp Swars::Agent::Index.fetch(run_remote: true, gtype: "",   user_key: "kinakom0chi", page_index: 0)
  tp Swars::Agent::Index.fetch(run_remote: true, gtype: "sb", user_key: "kinakom0chi", page_index: 0)
  tp Swars::Agent::Index.fetch(run_remote: true, gtype: "s1", user_key: "kinakom0chi", page_index: 0)
  tp Swars::Agent::Record.fetch(run_remote: true, key: "GRAN0215-kinakom0chi-20200411_195834")
end
# >> |------------------------------------------|
# >> | pc_gucchi-kinakom0chi-20200530_145751    |
# >> | kinakom0chi-PAPAMOS-20200530_144401      |
# >> | kinakom0chi-hosiii-20200530_144155       |
# >> | kinakom0chi-guriguri9000-20200529_190134 |
# >> | kinakom0chi-dokann-20200529_183638       |
# >> | LucasMon-kinakom0chi-20200529_183215     |
# >> | kakarot4649-kinakom0chi-20200528_202833  |
# >> | kinakom0chi-Yakult1972-20200528_183022   |
# >> | kinakom0chi-taka7280-20200528_182631     |
# >> | 1602st-kinakom0chi-20200527_201838       |
# >> |------------------------------------------|
# >> |--------------------------------------|
# >> | kinakom0chi-Onebingo-20200501_233039 |
# >> |--------------------------------------|
# >> |-------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> |               key | GRAN0215-kinakom0chi-20200411_195834                                                                                                                                                                                                                                |
# >> |        battled_at | 20200411_195834                                                                                                                                                                                                                                                     |
# >> |          rule_key |                                                                                                                                                                                                                                                                     |
# >> | preset_dirty_code | 0                                                                                                                                                                                                                                                                   |
# >> |       __final_key | GOTE_WIN_TIMEOUT                                                                                                                                                                                                                                                    |
# >> |        user_infos | [{:user_key=>"GRAN0215", :grade_key=>"2級"}, {:user_key=>"kinakom0chi", :grade_key=>"1級"}]                                                                                                                                                                         |
# >> |           csa_seq | [["+7776FU", 599], ["-8384FU", 600], ["+7968GI", 595], ["-8485FU", 598], ["+6877GI", 593], ["-7172GI", 595], ["+6978KI", 591], ["-7283GI", 594], ["+8879KA", 590], ["-8384GI", 592], ["+9796FU", 589], ["-9394FU", 591], ["+7968KA", 588], ["-3334FU", 588], ["+... |
# >> |   fetch_successed | true                                                                                                                                                                                                                                                                |
# >> |-------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|

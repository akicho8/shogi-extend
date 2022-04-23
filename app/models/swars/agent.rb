# -*- frozen_string_literal: true -*-

if $0 == __FILE__
  require File.expand_path('../../../../config/environment', __FILE__)
end

module Swars
  module Agent
    class BaseError < StandardError
      attr_accessor :status

      def initialize(status = 500, message = "(MESSAGE)")
        @status = status
        super(message)
      end
    end

    class SwarsFormatIncompatible < BaseError
      def initialize(*)
        super(400, "将棋ウォーズ本家のデータ構造が変わってしまいました")
      end
    end

    class SwarsConnectionFailed < BaseError
      def initialize(status = nil, message = nil)
        super(408, "混み合っています<br>しばらくしてからアクセスしてみてください")
      end
    end

    class SwarsUserNotFound < BaseError
      def initialize(status = nil, message = nil)
        super(404, "ウォーズIDが存在しません<br>大文字と小文字を間違えていませんか？")
      end
    end

    class SwarsBattleNotFound < BaseError
      def initialize(status = nil, message = nil)
        super(404, "指定の対局が存在しません<br>URLを間違えていませんか？")
      end
    end

    class Base
      # AGENT_TYPE = :faraday     # faraday or curl

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

        # # 2020-05-30
        # # --insecure をつけないと動作しない
        # # https://qiita.com/shimpeiws/items/10e2b150c6ff41d69013
        # def curl_command(url)
        #   [
        #     "curl",
        #     "-H 'authority: shogiwars.heroz.jp'",
        #     "-H 'pragma: no-cache'",
        #     "-H 'cache-control: no-cache'",
        #     "-H 'upgrade-insecure-requests: 1'",
        #     "-H 'user-agent: #{USER_AGENT}'",
        #     "-H 'accept: text/html'",
        #     "-H 'accept-encoding: gzip, deflate, br'",
        #     "-H 'accept-language: ja'",
        #     "-H 'cookie: #{Rails.application.credentials.swars_agent_cookie}'",
        #     "--silent",
        #     "--compressed",
        #     "--insecure",
        #     "'#{BASE_URL}#{url}'",
        #   ].join(" ")
        # end

        def html_fetch(url)
          begin
            # case AGENT_TYPE
            # when :faraday
            resp = agent.get(url)
            if resp.success?
              resp.body
            end
            # when :curl
            #   `#{curl_command(url)}`
            # end
          rescue Faraday::ConnectionFailed => error
            # SystemMailer.notify_exception(error)
            raise SwarsConnectionFailed
          end
        end
      end

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

      def html_fetch(name, url)
        if params[:SwarsConnectionFailed]
          raise SwarsConnectionFailed
        end
        if run_remote?
          self.class.html_fetch(url)
        else
          mock_html(name)
        end
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
        html = html_fetch("index", url)
        if false
          # ウォーズIDのスペルミスは頻繁に起きる
          # そのとき例外を出すとエラーページまで飛んでしまう
          # そのためユーザーはスペルミスを修正することができない
          if !html || params[:SwarsUserNotFound]
            raise SwarsUserNotFound
          end
        else
          if params[:SwarsUserNotFound]
            html = ""
          end
          html ||= ""
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

        html = html_fetch("show", url)
        if !html || params[:SwarsBattleNotFound]
          raise SwarsBattleNotFound
        end
        md = html.match(/data-react-props="(.*?)"/)
        md or raise SwarsFormatIncompatible
        # if params[:SwarsFormatIncompatible]
        #   raise SwarsFormatIncompatible
        # end
        props = JSON.parse(CGI.unescapeHTML(md.captures.first))
        if params[:show_props]
          pp props
        end

        game_hash = props["gameHash"]

        info[:rule_key] = game_hash["gtype"]

        # xmode 通常/友対
        info[:xmode_magic_number] = game_hash["opponent_type"]

        # 手合割
        info[:preset_magic_number] = game_hash["handicap"]

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
  # p Swars::Agent::Record.fetch(run_remote: true, key: "patrick0169-Shogochandrsu-20210612_060155")[:csa_seq]
  p Swars::Agent::Record.fetch(run_remote: true, key: "kinakom0chi-masauta-20220411_211436")[:xmode_magic_number]
  p Swars::Agent::Record.fetch(run_remote: true, key: "kinakom0chi-dondonh3-20220401_222404")[:xmode_magic_number]
  p Swars::Agent::Record.fetch(run_remote: true, key: "kinakom0chi-mosangun-20220402_214610")[:xmode_magic_number]
  p Swars::Agent::Record.fetch(run_remote: true, key: "kinakom0chi-yukky1119-20220402_210314")[:xmode_magic_number]
  p Swars::Agent::Record.fetch(run_remote: true, key: "chrono_-Ito_Shingo-20220112_000134")[:xmode_magic_number]
end

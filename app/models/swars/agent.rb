# -*- frozen_string_literal: true -*-

if $0 == __FILE__
  require File.expand_path('../../../../config/environment', __FILE__)
end

module Swars
  module Agent
    class Base
      BASE_URL   = "https://shogiwars.heroz.jp"
      USER_AGENT = "Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.163 Mobile Safari/537.36"

      class << self
        def agent
          @agent ||= Faraday.new(url: BASE_URL) do |conn|
            if Rails.env.development?
              conn.response :logger
            end
            conn.use FaradayMiddleware::Instrumentation # config/initializers/0260_faraday_logger.rb
            conn.headers[:user_agent] = USER_AGENT
            conn.headers[:cookie] = Rails.application.credentials.swars_agent_cookie
          end
        end
      end

      delegate :agent, to: "self.class"

      def initialize(options = {})
        @options = {
          run_remote: false,
        }.merge(options)
      end

      def run_remote?
        if Rails.env.test?
          return false
        end

        @options[:run_remote] || (ENV["RUN_REMOTE"] == "true") || Rails.env.production? || Rails.env.staging?
      end

      def mock_html(name)
        Pathname(File.dirname(__FILE__)).join("mock_html/#{name}.html").read
      end
    end

    class Index < Base
      cattr_accessor(:items_per_page) { 10 }

      def fetch(params = {})
        params = {
          gtype: "",    # 空:10分 sb:3分 s1:10秒
          user_key: nil,
          page_index: 0,
        }.merge(params)

        q = {
          gtype: params[:gtype],
          user_id: params[:user_key],
        }

        if v = params[:page_index]
          if v.nonzero?
            q[:page] = v.next
          end
        end

        url = "/games/history?#{q.to_query}"
        if @options[:verbose]
          tp url
        end
        if run_remote?
          html = agent.get(url).body
        else
          html = mock_html("index")
        end

        doc = Nokogiri.HTML(html)
        doc.search(".contents").collect { |elem|
          if md = elem.to_s.match(/game_id=([\w-]+)/)
            { key: md.captures.first }
          end
        }.compact
      end
    end

    class Record < Base
      def fetch(key)
        info = { key: key }

        url = battle_key_to_url(key)
        
        url_info = battle_key_split(key)
        info[:battled_at] = url_info[:battled_at]

        if @options[:verbose]
          tp info[:url]
        end

        if run_remote?
          str = agent.get(url).body
        else
          str = mock_html("show")
        end

        doc = Nokogiri::HTML(str)
        elem = doc.at("//div[@data-react-props]")
        props = JSON.parse(elem["data-react-props"], symbolize_names: true)
        if @options[:show_props]
          pp props
        end

        game_hash = props[:gameHash]

        info[:rule_key] = game_hash[:gtype]

        # 手合割
        info[:preset_dirty_code] = game_hash[:handicap]

        # 詰み・投了・切断などの結果がわかるキー(対局中はキーがない)
        if game_hash[:result]
          info[:__final_key] = game_hash[:result]

          info[:user_infos] = [
            { user_key: url_info[:black], grade_key: signed_number_to_grade_key(game_hash[:sente_dan]), },
            { user_key: url_info[:white], grade_key: signed_number_to_grade_key(game_hash[:gote_dan]),  },
          ]

          # moves がない場合がある
          if game_hash[:moves]
            # CSA形式の棋譜
            # 開始直後に切断している場合は空文字列になる
            # だから空ではないチェックをしてはいけない
            info[:csa_seq] = game_hash[:moves].collect { |e| [e[:m], e[:t]] }

            # 対局完了
            info[:fetch_successed] = true
          end
        end

        info
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

      # xxx -> /games/xxx
      def battle_key_to_url(key)
        "/games/#{key}"
      end

      def battle_key_split(key)
        [:black, :white, :battled_at].zip(key.split("-")).to_h
      end
    end
  end
end

if $0 == __FILE__
  tp Swars::Agent::Index.new(run_remote: false).fetch(gtype: "",   user_key: "kinakom0chi", page_index: 0)
  tp Swars::Agent::Index.new(run_remote: false).fetch(gtype: "sb", user_key: "kinakom0chi", page_index: 0)
  tp Swars::Agent::Index.new(run_remote: false).fetch(gtype: "s1", user_key: "kinakom0chi", page_index: 0)
  tp Swars::Agent::Record.new(run_remote: false).fetch("GRAN0215-kinakom0chi-20200411_195834")
end
# >> |--------------------------------------|
# >> | key                                  |
# >> |--------------------------------------|
# >> | devuser1-Yamada_Taro-20200101_123401 |
# >> | devuser2-Yamada_Taro-20200101_123402 |
# >> | devuser3-Yamada_Taro-20200101_123403 |
# >> |--------------------------------------|
# >> |--------------------------------------|
# >> | key                                  |
# >> |--------------------------------------|
# >> | devuser1-Yamada_Taro-20200101_123401 |
# >> | devuser2-Yamada_Taro-20200101_123402 |
# >> | devuser3-Yamada_Taro-20200101_123403 |
# >> |--------------------------------------|
# >> |--------------------------------------|
# >> | key                                  |
# >> |--------------------------------------|
# >> | devuser1-Yamada_Taro-20200101_123401 |
# >> | devuser2-Yamada_Taro-20200101_123402 |
# >> | devuser3-Yamada_Taro-20200101_123403 |
# >> |--------------------------------------|
# >> |-------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> |               key | GRAN0215-kinakom0chi-20200411_195834                                                                                                                                                                                                                                |
# >> |        battled_at | 20200411_195834                                                                                                                                                                                                                                                     |
# >> |          rule_key |                                                                                                                                                                                                                                                                     |
# >> | preset_dirty_code | 0                                                                                                                                                                                                                                                                   |
# >> |       __final_key | SENTE_WIN_TORYO                                                                                                                                                                                                                                                     |
# >> |        user_infos | [{:user_key=>"GRAN0215", :grade_key=>"三段"}, {:user_key=>"kinakom0chi", :grade_key=>"四段"}]                                                                                                                                                                       |
# >> |           csa_seq | [["+5756FU", 600], ["-8384FU", 599], ["+7776FU", 598], ["-8485FU", 598], ["+8877KA", 597], ["-6152KI", 597], ["+2858HI", 595], ["-7162GI", 588], ["+7968GI", 594], ["-5142OU", 588], ["+6857GI", 593], ["-4232OU", 586], ["+5948OU", 592], ["-1314FU", 579], ["+... |
# >> |   fetch_successed | true                                                                                                                                                                                                                                                                |
# >> |-------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|

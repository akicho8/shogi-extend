if $0 == __FILE__
  require File.expand_path('../../../../config/environment', __FILE__)
end

module Swars
  class Agent
    cattr_accessor(:items_per_page) { 10 }

    def initialize(**options)
      @options = {
        run_remote: false,
      }.merge(options)
    end

    concerning :HistoryGetMethods do
      def index_get(**params)
        params = {
          gtype: "",    # 空:10分 sb:3分 s1:10秒
          user_key: nil,
          page_index: 0,
        }.merge(params)

        if run_remote?
          q = {
            gtype: params[:gtype],
            # locale: "ja",
          }

          # if params[:page_index].nonzero?
          #   q[:start] = params[:page_index] * 10
          # end

          if params[:page_index].nonzero?
            q[:page] = params[:page_index].next
          end

          # url = "https://shogiwars.heroz.jp/users/history/#{params[:user_key]}?#{q.to_query}"
          # page = agent.get(url)
          # js_str = page.body

          url = "https://shogiwars.heroz.jp/games/history?user_id=#{params[:user_key]}&#{q.to_query}"
          command = "curl --silent '#{url}' -H 'authority: shogiwars.heroz.jp' -H 'pragma: no-cache' -H 'cache-control: no-cache' -H 'upgrade-insecure-requests: 1' -H 'user-agent: Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.3578.98 Mobile Safari/537.36' -H 'accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8' -H 'accept-encoding: gzip, deflate, br' -H 'accept-language: ja,en-US;q=0.9,en;q=0.8,zh-CN;q=0.7,zh;q=0.6,zh-TW;q=0.5' -H '#{Rails.application.credentials.cookie_for_agent}' --compressed"
          # puts command
          js_str = `#{command}`
        else
          js_str = local_html("https___shogiwars_heroz_jp_users_history_hanairobiyori_gtype_sb_locale_ja")
        end

        # $().html("xxx") となっているので xxx の部分を取り出して Nokogiri が解釈できる程度に整える
        # puts js_str

        if md = js_str.match(/html\("(.*)"\)/)
          str = too_escaped_html_normalize(md.captures.first)
        else
          # puts js_str
          str = js_str
        end

        doc = Nokogiri.HTML(str)
        doc.search(".contents").collect { |elem|
          row = {}

          # href = elem.at("a[href*=games]").attr(:href)
          # row[:key] = battle_key_from_url("http:#{href}")

          md = elem.to_s.match(/game_id=([\w-]+)/)
          unless md
            next
          end

          row[:key] = md.captures.first
          # puts elem.to_s.match(/kif-pona.heroz.jp/games/masaya0918a-naga2168-20190108_013313/)

          # md = elem.to_s.match(/appAnalysis\('(.*?)'\)/)
          # row[:key] = md.captures.first

          # if row[:key] == "Takechan831-Ito_Asuka-20190111_223848"
          #   puts elem.to_s
          # end

          # key から行けるページで次の情報もとれるのでここで取得しなくてもいい
          # と思ったが、指定の段位以上の人だけ取り込みたいとき、対局ページにGETする前に判断することができるので取っといた方がいい
          if true
            row[:user_infos] = elem.search(".history_prof").collect do |e|
              [:user_key, :grade_key].zip(e.inner_text.scan(/\S+/)).to_h
            end
          end

          if row[:user_infos].blank?
            row[:user_infos] = elem.text.scan(/(\w+)\p{blank}+(.*?[級段])/).collect do |e|
              [:user_key, :grade_key].zip(e).to_h
            end
          end

          row
        }.compact
      end

      private

      # 二重にエスケープされているJSのコンテンツとしてのHTMLを復元
      def too_escaped_html_normalize(html)
        html = html.remove("\\n")
        html = html.gsub("\\\"", '"')
        html = html.gsub("\\/", '/')
        html = html.gsub(/>\s*</m, '><')
      end

      # http://kif-pona.heroz.jp/games/xxx?locale=ja -> xxx
      def battle_key_from_url(url)
        url.remove(/.*games\//, /\?.*/)
      end
    end

    concerning :RecordGetMethods do
      def record_get(key)
        info = {
          key: key,
        }

        info[:url] = battle_key_to_url(key)
        url_info = [:black, :white, :battled_at].zip(key.split("-")).to_h
        info[:battled_at] = url_info[:battled_at]

        if run_remote?
          page = agent.get(info[:url])
          str = page.body
        else
          str = local_html("http___kif_pona_heroz_jp_games_hanairobiyori_ispt_20171104_220810_locale_ja")
        end

        if md = str.match(/handicap\s*=\s*(\d+)/)
          info[:preset_dirty_code] = md.captures.first
        end

        if md = str.match(/\b(?:receiveMove)\("(?<__csa_data>.*)"\)/)
          # 級位が文字化けするので
          str = str.toutf8

          # var gamedata = {...} の内容を拝借
          info[:gamedata] = str.scan(/^\s*(\w+):\s*"(.*)"/).to_h.symbolize_keys

          # key から先手後手はわかり、gamedataからそれぞれの段位がわかる
          info[:user_infos] = [
            {user_key: url_info[:black], grade_key: info[:gamedata][:dan0]},
            {user_key: url_info[:white], grade_key: info[:gamedata][:dan1]},
          ]

          # 詰み・投了・切断などの結果がわかるキー
          info[:__final_key] = md[:__csa_data].slice(/\w+$/)

          # CSA形式の棋譜
          # 開始直後に切断している場合は空文字列になる
          # だから空ではないチェックをしてはいけない
          info[:csa_seq] = md[:__csa_data].scan(/([+-]\d{4}[A-Z]{2}),L(\d+)/).collect do |v, rest_sec|
            [v, rest_sec.to_i]
          end

          # 対局完了？
          info[:st_done] = true
        end

        info
      end

      private

      # xxx -> http://kif-pona.heroz.jp/games/xxx?locale=ja
      def battle_key_to_url(key)
        "http://kif-pona.heroz.jp/games/#{key}?locale=ja"
      end
    end

    concerning :LegendSwarsUserKeysMethods do
      # 騎士団フェスのときは何もとれない
      def legend_user_keys(**params)
        if run_remote?
          str = agent.get("https://shogiwars.heroz.jp/?locale=en").body
        else
          str = local_html("https_shogiwars_heroz_jp_locale_en")
        end
        str.scan(%r{shogiwars.heroz.jp/users/(\w+)}).flatten.uniq
      end
    end

    def agent
      @agent ||= Mechanize.new.tap do |e|
        e.log = Rails.logger
        # e.user_agent_alias = Mechanize::AGENT_ALIASES.keys.grep_v(/\b(Mechanize|Linux|Mac)\b/i).sample
        e.user_agent_alias = 'iPhone'
      end
    end

    def run_remote?
      @options[:run_remote] || (ENV["RUN_REMOTE"] == "1") || Rails.env.production?
    end

    def local_html(key)
      Pathname("#{File.dirname(__FILE__)}/html/#{key}.html").read
    end
  end

  if $0 == __FILE__
    tp Agent.new(run_remote: true).index_get(gtype: "",  user_key: "chrono_", page_index: 0)
    tp Agent.new(run_remote: true).index_get(gtype: "",  user_key: "chrono_", page_index: 1)

    # tp Agent.new(run_remote: true).index_get(gtype: "",  user_key: "Ito_Asuka")
    # tp Agent.new(run_remote: false).record_get("MinoriChihara-Ito_Asuka-20190111_084942")

    # tp Agent.new(run_remote: true).record_get("MinoriChihara-Ito_Asuka-20190111_084942")
    exit

    # tp Agent.new(run_remote: true).index_get(gtype: "",  user_key: "kinakom0chi")
    # tp Agent.new(run_remote: true).index_get(gtype: "",  user_key: "masaya0918a")

    # tp Agent.new.legend_user_keys
    # tp Agent.new.index_get(gtype: "",  user_key: "Apery8")
    # tp Agent.new.index_get(gtype: "",  user_key: "Apery8", page_index: 1)
    #
    # # tp Agent.new.index_get(gtype: "sb",  user_key: "Apery8")
    # # tp Agent.new.index_get(gtype: "s1",  user_key: "Apery8")

    # tp Agent.new.record_get("hanairobiyori-ispt-20171104_220810")

    # tp Agent.new.record_get("masaya0918a-kinakom0chi-20190108_012942")

    # |--------------------------------------------+----------------------------------------------------------------------------------------------------|
    # | key                                 | user_infos                                                                                    |
    # |--------------------------------------------+----------------------------------------------------------------------------------------------------|
    # | hanairobiyori-ispt-20171104_220810         | [{:user_key=>"hanairobiyori", :grade_key=>"27級"}, {:user_key=>"ispt", :grade_key=>"3級"}]         |
    # | anklesam-hanairobiyori-20171104_220223     | [{:user_key=>"anklesam", :grade_key=>"2級"}, {:user_key=>"hanairobiyori", :grade_key=>"27級"}]     |
    # | komakoma1213-hanairobiyori-20171104_215841 | [{:user_key=>"komakoma1213", :grade_key=>"5級"}, {:user_key=>"hanairobiyori", :grade_key=>"28級"}] |
    # | hanairobiyori-mizumakura-20171104_215208   | [{:user_key=>"hanairobiyori", :grade_key=>"28級"}, {:user_key=>"mizumakura", :grade_key=>"3級"}]   |
    # | baldbull-hanairobiyori-20171104_213234     | [{:user_key=>"baldbull", :grade_key=>"3級"}, {:user_key=>"hanairobiyori", :grade_key=>"28級"}]     |
    # | hanairobiyori-chihaya_3-20171104_212752    | [{:user_key=>"hanairobiyori", :grade_key=>"28級"}, {:user_key=>"chihaya_3", :grade_key=>"2級"}]    |
    # | hanairobiyori-kazuruisena-20171104_212234  | [{:user_key=>"hanairobiyori", :grade_key=>"28級"}, {:user_key=>"kazuruisena", :grade_key=>"22級"}] |
    # | hanairobiyori-kanposs-20171104_211903      | [{:user_key=>"hanairobiyori", :grade_key=>"29級"}, {:user_key=>"kanposs", :grade_key=>"4級"}]      |
    # | hanairobiyori-Yuki1290-20171104_211225     | [{:user_key=>"hanairobiyori", :grade_key=>"29級"}, {:user_key=>"Yuki1290", :grade_key=>"2級"}]     |
    # | 9271-hanairobiyori-20171026_103138         | [{:user_key=>"9271", :grade_key=>"1級"}, {:user_key=>"hanairobiyori", :grade_key=>"29級"}]         |
    # |--------------------------------------------+----------------------------------------------------------------------------------------------------|
    # |-----------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
    # |      key | hanairobiyori-ispt-20171104_220810                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
    # |             url | http://kif-pona.heroz.jp/games/hanairobiyori-ispt-20171104_220810?locale=ja                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
    # |      battled_at | 20171104_220810                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
    # |        gamedata | {:name=>"hanairobiyori-ispt-20171104_220810", :avatar0=>"_e1708s4c", :avatar1=>"mc8", :dan0=>"27級", :dan1=>"3級", :gtype=>"sb"}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
    # | user_infos | [{:user_key=>"hanairobiyori", :grade_key=>"27級"}, {:user_key=>"ispt", :grade_key=>"3級"}]                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
    # |  __final_key | SENTE_WIN_TIMEOUT                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
    # |       csa_seq | [["+7968GI", 179], ["-3334FU", 180], ["+5756FU", 178], ["-4132KI", 177], ["+6857GI", 177], ["-1314FU", 176], ["+1716FU", 175], ["-8384FU", 175], ["+8879KA", 174], ["-8485FU", 174], ["+6978KI", 173], ["-3142GI", 173], ["+3948GI", 171], ["-4233GI", 172], ["+2726FU", 170], ["-5152OU", 171], ["+2625FU", 169], ["-2231KA", 170], ["+5969OU", 168], ["-3142KA", 170], ["+3736FU", 167], ["-7162GI", 169], ["+5746GI", 166], ["-6172KI", 166], ["+3635FU", 162], ["-3435FU", 164], ["+4635GI", 161], ["-0034FU", 163], ["+2524FU", 160], ["-2324FU", 162], ["+3524GI", 159], ["-3324GI", 162], ["+7924KA", 158], ["-4224KA", 161], ["+2824HI", 156], ["-0023FU", 155], ["+2428HI", 154], ["-8586FU", 149], ["+8786FU", 153], ["-8286HI", 147], ["+0087FU", 147], ["-8656HI", 146], ["+0057GI", 145], ["-5636HI", 141], ["+0037FU", 142], ["-3635HI", 139], ["+5746GI", 132], ["-3585HI", 135], ["+3736FU", 128], ["-0033GI", 130], ["+0068KA", 124], ["-5354FU", 125], ["+3635FU", 121], ["-3435FU", 124], ["+4635GI", 121], ["-0034FU", 120], ["+0024FU", 119], ["-2324FU", 117], ["+3524GI", 118], ["-3324GI", 116], ["+6824KA", 117], ["-0023FU", 113], ["+2468KA", 114], ["-0033GI", 109], ["+4958KI", 113], ["-9394FU", 107], ["+9796FU", 111], ["-6253GI", 100], ["+6979OU", 108], ["-5344GI", 99], ["+4857GI", 104], ["-4435GI", 97], ["+5746GI", 102], ["-3546GI", 95], ["+6846KA", 101], ["-0039KA", 93], ["+2818HI", 92], ["-3975UM", 83], ["+0076GI", 89], ["-7576UM", 81], ["+7776FU", 89], ["-0055GI", 78], ["+4668KA", 86], ["-8582HI", 72], ["+7988OU", 82], ["-0027GI", 70], ["+1848HI", 80], ["-2736NG", 66], ["+0037FU", 78], ["-3627NG", 64], ["+4849HI", 77], ["-2738NG", 61], ["+4979HI", 75], ["-5556GI", 57], ["+0057FU", 73], ["-5645GI", 56], ["+0077GI", 67], ["-3435FU", 54], ["+6766FU", 66], ["-3536FU", 53], ["+3736FU", 64], ["-4536GI", 52], ["+0037FU", 62], ["-3627NG", 50], ["+5756FU", 61], ["-2728NG", 48], ["+5867KI", 60], ["-3829NG", 47], ["+3736FU", 59], ["-2919NG", 46], ["+6846KA", 59], ["-0044KY", 42], ["+4628KA", 57], ["-1918NG", 40], ["+2839KA", 53], ["-4447NY", 38], ["+7949HI", 47], ["-4737NY", 35], ["+0048GI", 44], ["-3738NY", 34], ["+4959HI", 40], ["-3839NY", 33], ["+4839GI", 39], ["-0037KA", 31], ["+5979HI", 37], ["-3726UM", 29], ["+7768GI", 34], ["-1817NG", 28], ["+3938GI", 32], ["-2636UM", 27], ["+3849GI", 31], ["-0037FU", 25], ["+0048KY", 28], ["-1727NG", 24], ["+0047KA", 26], ["-3635UM", 22], ["+4758KA", 25], ["-3738TO", 20], ["+4847KY", 24], ["-3849TO", 18], ["+5849KA", 23], ["-2737NG", 18], ["+4958KA", 22], ["-0038FU", 17], ["+5869KA", 21], ["-3839TO", 16], ["+6857GI", 20], ["-3536UM", 13], ["+5746GI", 19], ["-3747NG", 12], ["+4657GI", 18], ["-3949TO", 9], ["+5768GI", 16], ["-4948TO", 7], ["+6877GI", 14], ["-0046KE", 6], ["+6947KA", 13], ["-3647UM", 5], ["+7919HI", 12], ["-4858TO", 4], ["+0079GI", 10], ["-5857TO", 3], ["+8898OU", 9], ["-5767TO", 2], ["+7867KI", 8], ["-4658NK", 1], ["+7788GI", 7]] |
    # |     st_done | true                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
    # |-----------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
  end
end
# >> |-------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> |               key | MinoriChihara-Ito_Asuka-20190111_084942                                                                                                                                                                                                                             |
# >> |               url | http://kif-pona.heroz.jp/games/MinoriChihara-Ito_Asuka-20190111_084942?locale=ja                                                                                                                                                                                    |
# >> |        battled_at | 20190111_084942                                                                                                                                                                                                                                                     |
# >> | preset_dirty_code | 5                                                                                                                                                                                                                                                                   |
# >> |          gamedata | {:name=>"hanairobiyori-Ito_Asuka-20190111_084942", :avatar0=>"_e1812s10c", :avatar1=>"coach04", :dan0=>"2級", :dan1=>"十段", :gtype=>""}                                                                                                                            |
# >> |        user_infos | [{:user_key=>"MinoriChihara", :grade_key=>"2級"}, {:user_key=>"Ito_Asuka", :grade_key=>"十段"}]                                                                                                                                                                     |
# >> |       __final_key | GOTE_WIN_TORYO                                                                                                                                                                                                                                                      |
# >> |           csa_seq | [["-7162GI", 599], ["+2726FU", 597], ["-4132KI", 598], ["+6978KI", 590], ["-5354FU", 596], ["+3948GI", 588], ["-6253GI", 595], ["+9796FU", 582], ["-9394FU", 594], ["+7776FU", 568], ["-4344FU", 592], ["+7968GI", 563], ["-5162OU", 589], ["+6877GI", 552], ["-... |
# >> |           st_done | true                                                                                                                                                                                                                                                                |
# >> |-------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|

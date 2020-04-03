# -*- frozen_string_literal: true -*-

if $0 == __FILE__
  require File.expand_path('../../../../config/environment', __FILE__)
end

module Swars
  class Agent
    cattr_accessor(:items_per_page) { 10 }

    def initialize(options = {})
      @options = {
        run_remote: false,
      }.merge(options)
    end

    concerning :HistoryGetMethods do
      def index_get(params = {})
        params = {
          gtype: "",    # 空:10分 sb:3分 s1:10秒
          user_key: nil,
          page_index: 0,
          grade_get_on_inex: false,
        }.merge(params)

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
        if @options[:verbose]
          tp url
        end

        if run_remote?
          # puts command
          js_str = `#{command}`
        else
          js_str = local_html("https___shogiwars_heroz_jp_users_history_devuser1_gtype_sb_locale_ja")
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
          # puts elem.to_s.match(/shogiwars.heroz.jp/games/masaya0918a-naga2168-20190108_013313/)

          # md = elem.to_s.match(/appAnalysis\('(.*?)'\)/)
          # row[:key] = md.captures.first

          # if row[:key] == "Takechan831-Yamada_Taro-20190111_223848"
          #   puts elem.to_s
          # end

          # key から行けるページで次の情報もとれるのでここで取得しなくてもいい
          # と思ったが、指定の段位以上の人だけ取り込みたいとき、対局ページにGETする前に判断することができるので取っといた方がいい
          if @options[:grade_get_on_inex]
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

      # https://shogiwars.heroz.jp/games/xxx?locale=ja -> xxx
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

        if @options[:verbose]
          tp info[:url]
        end

        if run_remote?
          page = agent.get(info[:url])
          str = page.body
        else
          str = local_html("show")
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

          # :moves がない場合がある
          if game_hash[:moves]
            # CSA形式の棋譜
            # 開始直後に切断している場合は空文字列になる
            # だから空ではないチェックをしてはいけない
            info[:csa_seq] = game_hash[:moves].collect { |e| [e[:m], e[:t]] }

            # 対局完了？
            info[:st_done] = true
          end
        end

        info
      end

      private

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

      # xxx -> https://shogiwars.heroz.jp/games/xxx?locale=ja
      def battle_key_to_url(key)
        # "https://shogiwars.heroz.jp/games/#{key}?locale=ja"
        # "https://shogiwars.heroz.jp/games/myasuMan-chrono_-20200116_232605"
        "https://shogiwars.heroz.jp/games/#{key}?locale=ja"
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
      if Rails.env.test?
        return false
      end

      @options[:run_remote] || (ENV["RUN_REMOTE"] == "1") || Rails.env.production? || Rails.env.staging?
    end

    def local_html(key)
      Pathname("#{File.dirname(__FILE__)}/html/#{key}.html").read
    end
  end

  if $0 == __FILE__
    # tp Agent.new(run_remote: true).index_get(gtype: "",  user_key: "chrono_", page_index: 0)
    tp Agent.new(run_remote: true).index_get(gtype: "sb",  user_key: "micro77", page_index: 0)

    # tp Agent.new(run_remote: true).index_get(gtype: "sb",  user_key: "chrono_", page_index: 0)
    # tp Agent.new(run_remote: true).index_get(gtype: "",  user_key: "chrono_", page_index: 1)

    # tp Agent.new(run_remote: true).index_get(gtype: "",  user_key: "Yamada_Taro")

    # tp Agent.new(run_remote: true).record_get("myasuMan-chrono_-20200116_232605")
    # tp Agent.new(run_remote: true).record_get("kkkkkfff-kinakom0chi-20191229_211058")

    #  tp Agent.new(run_remote: true, show_props: true).record_get("YuriCitrus-itoshinTV-20200115_152807")

    # tp Agent.new(run_remote: true).record_get("JUST_TAP_OUT-Aeterna7-20200117_114139")

    # tp Agent.new(run_remote: true).record_get("MinoriChihara-Yamada_Taro-20190111_084942")
    exit

    # tp Agent.new(run_remote: true).index_get(gtype: "",  user_key: "kinakom0chi")
    # tp Agent.new(run_remote: true).index_get(gtype: "",  user_key: "masaya0918a")

    # tp Agent.new.index_get(gtype: "",  user_key: "Apery8")
    # tp Agent.new.index_get(gtype: "",  user_key: "Apery8", page_index: 1)
    #
    # # tp Agent.new.index_get(gtype: "sb",  user_key: "Apery8")
    # # tp Agent.new.index_get(gtype: "s1",  user_key: "Apery8")

    # tp Agent.new.record_get("devuser1-ispt-20171104_220810")

    # tp Agent.new.record_get("masaya0918a-kinakom0chi-20190108_012942")

    # |--------------------------------------------+----------------------------------------------------------------------------------------------------|
    # | key                                 | user_infos                                                                                    |
    # |--------------------------------------------+----------------------------------------------------------------------------------------------------|
    # | devuser1-ispt-20171104_220810         | [{:user_key=>"devuser1", :grade_key=>"27級"}, {:user_key=>"ispt", :grade_key=>"3級"}]         |
    # | anklesam-devuser1-20171104_220223     | [{:user_key=>"anklesam", :grade_key=>"2級"}, {:user_key=>"devuser1", :grade_key=>"27級"}]     |
    # | komakoma1213-devuser1-20171104_215841 | [{:user_key=>"komakoma1213", :grade_key=>"5級"}, {:user_key=>"devuser1", :grade_key=>"28級"}] |
    # | devuser1-mizumakura-20171104_215208   | [{:user_key=>"devuser1", :grade_key=>"28級"}, {:user_key=>"mizumakura", :grade_key=>"3級"}]   |
    # | baldbull-devuser1-20171104_213234     | [{:user_key=>"baldbull", :grade_key=>"3級"}, {:user_key=>"devuser1", :grade_key=>"28級"}]     |
    # | devuser1-chihaya_3-20171104_212752    | [{:user_key=>"devuser1", :grade_key=>"28級"}, {:user_key=>"chihaya_3", :grade_key=>"2級"}]    |
    # | devuser1-kazuruisena-20171104_212234  | [{:user_key=>"devuser1", :grade_key=>"28級"}, {:user_key=>"kazuruisena", :grade_key=>"22級"}] |
    # | devuser1-kanposs-20171104_211903      | [{:user_key=>"devuser1", :grade_key=>"29級"}, {:user_key=>"kanposs", :grade_key=>"4級"}]      |
    # | devuser1-Yuki1290-20171104_211225     | [{:user_key=>"devuser1", :grade_key=>"29級"}, {:user_key=>"Yuki1290", :grade_key=>"2級"}]     |
    # | 9271-devuser1-20171026_103138         | [{:user_key=>"9271", :grade_key=>"1級"}, {:user_key=>"devuser1", :grade_key=>"29級"}]         |
    # |--------------------------------------------+----------------------------------------------------------------------------------------------------|
    # |-----------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
    # |      key | devuser1-ispt-20171104_220810                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
    # |             url | https://shogiwars.heroz.jp/games/devuser1-ispt-20171104_220810?locale=ja                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
    # |      battled_at | 20171104_220810                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
    # |        __gamedata | {:name=>"devuser1-ispt-20171104_220810", :avatar0=>"_e1708s4c", :avatar1=>"mc8", :dan0=>"27級", :dan1=>"3級", :gtype=>"sb"}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
    # | user_infos | [{:user_key=>"devuser1", :grade_key=>"27級"}, {:user_key=>"ispt", :grade_key=>"3級"}]                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
    # |  __final_key | SENTE_WIN_TIMEOUT                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
    # |       csa_seq | [["+7968GI", 179], ["-3334FU", 180], ["+5756FU", 178], ["-4132KI", 177], ["+6857GI", 177], ["-1314FU", 176], ["+1716FU", 175], ["-8384FU", 175], ["+8879KA", 174], ["-8485FU", 174], ["+6978KI", 173], ["-3142GI", 173], ["+3948GI", 171], ["-4233GI", 172], ["+2726FU", 170], ["-5152OU", 171], ["+2625FU", 169], ["-2231KA", 170], ["+5969OU", 168], ["-3142KA", 170], ["+3736FU", 167], ["-7162GI", 169], ["+5746GI", 166], ["-6172KI", 166], ["+3635FU", 162], ["-3435FU", 164], ["+4635GI", 161], ["-0034FU", 163], ["+2524FU", 160], ["-2324FU", 162], ["+3524GI", 159], ["-3324GI", 162], ["+7924KA", 158], ["-4224KA", 161], ["+2824HI", 156], ["-0023FU", 155], ["+2428HI", 154], ["-8586FU", 149], ["+8786FU", 153], ["-8286HI", 147], ["+0087FU", 147], ["-8656HI", 146], ["+0057GI", 145], ["-5636HI", 141], ["+0037FU", 142], ["-3635HI", 139], ["+5746GI", 132], ["-3585HI", 135], ["+3736FU", 128], ["-0033GI", 130], ["+0068KA", 124], ["-5354FU", 125], ["+3635FU", 121], ["-3435FU", 124], ["+4635GI", 121], ["-0034FU", 120], ["+0024FU", 119], ["-2324FU", 117], ["+3524GI", 118], ["-3324GI", 116], ["+6824KA", 117], ["-0023FU", 113], ["+2468KA", 114], ["-0033GI", 109], ["+4958KI", 113], ["-9394FU", 107], ["+9796FU", 111], ["-6253GI", 100], ["+6979OU", 108], ["-5344GI", 99], ["+4857GI", 104], ["-4435GI", 97], ["+5746GI", 102], ["-3546GI", 95], ["+6846KA", 101], ["-0039KA", 93], ["+2818HI", 92], ["-3975UM", 83], ["+0076GI", 89], ["-7576UM", 81], ["+7776FU", 89], ["-0055GI", 78], ["+4668KA", 86], ["-8582HI", 72], ["+7988OU", 82], ["-0027GI", 70], ["+1848HI", 80], ["-2736NG", 66], ["+0037FU", 78], ["-3627NG", 64], ["+4849HI", 77], ["-2738NG", 61], ["+4979HI", 75], ["-5556GI", 57], ["+0057FU", 73], ["-5645GI", 56], ["+0077GI", 67], ["-3435FU", 54], ["+6766FU", 66], ["-3536FU", 53], ["+3736FU", 64], ["-4536GI", 52], ["+0037FU", 62], ["-3627NG", 50], ["+5756FU", 61], ["-2728NG", 48], ["+5867KI", 60], ["-3829NG", 47], ["+3736FU", 59], ["-2919NG", 46], ["+6846KA", 59], ["-0044KY", 42], ["+4628KA", 57], ["-1918NG", 40], ["+2839KA", 53], ["-4447NY", 38], ["+7949HI", 47], ["-4737NY", 35], ["+0048GI", 44], ["-3738NY", 34], ["+4959HI", 40], ["-3839NY", 33], ["+4839GI", 39], ["-0037KA", 31], ["+5979HI", 37], ["-3726UM", 29], ["+7768GI", 34], ["-1817NG", 28], ["+3938GI", 32], ["-2636UM", 27], ["+3849GI", 31], ["-0037FU", 25], ["+0048KY", 28], ["-1727NG", 24], ["+0047KA", 26], ["-3635UM", 22], ["+4758KA", 25], ["-3738TO", 20], ["+4847KY", 24], ["-3849TO", 18], ["+5849KA", 23], ["-2737NG", 18], ["+4958KA", 22], ["-0038FU", 17], ["+5869KA", 21], ["-3839TO", 16], ["+6857GI", 20], ["-3536UM", 13], ["+5746GI", 19], ["-3747NG", 12], ["+4657GI", 18], ["-3949TO", 9], ["+5768GI", 16], ["-4948TO", 7], ["+6877GI", 14], ["-0046KE", 6], ["+6947KA", 13], ["-3647UM", 5], ["+7919HI", 12], ["-4858TO", 4], ["+0079GI", 10], ["-5857TO", 3], ["+8898OU", 9], ["-5767TO", 2], ["+7867KI", 8], ["-4658NK", 1], ["+7788GI", 7]] |
    # |     st_done | true                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
    # |-----------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
  end
end
# >> |-----------------------------------------|
# >> | key                                     |
# >> |-----------------------------------------|
# >> | myasuMan-chrono_-20200116_232605        |
# >> | chrono_-Biibaa-20200116_183504          |
# >> | Emotional_music-chrono_-20200116_182436 |
# >> | atmy125-chrono_-20200116_135406         |
# >> | chrono_-aobadai-20200115_173733         |
# >> | chrono_-nibannte-20200115_110615        |
# >> | chrono_-cx100mm-20200114_215541         |
# >> | ksakai100-chrono_-20200114_213559       |
# >> | neru1022-chrono_-20200114_212648        |
# >> | Syoog-chrono_-20200114_190606           |
# >> |-----------------------------------------|
# >> |--------------------------------------|
# >> | key                                  |
# >> |--------------------------------------|
# >> | kiricu-chrono_-20200117_002456       |
# >> | YomeTime-chrono_-20200117_001940     |
# >> | chrono_-kinesis-20200117_001308      |
# >> | chrono_-yakyuu43-20200117_000531     |
# >> | chrono_-sourin-20200116_235945       |
# >> | deppon-chrono_-20200116_235158       |
# >> | chrono_-peso3-20200116_231902        |
# >> | a487603-chrono_-20200116_231245      |
# >> | ahooooahooou-chrono_-20200116_230723 |
# >> | chrono_-HIHUMI-20200116_225950       |
# >> |--------------------------------------|
# >> |-------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> |               key | myasuMan-chrono_-20200116_232605                                                                                                                                                                                                                                    |
# >> |               url | https://shogiwars.heroz.jp/games/myasuMan-chrono_-20200116_232605?locale=ja                                                                                                                                                                                         |
# >> |        battled_at | 20200116_232605                                                                                                                                                                                                                                                     |
# >> | preset_dirty_code | 0                                                                                                                                                                                                                                                                   |
# >> |       __final_key | SENTE_WIN_TORYO                                                                                                                                                                                                                                                     |
# >> |        user_infos | [{:user_key=>"myasuMan", :grade_key=>"三段"}, {:user_key=>"chrono_", :grade_key=>"四段"}]                                                                                                                                                                           |
# >> |           csa_seq | [["+5756FU", 600], ["-8384FU", 599], ["+7776FU", 598], ["-8485FU", 598], ["+8877KA", 597], ["-6152KI", 597], ["+2858HI", 595], ["-7162GI", 588], ["+7968GI", 594], ["-5142OU", 588], ["+6857GI", 593], ["-4232OU", 586], ["+5948OU", 592], ["-1314FU", 579], ["+... |
# >> |           st_done | true                                                                                                                                                                                                                                                                |
# >> |-------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> |-------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> |               key | kkkkkfff-kinakom0chi-20191229_211058                                                                                                                                                                                                                                |
# >> |               url | https://shogiwars.heroz.jp/games/kkkkkfff-kinakom0chi-20191229_211058?locale=ja                                                                                                                                                                                     |
# >> |        battled_at | 20191229_211058                                                                                                                                                                                                                                                     |
# >> | preset_dirty_code | 0                                                                                                                                                                                                                                                                   |
# >> |       __final_key | GOTE_WIN_CHECKMATE                                                                                                                                                                                                                                                  |
# >> |        user_infos | [{:user_key=>"kkkkkfff", :grade_key=>"2級"}, {:user_key=>"kinakom0chi", :grade_key=>"2級"}]                                                                                                                                                                         |
# >> |           csa_seq | [["+7776FU", 599], ["-7162GI", 600], ["+6766FU", 594], ["-1314FU", 597], ["+1716FU", 589], ["-3334FU", 595], ["+7968GI", 585], ["-9394FU", 589], ["+6877GI", 583], ["-9495FU", 584], ["+4958KI", 583], ["-4132KI", 578], ["+2726FU", 582], ["-5141OU", 576], ["+... |
# >> |           st_done | true                                                                                                                                                                                                                                                                |
# >> |-------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|

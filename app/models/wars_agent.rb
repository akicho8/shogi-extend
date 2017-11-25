class WarsAgent
  def initialize(**options)
    @options = {
      mock_use: Rails.env.development? || Rails.env.test?
    }.merge(options)

    if Rails.env.development?
      @options[:mock_use] = true
    end
  end

  concerning :HistoryGetMethods do
    def battle_list_get(**params)
      params = {
        gtype: "",    # 空:10分 sb:3分 s1:10秒
        user_key: nil,
      }.merge(params)

      if @options[:mock_use]
        js_str = Rails.root.join("app/models/https___shogiwars_heroz_jp_users_history_hanairobiyori_gtype_sb_locale_ja.html").read
      else
        url = "https://shogiwars.heroz.jp/users/history/#{params[:user_key]}?gtype=#{params[:gtype]}&locale=ja"
        page = agent.get(url)
        js_str = page.body
      end

      # $().html("xxx") となっているので xxx の部分を取り出して Nokogiri が解釈できる程度に整える
      md = js_str.match(/html\("(.*)"\)/)
      str = too_escaped_html_normalize(md.captures.first)

      doc = Nokogiri.HTML(str)
      doc.search(".contents").collect do |elem|
        row = {}

        href = elem.at("a[href*=games]").attr(:href)
        row[:battle_key] = battle_key_from_url("http:#{href}")

        row[:wars_user_infos] = elem.search(".history_prof").collect do |e|
          [:user_key, :wars_rank].zip(e.inner_text.scan(/\S+/)).to_h
        end

        row
      end
    end

    private

    # エスケープされまくった謎のHTMLを復元
    def too_escaped_html_normalize(html)
      html = html.remove("\\n")
      html = html.gsub("\\\"", '"')
      html = html.gsub("\\/", '/')
      html = html.gsub(/>\s*</m, '><')
    end
  end

  concerning :BattleOneInfoGetMethods do
    def battle_page_get(battle_key)
      info = {
        battle_key: battle_key,
        url: battle_key_to_url(battle_key),
      }

      if @options[:mock_use]
        str = Rails.root.join("app/models/http___kif_pona_heroz_jp_games_hanairobiyori_ispt_20171104_220810_locale_ja.html").read
      else
        page = agent.get(info[:url])
        str = page.body
      end

      if md = str.match(/\b(?:receiveMove)\("(?<csa_data>.*)"\)/)
        # 級位が文字化けするので
        str = str.toutf8

        # var gamedata = {...} の内容を拝借
        info[:gamedata] = str.scan(/^\s*(\w+):\s*"(.*)"/).to_h.symbolize_keys

        # 結果
        info[:kekka_key] = md[:csa_data].slice(/\w+$/)

        # CSA形式の棋譜
        # 開始直後に切断している場合は空文字列になる
        # だから空ではないチェックをしてはいけない
        info[:csa_hands] = md[:csa_data].scan(/([+-]\d{4}[A-Z]{2}),L\d+/).flatten.join(",")

        # 対局完了？
        info[:battle_done] = true
      end

      info
    end
  end

  private

  def agent
    @agent || __agent
  end

  def __agent
    agent = Mechanize.new
    agent.log = Rails.logger
    agent.user_agent_alias = Mechanize::AGENT_ALIASES.keys.grep_v(/\b(Mechanize|Linux|Mac)\b/i).sample
    agent
  end

  # http://kif-pona.heroz.jp/games/xxx?locale=ja -> xxx
  def battle_key_from_url(url)
    url.remove(/.*games\//, /\?.*/)
  end

  # xxx -> http://kif-pona.heroz.jp/games/xxx?locale=ja
  def battle_key_to_url(battle_key)
    "http://kif-pona.heroz.jp/games/#{battle_key}?locale=ja"
  end
end

if $0 == __FILE__
  tp WarsAgent.new.battle_list_get(gtype: "",  user_key: "Apery8")
  # tp WarsAgent.new.battle_list_get(gtype: "sb",  user_key: "Apery8")
  # tp WarsAgent.new.battle_list_get(gtype: "s1",  user_key: "Apery8")
  tp WarsAgent.new.battle_page_get("hanairobiyori-ispt-20171104_220810")

  # |--------------------------------------------+----------------------------------------------------------------------------------------------------|
  # | battle_key                                 | wars_user_infos                                                                                    |
  # |--------------------------------------------+----------------------------------------------------------------------------------------------------|
  # | hanairobiyori-ispt-20171104_220810         | [{:user_key=>"hanairobiyori", :wars_rank=>"27級"}, {:user_key=>"ispt", :wars_rank=>"3級"}]         |
  # | anklesam-hanairobiyori-20171104_220223     | [{:user_key=>"anklesam", :wars_rank=>"2級"}, {:user_key=>"hanairobiyori", :wars_rank=>"27級"}]     |
  # | komakoma1213-hanairobiyori-20171104_215841 | [{:user_key=>"komakoma1213", :wars_rank=>"5級"}, {:user_key=>"hanairobiyori", :wars_rank=>"28級"}] |
  # | hanairobiyori-mizumakura-20171104_215208   | [{:user_key=>"hanairobiyori", :wars_rank=>"28級"}, {:user_key=>"mizumakura", :wars_rank=>"3級"}]   |
  # | baldbull-hanairobiyori-20171104_213234     | [{:user_key=>"baldbull", :wars_rank=>"3級"}, {:user_key=>"hanairobiyori", :wars_rank=>"28級"}]     |
  # | hanairobiyori-chihaya_3-20171104_212752    | [{:user_key=>"hanairobiyori", :wars_rank=>"28級"}, {:user_key=>"chihaya_3", :wars_rank=>"2級"}]    |
  # | hanairobiyori-kazuruisena-20171104_212234  | [{:user_key=>"hanairobiyori", :wars_rank=>"28級"}, {:user_key=>"kazuruisena", :wars_rank=>"22級"}] |
  # | hanairobiyori-kanposs-20171104_211903      | [{:user_key=>"hanairobiyori", :wars_rank=>"29級"}, {:user_key=>"kanposs", :wars_rank=>"4級"}]      |
  # | hanairobiyori-Yuki1290-20171104_211225     | [{:user_key=>"hanairobiyori", :wars_rank=>"29級"}, {:user_key=>"Yuki1290", :wars_rank=>"2級"}]     |
  # | 9271-hanairobiyori-20171026_103138         | [{:user_key=>"9271", :wars_rank=>"1級"}, {:user_key=>"hanairobiyori", :wars_rank=>"29級"}]         |
  # |--------------------------------------------+----------------------------------------------------------------------------------------------------|
  # |-------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
  # |  battle_key | hanairobiyori-ispt-20171104_220810                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
  # |         url | http://kif-pona.heroz.jp/games/hanairobiyori-ispt-20171104_220810?locale=ja                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
  # | battle_done | true                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
  # |    gamedata | {:name=>"hanairobiyori-ispt-20171104_220810", :avatar0=>"_e1708s4c", :avatar1=>"mc8", :dan0=>"27級", :dan1=>"3級", :gtype=>"sb"}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
  # |   kekka_key | SENTE_WIN_TIMEOUT                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
  # |   csa_hands | +7968GI,-3334FU,+5756FU,-4132KI,+6857GI,-1314FU,+1716FU,-8384FU,+8879KA,-8485FU,+6978KI,-3142GI,+3948GI,-4233GI,+2726FU,-5152OU,+2625FU,-2231KA,+5969OU,-3142KA,+3736FU,-7162GI,+5746GI,-6172KI,+3635FU,-3435FU,+4635GI,-0034FU,+2524FU,-2324FU,+3524GI,-3324GI,+7924KA,-4224KA,+2824HI,-0023FU,+2428HI,-8586FU,+8786FU,-8286HI,+0087FU,-8656HI,+0057GI,-5636HI,+0037FU,-3635HI,+5746GI,-3585HI,+3736FU,-0033GI,+0068KA,-5354FU,+3635FU,-3435FU,+4635GI,-0034FU,+0024FU,-2324FU,+3524GI,-3324GI,+6824KA,-0023FU,+2468KA,-0033GI,+4958KI,-9394FU,+9796FU,-6253GI,+6979OU,-5344GI,+4857GI,-4435GI,+5746GI,-3546GI,+6846KA,-0039KA,+2818HI,-3975UM,+0076GI,-7576UM,+7776FU,-0055GI,+4668KA,-8582HI,+7988OU,-0027GI,+1848HI,-2736NG,+0037FU,-3627NG,+4849HI,-2738NG,+4979HI,-5556GI,+0057FU,-5645GI,+0077GI,-3435FU,+6766FU,-3536FU,+3736FU,-4536GI,+0037FU,-3627NG,+5756FU,-2728NG,+5867KI,-3829NG,+3736FU,-2919NG,+6846KA,-0044KY,+4628KA,-1918NG,+2839KA,-4447NY,+7949HI,-4737NY,+0048GI,-3738NY,+4959HI,-3839NY,+4839GI,-0037KA,+5979HI,-3726UM,+7768GI,-1817NG,+3938GI,-2636UM,+3849GI,-0037FU,+0048KY,-1727NG,+0047KA,-3635UM,+4758KA,-3738TO,+4847KY,-3849TO,+5849KA,-2737NG,+4958KA,-0038FU,+5869KA,-3839TO,+6857GI,-3536UM,+5746GI,-3747NG,+4657GI,-3949TO,+5768GI,-4948TO,+6877GI,-0046KE,+6947KA,-3647UM,+7919HI,-4858TO,+0079GI,-5857TO,+8898OU,-5767TO,+7867KI,-4658NK,+7788GI |
  # |-------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
end

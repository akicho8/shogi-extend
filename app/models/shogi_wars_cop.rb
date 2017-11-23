class ShogiWarsCop
  def initialize(**options)
    @options = {
      mock_use: Rails.env.development? || Rails.env.test?
    }.merge(options)
  end

  def battle_list_get(**params)
    params = {
      gtype: "",    # 空:10分 sb:3分 s1:10秒
      user_key: "hanairobiyori",
    }.merge(params)

    if @options[:mock_use]
      js_str = Rails.root.join("config/https___shogiwars_heroz_jp_users_history_hanairobiyori_gtype_sb_locale_ja.html").read
    else
      url = "https://shogiwars.heroz.jp/users/history/#{params[:user_key]}?gtype=#{params[:gtype]}&locale=ja"
      page = current_agent.get(url)
      js_str = page.body
    end

    # js = Pathname("~/src/bushido/examples/shogiwars_history_raw.html").expand_path.read

    # $().html("xxx") となっているので xxx の部分を取り出す
    md = js_str.match(/html\("(.*)"\)/)
    dirty_html = md.captures.first

    str = dirty_html
    str = str.gsub("\\n", '')
    str = str.gsub("\\\"", '"')
    str = str.gsub("\\/", '/')
    str = str.gsub(/>\s*</m, '><')

    doc = Nokogiri.HTML(str)

    doc.search(".contents").collect do |elem|
      row = {}

      url = "http:" + elem.search("a").last.attr("href")
      url = url.remove("?locale=ja")
      url = url.remove("http://kif-pona.heroz.jp/games/")
      row[:battle_key] = url

      row[:users] = elem.search(".history_prof").collect do |e|
        [:user_key, :rank].zip(e.inner_text.scan(/\S+/)).to_h
      end

      row
    end
  end

  def battle_one_info_get(battle_key)
    info = {
      battle_key: battle_key,
      url: "http://kif-pona.heroz.jp/games/#{battle_key}",
    }

    if @options[:mock_use]
      str = Rails.root.join("config/http___kif_pona_heroz_jp_games_hanairobiyori_ispt_20171104_220810_locale_ja.html").read
    else
      str = current_agent.get(info[:url]).body
    end

    # 級位が文字化けするため
    str = str.toutf8

    # var gamedaata = {...} の内容を拝借
    info[:meta] = str.scan(/^\s*(\w+):\s*"(.*)"/).to_h.symbolize_keys

    info[:csa_hands] = str.scan(/([+-]\d{4}[A-Z]{2}),L\d+/).flatten.join(",")

    info
  end

  def current_agent
    @current_agent || __current_agent
  end

  def __current_agent
    agent = Mechanize.new
    agent.user_agent_alias = "iPhone"
    agent
  end
end

if $0 == __FILE__
  tp ShogiWarsCop.new.battle_list_get(gtype: "s1",  user_key: "hanairobiyori")
  tp ShogiWarsCop.new.battle_one_info_get("hanairobiyori-ispt-20171104_220810")

  # |---------------------------------------------+-----------------------------------------------------------------------------------|
  # | battle_key                                  | users                                                                             |
  # |---------------------------------------------+-----------------------------------------------------------------------------------|
  # | Manao333-hanairobiyori-20171104_230751      | [{:user_key=>"Manao333", :rank=>"1級"}, {:user_key=>"hanairobiyori", :rank=>"18級"}]      |
  # | hanairobiyori-hayamamhizuki-20171104_230324 | [{:user_key=>"hanairobiyori", :rank=>"19級"}, {:user_key=>"hayamamhizuki", :rank=>"1級"}] |
  # | hanairobiyori-747764774-20171104_230003     | [{:user_key=>"hanairobiyori", :rank=>"19級"}, {:user_key=>"747764774", :rank=>"1級"}]     |
  # | hideto3333-hanairobiyori-20171104_225827    | [{:user_key=>"hideto3333", :rank=>"2級"}, {:user_key=>"hanairobiyori", :rank=>"20級"}]    |
  # | kouchandai-hanairobiyori-20171102_153403    | [{:user_key=>"kouchandai", :rank=>"1級"}, {:user_key=>"hanairobiyori", :rank=>"21級"}]    |
  # | takeoutimao-hanairobiyori-20171026_105447   | [{:user_key=>"takeoutimao", :rank=>"1級"}, {:user_key=>"hanairobiyori", :rank=>"21級"}]   |
  # | hanairobiyori-HANSODE49-20171026_105001     | [{:user_key=>"hanairobiyori", :rank=>"22級"}, {:user_key=>"HANSODE49", :rank=>"2級"}]     |
  # | Namihei02-hanairobiyori-20171026_104400     | [{:user_key=>"Namihei02", :rank=>"二段"}, {:user_key=>"hanairobiyori", :rank=>"22級"}]    |
  # |---------------------------------------------+-----------------------------------------------------------------------------------|
  # |------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
  # | battle_key | hanairobiyori-ispt-20171104_220810                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
  # |        url | http://kif-pona.heroz.jp/games/hanairobiyori-ispt-20171104_220810                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
  # |       meta | {"name"=>"hanairobiyori-ispt-20171104_220810", "avatar0"=>"_e1708s4c", "avatar1"=>"mc8", "dan0"=>"27級", "dan1"=>"3級", "gtype"=>"sb"}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
  # |  csa_hands | +7968GI,-3334FU,+5756FU,-4132KI,+6857GI,-1314FU,+1716FU,-8384FU,+8879KA,-8485FU,+6978KI,-3142GI,+3948GI,-4233GI,+2726FU,-5152OU,+2625FU,-2231KA,+5969OU,-3142KA,+3736FU,-7162GI,+5746GI,-6172KI,+3635FU,-3435FU,+4635GI,-0034FU,+2524FU,-2324FU,+3524GI,-3324GI,+7924KA,-4224KA,+2824HI,-0023FU,+2428HI,-8586FU,+8786FU,-8286HI,+0087FU,-8656HI,+0057GI,-5636HI,+0037FU,-3635HI,+5746GI,-3585HI,+3736FU,-0033GI,+0068KA,-5354FU,+3635FU,-3435FU,+4635GI,-0034FU,+0024FU,-2324FU,+3524GI,-3324GI,+6824KA,-0023FU,+2468KA,-0033GI,+4958KI,-9394FU,+9796FU,-6253GI,+6979OU,-5344GI,+4857GI,-4435GI,+5746GI,-3546GI,+6846KA,-0039KA,+2818HI,-3975UM,+0076GI,-7576UM,+7776FU,-0055GI,+4668KA,-8582HI,+7988OU,-0027GI,+1848HI,-2736NG,+0037FU,-3627NG,+4849HI,-2738NG,+4979HI,-5556GI,+0057FU,-5645GI,+0077GI,-3435FU,+6766FU,-3536FU,+3736FU,-4536GI,+0037FU,-3627NG,+5756FU,-2728NG,+5867KI,-3829NG,+3736FU,-2919NG,+6846KA,-0044KY,+4628KA,-1918NG,+2839KA,-4447NY,+7949HI,-4737NY,+0048GI,-3738NY,+4959HI,-3839NY,+4839GI,-0037KA,+5979HI,-3726UM,+7768GI,-1817NG,+3938GI,-2636UM,+3849GI,-0037FU,+0048KY,-1727NG,+0047KA,-3635UM,+4758KA,-3738TO,+4847KY,-3849TO,+5849KA,-2737NG,+4958KA,-0038FU,+5869KA,-3839TO,+6857GI,-3536UM,+5746GI,-3747NG,+4657GI,-3949TO,+5768GI,-4948TO,+6877GI,-0046KE,+6947KA,-3647UM,+7919HI,-4858TO,+0079GI,-5857TO,+8898OU,-5767TO,+7867KI,-4658NK,+7788GI |
  # |------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
end

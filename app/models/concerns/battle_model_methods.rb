module BattleModelMethods
  extend ActiveSupport::Concern

  included do
    include BoardImageMethods
    include TagMethods
    include TimeChartMethods

    cattr_accessor(:fixed_defaut_time) { Time.zone.parse("0001/01/01") }

    acts_as_ordered_taggable_on :other_tags

    serialize :meta_info

    before_validation do
      self.meta_info ||= {}
      self.turn_max ||= 0
      self.accessed_at ||= Time.current
    end

    before_validation on: :update do
      if !sfen_body
        self.sfen_body ||= fast_parsed_info.to_sfen
      end

      # 盤面が変化したことが一瞬でわかるように盤面をハッシュ化しておく
      if will_save_change_to_attribute?(:sfen_body) || sfen_hash.nil?
        if sfen_body
          self.sfen_hash = Digest::MD5.hexdigest(sfen_body)
        end
      end
    end
  end

  # def total_seconds
  #   @total_seconds ||= heavy_parsed_info.pi.move_infos.sum { |e| e[:used_seconds] }
  # end

  # 更新方法
  # ActiveRecord::Base.logger = nil
  # Swars::Battle.find_each { |e| e.tap(&:parser_exec).save! }
  # Swars::Battle.find_each { |e| e.parser_exec; print(e.changed? ? "U" : "."); e.save! } rescue $!
  def parser_exec(options = {})
    return if @parser_executed

    options = {
      destroy_all: false,
    }.merge(options)

    info = fast_parsed_info

    if ENV["INTEGRITY_VALIDATE"]
      begin
        info.container
      rescue => error
        p error
        puts error
        puts "https://shogiwars.heroz.jp/games/#{key}?locale=ja"
        puts "--------------------------------------------------------------------------------"
        puts kifu_body
        puts "--------------------------------------------------------------------------------"
        abort
      end
    end

    info.container               # 不整合があるとここで Bioshogi::BioshogiError を投げる

    self.turn_max = info.container.turn_info.turn_offset
    self.critical_turn = info.container.critical_turn
    self.outbreak_turn = info.container.outbreak_turn
    self.sfen_body = info.container.to_history_sfen
    self.sfen_hash = Digest::MD5.hexdigest(sfen_body)

    preset_key_set(info)

    if !battled_at
      if v = info.formatter.pi.header["開始日時"].presence
        self.battled_at ||= Bioshogi::Parser::TimeParser.new(v).to_time
      end
      self.battled_at ||= fixed_defaut_time
    end

    parser_exec_after(info)
    @parser_executed = true
  end

  def parser_exec_after(info)
  end

  def remake(options = {})
    b = taggings.collect { |e| e.tag.name }.sort
    parser_exec
    save!
    memberships.each(&:save!)   # 更新で設定したタグを保存するため
    a = taggings.collect { |e| e.tag.name }.sort
    flag = a != b # タグの変更は e.changed? では関知できない
    print(flag ? "U" : ".")
    flag
  end

  # def header_detail(h)
  #   meta_info[:header]
  # end

  # def date_link(h, v)
  #   if v.blank?
  #     return
  #   end
  #
  #   Time.zone.parse(v.to_s).to_fs(:ymd) rescue v
  # end

  # def preset_link(h, name)
  #   label = name
  #   if label != "平手"
  #     label = h.tag.span(label, :class => "text-danger")
  #   end
  #   h.link_to(label, h.general_search_path(name))
  # end

  def showable_tag_list
    [
      *attack_tag_list,
      *defense_tag_list,
      *technique_tag_list,
      *note_tag_list,
      *other_tag_list,
    ]
  end

  # def display_turn
  #   # start_turn || outbreak_turn || critical_turn || 0
  #   start_turn || critical_turn || 0
  # end

  def display_turn
    # image_turn || start_turn || outbreak_turn || critical_turn || turn_max
    # image_turn || start_turn || critical_turn || turn_max
    critical_turn || turn_max
  end

  def adjust_turn(turn = nil)
    turn = turn.presence

    if turn
      turn = turn.to_i
    end

    turn ||= display_turn

    # 99手までのとき -1 を指定すると99手目にする
    if turn.negative?
      turn = turn_max + turn + 1
    end

    # 99手までのとき 100 を指定すると99手目にする
    # 99手までのとき -1000 を指定すると0手目にする
    turn.clamp(0, turn_max)
  end

  def adjust_viewpoint(viewpoint = nil)
    viewpoint.presence || "black"
  end

  def to_twitter_card_params(params = {})
    turn = adjust_turn(params[:turn])
    viewpoint = adjust_viewpoint(params[:viewpoint])

    {}.tap do |e|
      e[:title]       = params[:title].presence || twitter_card_title || "#{turn}手目"
      e[:image]       = twitter_card_image_url(turn: turn, viewpoint: viewpoint)
      e[:description] = params[:description].presence || twitter_card_description
    end
  end

  def twitter_card_title
    [tournament_name, title].collect(&:presence).compact.join(" ").presence
  end

  def twitter_card_description
    [description].collect(&:presence).compact.join(" ").presence
  end

  def twitter_card_image_url(options = {})
    turn = adjust_turn(options[:turn])
    viewpoint = adjust_viewpoint(options[:viewpoint])
    Rails.application.routes.url_helpers.polymorphic_url(self, {format: "png", turn: turn, viewpoint: viewpoint})
  end

  def kif_url(options = {})
    Rails.application.routes.url_helpers.full_url_for([self, {only_path: false, format: :kif, **options}])
  end

  def battle_decorator(params = {})
    raise ArgumentError, "view_context required" if !params[:view_context]
    @battle_decorator ||= battle_decorator_class.new(params.merge(battle: self))
  end

  def mini_battle_decorator(params = {})
    @mini_battle_decorator ||= battle_decorator_class.new(params.merge(battle: self))
  end

  def battle_decorator_class
  end

  # def player_info
  #   decorator = mini_battle_decorator
  #   LocationInfo.inject({}) { |a, e|
  #     name = decorator.player_name_for(e.key)
  #     if false
  #       if name
  #         name = name[0...3]
  #       end
  #     end
  #     a.merge(e.key => {name: name, :class => "has-text-weight-normal"})
  #   }
  # end

  # FIXME: self に依存させないようにして全部 KifuParser に委譲すること
  concerning :KifuConvertMethods do
    included do
      delegate :to_xxx, :to_all, :all_kifs, to: :heavy_parsed_info
    end

    # FIXME: 名前がよくない
    # KI2変換可能だけど重い
    def heavy_parsed_info
      @heavy_parsed_info ||= KifuParser.new(source: kifu_body)
    end

    # バリデーションをはずして KI2 への変換もしない前提の軽い版
    # ヘッダーやタグが欲しいとき用
    def fast_parsed_info
      @fast_parsed_info ||= parser_class.parse(kifu_body, {typical_error_case: :embed}.merge(fast_parser_options))
    end

    # # # 平手から開始した76歩の場合
    # #
    # # {
    # #   "initial_state_board_sfen": "startpos",
    # #   "last_sfen": "sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/2P6/PP1PPPPPP/1B5R1/LNSGKGSNL w - 2",
    # #   "moves": [
    # #     "7g7f"
    # #   ]
    # # }
    # #
    # # # 72手目からの局面図
    # # {
    # #   "initial_state_board_sfen": "sfen lr4knl/3g2gs1/4ppP2/p4bNpp/2pSsN3/PPPP1P2P/2N1P1G2/2G6/L1K4RL w BPs3p 72",
    # #   "last_sfen": "sfen lr4knl/3g2gs1/4ppP2/p4bNpp/2pSsN3/PPPP1P2P/2N1P1G2/2G6/L1K4RL w BPs3p 72",
    # #   "moves": []
    # # }
    # #
    # def sfen_attrs
    #   @sfen_attrs ||= yield_self do
    #     container = heavy_parsed_info.container
    #
    #     args = {}
    #     if container.initial_state_board_sfen != "startpos"
    #       args[:initpos] = container.initial_state_board_sfen.remove(/^sfen\s*/)
    #     end
    #     if container.hand_logs.present?
    #       args[:moves] = container.hand_logs.collect(&:to_sfen).join(".")
    #     end
    #     kent_query = args.to_query
    #
    #     {
    #       initial_state_board_sfen: container.initial_state_board_sfen, # => "startpos"
    #       last_sfen: container.to_short_sfen,                         # => "sfen lnsgkgsnl/1r5b1/ppppppppp/7s1/9/9/PPPPPPPPP/1B1S3R1/LN1GKGSNL b Ss 3"
    #       moves: container.hand_logs.collect(&:to_sfen),                # => ["7i6h", "S*2d"]
    #       kent_query: kent_query,
    #     }
    #   }.call
    # end
    #
    # def kento_app_embed_url
    #   @kento_app_embed_url ||= yield_self do
    #     container = heavy_parsed_info.container
    #
    #     args = {}
    #     if container.initial_state_board_sfen != "startpos"
    #       args[:initpos] = container.initial_state_board_sfen.remove(/^sfen\s*/)
    #     end
    #     if container.hand_logs.present?
    #       args[:moves] = container.hand_logs.collect(&:to_sfen).join(".")
    #     end
    #
    #     "https://www.kento-shogi.com/?#{args.to_query}"
    #   }.call
    # end

    def sfen_info
      @sfen_info ||= Bioshogi::Sfen.parse(sfen_body)
    end

    def parser_class
      Bioshogi::Parser
    end

    def share_board_path
      params = {
        body: sfen_body.gsub(/\s+/, "."),
        viewpoint: "black",
      }
      "/share-board?#{params.to_query}"
    end

    private

    # オプションはサブクラスで渡してもらう
    def fast_parser_options
      {}
    end
  end
end
# ~> -:2:in `<module:BattleModelMethods>': uninitialized constant BattleModelMethods::ActiveSupport (NameError)
# ~> 	from -:1:in `<main>'

module BattleModelSharedMethods
  extend ActiveSupport::Concern

  included do
    include ImageMod

    include TaggingModel

    cattr_accessor(:kifu_cache_enable)     { true }
    cattr_accessor(:kifu_cache_expires_in) { 1.days }

    cattr_accessor(:fixed_defaut_time) { Time.zone.parse("0001/01/01") }

    acts_as_ordered_taggable_on :other_tags

    has_many :converted_infos, as: :convertable, dependent: :destroy, inverse_of: :convertable

    serialize :meta_info

    before_validation do
      self.meta_info ||= {}
      self.turn_max ||= 0
    end
  end

  # def total_seconds
  #   @total_seconds ||= heavy_parsed_info.move_infos.sum { |e| e[:used_seconds] }
  # end

  # 更新方法
  # ActiveRecord::Base.logger = nil
  # Swars::Battle.find_each { |e| e.tap(&:parser_exec).save! }
  # Swars::Battle.find_each { |e| e.parser_exec; print(e.changed? ? "U" : "."); e.save! } rescue $!
  def parser_exec(**options)
    return if @parser_executed

    options = {
      destroy_all: false,
    }.merge(options)

    info = fast_parsed_info
    converted_infos.destroy_all if options[:destroy_all]

    if kifu_cache_enable
    else
      # くそ重くなるのでこれはやってはいけない
      KifuFormatWithBodInfo.each do |e|
        converted_info = converted_infos.text_format_eq(e.key).take || converted_infos.build
        converted_info.text_body = info.public_send("to_#{e.key}", compact: true, no_embed_if_time_blank: true)
        converted_info.text_format = e.key
      end
    end

    self.turn_max = info.mediator.turn_info.turn_offset
    self.critical_turn = info.mediator.critical_turn
    self.sfen_body = info.mediator.to_sfen

    if AppConfig[:swars_tag_search_function]
      self.meta_info = {
        :header          => info.header.to_h,
        # :detail_names    => info.header.sente_gote.collect { |e| Splitter.split(info.header["#{e}詳細"]) },
        # :simple_names    => info.header.sente_gote.collect { |e| Splitter.pair_split(info.header[e]) },
        # :skill_set_hash  => info.skill_set_hash,
      }

      self.defense_tag_list = ""
      self.attack_tag_list = ""
      self.technique_tag_list = ""
      self.note_tag_list = ""
      self.other_tag_list = ""

      defense_tag_list.add   info.mediator.players.flat_map { |e| e.skill_set.defense_infos.normalize.flat_map { |e| [e.name, *e.alias_names] } }
      attack_tag_list.add    info.mediator.players.flat_map { |e| e.skill_set.attack_infos.normalize.flat_map  { |e| [e.name, *e.alias_names] } }
      technique_tag_list.add info.mediator.players.flat_map { |e| e.skill_set.technique_infos.normalize.flat_map  { |e| [e.name, *e.alias_names] } }
      note_tag_list.add      info.mediator.players.flat_map { |e| e.skill_set.note_infos.normalize.flat_map  { |e| [e.name, *e.alias_names] } }

      other_tag_list.add info.header["棋戦"]
      other_tag_list.add info.header["持ち時間"]
      other_tag_list.add tournament_list
      other_tag_list.add Splitter.split(info.header["掲載"].to_s)
      other_tag_list.add Splitter.split(info.header["備考"].to_s)
      other_tag_list.add info.header.sente_gote.flat_map { |e| Splitter.split(info.header["#{e}詳細"]) }
      other_tag_list.add info.header.sente_gote.flat_map { |e| Splitter.split(info.header["#{e}"])     }
      other_tag_list.add place_list
      other_tag_list.add info.header["手合割"]
    end

    if v = info.header["開始日時"].presence
      if t = (Time.zone.parse(v) rescue nil)
        self.battled_at ||= t
      else
        values = v.scan(/\d+/).collect(&:to_i)
        self.battled_at ||= (Time.zone.local(*values) rescue nil)
      end
    end
    self.battled_at ||= fixed_defaut_time

    parser_exec_after(info)
    @parser_executed = true
  end

  def parser_exec_after(info)
  end

  def remake(**options)
    b = taggings.collect { |e| e.tag.name }.sort
    parser_exec
    save!
    memberships.each(&:save!)   # 更新で設定したタグを保存するため
    a = taggings.collect { |e| e.tag.name }.sort
    flag = a != b # タグの変更は e.changed? では関知できない
    print(flag ? "U" : ".")
    flag
  end

  def header_detail(h)
    meta_info[:header]
  end

  def date_link(h, v)
    if v.blank?
      return
    end

    Time.zone.parse(v.to_s).to_s(:ymd) rescue v
  end

  def preset_link(h, name)
    label = name
    if label != "平手"
      label = h.tag.span(label, :class => "text-danger")
    end
    h.link_to(label, h.general_search_path(name))
  end

  def showable_tag_list
    [
      *attack_tag_list,
      *defense_tag_list,
      *technique_tag_list,
      *note_tag_list,
      *other_tag_list,
    ]
  end

  if AppConfig[:swars_tag_search_function]
    def place_list
      v = meta_info[:header]["場所"].to_s
      if v.start_with?("http")
        return []
      end
      if md = v.match(/(.*)「(.*?)」/)
        v = md.captures
      end
      Array(v).reject(&:blank?)
    end

    def tournament_list
      Splitter.split(meta_info[:header]["棋戦詳細"].to_s)
    end
  end

  def to_kifu_copy_params(h, **options)
    {
      kc_url: h.url_for(self),
      kc_title: title,
      **options,
    }
  end

  def sp_turn
    start_turn || critical_turn || 0
  end

  def og_turn
    image_turn || start_turn || critical_turn || turn_max
  end

  def adjust_turn(turn)
    # turn = turn.presence
    #
    # if turn
    #   turn = turn.to_i
    # end

    turn ||= og_turn

    # 99手までのとき -1 を指定すると99手目にする
    if turn.negative?
      turn = turn_max + turn + 1
    end

    # 99手までのとき 100 を指定すると99手目にする
    # 99手までのとき -1000 を指定すると0手目にする
    turn = turn.clamp(0, turn_max)

    # raise self.attributes.inspect
    #
    # raise turn_max.inspect
    # raise turn.inspect

    turn
  end

  def record_to_twitter_options(h)
    options = {}

    v = adjust_turn(h.current_force_turn)
    if v == turn_max
      turn = "#{turn}手目(終了図)"
    else
      turn = "#{turn}手目"
    end
    options[:title] = h.params[:title].presence || "#{title}【#{turn}】"

    if turn = h.current_force_turn
      options[:url] = modal_on_index_url(turn: turn)
    else
      options[:url] = modal_on_index_url
    end

    if turn = h.current_force_turn
      options[:image] = twitter_card_image_url(h, turn: turn)
    else
      options[:image] = twitter_card_image_url(h)
    end

    options[:description] = h.params[:description].presence || description

    options
  end

  def twitter_card_image_url(h, options = {})
    # rails_representation_path(current_record.thumbnail_image.variant(resize: "1200x630!", type: :grayscale))
    # とした場合はリダイレクトするURLになってしまうため使えない
    # 固定URL化する
    # h.polymorphic_url([h.ns_prefix, self], {format: "png", updated_at: updated_at.to_i}.merge(options))
    h.polymorphic_url([h.ns_prefix, self], {format: "png"}.merge(options))
  end

  def battle_decorator(params = {})
    raise ArgumentError, "view_context required" unless params[:view_context]
    @battle_decorator ||= battle_decorator_class.new(params.merge(battle: self))
  end

  def battle_decorator_class
  end

  def player_info
    decorator = battle_decorator_class.new(battle: self)
    Bioshogi::Location.inject({}) { |a, e|
      name = decorator.player_name_for(e.key)
      if name
        name = name[0...3]
      end
      a.merge(e.key => {name: name})
    }
  end

  concerning :KifuConvertMethods do
    # cache_key は updated_at が元になっているため、間接的に kifu_body の更新で cache_key は変化する
    def to_cached_kifu(key)
      if kifu_cache_enable
        # Rails.cache.fetch([cache_key, key].join("-"), expires_in: (Rails.env.production? || Rails.env.staging?) ? kifu_cache_expires_in : 0) do
        heavy_parsed_info.public_send("to_#{key}", compact: true, no_embed_if_time_blank: true)
        # end
      else
        if e = converted_infos.text_format_eq(key).take
          e.text_body
        end
      end
    end

    def existing_sfen
      unless sfen_body
        update!(sfen_body: fast_parsed_info.to_sfen)
      end

      sfen_body
    end

    # バリデーションをはずして KI2 への変換もしない前提の軽い版
    # ヘッダーやタグが欲しいとき用
    def fast_parsed_info
      @fast_parsed_info ||= parser_class.parse(kifu_body, {typical_error_case: :embed}.merge(fast_parsed_options))
    end

    # KI2変換可能だけど重い
    def heavy_parsed_info
      @heavy_parsed_info ||= parser_class.parse(kifu_body, typical_error_case: :embed, support_for_piyo_shogi_v4_1_5: false)
    end

    def all_kifs
      @all_kifs ||= KifuFormatWithBodInfo.inject({}) { |a, e| a.merge(e.key => to_cached_kifu(e.key)) }
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
    #   @sfen_attrs ||= -> {
    #     mediator = heavy_parsed_info.mediator
    #
    #     args = {}
    #     if mediator.initial_state_board_sfen != "startpos"
    #       args[:initpos] = mediator.initial_state_board_sfen.remove(/^sfen\s*/)
    #     end
    #     if mediator.hand_logs.present?
    #       args[:moves] = mediator.hand_logs.collect(&:to_sfen).join(".")
    #     end
    #     kent_query = args.to_query
    #
    #     {
    #       initial_state_board_sfen: mediator.initial_state_board_sfen, # => "startpos"
    #       last_sfen: mediator.to_current_sfen,                         # => "sfen lnsgkgsnl/1r5b1/ppppppppp/7s1/9/9/PPPPPPPPP/1B1S3R1/LN1GKGSNL b Ss 3"
    #       moves: mediator.hand_logs.collect(&:to_sfen),                # => ["7i6h", "S*2d"]
    #       kent_query: kent_query,
    #     }
    #   }.call
    # end
    #
    # def kento_app_embed_url
    #   @kento_app_embed_url ||= -> {
    #     mediator = heavy_parsed_info.mediator
    #
    #     args = {}
    #     if mediator.initial_state_board_sfen != "startpos"
    #       args[:initpos] = mediator.initial_state_board_sfen.remove(/^sfen\s*/)
    #     end
    #     if mediator.hand_logs.present?
    #       args[:moves] = mediator.hand_logs.collect(&:to_sfen).join(".")
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

    private

    # オプションはサブクラスで渡してもらう
    def fast_parsed_options
      {}
    end
  end

  concerning :SaturnMethods do
    included do
      before_validation do
        self.saturn_key ||= "public"
      end
    end

    def saturn_info
      SaturnInfo.fetch(saturn_key)
    end
  end
end

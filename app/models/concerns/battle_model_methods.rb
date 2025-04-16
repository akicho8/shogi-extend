# 共通

module BattleModelMethods
  extend ActiveSupport::Concern

  included do
    include BoardImageMethods
    include TagMethods
    include TimeChartMethods
    include Swars::Battle::RebuilderMethods

    cattr_accessor(:fixed_defaut_time) { Time.zone.parse("0001/01/01") }

    serialize :meta_info, coder: YAML

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

  # 更新方法
  # ActiveRecord::Base.logger = nil
  # Swars::Battle.find_each { |e| e.tap(&:parsed_data_to_columns_set).save! }
  # Swars::Battle.find_each { |e| e.parsed_data_to_columns_set; print(e.changed? ? "U" : "."); e.save! } rescue $!
  def parsed_data_to_columns_set
    return if @parser_executed
    integrity_validate
    fast_parsed_info.container               # 不整合があるとここで Bioshogi::BioshogiError を投げる

    turn_columns_set
    sfen_set
    preset_key_set
    battled_at_set

    parsed_data_to_columns_set_after
    @parser_executed = true
  end

  def integrity_validate
    if ENV["INTEGRITY_VALIDATE"]
      begin
        fast_parsed_info.container
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
  end

  def turn_columns_set
    self.turn_max      = fast_parsed_info.container.turn_info.turn_offset
    self.critical_turn = fast_parsed_info.container.critical_turn
    self.outbreak_turn = fast_parsed_info.container.outbreak_turn
  end

  def sfen_set
    self.sfen_body = fast_parsed_info.container.to_history_sfen
    self.sfen_hash = Digest::MD5.hexdigest(sfen_body)
  end

  def battled_at_set
    if !battled_at
      if v = fast_parsed_info.formatter.pi.header["開始日時"].presence
        self.battled_at ||= Bioshogi::Parser::TimeParser.new(v).to_time
      end
      self.battled_at ||= fixed_defaut_time
    end
  end

  def parsed_data_to_columns_set_after
  end

  def showable_tag_list
    [
      *attack_tag_list,
      *defense_tag_list,
      *technique_tag_list,
      *note_tag_list,
    ]
  end

  def display_turn
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
    Rails.application.routes.url_helpers.polymorphic_url(self, { format: "png", turn: turn, viewpoint: viewpoint })
  end

  def kif_url(options = {})
    Rails.application.routes.url_helpers.full_url_for([self, { only_path: false, format: :kif, **options }])
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
      @fast_parsed_info ||= parser_class.parse(kifu_body, { typical_error_case: :embed }.merge(fast_parser_options))
    end

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

module ConvertMethods
  extend ActiveSupport::Concern

  included do
    cattr_accessor(:kifu_cache_enable)     { true }
    cattr_accessor(:kifu_cache_expires_in) { 1.days }

    acts_as_ordered_taggable_on :defense_tags
    acts_as_ordered_taggable_on :attack_tags
    acts_as_ordered_taggable_on :technique_tags
    acts_as_ordered_taggable_on :note_tags
    acts_as_ordered_taggable_on :other_tags
    acts_as_ordered_taggable_on :secret_tags

    has_many :converted_infos, as: :convertable, dependent: :destroy, inverse_of: :convertable

    serialize :meta_info

    before_validation do
      self.meta_info ||= {}
      self.turn_max ||= 0
    end
  end

  # cache_key は updated_at が元になっているため、間接的に kifu_body の更新で cache_key は変化する
  def to_cached_kifu(key)
    if kifu_cache_enable
      Rails.cache.fetch([cache_key, key].join("-"), expires_in: Rails.env.production? ? kifu_cache_expires_in : 0) do
        heavy_parsed_info.public_send("to_#{key}", compact: true)
      end
    else
      if e = converted_infos.text_format_eq(key).take
        e.text_body
      end
    end
  end

  def to_cached_sfen
    Rails.cache.fetch([cache_key, "sfen"].join("-"), expires_in: Rails.env.production? ? kifu_cache_expires_in : 0) do
      fast_parsed_info.to_sfen
    end
  end

  # KI2変換可能だけど重い
  def heavy_parsed_info
    @heavy_parsed_info ||= Bioshogi::Parser.parse(kifu_body, typical_error_case: :embed)
  end

  # バリデーションをはずして KI2 への変換もしない前提の軽い版
  # ヘッダーやタグが欲しいとき用
  def fast_parsed_info
    @fast_parsed_info ||= Bioshogi::Parser.parse(kifu_body, {typical_error_case: :embed}.merge(fast_parsed_options))
  end

  # オプションはサブクラスで渡してもらう
  def fast_parsed_options
    {}
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
        converted_info.text_body = info.public_send("to_#{e.key}", compact: true)
        converted_info.text_format = e.key
      end
    end

    self.turn_max = info.mediator.turn_info.turn_max

    self.meta_info = {
      :header          => info.header.to_h,
      :detail_names    => info.header.sente_gote.collect { |e| Splitter.split(info.header["#{e}詳細"]) },
      :simple_names    => info.header.sente_gote.collect { |e| Splitter.pair_split(info.header[e]) },
      :skill_set_hash  => info.skill_set_hash,
    }

    self.defense_tag_list = ""
    self.attack_tag_list = ""
    self.technique_tag_list = ""
    self.note_tag_list = ""
    self.other_tag_list = ""
    self.secret_tag_list = ""

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

    if v = info.header["開始日時"].presence
      if t = (Time.zone.parse(v) rescue nil)
        self.battled_at = t
      else
        values = v.scan(/\d+/).collect { |e|
          e = e.to_i
          if e.zero?
            e = 1
          end
          e
        }
        self.battled_at = Time.zone.local(*values)
      end
    else
      self.battled_at = Time.zone.parse("0001/01/01")
    end

    other_tag_list.add info.header["手合割"]

    parser_exec_after(info)
    @parser_executed = true
  end

  def parser_exec_after(info)
  end

  def remake(**options)
    b = taggings.collect { |e| e.tag.name }.sort
    parser_exec
    save!
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

  def to_kifu_copy_params(h, **options)
    options = {
      format: "kif",
      copy_trigger: true,
    }.merge(options)

    {
      kc_url: h.url_for([self, options]),
      kc_title: to_title,
    }
  end

  def to_title
  end
end

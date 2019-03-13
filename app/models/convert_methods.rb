module ConvertMethods
  extend ActiveSupport::Concern

  included do
    cattr_accessor(:kifu_cache_enable)     { true }
    cattr_accessor(:kifu_cache_expires_in) { 1.days }

    acts_as_ordered_taggable_on :defense_tags
    acts_as_ordered_taggable_on :attack_tags
    acts_as_ordered_taggable_on :technique_tags
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
        parsed_info.public_send("to_#{key}", compact: true)
      end
    else
      if e = converted_infos.text_format_eq(key).take
        e.text_body
      end
    end
  end

  def parsed_info
    @parsed_info ||= Warabi::Parser.parse(kifu_body, typical_error_case: :embed)
  end

  # 更新方法
  # ActiveRecord::Base.logger = nil
  # Swars::Battle.find_each { |e| e.tap(&:parser_exec).save! }
  # Swars::Battle.find_each { |e| e.parser_exec; print(e.changed? ? "U" : "."); e.save! } rescue $!
  def parser_exec(**options)
    return if @parser_executed

    options = {
      destroy_all: false,
    }.merge(options)

    info = parsed_info
    converted_infos.destroy_all if options[:destroy_all]

    if kifu_cache_enable
    else
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

    self.defense_tags.clear
    self.attack_tags.clear
    self.technique_tags.clear
    self.other_tags.clear
    self.secret_tags.clear

    defense_tag_list   << info.mediator.players.flat_map { |e| e.skill_set.defense_infos.normalize.flat_map { |e| [e.name, *e.alias_names] } }
    attack_tag_list    << info.mediator.players.flat_map { |e| e.skill_set.attack_infos.normalize.flat_map  { |e| [e.name, *e.alias_names] } }
    technique_tag_list << info.mediator.players.flat_map { |e| e.skill_set.technique_infos.normalize.flat_map  { |e| [e.name, *e.alias_names] } }

    other_tag_list << info.header["棋戦"]
    other_tag_list << info.header["持ち時間"]
    other_tag_list << tournament_list
    other_tag_list << Splitter.split(info.header["掲載"].to_s)
    other_tag_list << Splitter.split(info.header["備考"].to_s)
    other_tag_list << info.header.sente_gote.flat_map { |e| Splitter.split(info.header["#{e}詳細"]) }
    other_tag_list << info.header.sente_gote.flat_map { |e| Splitter.split(info.header["#{e}"])     }
    other_tag_list << place_list

    if v = info.header["開始日時"].presence
      other_tag_list << date_to_tags(v)

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

    other_tag_list << turn_max
    other_tag_list << info.header["手合割"]

    parser_exec_after(info)
    @parser_executed = true
  end

  def parser_exec_after(info)
  end

  def header_detail(h)
    meta_info[:header]
  end

  def date_link(h, v)
    if v.blank?
      return
    end

    list = []

    if v.kind_of?(String)
      y, m, d, *other = v.scan(/\d+/).collect(&:to_i)
    else
      y, m, d, *other = v.year, v.month, v.day, v.hour, v.min
    end

    if y.nonzero?
      list << h.link_to(("%04d" % y), h.general_search_path("%04d" % y))
    else
      list << "????"
    end

    if m.nonzero?
      list << h.link_to(("%02d" % m), h.general_search_path("%04d/%02d" % [y, m]))
    else
      list << "??"
    end

    if d.nonzero?
      list << h.link_to(("%02d" % d), h.general_search_path("%04d/%02d/%02d" % [y, m, d]))
    else
      list << "??"
    end

    other = other.take(2)
    if other.all?(&:zero?)
      other.clear
    end
    list.join("/").html_safe + " " + other.collect { |e| "%02d" % e }.join(":").html_safe
  end

  def date_to_tags(v)
    list = []

    values = v.scan(/\d+/).collect(&:to_i).take(3)
    list.concat(values)

    y, m, d = values

    if y.nonzero?
      list << "%04d" % y
    end

    if m.nonzero?
      list << "%04d/%02d" % [y, m]
    end

    if d.nonzero?
      list << "%04d/%02d/%02d" % [y, m, d]
    end

    list
  end

  def preset_link(h, name)
    label = name
    if label != "平手"
      label = h.tag.span(label, :class => "text-danger")
    end
    h.link_to(label, h.general_search_path(name))
  end

  def showable_tag_list
    attack_tag_list + defense_tag_list + technique_tag_list + other_tag_list
  end

  def place_list
    v = meta_info[:header]["場所"].to_s
    if md = v.match(/(.*)「(.*?)」/)
      v = md.captures
    end
    Array(v).reject(&:blank?)
  end

  def tournament_list
    Splitter.split(meta_info[:header]["棋戦詳細"].to_s)
  end
end

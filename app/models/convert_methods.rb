module ConvertMethods
  extend ActiveSupport::Concern

  included do
    acts_as_ordered_taggable_on :defense_tags
    acts_as_ordered_taggable_on :attack_tags
    acts_as_ordered_taggable_on :other_tags

    has_many :converted_infos, as: :convertable, dependent: :destroy, inverse_of: :convertable

    serialize :meta_info

    before_validation do
      self.meta_info ||= {}
      self.turn_max ||= 0
    end
  end

  # 更新方法
  # ActiveRecord::Base.logger = nil
  # BattleRecord.find_each { |e| e.tap(&:parser_exec).save! }
  # BattleRecord.find_each { |e| e.parser_exec; print(e.changed? ? "U" : "."); e.save! } rescue $!
  def parser_exec(**options)
    return if @parser_executed

    options = {
      destroy_all: false,
    }.merge(options)

    info = Bushido::Parser.parse(kifu_body, typical_error_case: :embed)
    converted_infos.destroy_all if options[:destroy_all]
    KifuFormatInfo.each do |e|
      converted_info = converted_infos.text_format_eq(e.key).take
      converted_info ||= converted_infos.build
      converted_info.attributes = {text_body: info.public_send("to_#{e.key}"), text_format: e.key}
    end
    self.turn_max = info.mediator.turn_max

    self.meta_info = {
      :header          => info.header.to_h,
      :detail_names    => info.header.sente_gote.collect { |e| Splitter.split(info.header["#{e}詳細"]) },
      :simple_names    => info.header.sente_gote.collect { |e| Splitter.pair_split(info.header[e]) },
      :skill_set_hash  => info.skill_set_hash,
    }

    self.defense_tag_list = info.mediator.players.flat_map { |e| e.skill_set.normalized_defense_infos }.collect(&:key)
    self.attack_tag_list  = info.mediator.players.flat_map { |e| e.skill_set.normalized_attack_infos  }.collect(&:key)
    self.other_tag_list   = []

    other_tag_list << info.header["棋戦"]
    other_tag_list << info.header["持ち時間"]
    other_tag_list << Splitter.split(info.header["棋戦詳細"].to_s)
    other_tag_list << Splitter.split(info.header["掲載"].to_s)
    other_tag_list << Splitter.split(info.header["備考"].to_s)
    other_tag_list << info.header.sente_gote.flat_map { |e| Splitter.split(info.header["#{e}詳細"]) }
    other_tag_list << info.header.sente_gote.flat_map { |e| Splitter.split(info.header["#{e}"])     }

    if v = info.header["場所"]
      if md = v.match(/(.*)「(.*?)」/)
        other_tag_list << md.captures
      else
        other_tag_list << v
      end
    end

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
    if persisted?
      ships = battle_ships.order(:position)
    else
      ships = battle_ships
    end

    # 両者にタグを作らんと意味ないじゃん
    info.mediator.players.each.with_index do |player, i|
      battle_ship = ships[i]
      battle_ship.defense_tag_list = player.skill_set.normalized_defense_infos.collect(&:key)
      battle_ship.attack_tag_list  = player.skill_set.normalized_attack_infos.collect(&:key)
    end
  end

  def header_detail(h)
    return meta_info[:header]

    row = meta_info[:to_meta_h].dup
    row.each do |k, v|
      if v
        case k
        when /の(囲い|戦型)$/
          row[k] = v.collect { |e| h.link_to(e, h.resource_ns1_general_search_path(e)) }.join(" ").html_safe
        when "棋戦詳細"
          row[k] = v.collect { |e| h.link_to(e, h.resource_ns1_general_search_path(e)) }.join(" ").html_safe
        when "場所"
          if md = v.match(/(.*)「(.*?)」/)
            v = md.captures
          end
          row[k] = Array(v).collect { |e| h.link_to(e, h.resource_ns1_general_search_path(e)) }.join(" ").html_safe
        when "掲載"
          row[k] = h.link_to(v, h.resource_ns1_general_search_path(v))
        when "持ち時間"
          row[k] = h.link_to(v, h.resource_ns1_general_search_path(v))
        when "手合割"
          row[k] = teaiwari_link(h, v)
        when /.手\z/
          row[k] = v.collect { |e| h.link_to(e, h.resource_ns1_general_search_path(e)) }.join(" ").html_safe
        when /.手詳細/
          row[k] = v.collect { |e| h.link_to(e, h.resource_ns1_general_search_path(e)) }.join(" ").html_safe
        when "棋戦"
          row[k] = h.link_to(v, h.resource_ns1_general_search_path(v))
        when "戦型"
          row[k] = h.link_to(v, h.resource_ns1_general_search_path(v))
        when /日時?\z/
          row[k] = date_link(h, v)
        end
      end
    end
    row
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
      list << h.link_to(("%04d" % y), h.resource_ns1_general_search_path("%04d" % y))
    else
      list << "????"
    end

    if m.nonzero?
      list << h.link_to(("%02d" % m), h.resource_ns1_general_search_path("%04d/%02d" % [y, m]))
    else
      list << "??"
    end

    if d.nonzero?
      list << h.link_to(("%02d" % d), h.resource_ns1_general_search_path("%04d/%02d/%02d" % [y, m, d]))
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

  def teaiwari_link(h, name)
    label = name
    if label != "平手"
      label = h.tag.span(label, :class => "text-danger")
    end
    h.link_to(label, h.resource_ns1_general_search_path(name))
  end

  def mountain_post_once
    unless mountain_url
      mountain_post
    end
  end

  def mountain_post
    url = Rails.application.routes.url_helpers.mountain_upload_url
    if converted_info = converted_infos.text_format_eq(:kif).take
      kif = converted_info.text_body

      if AppConfig[:run_localy]
        url = "http://shogi-s.com/result/5a274d10px"
      else
        response = Faraday.post(url, kif: kif)
        logger.info(response.status.to_t)
        logger.info(response.headers.to_t)
        url = response.headers["location"].presence
      end

      if url
        update!(mountain_url: url)
      end
    end
  end
end

class BattleDecorator
  def self.format_foo1(value)
    m, s = value.divmod(1.minutes)
    if m == 0
      s
    else
      "#{m}:%02d" % s
    end
  end

  def self.default_params
    {
      yoko3retu: 3,
      cell_rows: 25,
    }
  end

  attr_accessor :params

  delegate :memberships, :preset_info, to: :battle

  def initialize(params)
    @params = self.class.default_params.merge(params)
  end

  def hand_log_for(*args)
    if idx = index_of(*args)
      hand_logs[idx]
    end
  end

  def user_name_for(location)
    membership_for(location).user.key
  end

  def sengata_pack
    memberships.collect { |m|
      s = m.attack_tag_list.first || m.defense_tag_list.first || m.note_tag_list.grep_v(/指導対局/).first
      if s
        s = s.remove(/△|▲/)
        vc.tag.div { m.location.hexagon_mark + " #{s}" }
      end
    }.compact.join.html_safe
  end

  # sengo_one_char(:black) # => "先 ☗"
  def sengo_one_char(location)
    location = Bioshogi::Location.fetch(location)
    name = location.call_name(handicap?)
    [name.chars.first, location.hexagon_mark].join(" ")
  end
  
  def battle_end_at
    battle.end_at
  end

  def blank_jihunkara
    # s = "#{spc(3)}時#{spc(3)}分"
    # "#{s} 〜 #{s}".html_safe
  end

  def dankyuu_number_for(location, type)
    s = membership_for(location).grade.grade_info.name
    if s.include?(type)
      # s.remove(type)
      s
    end
  end

  def kirokugakari
  end

  def bikou_body
    s = []

    if battle.final_info.draw
      s << battle.final_info.name
    else
      s << [lose_membership.location.call_name(handicap?), battle.final_info.name].join
    end

    s += battle.note_tag_list.grep(/(^相|入玉)/)
    if battle.memberships.any? { |e| e.note_tag_list.include?("指導対局") }
      s << "指導対局"
    end
    # s << "あああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああ"
    s.join(" ")
  end

  def teaiwari
    s = []
    name = preset_info.name
    s << name
    # if name == "平手"
    #   s << "振駒"
    # end
    s.join(" ")
  end

  def kaku_jikan
    battle.rule_info.life_time / 1.minutes
  end

  def total_seconds_str_for(location)
    m = membership_for(location)
    min, sec = m.total_seconds.divmod(1.minutes)
    "#{m.location.hexagon_mark}#{min}分#{sec}秒"
  end

  def katimake_result
    if win_membership
      s = "#{battle.turn_max}手で #{win_membership.user.key} #{win_membership.grade.name}の勝ち"
    else
      s = "#{battle.turn_max}手で#{battle.final_info.name}"
    end
    s
  end

  def battle
    params[:battle]
  end

  def membership_for(location)
    location = Bioshogi::Location.fetch(location)
    battle.memberships[location.code]
  end

  def nikozutu
    location_size
  end

  def yoko3retu
    params[:yoko3retu]
  end

  def cell_rows
    params[:cell_rows]
  end

  def page_count
    q, r = battle.turn_max.divmod(count_of_1page)
    if r.nonzero?
      q += 1
    end
    q
  end

  private

  def handicap?
    preset_info.handicap
  end

  def win_membership
    @win_membership ||= memberships.find { |e| e.judge_info.key == :win }
  end

  def lose_membership
    @lose_membership ||= memberships.find { |e| e.judge_info.key == :lose }
  end

  def index_of(page_index, x, y, left_or_right)
    if handicap?
      if page_index == 0 && x == 0 && y == 0 && left_or_right == 0
        return
      end
    end

    base = page_index * count_of_1page
    base += base + x * (cell_rows * location_size) + (y * nikozutu) + left_or_right
    base - one_if_handicap
  end

  def one_if_handicap
    handicap? ? 1 : 0
  end

  def count_of_1page
    cell_rows * yoko3retu * nikozutu
  end

  def hand_logs
    @hand_logs ||= battle.heavy_parsed_info.mediator.hand_logs
  end

  def location_size
    Bioshogi::Location.count
  end

  def vc
    params[:view_context]
  end

  def spc(n = 1)
    "&nbsp;" * n
  end
end

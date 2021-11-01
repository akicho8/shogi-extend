module BattleDecorator
  class Base
    def self.personal_clock_format(value)
      m, s = value.divmod(1.minutes)
      if m == 0
        s
      else
        "#{m}:%02d" % s
      end
    end

    def self.default_params
      {
        outer_columns: 3,       # 横何列か
        cell_rows: 25,          # 縦何行か
        separator: "→",        # 戦型の区切り
        strategy_take_max: 3,   # 戦型は最大何個表示するか
      }
    end

    attr_accessor :params

    def initialize(params)
      @params = self.class.default_params.merge(params)
    end

    def hand_info(*args)
      if e = hand_log_for(*args)
        value = e.to_ki2(same_suffix: "\u3000", separator: " ", compact_if_gt: 7)

        if debug_mode?
          value = "９九成香左上"
          # value = "１２３４５６".chars.take(rand(4..6)).join
          # value = "１２３４５６"
        end

        {
          :object => e,
          :value  => value,
          :class  => "hand_size#{value.size}",
        }
      end
    end

    def player_name_for(location)
    end

    def end_at_s
    end

    # 戦型は空にすると .value の部分が入力できなくなるため td を edit できるようにした
    # そのため先後まとめたテキストに変更した
    # なかに <br> が含まれるのがいやだけど仕方ない
    # もし buefy で textarea 対応の dialog がでたら改善できるかもしれない
    # そのときはタグを pre にする
    def strategy_pack_for_all
      if battle.turn_max >= 1
        Bioshogi::Location.collect { |location|
          s = strategy_pack_core(location)
          s ||= "不明"
          s = s.remove(/△|▲/)
          "#{location.pentagon_mark} #{s}"
        }.join("<br>")
      end
    end

    # location_kanji_char(:black) # => "先 ☗"
    def location_kanji_char(location)
      location = Bioshogi::Location.fetch(location)
      name = location.call_name(handicap?)
      name.chars.first
    end

    def battle_begin_at
      battle.battled_at
    end

    def battle_end_at
    end

    def begin_at_s
      if battle_begin_at_available?
        if v = battle_begin_at
          v.to_s(:ja_ad_format)
        end
      end
    end

    def end_at_s
      if battle_begin_at_available?
        if v = battle_end_at
          v.to_s(:ja_ad_format)
        end
      end
    end

    def battle_begin_at_available?
      if v = battle_begin_at
        v != battle.fixed_defaut_time
      end
    end

    def datetime_blank
    end

    def grade_name_for(location)
    end

    def umpire_name
    end

    # 備考を配列で返す
    def desc_body_core
    end

    def desc_body
      if s = desc_body_core
        # 3行以内なら折り返す
        if s.size <= 3
          s.join("<br>")
        else
          s.join(" ")
        end
      end
    end

    def preset_str
      preset_info.name
    end

    def hold_time_str
    end

    def total_seconds_str_for(location)
      location = Bioshogi::Location.fetch(location)
      seconds = total_seconds_for(location)
      m, s = seconds.divmod(1.minutes)
      [location.pentagon_mark, " ", m.nonzero? ? "#{m}分" : nil, "#{s}秒"].join
    end

    def tournament_name
    end

    def battle_result_str
    end

    def battle
      params[:battle]
    end

    def membership_for(location)
      location = Bioshogi::Location.fetch(location)
      memberships[location.code]
    end

    def inner_fixed_columns
      location_size
    end

    def outer_columns
      params[:outer_columns]
    end

    def cell_rows
      params[:cell_rows]
    end

    def page_count
      turn_max = battle.turn_max + one_if_handicap

      q, r = turn_max.divmod(count_of_1page)
      if r.nonzero?
        q += 1
      end

      # 初手投了の場合 q == 0 で何も表示されなくなるのを防ぐ
      if q.zero?
        q = 1
      end

      q
    end

    def rule_name
    end

    def as_json(*)
      if params[:formal_sheet_blank]
        return {}
      end

      {
        :desc_body                   => desc_body,
        :tournament_name             => tournament_name,
        :rule_name                   => rule_name,
        :strategy_pack_for_all       => strategy_pack_for_all,
        :battle_result_str           => battle_result_str,
        :player_name_for_black       => player_name_for(:black),
        :player_name_for_white       => player_name_for(:white),
        :grade_name_for_black        => grade_name_for(:black),
        :grade_name_for_white        => grade_name_for(:white),
        :umpire_name                 => "",
        :begin_at_s                  => begin_at_s,
        :end_at_s                    => end_at_s,
        :preset_str                  => preset_str,
        :hold_time_str               => hold_time_str,
        :total_seconds_str_for_black => total_seconds_str_for(:black),
        :total_seconds_str_for_white => total_seconds_str_for(:white),
        :hirukyuu                    => "",
        :yuukyuu                     => "",

        ################################################################################

        :page_count                => page_count,
        :location_kanji_char_black => location_kanji_char(:black),
        :location_kanji_char_white => location_kanji_char(:white),
        :outer_columns             => outer_columns,
        :inner_fixed_columns       => inner_fixed_columns,
        :cell_rows                 => cell_rows,
        :html_title                => battle.title,

        :cell_matrix               => cell_matrix,
      }
    end

    private

    def cell_matrix
      page_count.times.collect do |page_index|
        cell_rows.times.collect do |y|
          outer_columns.times.collect do |x|
            inner_fixed_columns.times.collect do |left_or_right|
              cell = {}
              if params[:formal_sheet_blank]
              else
                if hand_info = hand_info(page_index, x, y, left_or_right)
                  cell[:class] = hand_info[:class]
                  cell[:value] = hand_info[:value]
                  personal_clock = hand_info[:object].personal_clock
                  cell[:used_seconds] = self.class.personal_clock_format(personal_clock.used_seconds)
                  cell[:total_seconds] = self.class.personal_clock_format(personal_clock.total_seconds)
                end
              end
              cell
            end
          end
        end
      end
    end

    def total_seconds_for(location)
    end

    def debug_mode?
      params[:formal_sheet_debug]
    end

    def hand_log_for(*args)
      if idx = index_of(*args)
        hand_logs[idx]
      end
    end

    def memberships
      []
    end

    def preset_info
      battle.preset_info
    end

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
      offset = x * (cell_rows * location_size) + (y * inner_fixed_columns) + left_or_right
      base + offset - one_if_handicap
    end

    def one_if_handicap
      handicap? ? 1 : 0
    end

    def count_of_1page
      cell_rows * outer_columns * inner_fixed_columns
    end

    def hand_logs
      @hand_logs ||= heavy_parsed_info.mediator.hand_logs
    end

    def heavy_parsed_info
      battle.heavy_parsed_info.core_parser
    end

    def location_size
      Bioshogi::Location.count
    end

    def vc
      params[:view_context]
    end

    # helper methods

    # 半角化
    def normalize_str(str)
      NKF.nkf('-w -Z', str.to_s).squish
    end
  end
end

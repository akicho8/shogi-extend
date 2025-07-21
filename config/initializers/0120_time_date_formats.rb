Time::DATE_FORMATS.update({
    ymdhm: "%F %H:%M",
    ymdhms: "%F %T",
    ymd: "%F",

    battle_short: "%H:%M",               # 12:34
    battle_medium: "%-m/%-d %H:%M",      # 1/2 12:34
    battle_long: "%F %H:%M",             # 2020-01-02 12:34
    csa_ymdhms: "%Y/%m/%d %H:%M:%S",
    ymd_j: "%Y-%m-%d %J",

    :ja_ad_format => proc { |t|
      t.strftime("%Y年%-m月%-d日%-H時%-M分")
    },

    :battle_time => proc { |time|
      case
      when time >= 1.days.ago
        time.to_fs(:battle_short)
      when time.year == Time.current.year
        time.to_fs(:battle_medium)
      else
        time.to_fs(:battle_long)
      end
    },

    # :date_short => proc { |time|
    #   case
    #   when time.year == Time.current.year
    #     time.strftime("%-m/%-d")
    #   else
    #     time.strftime("%Y-%m-%d")
    #   end
    # },

    :battle_time_today => proc { |time|
    },

    :distance => proc { |time|
      d = time - Time.current
      suffix = d.negative? ? "前" : "後"
      t = d.abs
      case
        # when time >= Time.current.beginning_of_day
        # when time >= 1.days.ago
        #   time.to_fs(:battle_short)
      when t < 1.minute then "#{t.div(1.second)}秒#{suffix}"
      when t < 1.hour   then "#{t.div(1.minute)}分#{suffix}"
      when t < 1.day    then "#{t.div(1.hour)}時間#{suffix}"
        # when t < 1.week   then "#{t.div(1.day}日#{suffix}"
      when t < 1.month  then "#{t.div(1.day)}日#{suffix}"
      when t < 1.year   then "#{t.div(1.month)}ヶ月#{suffix}"
      else                  "#{t.div(1.year)}年#{suffix}"
      end
    },

    :battle_time_detail => proc { |time|
      "#{time.to_fs(:ymdhm)} (#{time.to_fs(:battle_time)})"
    },

    #
    # # "12:34" ※1日以内なら「時間」のみ、1年以内なら「月日」、1年以上なら「年月日」
    # :gmail_index_like => proc {|time|
    #   # MEMO: time が未来の場合はエラーになるので注意
    #   gap = (time.to_i - Time.current.to_i)  # 秒
    #   t = gap.abs
    #   case
    #   when t < 1.day    then format = "%R"
    #   when t < 1.year   then format = "#{time.month}/#{time.day}(%J)" # "%m月%d日(%J)"
    #   else                   format = "%y年%m月"
    #   end
    #   time.strftime(format)
    # },

    # # "12:34 (56分前)"
    # :gmail_show_like   => proc {|time| "#{time.to_fs(:gmail_index_like)} (#{time.to_fs(:distance)})"},
    # :gmail_show_like2  => proc {|time| " #{time.to_fs(:gmail_show_like)} "},
    #
    # :last_access   => proc {|time|
    #   t = (Time.current.to_i - time.to_i).abs
    #   case
    #   when t < 3.minute.to_i then "ONLINE"
    #   when t < 1.hour.to_i   then "#{t / 1.minute.to_i}分前"
    #   when t < 1.day.to_i    then "#{t / 1.hour.to_i}時間前"
    #   else                        "#{t / 1.day.to_i}日前"
    #   end
    # },
    # :before_days   => proc {|time|
    #   t = (Time.current.to_i - time.to_i).abs
    #   case
    #   when t < 1.minute.to_i then "#{t / 1.second.to_i}秒前"
    #   when t < 1.hour.to_i   then "#{t / 1.minute.to_i}分前"
    #   when t < 1.day.to_i    then "#{t / 1.hour.to_i}時間前"
    #   else                        "#{t / 1.day.to_i}日前"
    #   end
    # },
    # :gmail_show_like3s  => proc {|time| " #{time.to_fs(:last_access)} "},
  })

# strftime("%J") で日本語の曜日表示
#
#   Time.prepend(WeekNameSupport)
#   Time.current.strftime("%J") # => "土"
#
module WeekNameSupport
  def strftime(format)
    super(format.gsub(/%J/, I18n.t("date.abbr_day_names")[wday]))
  end
end

[Time, Date, DateTime].each do |klass|
  klass.prepend(WeekNameSupport)
end

if $0 == __FILE__
  current_time = Time.current
  Time::DATE_FORMATS.keys.sort_by { |key| key.to_s }.each { |key|
    puts "%-40s %s" % [key, current_time.to_s(key)]
  }
end

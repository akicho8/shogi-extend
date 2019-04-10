Time::DATE_FORMATS.update({
    ymdhm: "%F %H:%M",
    ymdhms: "%F %T",
    ymd: "%F",

    battle_long: "%F %H:%M",
    battle_short: "%H:%M",
    csa_ymdhms: "%Y/%m/%d %H:%M:%S",

    # :ymd     => "%y/%m/%d",
    # :yymdhm  => "%Y/%m/%d %R",
    # :yymdhms => "%Y/%m/%d %X",
    # :ymdhm   => "%y/%m/%d %R",
    # :ymdhms  => "%y/%m/%d %X",
    # :mdhm    => "%m/%d %R",
    # :mdhms   => "%m/%d %X",
    # :hms     => "%X",
    # :hm      => "%R",
    # :exec_distance => proc {|time; gap, before_after|
    #   gap = time - Time.current
    #   before_after = (gap <= 0 ? '前' : '後')
    #   "#{time.to_s(:hms)}(#{time.to_s(:battle_time)}#{before_after})"
    # },

    # battle_time: proc {|time|
    #   # key = :battle_long
    #   # if time >= Time.current.midnight
    #   #   key = :battle_short
    #   # end
    #   # time.to_s(key)
    # },

    # # "3日後"
    # :distance => proc {|time; gap, before_after|
    #   gap = (time.to_i - Time.current.to_i).to_i  # 秒
    #   before_after = ""
    #   if gap != 0
    #     before_after = (gap < 0 ? '前' : '後')
    #   end
    #   "#{time.to_s(:battle_time)}#{before_after}"
    # },
    # :diff => proc {|time| time.to_s(:distance)},
    #
    # "3日"
    :battle_time => proc { |time|
      d = time - Time.current
      suffix = d.negative? ? '前' : '後'
      t = d.abs
      case
        # when time >= Time.current.midnight
      when time >= 1.days.ago
        time.to_s(:battle_short)
      when t < 1.minute then "#{t.div(1.second)}秒#{suffix}"
      when t < 1.hour   then "#{t.div(1.minute)}分#{suffix}"
      when t < 1.day    then "#{t.div(1.hour)}時間#{suffix}"
        # when t < 1.week   then "#{t.div(1.day}日#{suffix}"
      when t < 1.month  then "#{t.div(1.day)}日#{suffix}"
      when t < 1.year   then "#{t.div(1.month)}ヶ月#{suffix}"
      else                  "#{t.div(1.year)}年#{suffix}"
      end
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
    # :gmail_show_like   => proc {|time| "#{time.to_s(:gmail_index_like)} (#{time.to_s(:distance)})"},
    # :gmail_show_like2  => proc {|time| " #{time.to_s(:gmail_show_like)} "},
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
    # :gmail_show_like3s  => proc {|time| " #{time.to_s(:last_access)} "},
  })

if $0 == __FILE__
  current_time = Time.current
  Time::DATE_FORMATS.keys.sort_by {|key| key.to_s}.each {|key|
    puts "%-40s %s" % [key, current_time.to_s(key)]
  }
end

# 時間チャート
#
# user1 = Swars::User.create!(:key => "devuser1")
# user2 = Swars::User.create!(:key => "devuser2")
#
# record = Swars::Battle.new
# record.final_key = :TIMEOUT
# record.memberships.build(user: user1)
# record.memberships.build(user: user2)
# record.save!
#
# record.memberships[1].leave_alone_seconds # => 10 minutes and -10 seconds
# record.memberships[0].think_max           # => 5
# record.memberships[1].think_max           # => 590
# record.memberships[0].time_chart_xy_list  # => [{:x=>1, :y=>1 second}, {:x=>3, :y=>5 seconds}, {:x=>5, :y=>2 seconds}]
# record.memberships[1].time_chart_xy_list  # => [{:x=>2, :y=>-3 seconds}, {:x=>4, :y=>-7 seconds}, {:x=>6, :y=>-10 minutes and 10 seconds}]
# record.time_chart_label_max               # => 6
#
# experiment/0260_swars_battle_time_chart.rb
#
module TimeChartMod
  extend ActiveSupport::Concern

  def time_chart_datasets
    raise NotImplementedError, "#{__method__} is not implemented"
  end

  def time_chart_params
    {
      labels: (0..time_chart_label_max).to_a, # (1..turn_max) ではなくデータを元に作る
      datasets: time_chart_datasets,
    }
  end

  def time_chart_label_max
    Bioshogi::Location.collect { |e| time_chart_sec_list_of(e).size }.sum
  end

  # FreeBattle 用
  # Swars::Battle では変更する
  # [{:x=>1, :y=>10 seconds}, {:x=>3, :y=>20 seconds}]
  def time_chart_sec_list_of(location)
    raw_sec_list(location)
  end

  # location の [10, 20] を返す
  def raw_sec_list(location)
    location = Bioshogi::Location[location]

    @raw_sec_list ||= {}
    @raw_sec_list[location] ||= -> {
      c = Bioshogi::Location.count
      pos = preset_info.to_turn_info.current_location(location.code).code # 先手後手の順だけど駒落ちなら、後手先手の順になる
      v = fast_parsed_info.move_infos.find_all.with_index { |e, i| i.modulo(c) == pos }
      v.collect { |e| e[:used_seconds] }
    }.call
  end

  def raw_sec_list_all
    @raw_sec_list_all ||= fast_parsed_info.move_infos.find_all.collect { |e| e[:used_seconds] }
  end

  # location の [{:x=>1, :y=>10}, {:x=>3, :y=>20}] を返す
  def time_chart_xy_list(location)
    # c = Bioshogi::Location.count
    # loc = preset_info.to_turn_info.current_location(location.code)
    # time_chart_sec_list_of(location).collect.with_index { |e, i| { x: 1 + loc.code + i * c, y: location.value_sign * (e || 0) } } # 表示上「1手目」と表記したいので +1

    location = Bioshogi::Location[location]

    c = Bioshogi::Location.count
    loc = preset_info.to_turn_info.current_location(location.code)

    a = time_chart_sec_list_of(location)
    it = a.each
    (0..time_chart_label_max).collect do |i|
      x = i
      y = nil
      if i >= 1
        if (loc.code + i).modulo(c).nonzero?
          y = location.value_sign * (it.next || 0)
        end
      end
      # いまのところ x は 0 から始まるインデックスと同じなので省略して値だけにもできる
      # x, y は予約語。他にも追加していい
      { x: x, y: y }
    end
  end
end

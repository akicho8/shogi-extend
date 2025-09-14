# 時間チャート
#
# user1 = Swars::User.create!(:key => "DevUser1")
# user2 = Swars::User.create!(:key => "DevUser2")
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
# workbench/0260_swars_battle_time_chart.rb
#
module TimeChartMethods
  extend ActiveSupport::Concern

  def time_chart_datasets
    raise NotImplementedError, "#{__method__} is not implemented"
  end

  def time_chart_params
    labels = (0..time_chart_label_max).to_a # (1..turn_max) ではなくデータを元に作る
    {
      :tcv_normal => {
        :labels   => labels,
        :datasets => time_chart_datasets(false),
      },
      :tcv_accretion => {
        :labels   => labels,
        :datasets => time_chart_datasets(true),
      },
    }
  end

  # ウォーズのデータ不整合で先後でデータ数が2つ以上異なる場合があるため sum ではなく大きい方を2倍する
  # これでグラフ内に必ず収まる
  def time_chart_label_max
    LocationInfo.collect { |e| time_chart_sec_list_of(e).size }.max * 2
  end

  # FreeBattle 用
  # Swars::Battle では変更する
  # [{:x=>1, :y=>10 seconds}, {:x=>3, :y=>20 seconds}]
  def time_chart_sec_list_of(location_info)
    raw_sec_list(location_info)
  end

  # location_info の [10, 20] を返す
  def raw_sec_list(location_info)
    location_info = LocationInfo.fetch(location_info)

    @raw_sec_list ||= {}
    @raw_sec_list[location_info] ||= yield_self do
      c = LocationInfo.count
      pos = preset_info.to_turn_info.current_location(location_info.code).code # 先手後手の順だけど駒落ちなら、後手先手の順になる
      v = fast_parsed_info.pi.move_infos.find_all.with_index { |e, i| i.modulo(c) == pos }
      v.collect { |e| e[:used_seconds] || 0 }
    end
  end

  def raw_sec_list_all
    @raw_sec_list_all ||= fast_parsed_info.pi.move_infos.find_all.collect { |e| e[:used_seconds] }
  end

  # location_info の [{:x=>1, :y=>10}, {:x=>3, :y=>20}] を返す
  def time_chart_xy_list2(location_info, accretion)
    location_info = LocationInfo.fetch(location_info)
    list = time_chart_xy_list3(location_info)
    if accretion
      acc = 0
      list = list.collect { |e|
        if y = e[:y]
          acc += y
        end
        { x: e[:x], y: y ? acc : nil }
      }
    end
    list
  end

  private

  def time_chart_xy_list3(location_info)
    @time_chart_xy_list3 ||= {}
    @time_chart_xy_list3[location_info.key] ||= time_chart_xy_list4(location_info)
  end

  # location_info の [{:x=>1, :y=>10}, {:x=>3, :y=>20}] を返す
  def time_chart_xy_list4(location_info)
    # c = LocationInfo.count
    # loc = preset_info.to_turn_info.current_location(location_info.code)
    # time_chart_sec_list_of(location_info).collect.with_index { |e, i| { x: 1 + loc.code + i * c, y: location_info.sign_dir * (e || 0) } } # 表示上「1手目」と表記したいので +1

    location_info = LocationInfo[location_info]

    c = LocationInfo.count
    loc = preset_info.to_turn_info.current_location(location_info.code)

    a = time_chart_sec_list_of(location_info)

    # raise memberships[0].sec_list.collect(&:to_i).inspect

    list = []
    it = a.each
    #
    # もともとはこの方法だったがウォーズのデータが壊れていて指し手が先手と後手で2つ以上異なる場合がある
    # 例えば先手は50手分のデータがあるのに後手は48手までしかないなど
    # なので (0..time_chart_label_max) までデータがある想定でいくと StopIteration の例外が発生する場合がある
    # なので逆に StopIteration が発生するまで取り込む
    #
    0.step do |i|
      x = i
      y = nil
      begin
        if i >= 1
          if (loc.code + i).modulo(c).nonzero?
            y = location_info.sign_dir * (it.next || 0)
          end
        end
      rescue StopIteration
        break
      end
      # いまのところ x は 0 から始まるインデックスと同じなので省略して値だけにもできる
      # x, y は予約語。他にも追加していい
      list << { x: x, y: y }
    end

    list
  end
end

module TimeChartMod
  extend ActiveSupport::Concern

  def time_chart_datasets
    raise NotImplementedError, "#{__method__} is not implemented"
  end

  def time_chart_params
    {
      labels: (1..time_chart_label_max).to_a, # (1..turn_max) ではなくデータを元に作る
      datasets: time_chart_datasets.collect.with_index { |e, i| e.merge(time_chart_dataset_default(i)) },
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

  # location の [{:x=>1, :y=>10 seconds}, {:x=>3, :y=>20 seconds}] を返す
  def time_chart_xy_hash_list(location)
    c = Bioshogi::Location.count
    loc = preset_info.to_turn_info.current_location(location.code)
    time_chart_sec_list_of(location).collect.with_index { |e, i| { x: 1 + loc.code + i * c, y: location.value_sign * (e || 0) } } # 表示上「1手目」と表記したいので +1
  end

  def time_chart_dataset_default(i)
    {
      borderColor: PaletteInfo[i].border_color,
      backgroundColor: PaletteInfo[i].background_color,
      fill: true,               # 塗り潰す？
      pointRadius: 1.2,         # 点半径
      borderWidth: 1,           # 点枠の太さ
      pointHoverRadius: 5,      # 点半径(アクティブ時)
      pointHoverBorderWidth: 2, # 点枠の太さ(アクティブ時)
      pointHitRadius: 5,        # タップできる大きさ
      showLine: true,           # 線で繋げる
      lineTension: 0.2,         # 0なら線がカクカクになる
    }
  end
end

module SwarsMedalSupport
  extend self

  def black_ibisha
    "+2726FU"
  end

  def black_furibisha
    "+2878HI"
  end

  # 残り秒数
  def life
    600
  end

  def csa_seq_generate1(size)
    Swars::KifuGenerator.generate(size: size)
  end

  # n手分ノータイム指し 最後だけ sec 秒
  def csa_seq_generate2(n, sec)
    list = csa_seq_generate1(n)
    v = list.pop
    v = [v.first, life - sec]
    list + [v]
  end

  # 2手1組としてn手分sec秒ずつ指す
  def csa_seq_generate3(n, sec)
    n.times.flat_map do |i|
      seconds = life - (i * sec.seconds)
      [["+5958OU", seconds], ["-5152OU", seconds], ["+5859OU", seconds], ["-5251OU", seconds]]
    end
  end

  # 指し手の平均用
  def csa_seq_generate5(seconds = [100, 200])
    [
      ["+5958OU", life - seconds[0]],
      ["-5152OU", life],
      ["+5859OU", life - seconds[0] - seconds[1]],
      ["-5251OU", life],
    ]
  end

  # 先手は居玉
  def csa_seq_generate6(n)
    [["+2858HI", life], ["-5152OU", life], ["+5828HI", life], ["-5251OU", life]].cycle.take(n)
  end

  # 先手居飛車でN手の棋譜を生成
  def ibisha_csa_seq_generate(n)
    [ [black_ibisha, life], ["-1112KY", life] ] + csa_seq_generate1(n - 2)
  end

  # 先手振り飛車でN手の棋譜を生成
  def furibisha_csa_seq_generate(n)
    [ [black_furibisha, life], ["-1112KY", life] ] + csa_seq_generate1(n - 2)
  end
end

RSpec::Rails::ModelExampleGroup.module_eval do
  include SwarsMedalSupport
end

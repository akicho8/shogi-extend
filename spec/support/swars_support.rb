RSpec::Rails::ModelExampleGroup.module_eval do
  concerning :SwarsSupport do
    # 残り秒数
    def life
      600
    end

    # 開戦する
    def outbreak_csa
      [
        ["+1716FU", life],
        ["-1314FU", life],
        ["+1615FU", life],
        ["-1415FU", life],
        ["+1915KY", life],
        ["-1115KY", life],
      ]
    end

    def csa_seq_generate1(n, sec: 0)
      rest = life - sec
      [
        ["+5958OU", rest],
        ["-5152OU", rest],
        ["+5859OU", rest],
        ["-5251OU", rest],
      ].cycle.take(n)
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

    # 棋神乱用
    def csa_seq_generate4(n, sec = 2)
      outbreak_csa + n.times.flat_map do |i|
        seconds = life - (i * (sec * 2))
        [["+5958OU", seconds], ["-5152OU", seconds], ["+5859OU", seconds - sec], ["-5251OU", seconds]]
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
  end
end

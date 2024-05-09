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

  # 先手は居玉
  def csa_seq_generate6(n)
    
  end

  # 先手居飛車でN手の棋譜を生成
  def ibisha_csa_seq_generate(n)
    [ [black_ibisha, life], ["-1112KY", life] ] + Swars::KifuGenerator.generate_n(n - 2)
  end

  # 先手振り飛車でN手の棋譜を生成
  def furibisha_csa_seq_generate(n)
    [ [black_furibisha, life], ["-1112KY", life] ] + Swars::KifuGenerator.generate_n(n - 2)
  end
end

RSpec::Rails::ModelExampleGroup.module_eval do
  include SwarsMedalSupport
end

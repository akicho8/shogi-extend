# AiCop.obt_auto_max_gteq
module Swars
  module AiCop
    mattr_accessor(:obt_auto_max_gteq) { 10 } # 1,2秒がN回以上続けば棋神の疑い
  end
end

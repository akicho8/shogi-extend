module Wbook
  module Converter
    extend self

    def sfen_to_kif_str(sfen)
      Bioshogi::Parser.parse(sfen).to_kif
    end

    def sfen_to_ki2_str(sfen)
      parse(sfen).mediator.hand_logs.collect { |e|
        e.to_ki2({
            :with_location => true,            # 先手後手のマークを入れる？
            :force_drop    => true,            # 「打」を省略できるときでも「打」を明示する？
            :place_format  => :hankaku_number, # name は "3四" で zenkaku_number は "３４" で hankaku_number なら "34"
            :char_type     => :formal_sheet,   # 駒表記を「全」ではなく「成銀」のようにする
          })
      }.join(" ")
    end

    def parse(sfen)
      Bioshogi::Parser.parse(sfen, {
          :skill_monitor_enable           => false,
          :skill_monitor_technique_enable => false,
        })
    end
  end
end

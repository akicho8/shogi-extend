# rails r 'Swars::Battle::InitialImportForPaper.new.perform'
module Swars
  class Battle
    class InitialImportForPaper
      def perform
        tp "棋譜用紙の境界線チェック用データ投入"
        tp Battle.count
        patterns.each(&method(:battle_create!))
        tp Battle.count
      end

      private

      def battle_create!(params)
        Battle.create!(preset_key: params[:preset_key], csa_seq: csa_seq_for(params))
      end

      def csa_seq_for(params)
        if params[:preset_key] == "平手"
          list = [["+5958OU", 0], ["-5152OU", 0], ["+5859OU", 0], ["-5251OU", 0]]
        else
          list = [["-5152OU", 0], ["+5958OU", 0], ["-5251OU", 0], ["+5859OU", 0]]
        end
        it = list.cycle
        params[:turn_max].times.collect { it.next }
      end

      def patterns
        [
          { turn_max:   0, preset_key: "平手",   },
          { turn_max:   1, preset_key: "平手",   },
          { turn_max: 149, preset_key: "平手",   },
          { turn_max: 150, preset_key: "平手",   },
          { turn_max: 151, preset_key: "平手",   },
          { turn_max:   0, preset_key: "香落ち", },
          { turn_max:   1, preset_key: "香落ち", },
          { turn_max: 149, preset_key: "香落ち", },
          { turn_max: 150, preset_key: "香落ち", },
          { turn_max: 151, preset_key: "香落ち", },
          { turn_max: 152, preset_key: "香落ち", },
        ]
      end
    end
  end
end


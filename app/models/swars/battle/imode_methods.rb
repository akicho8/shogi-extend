module Swars
  class Battle
    concern :ImodeMethods do
      included do
        EVEN_MATCH_STARTING_POSITION = "lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1"

        custom_belongs_to :imode, ar_model: Imode, st_model: ImodeInfo, default: "通常"

        before_validation do
          if changes_to_save[:starting_position]
            # ほとんどが平手なので基本 DB に入れない
            if self.starting_position == EVEN_MATCH_STARTING_POSITION
              self.starting_position = nil
            end
            # 空文字列は nil にしておく
            self.starting_position = starting_position.presence
          end
        end
      end

      def starting_position_or_default
        starting_position || "position sfen #{EVEN_MATCH_STARTING_POSITION}"
      end
    end
  end
end

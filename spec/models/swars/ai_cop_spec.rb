require "rails_helper"

module Swars
  RSpec.describe AiCop, type: :model do
    describe "棋神判定" do
      def one
        [3, 1, 2, 2, 2]
      end

      it "works" do
        assert { Swars::AiCop.test([])                    == {:ai_drop_total=>nil, :ai_ticket_count=>nil, :ai_wave_count=>nil, :ai_two_freq=>nil} }
        assert { Swars::AiCop.test([0])                   == {:ai_drop_total=>nil, :ai_ticket_count=>nil, :ai_wave_count=>nil, :ai_two_freq=>0.0} }

        assert { Swars::AiCop.test([3])                   == {:ai_drop_total=>nil, :ai_ticket_count=>nil, :ai_wave_count=>nil, :ai_two_freq=>0.0} }
        assert { Swars::AiCop.test([3, 1, 2])             == {:ai_drop_total=>nil, :ai_ticket_count=>nil, :ai_wave_count=>nil, :ai_two_freq=>0.3333333333333333} }
        assert { Swars::AiCop.test([3, 1, 2, 2])          == {:ai_drop_total=>nil, :ai_ticket_count=>nil, :ai_wave_count=>nil, :ai_two_freq=>0.5} }
        assert { Swars::AiCop.test([3, 1, 2, 2, 2])       == {:ai_drop_total=>5, :ai_ticket_count=>1, :ai_wave_count=>1, :ai_two_freq=>0.6} }
        assert { Swars::AiCop.test([3, 1, 2, 2, 2, 2])    == {:ai_drop_total=>6, :ai_ticket_count=>2, :ai_wave_count=>1, :ai_two_freq=>0.6666666666666666} }

        assert { Swars::AiCop.test(one)                   == {:ai_drop_total=>5, :ai_ticket_count=>1, :ai_wave_count=>1, :ai_two_freq=>0.6} }
        assert { Swars::AiCop.test([3, 1, *one])          == {:ai_drop_total=>5, :ai_ticket_count=>1, :ai_wave_count=>1, :ai_two_freq=>0.42857142857142855} }
        assert { Swars::AiCop.test([3, 1, 2, *one])       == {:ai_drop_total=>5, :ai_ticket_count=>1, :ai_wave_count=>1, :ai_two_freq=>0.5} }
        assert { Swars::AiCop.test([3, 1, 2, 2, *one])    == {:ai_drop_total=>5, :ai_ticket_count=>1, :ai_wave_count=>1, :ai_two_freq=>0.5555555555555556} }
        assert { Swars::AiCop.test([3, 1, 2, 2, 2, *one]) == {:ai_drop_total=>10, :ai_ticket_count=>2, :ai_wave_count=>2, :ai_two_freq=>0.6} }
        assert { Swars::AiCop.test([*one, *one, *one])    == {:ai_drop_total=>15, :ai_ticket_count=>3, :ai_wave_count=>3, :ai_two_freq=>0.6} }

        assert { Swars::AiCop.test([3, 1, 2, 1, 2])       == {:ai_drop_total=>nil, :ai_ticket_count=>nil, :ai_wave_count=>nil, :ai_two_freq=>0.4} }
        assert { Swars::AiCop.test([3, 1, 2, 3, 2])       == {:ai_drop_total=>nil, :ai_ticket_count=>nil, :ai_wave_count=>nil, :ai_two_freq=>0.4} }
      end

      it "used?" do
        assert { Swars::AiCop.used?(one) }
      end

      it "analize" do
        assert { Swars::AiCop.analize(one).ai_drop_total == 5 }
      end

      # it "ai_drop_total" do
      #   assert { Swars::AiCop.ai_drop_total(one) == 5 }
      # end
    end
  end
end
# >> Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >> 
# >> Swars::AiCop
# >>   棋神判定
# >>     works
# >>     used?
# >>     analize
# >> 
# >> Top 3 slowest examples (0.38807 seconds, 15.0% of total time):
# >>   Swars::AiCop 棋神判定 works
# >>     0.19864 seconds -:10
# >>   Swars::AiCop 棋神判定 analize
# >>     0.12561 seconds -:35
# >>   Swars::AiCop 棋神判定 used?
# >>     0.06382 seconds -:31
# >> 
# >> Finished in 2.59 seconds (files took 4.13 seconds to load)
# >> 3 examples, 0 failures
# >> 

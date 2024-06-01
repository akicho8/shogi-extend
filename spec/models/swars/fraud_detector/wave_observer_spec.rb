require "rails_helper"

module Swars
  RSpec.describe FraudDetector::WaveObserver, type: :model do
    describe "棋神判定" do
      def one
        [3, 1, 2, 2, 2]
      end

      it "works" do
        assert { FraudDetector::WaveObserver.test([])                    == {:drop_total=>0, :wave_count=>0,  :ticket_count=>nil} }
        assert { FraudDetector::WaveObserver.test([0])                   == {:drop_total=>0, :wave_count=>0,  :ticket_count=>nil} }

        assert { FraudDetector::WaveObserver.test([3])                   == {:drop_total=>0, :wave_count=>0,  :ticket_count=>nil} }
        assert { FraudDetector::WaveObserver.test([3, 1, 2])             == {:drop_total=>0, :wave_count=>0,  :ticket_count=>nil} }
        assert { FraudDetector::WaveObserver.test([3, 1, 2, 2])          == {:drop_total=>0, :wave_count=>0,  :ticket_count=>nil} }
        assert { FraudDetector::WaveObserver.test([3, 1, 2, 2, 2])       == {:drop_total=>5, :wave_count=>1,  :ticket_count=>1} }
        assert { FraudDetector::WaveObserver.test([3, 1, 2, 2, 2, 2])    == {:drop_total=>6, :wave_count=>1,  :ticket_count=>2} }

        assert { FraudDetector::WaveObserver.test(one)                   == {:drop_total=>5, :wave_count=>1,  :ticket_count=>1} }
        assert { FraudDetector::WaveObserver.test([3, 1, *one])          == {:drop_total=>5, :wave_count=>1,  :ticket_count=>1} }
        assert { FraudDetector::WaveObserver.test([3, 1, 2, *one])       == {:drop_total=>5, :wave_count=>1,  :ticket_count=>1} }
        assert { FraudDetector::WaveObserver.test([3, 1, 2, 2, *one])    == {:drop_total=>5, :wave_count=>1,  :ticket_count=>1} }
        assert { FraudDetector::WaveObserver.test([3, 1, 2, 2, 2, *one]) == {:drop_total=>10, :wave_count=>2, :ticket_count=>2} }
        assert { FraudDetector::WaveObserver.test([*one, *one, *one])    == {:drop_total=>15, :wave_count=>3, :ticket_count=>3} }

        assert { FraudDetector::WaveObserver.test([3, 1, 2, 1, 2])       == {:drop_total=>0, :wave_count=>0, :ticket_count=>nil} }
        assert { FraudDetector::WaveObserver.test([3, 1, 2, 3, 2])       == {:drop_total=>0, :wave_count=>0, :ticket_count=>nil} }

        tanpatu = [1, 1, 2, 1, 2, 1, 1, 1, 1, 3, 2, 2, 11, 1, 4, 4, 1, 2, 2, 2, 4, 1, 2, 2, 2, 4, 1, 2, 2, 2, 4, 1, 2, 2, 2, 4, 1, 2, 2, 2, 1, 4, 1, 2, 2, 2, 4, 1, 2, 2, 2, 4, 1, 2, 2, 2, 3, 2, 2, 2, 2, 4, 2, 1, 2, 2, 4, 2, 1, 2, 2, 4, 1, 2, 2, 2, 2, 3, 1, 2, 5]
        renpatu = [0, 1, 0, 2, 0, 1, 0, 1, 1, 1, 1, 1, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 2, 3, 2, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 3, 2, 2, 2, 2, 2, 2, 2]
        assert { FraudDetector::WaveObserver.test(tanpatu)    == {:drop_total=>46, :wave_count=>9, :ticket_count=>10} }
        assert { FraudDetector::WaveObserver.test(renpatu)    == {:drop_total=>0, :wave_count=>0,  :ticket_count=>nil} }
      end

      it "used?" do
        assert { FraudDetector::WaveObserver.used?(one) }
      end

      it "parse" do
        assert { FraudDetector::WaveObserver.parse(one).drop_total == 5 }
      end
    end
  end
end
# >> Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >> 
# >> Swars::FraudDetector::WaveObserver
# >>   棋神判定
# >>     works
# >>     used?
# >>     parse
# >> 
# >> Top 3 slowest examples (0.3592 seconds, 14.3% of total time):
# >>   Swars::FraudDetector::WaveObserver 棋神判定 works
# >>     0.21996 seconds -:10
# >>   Swars::FraudDetector::WaveObserver 棋神判定 used?
# >>     0.0761 seconds -:36
# >>   Swars::FraudDetector::WaveObserver 棋神判定 parse
# >>     0.06315 seconds -:40
# >> 
# >> Finished in 2.51 seconds (files took 1.6 seconds to load)
# >> 3 examples, 0 failures
# >> 

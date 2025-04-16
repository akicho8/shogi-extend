require "rails_helper"

RSpec.describe Swars::FraudDetector::WaveObserver, type: :model do
  describe "棋神判定" do
    def one
      [3, 1, 2, 2, 2]
    end

    it "works" do
      assert { Swars::FraudDetector::WaveObserver.test([])                    == { :ai_drop_total => 0, :ai_wave_count => 0,  } }
      assert { Swars::FraudDetector::WaveObserver.test([0])                   == { :ai_drop_total => 0, :ai_wave_count => 0,  } }

      assert { Swars::FraudDetector::WaveObserver.test([3])                   == { :ai_drop_total => 0, :ai_wave_count => 0,  } }
      assert { Swars::FraudDetector::WaveObserver.test([3, 1, 2])             == { :ai_drop_total => 0, :ai_wave_count => 0,  } }
      assert { Swars::FraudDetector::WaveObserver.test([3, 1, 2, 2])          == { :ai_drop_total => 0, :ai_wave_count => 0,  } }
      assert { Swars::FraudDetector::WaveObserver.test([3, 1, 2, 2, 2])       == { :ai_drop_total => 5, :ai_wave_count => 1,  } }
      assert { Swars::FraudDetector::WaveObserver.test([3, 1, 2, 2, 2, 2])    == { :ai_drop_total => 6, :ai_wave_count => 1,  } }

      assert { Swars::FraudDetector::WaveObserver.test(one)                   == { :ai_drop_total => 5, :ai_wave_count => 1,  } }
      assert { Swars::FraudDetector::WaveObserver.test([3, 1, *one])          == { :ai_drop_total => 5, :ai_wave_count => 1,  } }
      assert { Swars::FraudDetector::WaveObserver.test([3, 1, 2, *one])       == { :ai_drop_total => 5, :ai_wave_count => 1,  } }
      assert { Swars::FraudDetector::WaveObserver.test([3, 1, 2, 2, *one])    == { :ai_drop_total => 5, :ai_wave_count => 1,  } }
      assert { Swars::FraudDetector::WaveObserver.test([3, 1, 2, 2, 2, *one]) == { :ai_drop_total => 10, :ai_wave_count => 2, } }
      assert { Swars::FraudDetector::WaveObserver.test([*one, *one, *one])    == { :ai_drop_total => 15, :ai_wave_count => 3, } }

      assert { Swars::FraudDetector::WaveObserver.test([3, 1, 2, 1, 2])       == { :ai_drop_total => 0, :ai_wave_count => 0, } }
      assert { Swars::FraudDetector::WaveObserver.test([3, 1, 2, 3, 2])       == { :ai_drop_total => 0, :ai_wave_count => 0, } }

      tanpatu = [1, 1, 2, 1, 2, 1, 1, 1, 1, 3, 2, 2, 11, 1, 4, 4, 1, 2, 2, 2, 4, 1, 2, 2, 2, 4, 1, 2, 2, 2, 4, 1, 2, 2, 2, 4, 1, 2, 2, 2, 1, 4, 1, 2, 2, 2, 4, 1, 2, 2, 2, 4, 1, 2, 2, 2, 3, 2, 2, 2, 2, 4, 2, 1, 2, 2, 4, 2, 1, 2, 2, 4, 1, 2, 2, 2, 2, 3, 1, 2, 5]
      renpatu = [0, 1, 0, 2, 0, 1, 0, 1, 1, 1, 1, 1, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 2, 3, 2, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 3, 2, 2, 2, 2, 2, 2, 2]
      assert { Swars::FraudDetector::WaveObserver.test(tanpatu)    == { :ai_drop_total => 46, :ai_wave_count => 9, } }
      assert { Swars::FraudDetector::WaveObserver.test(renpatu)    == { :ai_drop_total => 0, :ai_wave_count => 0,  } }
    end

    it "used?" do
      assert { Swars::FraudDetector::WaveObserver.used?(one) }
    end

    it "parse" do
      assert { Swars::FraudDetector::WaveObserver.parse(one).drop_total == 5 }
    end
  end
end
# >> Swars::Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >>
# >> Swars::FraudDetector::WaveObserver
# >>   棋神判定
# >>     works
# >>     used?
# >>     parse
# >>
# >> Swars::Top 3 slowest examples (0.22312 seconds, 11.2% of total time):
# >>   Swars::FraudDetector::WaveObserver 棋神判定 works
# >>     0.1286 seconds -:10
# >>   Swars::FraudDetector::WaveObserver 棋神判定 parse
# >>     0.04838 seconds -:40
# >>   Swars::FraudDetector::WaveObserver 棋神判定 used?
# >>     0.04615 seconds -:36
# >>
# >> Swars::Finished in 1.99 seconds (files took 1.09 seconds to load)
# >> 3 examples, 0 failures
# >>

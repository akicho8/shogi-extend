require "../setup"

one = [3, 1, 2, 2, 2]

Swars::FraudDetector::WaveObserver.test([])                    # => {:ai_drop_total=>0, :ai_wave_count=>0}
Swars::FraudDetector::WaveObserver.test([0])                   # => {:ai_drop_total=>0, :ai_wave_count=>0}

Swars::FraudDetector::WaveObserver.test([3])                   # => {:ai_drop_total=>0, :ai_wave_count=>0}
Swars::FraudDetector::WaveObserver.test([3, 1, 2])             # => {:ai_drop_total=>0, :ai_wave_count=>0}
Swars::FraudDetector::WaveObserver.test([3, 1, 2, 2])          # => {:ai_drop_total=>0, :ai_wave_count=>0}
Swars::FraudDetector::WaveObserver.test([3, 1, 2, 2, 2])       # => {:ai_drop_total=>5, :ai_wave_count=>1}
Swars::FraudDetector::WaveObserver.test([3, 1, 2, 2, 2, 2])    # => {:ai_drop_total=>6, :ai_wave_count=>1}

Swars::FraudDetector::WaveObserver.test(one)                   # => {:ai_drop_total=>5, :ai_wave_count=>1}
Swars::FraudDetector::WaveObserver.test([3, 1, *one])          # => {:ai_drop_total=>5, :ai_wave_count=>1}
Swars::FraudDetector::WaveObserver.test([3, 1, 2, *one])       # => {:ai_drop_total=>5, :ai_wave_count=>1}
Swars::FraudDetector::WaveObserver.test([3, 1, 2, 2, *one])    # => {:ai_drop_total=>5, :ai_wave_count=>1}
Swars::FraudDetector::WaveObserver.test([3, 1, 2, 2, 2, *one]) # => {:ai_drop_total=>10, :ai_wave_count=>2}
Swars::FraudDetector::WaveObserver.test([*one, *one, *one])    # => {:ai_drop_total=>15, :ai_wave_count=>3}

Swars::FraudDetector::WaveObserver.test([3, 1, 2, 1, 2])       # => {:ai_drop_total=>0, :ai_wave_count=>0}
Swars::FraudDetector::WaveObserver.test([3, 1, 2, 3, 2])       # => {:ai_drop_total=>0, :ai_wave_count=>0}

tanpatu = [1, 1, 2, 1, 2, 1, 1, 1, 1, 3, 2, 2, 11, 1, 4, 4, 1, 2, 2, 2, 4, 1, 2, 2, 2, 4, 1, 2, 2, 2, 4, 1, 2, 2, 2, 4, 1, 2, 2, 2, 1, 4, 1, 2, 2, 2, 4, 1, 2, 2, 2, 4, 1, 2, 2, 2, 3, 2, 2, 2, 2, 4, 2, 1, 2, 2, 4, 2, 1, 2, 2, 4, 1, 2, 2, 2, 2, 3, 1, 2, 5]
renpatu = [0, 1, 0, 2, 0, 1, 0, 1, 1, 1, 1, 1, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 2, 3, 2, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 3, 2, 2, 2, 2, 2, 2, 2]
Swars::FraudDetector::WaveObserver.test(tanpatu)    # => {:ai_drop_total=>46, :ai_wave_count=>9}
Swars::FraudDetector::WaveObserver.test(renpatu)    # => {:ai_drop_total=>0, :ai_wave_count=>0}

Swars::FraudDetector::WaveObserver.parse(one).drop_total # => 5

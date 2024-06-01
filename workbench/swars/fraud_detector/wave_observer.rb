require "../setup"

one = [3, 1, 2, 2, 2]

Swars::FraudDetector::WaveObserver.test([])                    # => {:drop_total=>0, :wave_count=>0, :ticket_count=>nil}
Swars::FraudDetector::WaveObserver.test([0])                   # => {:drop_total=>0, :wave_count=>0, :ticket_count=>nil}

Swars::FraudDetector::WaveObserver.test([3])                   # => {:drop_total=>0, :wave_count=>0, :ticket_count=>nil}
Swars::FraudDetector::WaveObserver.test([3, 1, 2])             # => {:drop_total=>0, :wave_count=>0, :ticket_count=>nil}
Swars::FraudDetector::WaveObserver.test([3, 1, 2, 2])          # => {:drop_total=>0, :wave_count=>0, :ticket_count=>nil}
Swars::FraudDetector::WaveObserver.test([3, 1, 2, 2, 2])       # => {:drop_total=>5, :wave_count=>1, :ticket_count=>1}
Swars::FraudDetector::WaveObserver.test([3, 1, 2, 2, 2, 2])    # => {:drop_total=>6, :wave_count=>1, :ticket_count=>2}

Swars::FraudDetector::WaveObserver.test(one)                   # => {:drop_total=>5, :wave_count=>1, :ticket_count=>1}
Swars::FraudDetector::WaveObserver.test([3, 1, *one])          # => {:drop_total=>5, :wave_count=>1, :ticket_count=>1}
Swars::FraudDetector::WaveObserver.test([3, 1, 2, *one])       # => {:drop_total=>5, :wave_count=>1, :ticket_count=>1}
Swars::FraudDetector::WaveObserver.test([3, 1, 2, 2, *one])    # => {:drop_total=>5, :wave_count=>1, :ticket_count=>1}
Swars::FraudDetector::WaveObserver.test([3, 1, 2, 2, 2, *one]) # => {:drop_total=>10, :wave_count=>2, :ticket_count=>2}
Swars::FraudDetector::WaveObserver.test([*one, *one, *one])    # => {:drop_total=>15, :wave_count=>3, :ticket_count=>3}

Swars::FraudDetector::WaveObserver.test([3, 1, 2, 1, 2])       # => {:drop_total=>0, :wave_count=>0, :ticket_count=>nil}
Swars::FraudDetector::WaveObserver.test([3, 1, 2, 3, 2])       # => {:drop_total=>0, :wave_count=>0, :ticket_count=>nil}

tanpatu = [1, 1, 2, 1, 2, 1, 1, 1, 1, 3, 2, 2, 11, 1, 4, 4, 1, 2, 2, 2, 4, 1, 2, 2, 2, 4, 1, 2, 2, 2, 4, 1, 2, 2, 2, 4, 1, 2, 2, 2, 1, 4, 1, 2, 2, 2, 4, 1, 2, 2, 2, 4, 1, 2, 2, 2, 3, 2, 2, 2, 2, 4, 2, 1, 2, 2, 4, 2, 1, 2, 2, 4, 1, 2, 2, 2, 2, 3, 1, 2, 5]
renpatu = [0, 1, 0, 2, 0, 1, 0, 1, 1, 1, 1, 1, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 2, 3, 2, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 3, 2, 2, 2, 2, 2, 2, 2]
Swars::FraudDetector::WaveObserver.test(tanpatu)    # => {:drop_total=>46, :wave_count=>9, :ticket_count=>10}
Swars::FraudDetector::WaveObserver.test(renpatu)    # => {:drop_total=>0, :wave_count=>0, :ticket_count=>nil}

Swars::FraudDetector::WaveObserver.parse(one).drop_total # => 5

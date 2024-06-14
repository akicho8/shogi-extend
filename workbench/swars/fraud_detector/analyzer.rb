require "./setup"
Swars::FraudDetector::Analyzer.test([3, 1, 2, 2, 2, 1, 2, 1])    # => {:ai_two_freq=>0.5, :ai_drop_total=>5, :ai_wave_count=>1, :ai_noizy_two_max=>3, :ai_gear_freq=>0.125}

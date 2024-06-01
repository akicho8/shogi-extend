require "./setup"
Swars::FraudDetector::GearObserver.freq([])                            # => nil
Swars::FraudDetector::GearObserver.freq([1, 2])                        # => 0.0
Swars::FraudDetector::GearObserver.freq([1, 2, 2, 1])                  # => 0.0
Swars::FraudDetector::GearObserver.freq([1, 2, 1])                     # => 0.3333333333333333
Swars::FraudDetector::GearObserver.freq([1, 2, 1, 2, 1])               # => 0.4

require "./setup"
Swars::FraudDetector::NoizyTwoMaxObserver.max([])                                # => 0
Swars::FraudDetector::NoizyTwoMaxObserver.max([2])                               # => 1
Swars::FraudDetector::NoizyTwoMaxObserver.max([2, 2])                            # => 2
Swars::FraudDetector::NoizyTwoMaxObserver.max([2, 2, 1])                         # => 2
Swars::FraudDetector::NoizyTwoMaxObserver.max([2, 2, 2, 1])                      # => 3
Swars::FraudDetector::NoizyTwoMaxObserver.max([2, 2, 2, 2, 1])                   # => 5
Swars::FraudDetector::NoizyTwoMaxObserver.max([2, 2, 2, 2, 1, 2])                # => 6
Swars::FraudDetector::NoizyTwoMaxObserver.max([2, 2, 2, 2, 1, 2, 2])             # => 7
Swars::FraudDetector::NoizyTwoMaxObserver.max([2, 2, 2, 2, 1, 2, 2, 2])          # => 8
Swars::FraudDetector::NoizyTwoMaxObserver.max([2, 2, 2, 2, 1, 2, 2, 2, 1, 1, 2]) # => 8
Swars::FraudDetector::NoizyTwoMaxObserver.max([2, 2, 2, 2, 1, 2, 2, 2, 2, 1, 2]) # => 11
Swars::FraudDetector::NoizyTwoMaxObserver.max([3, 2, 3])                         # => 1
Swars::FraudDetector::NoizyTwoMaxObserver.max([3, 2, 3, 2, 2])                   # => 2
Swars::FraudDetector::NoizyTwoMaxObserver.max([2, 2, 2, 2, 2, 2, 2, 2, 1, 1, 2]) # => 9

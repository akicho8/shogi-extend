require "../setup"
Swars::FraudDetector::TwoObserver.parse([]).count        # => 0
Swars::FraudDetector::TwoObserver.parse([2]).count       # => 1
Swars::FraudDetector::TwoObserver.parse([2, 1, 2]).count # => 2

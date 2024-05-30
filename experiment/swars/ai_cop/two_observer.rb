require "../setup"
Swars::AiCop::TwoObserver.parse([]).count        # => 0
Swars::AiCop::TwoObserver.parse([2]).count       # => 1
Swars::AiCop::TwoObserver.parse([2, 1, 2]).count # => 2

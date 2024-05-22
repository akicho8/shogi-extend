require "./setup"
Swars::AiCop::GearObserver.freq([])                            # => nil
Swars::AiCop::GearObserver.freq([1, 2])                        # => 0.0
Swars::AiCop::GearObserver.freq([1, 2, 2, 1])                  # => 0.0
Swars::AiCop::GearObserver.freq([1, 2, 1])                     # => 0.3333333333333333
Swars::AiCop::GearObserver.freq([1, 2, 1, 2, 1])               # => 0.4

require "./setup"
Swars::AiCop::NtmObserver.max([])                                # => 0
Swars::AiCop::NtmObserver.max([2])                               # => 1
Swars::AiCop::NtmObserver.max([2, 2])                            # => 2
Swars::AiCop::NtmObserver.max([2, 2, 1])                         # => 2
Swars::AiCop::NtmObserver.max([2, 2, 2, 1])                      # => 3
Swars::AiCop::NtmObserver.max([2, 2, 2, 2, 1])                   # => 5
Swars::AiCop::NtmObserver.max([2, 2, 2, 2, 1, 2])                # => 6
Swars::AiCop::NtmObserver.max([2, 2, 2, 2, 1, 2, 2])             # => 7
Swars::AiCop::NtmObserver.max([2, 2, 2, 2, 1, 2, 2, 2])          # => 8
Swars::AiCop::NtmObserver.max([2, 2, 2, 2, 1, 2, 2, 2, 1, 1, 2]) # => 8
Swars::AiCop::NtmObserver.max([2, 2, 2, 2, 1, 2, 2, 2, 2, 1, 2]) # => 11
Swars::AiCop::NtmObserver.max([3, 2, 3])                         # => 1
Swars::AiCop::NtmObserver.max([3, 2, 3, 2, 2])                   # => 2
Swars::AiCop::NtmObserver.max([2, 2, 2, 2, 2, 2, 2, 2, 1, 1, 2]) # => 9

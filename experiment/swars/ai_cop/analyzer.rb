#!/usr/bin/env ruby
require File.expand_path('../../../../config/environment', __FILE__)

one = [3, 1, 2, 2, 2]

Swars::AiCop::Analyzer.test([])                    # => {:drop_total=>0, :wave_count=>0, :two_count=>0, :two_freq=>0, :noizy_two_max=>0, :ticket_count=>nil}
Swars::AiCop::Analyzer.test([0])                   # => {:drop_total=>0, :wave_count=>0, :two_count=>0, :two_freq=>0.0, :noizy_two_max=>0, :ticket_count=>nil}

Swars::AiCop::Analyzer.test([3])                   # => {:drop_total=>0, :wave_count=>0, :two_count=>0, :two_freq=>0.0, :noizy_two_max=>0, :ticket_count=>nil}
Swars::AiCop::Analyzer.test([3, 1, 2])             # => {:drop_total=>0, :wave_count=>0, :two_count=>1, :two_freq=>0.3333333333333333, :noizy_two_max=>1, :ticket_count=>nil}
Swars::AiCop::Analyzer.test([3, 1, 2, 2])          # => {:drop_total=>0, :wave_count=>0, :two_count=>2, :two_freq=>0.5, :noizy_two_max=>2, :ticket_count=>nil}
Swars::AiCop::Analyzer.test([3, 1, 2, 2, 2])       # => {:drop_total=>5, :wave_count=>1, :two_count=>3, :two_freq=>0.6, :noizy_two_max=>3, :ticket_count=>1}
Swars::AiCop::Analyzer.test([3, 1, 2, 2, 2, 2])    # => {:drop_total=>6, :wave_count=>1, :two_count=>4, :two_freq=>0.6666666666666666, :noizy_two_max=>4, :ticket_count=>2}

Swars::AiCop::Analyzer.test(one)                   # => {:drop_total=>5, :wave_count=>1, :two_count=>3, :two_freq=>0.6, :noizy_two_max=>3, :ticket_count=>1}
Swars::AiCop::Analyzer.test([3, 1, *one])          # => {:drop_total=>5, :wave_count=>1, :two_count=>3, :two_freq=>0.42857142857142855, :noizy_two_max=>3, :ticket_count=>1}
Swars::AiCop::Analyzer.test([3, 1, 2, *one])       # => {:drop_total=>5, :wave_count=>1, :two_count=>4, :two_freq=>0.5, :noizy_two_max=>3, :ticket_count=>1}
Swars::AiCop::Analyzer.test([3, 1, 2, 2, *one])    # => {:drop_total=>5, :wave_count=>1, :two_count=>5, :two_freq=>0.5555555555555556, :noizy_two_max=>3, :ticket_count=>1}
Swars::AiCop::Analyzer.test([3, 1, 2, 2, 2, *one]) # => {:drop_total=>10, :wave_count=>2, :two_count=>6, :two_freq=>0.6, :noizy_two_max=>3, :ticket_count=>2}
Swars::AiCop::Analyzer.test([*one, *one, *one])    # => {:drop_total=>15, :wave_count=>3, :two_count=>9, :two_freq=>0.6, :noizy_two_max=>3, :ticket_count=>3}

Swars::AiCop::Analyzer.test([3, 1, 2, 1, 2])       # => {:drop_total=>0, :wave_count=>0, :two_count=>2, :two_freq=>0.4, :noizy_two_max=>1, :ticket_count=>nil}
Swars::AiCop::Analyzer.test([3, 1, 2, 3, 2])       # => {:drop_total=>0, :wave_count=>0, :two_count=>2, :two_freq=>0.4, :noizy_two_max=>1, :ticket_count=>nil}

tanpatu = [1, 1, 2, 1, 2, 1, 1, 1, 1, 3, 2, 2, 11, 1, 4, 4, 1, 2, 2, 2, 4, 1, 2, 2, 2, 4, 1, 2, 2, 2, 4, 1, 2, 2, 2, 4, 1, 2, 2, 2, 1, 4, 1, 2, 2, 2, 4, 1, 2, 2, 2, 4, 1, 2, 2, 2, 3, 2, 2, 2, 2, 4, 2, 1, 2, 2, 4, 2, 1, 2, 2, 4, 1, 2, 2, 2, 2, 3, 1, 2, 5]
renpatu = [0, 1, 0, 2, 0, 1, 0, 1, 1, 1, 1, 1, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 2, 3, 2, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 3, 2, 2, 2, 2, 2, 2, 2]
Swars::AiCop::Analyzer.test(tanpatu)    # => {:drop_total=>46, :wave_count=>9, :two_count=>43, :two_freq=>0.5308641975308642, :noizy_two_max=>4, :ticket_count=>10}
Swars::AiCop::Analyzer.test(renpatu)    # => {:drop_total=>0, :wave_count=>0, :two_count=>62, :two_freq=>0.7654320987654321, :noizy_two_max=>46, :ticket_count=>nil}

Swars::AiCop::Analyzer.analyze(one).drop_total # => 5

#!/usr/bin/env ruby
require File.expand_path('../../../config/environment', __FILE__)

one = [3, 1, 2, 2, 2]

Swars::AiCop.test([])                    # => {:ai_drop_total=>nil, :ai_ticket_count=>nil, :ai_wave_count=>nil, :ai_two_freq=>nil}
Swars::AiCop.test([0])                   # => {:ai_drop_total=>nil, :ai_ticket_count=>nil, :ai_wave_count=>nil, :ai_two_freq=>0.0}

Swars::AiCop.test([3])                   # => {:ai_drop_total=>nil, :ai_ticket_count=>nil, :ai_wave_count=>nil, :ai_two_freq=>0.0}
Swars::AiCop.test([3, 1, 2])             # => {:ai_drop_total=>nil, :ai_ticket_count=>nil, :ai_wave_count=>nil, :ai_two_freq=>0.3333333333333333}
Swars::AiCop.test([3, 1, 2, 2])          # => {:ai_drop_total=>nil, :ai_ticket_count=>nil, :ai_wave_count=>nil, :ai_two_freq=>0.5}
Swars::AiCop.test([3, 1, 2, 2, 2])       # => {:ai_drop_total=>5, :ai_ticket_count=>1, :ai_wave_count=>1, :ai_two_freq=>0.6}
Swars::AiCop.test([3, 1, 2, 2, 2, 2])    # => {:ai_drop_total=>6, :ai_ticket_count=>2, :ai_wave_count=>1, :ai_two_freq=>0.6666666666666666}

Swars::AiCop.test(one)                   # => {:ai_drop_total=>5, :ai_ticket_count=>1, :ai_wave_count=>1, :ai_two_freq=>0.6}
Swars::AiCop.test([3, 1, *one])          # => {:ai_drop_total=>5, :ai_ticket_count=>1, :ai_wave_count=>1, :ai_two_freq=>0.42857142857142855}
Swars::AiCop.test([3, 1, 2, *one])       # => {:ai_drop_total=>5, :ai_ticket_count=>1, :ai_wave_count=>1, :ai_two_freq=>0.5}
Swars::AiCop.test([3, 1, 2, 2, *one])    # => {:ai_drop_total=>5, :ai_ticket_count=>1, :ai_wave_count=>1, :ai_two_freq=>0.5555555555555556}
Swars::AiCop.test([3, 1, 2, 2, 2, *one]) # => {:ai_drop_total=>10, :ai_ticket_count=>2, :ai_wave_count=>2, :ai_two_freq=>0.6}
Swars::AiCop.test([*one, *one, *one])    # => {:ai_drop_total=>15, :ai_ticket_count=>3, :ai_wave_count=>3, :ai_two_freq=>0.6}

Swars::AiCop.test([3, 1, 2, 1, 2])       # => {:ai_drop_total=>nil, :ai_ticket_count=>nil, :ai_wave_count=>nil, :ai_two_freq=>0.4}
Swars::AiCop.test([3, 1, 2, 3, 2])       # => {:ai_drop_total=>nil, :ai_ticket_count=>nil, :ai_wave_count=>nil, :ai_two_freq=>0.4}

Swars::AiCop.analize(one).ai_drop_total # => 5

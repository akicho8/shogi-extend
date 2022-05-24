#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

record = Swars::Battle.create!
record.memberships[0].attack_tag_list  # => ["嬉野流"]
record.memberships[1].attack_tag_list  # => ["△３ニ飛戦法"]
record.memberships[0].defense_tag_list # => []
record.memberships[1].defense_tag_list # => []
record.memberships[0].note_tag_list    # => ["居飛車", "居玉"]
record.memberships[1].note_tag_list    # => ["振り飛車", "居玉"]



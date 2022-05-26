#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

# require "battle_model_shared_methods"
# require "colosseum/battle"
# require "colosseum/chat_message"
# require "colosseum/custom_preset_info"
# require "colosseum/lifetime_info"
# require "colosseum/lobby_message"
# require "colosseum/membership"
# require "colosseum/team_info"
require "colosseum/user"
# require "colosseum/watch_ship"
# require "colosseum/xstate_info"
# require "free_battle"
# require "general/battle"
# require "general/final_info"
# require "general/membership"
# require "judge_info"
# require "kifu_format_info"
# require "swars/access_log"
# require "swars/battle"
# require "swars/final_info"
# require "swars/grade"
# require "swars/grade_info"
# require "swars/membership"
# require "swars/rule_info"
# require "swars/search_log"
require "swars/user"

attributes = ActiveRecord::Base.subclasses.collect { |e|
  next if e.abstract_class
  p e
  p e.count
  [e.model_name.i18n_key.to_s, e.columns.collect { |e| [e.name, e.comment] }.to_h]
}.compact.to_h

pp attributes
# >> ActsAsTaggableOn::Tagging (call 'ActsAsTaggableOn::Tagging.connection' to establish a connection)
# >> 3680
# >> ActsAsTaggableOn::Tag(id: integer, name: string, taggings_count: integer)
# >> 233
# >> {"acts_as_taggable_on/tagging"=>
# >>   {"id"=>nil,
# >>    "tag_id"=>nil,
# >>    "taggable_type"=>nil,
# >>    "taggable_id"=>nil,
# >>    "tagger_type"=>nil,
# >>    "tagger_id"=>nil,
# >>    "context"=>nil,
# >>    "created_at"=>nil},
# >>  "acts_as_taggable_on/tag"=>{"id"=>nil, "name"=>nil, "taggings_count"=>nil}}

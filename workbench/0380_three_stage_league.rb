#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

# tp Tsl::Spider.new(generation: 32).user_infos

Tsl.setup(reset: true)

(28..67).each do |generation|
  Tsl::Spider.new(generation: generation).call.each do |e|
    if v = e[:age]
      if v < 10
        p generation
        exit
      end
    end
  end
end
# p :end

# # Tsl.destroy_all
# Tsl::League.setup
#
# Tsl::User.count                 # => 177
# Tsl::Membership.count           # => 1272
# Tsl::League.count               # => 40
#
# tp Tsl::Membership.count

# Tsl::Membership.all.collect(&:ox).collect(&:size).minmax # => [0, 18]
#
# tp Tsl::User.all
# >> {:result_key=>"none", :start_pos=>1, :name=>"松本秀介", :win=>6, :lose=>12, :ox=>"xxoxoxoxxxoxxxoxox"}

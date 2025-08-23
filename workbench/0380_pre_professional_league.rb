#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

# tp Ppl::ModernitySpider.new(generation: 32).user_infos

Ppl.setup(reset: true)

(28..67).each do |generation|
  Ppl::ModernitySpider.new(generation: generation).call.each do |e|
    if v = e[:age]
      if v < 10
        p generation
        exit
      end
    end
  end
end
# p :end

# # Ppl.destroy_all
# Ppl::League.setup
#
# Ppl::User.count                 # => 177
# Ppl::Membership.count           # => 1272
# Ppl::League.count               # => 40
#
# tp Ppl::Membership.count

# Ppl::Membership.all.collect(&:ox).collect(&:size).minmax # => [0, 18]
#
# tp Ppl::User.all
# >> {:result_key=>"none", :start_pos=>1, :name=>"松本秀介", :win=>6, :lose=>12, :ox=>"xxoxoxoxxxoxxxoxox"}

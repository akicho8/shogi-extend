#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

Swars::User.destroy_all
Swars::Battle.destroy_all

@user1 = Swars::User.create!
@user2 = Swars::User.create!

def test(white, judge_key)
  Swars::Battle.create! do |e|
    e.memberships.build(user: @user1, judge_key: judge_key)
    e.memberships.build(user: @user2, grade: Swars::Grade.find_by(key: white))
  end
end

test("初段", "win")
test("九段", "win")
test("九段", "win")
test("九段", "lose")

@user1.user_info.every_grade_list # => [{:grade_name=>"九段", :judge_counts=>{:win=>2, :lose=>1}, :appear_ratio=>1.5}, {:grade_name=>"初段", :judge_counts=>{:win=>1, :lose=>0}, :appear_ratio=>0.5}]

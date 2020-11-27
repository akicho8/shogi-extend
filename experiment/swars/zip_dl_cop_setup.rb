#!/usr/bin/env ruby
require File.expand_path('../../../config/environment', __FILE__)

t = "2020-11-26".to_time(:local).midnight

Swars::Battle.destroy_all
Swars::ZipDlLog.destroy_all
Swars::User.destroy_all

Timecop.freeze("2020-01-01")

current_user = User.create!

@user1 = Swars::User.create!(user_key: "alice")
@user2 = Swars::User.create!(user_key: "bob")

def test1(seconds)
  Timecop.freeze(Time.current + seconds) do
    Swars::Battle.create_with_members!([@user1, @user2])
  end
end

10.times do |i|
  test1(i)
end

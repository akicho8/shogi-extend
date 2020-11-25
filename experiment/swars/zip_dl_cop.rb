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

test1(0)  # 1回目
test1(1)  # 2回目
test1(2)  # 2回目
test1(3)  # 3回目

zip_dl_cop = Swars::ZipDlMan.new({
    :current_user        => current_user,
    :current_index_scope => @user1.battles,
    :query               => "alice",
    :zip_dl_max          => 2,
    :zip_scope_key       => :continue,
  })

zip_dl_cop.to_config             # => {:form_params_default=>{:zip_scope_key=>"latest", :zip_format_key=>"kif", :encode_key=>"UTF-8", :zip_dl_max=>50}, :swars_zip_dl_logs=>{:count=>0, :last=>nil}, :scope_info=>[{:key=>:latest, :name=>"直近", :count=>2}, {:key=>:today, :name=>"本日分", :count=>2}, {:key=>:continue, :name=>"前回の続きから", :count=>0}, {:key=>:oldest, :name=>"一番古い1件", :count=>1}]}
zip_dl_cop.zip_filename          # => "shogiwars-alice-0-20200101000000-kif-UTF-8.zip"

record = zip_dl_cop.huruinowo_dl # 一番古いもの1件ダウンロードしたことにする
record.user == current_user      # => true
record.swars_user == @user1      # => true
record.begin_at.sec == 0         # => true
record.end_at.sec == 1           # => true
record.dl_count  == 1            # => true

record = zip_dl_cop.swars_zip_dl_logs_create!
record.begin_at.sec == 1         # => true
record.end_at.sec   == 3         # => true
record.dl_count == 2             # => true

record = zip_dl_cop.swars_zip_dl_logs_create!
record.begin_at.sec == 3         # => true
record.end_at.sec   == 4         # => true
record.dl_count == 1             # => true

record = zip_dl_cop.swars_zip_dl_logs_create!
record == nil                    # => true

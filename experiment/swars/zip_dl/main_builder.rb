#!/usr/bin/env ruby
require File.expand_path('../../../../config/environment', __FILE__)

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

main_builder = Swars::ZipDl::MainBuilder.new({
    :current_user        => current_user,
    :current_index_scope => @user1.battles,
    :swars_user          => @user1,
    :query               => "alice",
    :zip_dl_max          => 2,
    :zip_dl_scope_key    => :zdsk_continue,
  })

main_builder.as_json             # => {:form_params_default=>{:zip_dl_scope_key=>"zdsk_inherit", :zip_dl_format_key=>"kif", :zip_dl_max=>50, :zip_dl_structure_key=>"date", :body_encode=>"UTF-8"}, :swars_zip_dl_logs=>{:count=>0, :last=>nil}, :limiter=>{:over_p=>false, :message=>nil, :limiter.recent_count=>0, :limiter.recent_period=>1 day, :limiter.recent_count_max=>3}, :scope_info=>{:zdsk_continue=>{:key=>:zdsk_continue, :name=>"前回の続きから", :count=>0, :message=>"「前回の続きから」以外の方法で一度ダウンロードすると使えるようになります"}, :zdsk_today=>{:key=>:zdsk_today, :name=>"本日", :count=>0, :message=>"本日分を日時昇順で取得する"}, :zdsk_inherit=>{:key=>:zdsk_inherit, :name=>"そのまま", :count=>2, :message=>"一覧で表示した通りに画面の上から順に取得する"}}}
main_builder.zip_filename          # => "shogiwars-alice-0-20200101000000-kif-UTF-8.zip"

record = main_builder.oldest_log_create # 一番古いもの1件ダウンロードしたことにする
record.user == current_user      # => true
record.swars_user == @user1      # => true
record.begin_at.sec == 0         # => true
record.end_at.sec == 1           # => true
record.dl_count  == 1            # => true

record = main_builder.swars_zip_dl_logs_create!
record.begin_at.sec == 1         # => true
record.end_at.sec   == 3         # => true
record.dl_count == 2             # => true

record = main_builder.swars_zip_dl_logs_create!
record.begin_at.sec == 3         # => true
record.end_at.sec   == 4         # => true
record.dl_count == 1             # => true

record = main_builder.swars_zip_dl_logs_create!
record == nil                    # => true

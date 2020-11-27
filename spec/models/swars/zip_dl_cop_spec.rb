require 'rails_helper'

module Swars
  RSpec.describe Battle, type: :model do
    before do
      Actb.setup
      Emox.setup
      Swars.setup
    end

    let(:current_user) { ::User.create!                  }
    let(:user1)        { User.create!(user_key: "alice") }
    let(:user2)        { User.create!(user_key: "bob")   }

    it "works" do
      def test1(seconds)
        Timecop.freeze(Time.current + seconds) do
          Battle.create_with_members!([user1, user2])
        end
      end

      test1(0)  #0 1回目
      test1(1)  #1 2回目
      test1(2)  #2 2回目
      test1(3)  #3 3回目

      zip_dl_cop = ZipDlCop.new({
          :current_user        => current_user,   # ログインしている人
          :current_index_scope => user1.battles,  # 対象レコードたち
          :swars_user          => user1,          # 対象者のキー
          :query               => "alice",        # デバッグ用にいれておく。いまのところ user1.name と同一
          :zip_dl_max          => 2,              # 一度にダウンロードする数
          :zip_dl_scope_key    => :zdsk_continue, # 前回の続きから
        })

      assert { zip_dl_cop.to_config == {:form_params_default=>{:zip_dl_scope_key=>"latest", :zip_dl_format_key=>"kif", :encode_key=>"UTF-8", :zip_dl_max=>50}, :swars_zip_dl_logs=>{:count=>0, :last=>nil}, :scope_info=>[{:key=>:latest, :name=>"直近", :count=>2}, {:key=>:today, :name=>"本日分", :count=>2}, {:key=>:continue, :name=>"前回の続きから", :count=>0}, {:key=>:oldest, :name=>"一番古い1件", :count=>1}]} }
      assert { zip_dl_cop.zip_filename == "shogiwars-alice-0-20000101000000-kif-UTF-8.zip" }

      # 1回目
      record = zip_dl_cop.oldest_log_create       # 一番古いもの1件ダウンロードしたことにする
      assert { record.user == current_user      } # ログインしている人
      assert { record.swars_user == user1       } # 対象者
      assert { record.dl_count == 1             } # 1件だけ
      assert { record.begin_at.sec == 0         } # ダウンロード範囲 0...1
      assert { record.end_at.sec   == 1         } # なので次は 0+1

      # 2回目
      record = zip_dl_cop.swars_zip_dl_logs_create!
      assert { record.begin_at.sec == 1         } # ダウンロード範囲 1...3
      assert { record.end_at.sec   == 3         }

      # 3回目
      record = zip_dl_cop.swars_zip_dl_logs_create!
      assert { record.begin_at.sec == 3         } # ダウンロード範囲 3...4
      assert { record.end_at.sec   == 4         }

      # 4回目
      record = zip_dl_cop.swars_zip_dl_logs_create!
      assert { record == nil                    }
    end
  end
end
# >> Run options: exclude {:slow_spec=>true}
# >> F
# >> 
# >> Failures:
# >> 
# >>   1) Swars::Battle works
# >>      Failure/Error: Unable to find - to read failed line
# >>      # -:36:in `block (2 levels) in <module:Swars>'
# >>      # ./spec/support/database_cleaner.rb:18:in `block (3 levels) in <main>'
# >>      # ./spec/support/database_cleaner.rb:18:in `block (2 levels) in <main>'
# >> 
# >> Finished in 1.97 seconds (files took 2.44 seconds to load)
# >> 1 example, 1 failure
# >> 
# >> Failed examples:
# >> 
# >> rspec -:15 # Swars::Battle works
# >> 

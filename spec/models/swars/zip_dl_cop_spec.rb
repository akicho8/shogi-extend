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

      assert { zip_dl_cop.to_config }
      assert { zip_dl_cop.zip_filename == "shogiwars-alice-0-20000101000000-kif-UTF-8.zip" }

      # 1回目
      record = zip_dl_cop.oldest_log_create       # 一番古いもの1件ダウンロードしたことにする
      assert { zip_dl_cop.zip_filename == "shogiwars-alice-2-20000101000002-kif-UTF-8.zip" } # 現在日時ではなく battled_at からファイル名を作っている
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
# >> .
# >> 
# >> Finished in 2.08 seconds (files took 2.22 seconds to load)
# >> 1 example, 0 failures
# >> 

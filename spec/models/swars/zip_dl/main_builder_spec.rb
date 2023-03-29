require "#{__dir__}/test_methods"

module Swars
  module ZipDl
    RSpec.describe MainBuilder, type: :model, swars_spec: true, zip_dl_spec: true do
      include TestMethods

      describe "継続ダウンロード" do
        def case1(seconds)
          Timecop.freeze(Time.current + seconds) do
            Battle.create_with_members!([swars_user1, swars_user2])
          end
        end

        it "works" do
          case1(0)  #0 1回目
          case1(1)  #1 2回目
          case1(2)  #2 2回目
          case1(3)  #3 3回目

          main_builder = MainBuilder.new({
              **base_params,
              :zip_dl_max           => 2,              # 一度にダウンロードする数
              :zip_dl_scope_key     => :zdsk_continue, # 前回の続きから
              :zip_dl_format_key    => "ki2",
              :body_encode          => "Shift_JIS",
            })

          assert2 { main_builder.as_json }

          # 1回目
          record = main_builder.oldest_log_create       # 一番古いもの1件ダウンロードしたことにする
          assert2 { record.user == current_user      } # ログインしている人
          assert2 { record.swars_user == swars_user1       } # 対象者
          assert2 { record.dl_count == 1             } # 1件だけ
          assert2 { record.begin_at.sec == 0         } # ダウンロード範囲 0...1
          assert2 { record.end_at.sec   == 1         } # なので次は 0+1

          assert2 { main_builder.zip_filename == "shogiwars-alice-2-20000101000002-ki2-Shift_JIS.zip" }

          Zip::InputStream.open(main_builder.to_zip_output_stream) do |zis|
            entry = zis.get_next_entry
            assert2 { entry.name               == "alice/2000-01-01/alice-bob-20000101_000001.ki2" }
            assert2 { NKF.guess(zis.read).to_s == "Shift_JIS"                    }
          end

          # 2回目
          record = main_builder.swars_zip_dl_logs_create!
          assert2 { record.begin_at.sec == 1         } # ダウンロード範囲 1...3
          assert2 { record.end_at.sec   == 3         }

          # 3回目
          record = main_builder.swars_zip_dl_logs_create!
          assert2 { record.begin_at.sec == 3         } # ダウンロード範囲 3...4
          assert2 { record.end_at.sec   == 4         }

          # 4回目
          record = main_builder.swars_zip_dl_logs_create!
          assert2 { record == nil                    }
        end
      end

      describe "短期間の大量ダウンロードで制限をかける" do
        before do
          @recent_count_max = Limiter.recent_count_max
          Limiter.recent_count_max = 2 # 短期間で2つの棋譜をダウンロードしたら禁止
        end

        after do
          Limiter.recent_count_max = @recent_count_max
        end

        def main_builder
          MainBuilder.new(base_params)
        end

        it "works" do
          Battle.create_with_members!([swars_user1, swars_user2])

          assert2 { main_builder.limiter.recent_count == 0 }
          assert2 { main_builder.limiter.over? == false }

          # 1回目のダウンロード後は 1 >= 2 なのでまだOK
          main_builder.swars_zip_dl_logs_create!
          assert2 { main_builder.limiter.recent_count == 1 }
          assert2 { main_builder.limiter.over? == false    }

          # 2回目でダウンロードで 2 >= 2 になってもうダウンロードできない
          main_builder.swars_zip_dl_logs_create!
          assert2 { main_builder.limiter.recent_count == 2 }
          assert2 { main_builder.limiter.over? == true  }
        end
      end
    end
  end
end

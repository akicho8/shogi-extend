require "rails_helper"

module QuickScript
  RSpec.describe Dev::BackgroundJobScript, type: :model do
    it "works" do
      post_index = SecureRandom.hex
      assert { Dev::BackgroundJobScript.new.call == nil }                                                            # GET
      assert { Dev::BackgroundJobScript.new({post_index: post_index}, {_method: "post"}).call == {_autolink: nil} }  # POSTでバックグラウンド実行開始
      assert { AppLog.exists?(subject: "バックグラウンド実行完了(#{post_index})") }                                  # 実行完了
    end

    it "バックグラウンド実行する予定のコードを直接実行する" do
      assert { Dev::BackgroundJobScript.new({}, {running_in_background: true}).call.kind_of?(AppLog) }
    end
  end
end

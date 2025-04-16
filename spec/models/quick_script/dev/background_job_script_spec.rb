require "rails_helper"

RSpec.describe QuickScript::Dev::BackgroundJobScript, type: :model do
  it "works" do
    post_index = SecureRandom.hex
    assert { QuickScript::Dev::BackgroundJobScript.new.call == nil }                                                            # GET
    assert { QuickScript::Dev::BackgroundJobScript.new({ post_index: post_index }, { _method: "post" }).call == { _autolink: nil } }  # POSTでバックグラウンド実行開始
    assert { AppLog.exists?(subject: "バックグラウンド実行完了(#{post_index})") }                                  # 実行完了
  end

  it "バックグラウンド実行する予定のコードを直接実行する" do
    assert { QuickScript::Dev::BackgroundJobScript.new({}, { running_in_background: true }).call.kind_of?(AppLog) }
  end
end

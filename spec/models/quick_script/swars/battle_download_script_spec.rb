require "rails_helper"

RSpec.describe QuickScript::Swars::BattleDownloadScript, type: :model do
  def case1
    @current_user = User.create!
    ::Swars::Battle.create! do |e|
      e.memberships.build(user: ::Swars::User.create!(key: "SWARS_USER_KEY"))
    end
  end

  it "methods" do
    case1
    instance = QuickScript::Swars::BattleDownloadScript.new({ query: "SWARS_USER_KEY", max_key: "200" }, { current_user: @current_user })
    assert { instance.download_content  }
    assert { instance.download_filename }
    assert { instance.download_url      }
    assert { instance.mail_subject      }
    assert { instance.posted_message    }
    assert { instance.summary           }
    assert { instance.mail_notify       }
    assert { @current_user.swars_zip_dl_logs.count == 1 }
    assert { instance.dl_rest_count == 100 } # 200 を希望したが残りは 100 件のため制限している
  end

  it "フォーム" do
    case1

    # ブラウザでダウンロード (開発時のみ可)
    instance = QuickScript::Swars::BattleDownloadScript.new({ query: "SWARS_USER_KEY" }, { current_user: @current_user, _method: "post" })
    assert { instance.as_json[:flash][:notice] == "ダウンロードを開始しました" }

    # バックグラウンド実行予約 (本番)
    instance = QuickScript::Swars::BattleDownloadScript.new({ query: "SWARS_USER_KEY", bg_request_key: :on }, { current_user: @current_user, _method: "post" })
    assert { instance.as_json[:flash][:notice].include?("ZIPで送ります") }
    assert { ActionMailer::Base.deliveries.count == 1 } # テスト環境では即座に実行され、管理者には送らず、本人だけにメールされた
  end
end

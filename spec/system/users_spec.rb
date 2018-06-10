require "rails_helper"

RSpec.describe "対戦", type: :system do
  context "ロビー" do
    before do
      visit "/online/battles"
    end

    it "ロビーの表示" do
      expect(page).to have_content "Rails"
      doc_image("ロビー")
    end

    it "チャットでメッセージ送信" do
      message = SecureRandom.hex

      find(".chat_container input[type=text]").set(message)
      click_on("送信")
      expect(page).to have_content message

      # リロード
      refresh
      expect(page).to have_content message
    end

    it "ルール設定の変更" do
      click_on("ルール設定")
      expect(page).to have_content "人数"
      choose("チーム戦")
      expect(page).to have_checked_field("チーム戦", visible: false) # FIXME: visible: false を付ける必要はないはず
      click_on("閉じる")
      refresh

      # 反映されている
      click_on("ルール設定")
      expect(page).to have_checked_field("チーム戦", visible: false)
    end
  end

  # できればクリックしたい
  it "プロフィール表示" do
    @alice = create(:user)
    visit "/online/users/#{@alice.id}"
    doc_image("プロフィール")
  end

  it "プロフィール設定" do
    @alice = create(:user)
    visit "/online/users/#{@alice.id}/edit"
    doc_image("プロフィール設定")
  end

  describe "自動マッチング" do
    it "シングルス" do
      p ["#{__FILE__}:#{__LINE__}", __method__, ]
      using_session("user1") do
        p ["#{__FILE__}:#{__LINE__}", __method__, ]
        visit "/online/battles"
        p ["#{__FILE__}:#{__LINE__}", __method__, ]
        click_on("バトル開始")
        p ["#{__FILE__}:#{__LINE__}", __method__, ]
        expect(page).to have_content "マッチング開始"
        p ["#{__FILE__}:#{__LINE__}", __method__, ]
        doc_image("マッチング開始")
      end
      using_session("user2") do
        p ["#{__FILE__}:#{__LINE__}", __method__, ]
        visit "/online/battles"
        p ["#{__FILE__}:#{__LINE__}", __method__, ]
        click_on("バトル開始")
        p ["#{__FILE__}:#{__LINE__}", __method__, ]
        sleep(2)
        p ["#{__FILE__}:#{__LINE__}", __method__, ]
        assert { current_path == polymorphic_path([:resource_ns1, BattleRoom.last]) }
        p ["#{__FILE__}:#{__LINE__}", __method__, ]
        doc_image("自動マッチング_対戦開始")
        p ["#{__FILE__}:#{__LINE__}", __method__, ]
      end
    end

    it "ダブルス" do
      p ["#{__FILE__}:#{__LINE__}", __method__, ]
      matching_set("user1", "ダブルス")
      p ["#{__FILE__}:#{__LINE__}", __method__, ]
      matching_set("user2", "ダブルス")
      p ["#{__FILE__}:#{__LINE__}", __method__, ]
      matching_set("user3", "ダブルス")
      p ["#{__FILE__}:#{__LINE__}", __method__, ]

      using_session("user4") do
        p ["#{__FILE__}:#{__LINE__}", __method__, ]
        visit "/online/battles"
        p ["#{__FILE__}:#{__LINE__}", __method__, ]
        click_on("ルール設定")
        p ["#{__FILE__}:#{__LINE__}", __method__, ]
        choose("ダブルス")
        p ["#{__FILE__}:#{__LINE__}", __method__, ]
        click_on("閉じる")
        p ["#{__FILE__}:#{__LINE__}", __method__, ]
        click_on("バトル開始")
        p ["#{__FILE__}:#{__LINE__}", __method__, ]
        sleep(2)
        p ["#{__FILE__}:#{__LINE__}", __method__, ]
        assert { current_path == polymorphic_path([:resource_ns1, BattleRoom.last]) }
        p ["#{__FILE__}:#{__LINE__}", __method__, ]
        doc_image("自動マッチング_ダブルス_対戦開始")
        p ["#{__FILE__}:#{__LINE__}", __method__, ]
        # 4人そろっていることを確認したい
        p ["#{__FILE__}:#{__LINE__}", __method__, ]
      end
    end

    it "チーム戦" do
      p ["#{__FILE__}:#{__LINE__}", __method__, ]
      matching_set("user1", "チーム戦")
      p ["#{__FILE__}:#{__LINE__}", __method__, ]
      matching_set("user2", "チーム戦")
      p ["#{__FILE__}:#{__LINE__}", __method__, ]
      matching_set("user3", "チーム戦")
      p ["#{__FILE__}:#{__LINE__}", __method__, ]
      matching_set("user4", "チーム戦")
      p ["#{__FILE__}:#{__LINE__}", __method__, ]
      matching_set("user5", "チーム戦")
      p ["#{__FILE__}:#{__LINE__}", __method__, ]
      matching_set("user6", "チーム戦")
      p ["#{__FILE__}:#{__LINE__}", __method__, ]
      matching_set("user7", "チーム戦")
      p ["#{__FILE__}:#{__LINE__}", __method__, ]

      using_session("user8") do
        p ["#{__FILE__}:#{__LINE__}", __method__, ]
        visit "/online/battles"
        p ["#{__FILE__}:#{__LINE__}", __method__, ]
        click_on("ルール設定")
        p ["#{__FILE__}:#{__LINE__}", __method__, ]
        choose("チーム戦")
        p ["#{__FILE__}:#{__LINE__}", __method__, ]
        click_on("閉じる")
        p ["#{__FILE__}:#{__LINE__}", __method__, ]
        click_on("バトル開始")
        p ["#{__FILE__}:#{__LINE__}", __method__, ]
        sleep(2)
        p ["#{__FILE__}:#{__LINE__}", __method__, ]
        assert { current_path == polymorphic_path([:resource_ns1, BattleRoom.last]) }
        p ["#{__FILE__}:#{__LINE__}", __method__, ]
        doc_image("自動マッチング_チーム戦_対戦開始")
        p ["#{__FILE__}:#{__LINE__}", __method__, ]
      end
    end
  end

  context "対局リクエスト" do
    it "自分vs自分" do
      visit "/online/battles"
      refresh
      find(".message_link_to.user_#{User.last.id}").click
      expect(page).to have_content "対局申し込み"
      doc_image("対局申し込み")
      click_on("対局申し込み")
      expect(page).to have_content "さんからの挑戦状"
      doc_image("挑戦状受信")
      click_on("受ける")
      sleep(2)
      assert { current_path == polymorphic_path([:resource_ns1, BattleRoom.last]) }
      doc_image("自己対局")
    end

    it "自分vs他人" do
      using_session("user1") do
        visit "/online/battles"
        @user1 = User.last
      end
      using_session("user2") do
        visit "/online/battles"
        find(".message_link_to.user_#{@user1.id}").click
        expect(page).to have_content "対局申し込み"
        doc_image("自分vs他人_局申し込み")
        click_on("対局申し込み")
      end
      using_session("user1") do
        expect(page).to have_content "さんからの挑戦状"
        doc_image("自分vs他人_挑戦状受信")
        click_on("受ける")
        sleep(2)
        # 対局画面に移動
        assert { current_path == polymorphic_path([:resource_ns1, BattleRoom.last]) }
        doc_image("自分vs他人_対局開始_他人")
      end
      using_session("user2") do
        # 対局画面に移動
        assert { current_path == polymorphic_path([:resource_ns1, BattleRoom.last]) }
        doc_image("自分vs他人_対局開始_自分")
      end
    end
  end

  context "メッセージ送信" do
    it "自分にメッセージ送信" do
      message = SecureRandom.hex
      visit "/online/battles"
      refresh
      find(".message_link_to.user_#{User.last.id}").click
      within(".modal-card") do
        expect(page).to have_content "対局申し込み"
        find("input[type=text]").set(message)
        click_on("送信")
      end
      expect(page).to have_content message
      doc_image("自分に送ったメッセージが届く")
    end

    it "他人にメッセージ送信" do
      @alice = create(:user)
      message = SecureRandom.hex
      visit "/online/battles"
      find(".message_link_to.user_#{@alice.id}").click
      expect(page).to have_content "対局申し込み"
      within(".modal-card") do
        find("input[type=text]").set(message)
        click_on("送信")
      end
      doc_image("他人にメッセージ送信直後")
    end
  end

  def matching_set(name, rule)
    using_session(name) do
      visit "/online/battles"
      click_on("ルール設定")
      choose(rule)
      click_on("閉じる")
      click_on("バトル開始")
      expect(page).to have_content "マッチング開始"
    end
  end
end

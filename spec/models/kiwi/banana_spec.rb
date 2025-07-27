# -*- coding: utf-8 -*-

# == Schema Information ==
#
# ライブラリ (kiwi_bananas as Kiwi::Banana)
#
# |-----------------------+----------------+-------------+---------------------+------+-------|
# | name                  | desc           | type        | opts                | refs | index |
# |-----------------------+----------------+-------------+---------------------+------+-------|
# | id                    | ID             | integer(8)  | NOT NULL PK         |      |       |
# | key                   | キー           | string(255) | NOT NULL            |      | A!    |
# | user_id               | 所有者         | integer(8)  | NOT NULL            |      | C     |
# | folder_id             | 公開設定       | integer(8)  | NOT NULL            |      | D     |
# | lemon_id              | 動画ファイル   | integer(8)  | NOT NULL            |      | B!    |
# | title                 | タイトル       | string(100) | NOT NULL            |      |       |
# | description           | 説明           | text(65535) | NOT NULL            |      |       |
# | thumbnail_pos         | サムネ位置(秒) | float(24)   | NOT NULL            |      |       |
# | banana_messages_count | コメント数     | integer(4)  | DEFAULT(0) NOT NULL |      | E     |
# | access_logs_count     | アクセス数     | integer(4)  | DEFAULT(0) NOT NULL |      | F     |
# | created_at            | 作成日時       | datetime    | NOT NULL            |      |       |
# | updated_at            | 更新日時       | datetime    | NOT NULL            |      |       |
# |-----------------------+----------------+-------------+---------------------+------+-------|
#
# - Remarks ----------------------------------------------------------------------
# [Warning: Need to add relation] Kiwi::Banana モデルに belongs_to :folder を追加してください
# [Warning: Need to add relation] Kiwi::Banana モデルに belongs_to :lemon を追加してください
# [Warning: Need to add relation] Kiwi::Banana モデルに belongs_to :user を追加してください
# --------------------------------------------------------------------------------

require "rails_helper"

RSpec.describe Kiwi::Banana, type: :model, kiwi: true do
  include KiwiSupport

  it "works" do
    user1 = User.create!

    # 動画作成
    free_battle1 = user1.free_battles.create!(kifu_body: mp4_params1[:body], use_key: "kiwi_lemon")
    lemon1 = user1.kiwi_lemons.create!(recordable: free_battle1, all_params: mp4_params1[:all_params])
    lemon1.main_process

    lemon1.thumbnail_clean    # テストが不安定になるので最初に消しておく
    # # この時点でサムネは作らない
    assert { lemon1.thumbnail_real_path.exist? == false }
    tp lemon1 if $0 == "-"

    # 動画ライブラリ登録 (フォーム初期値)
    banana1 = user1.kiwi_bananas.build(lemon: lemon1) # => #<Kiwi::Banana id: nil, key: nil, user_id: 21, folder_id: nil, lemon_id: 21, title: nil, description: nil, thumbnail_pos: nil, banana_messages_count: 0, access_logs_count: 0, created_at: nil, updated_at: nil, tag_list: nil>
    banana1.form_values_default_assign
    tp banana1.attributes if $0 == "-"           # => {"id"=>nil, "key"=>nil, "user_id"=>21, "folder_id"=>nil, "lemon_id"=>21, "title"=>"(cover_text)", "description"=>"(description1)\n(description2)", "thumbnail_pos"=>0.0, "banana_messages_count"=>0, "access_logs_count"=>0, "created_at"=>nil, "updated_at"=>nil, "tag_list"=>["居飛車", "相居飛車"]}
    assert { banana1.thumbnail_pos == 0 }
    assert { banana1.title == "(cover_text)" }
    assert { banana1.description == "(description1)\n(description2)" }
    assert { banana1.tag_list == ["居飛車"] }

    # 確認のためにあれば削除しておく
    lemon1.thumbnail_clean
    assert { !lemon1.thumbnail_real_path.exist? }

    # 登録実行
    # サムネ位置が nil -> 0.5 になることでサムネ作成される
    banana1 = user1.kiwi_bananas.create!(lemon: lemon1, title: "タイトル#{user1.kiwi_bananas.count.next}" * 4, description: "description" * 4, tag_list: %w[居飛車 嬉野流 右玉], thumbnail_pos: 0.5)
    assert { banana1.thumbnail_pos == 0.5 }
    assert { lemon1.real_path.exist? }
    assert { lemon1.browser_path }
    assert { lemon1.browser_url  }
    assert { lemon1.thumbnail_real_path.exist? }
    assert { lemon1.thumbnail_browser_path }
    assert { lemon1.thumbnail_browser_path_if_exist }
    assert { banana1.og_meta[:og_image_path] == lemon1.thumbnail_browser_path }

    tp banana1 if $0 == "-" # => #<Kiwi::Banana id: 20, key: "FIJOSUQRFOl", user_id: 21, folder_id: 63, lemon_id: 21, title: "タイトル1タイトル1タイトル1タイトル1", description: "descriptiondescriptiondescriptiondescription", thumbnail_pos: 0.5, banana_messages_count: 0, access_logs_count: 0, created_at: "2000-01-01 00:00:00.000000000 +0900", updated_at: "2000-01-01 00:00:00.000000000 +0900", tag_list: ["居飛車", "嬉野流", "右玉"]>

    # コメントされた
    banana1.banana_messages.create!(user: user1, body: "(message1)")      # => #<Kiwi::BananaMessage id: 14, user_id: 21, banana_id: 20, body: "(message1)", position: 1, deleted_at: nil, created_at: "2000-01-01 00:00:00.000000000 +0900", updated_at: "2000-01-01 00:00:00.000000000 +0900">
    user1.kiwi_banana_messages.create!(banana: banana1, body: "(message1)") # => #<Kiwi::BananaMessage id: 15, user_id: 21, banana_id: 20, body: "(message1)", position: 2, deleted_at: nil, created_at: "2000-01-01 00:00:00.000000000 +0900", updated_at: "2000-01-01 00:00:00.000000000 +0900">
    user1.kiwi_banana_message_speak(banana1, "(message1)")                # => #<Kiwi::BananaMessage id: 16, user_id: 21, banana_id: 20, body: "(message1)", position: 3, deleted_at: nil, created_at: "2000-01-01 00:00:00.000000000 +0900", updated_at: "2000-01-01 00:00:00.000000000 +0900">

    # アクセスされた
    banana1.access_logs.create!(user: user1)   # => #<Kiwi::AccessLog id: 4, user_id: 21, banana_id: 20, created_at: "2000-01-01 00:00:00.000000000 +0900">
  end

  it "GIFのOGP画像はサムネではなく本体" do
    user1 = User.create!
    free_battle1 = user1.free_battles.create!(kifu_body: gif_params1[:body], use_key: "kiwi_lemon")
    lemon1 = user1.kiwi_lemons.create!(recordable: free_battle1, all_params: gif_params1[:all_params])
    lemon1.main_process
    assert { lemon1.og_image_path == lemon1.browser_path }
  end

  describe "検索" do
    before do
      @user = User.create!(name: "(alice)")
      free_battle1 = @user.free_battles.create!(kifu_body: mp4_params1[:body], use_key: "kiwi_lemon")
      lemon1 = @user.kiwi_lemons.create!(recordable: free_battle1, all_params: mp4_params1[:all_params])
      @banana = @user.kiwi_bananas.create!(lemon: lemon1, title: "(ア)", description: "(description)", folder_key: "public", tag_list: ["a", "b"])
      @user.kiwi_access_logs.create!(banana: @banana)
    end

    it "ユーザー名で検索できる" do
      assert { Kiwi::Banana.general_search(query: "(alice)").present? }
    end

    it "説明を検索できる" do
      assert { Kiwi::Banana.general_search(query: "(description)").present? }
      assert { Kiwi::Banana.general_search(query: "unknown").blank? }
    end

    it "カタカナをひらがなで検索できる" do
      assert { Kiwi::Banana.general_search(query: "あ").present? }
      assert { Kiwi::Banana.general_search(query: "ん").blank? }
    end

    it "タグ検索できる" do
      assert { Kiwi::Banana.general_search(tag: "a").present?   }
      assert { Kiwi::Banana.general_search(tag: "b").present?   }
      assert { Kiwi::Banana.general_search(tag: "a,b").present? }
      assert { Kiwi::Banana.general_search(tag: "c").blank?     }
    end

    it "公開設定" do
      assert { Kiwi::Banana.general_search(current_user: @user, search_preset_key: "公開").present? }
      assert { Kiwi::Banana.general_search(current_user: @user, search_preset_key: "限定公開").blank? }
      assert { Kiwi::Banana.general_search(current_user: @user, search_preset_key: "非公開").blank? }
    end

    it "戦法" do
      assert { Kiwi::Banana.general_search(search_preset_key: "居飛車").blank? }
      assert { Kiwi::Banana.general_search(search_preset_key: "右玉").blank? }
    end

    it "join問題が起きない" do
      assert { Kiwi::Banana.general_search(current_user: @user, query: "ア", tag: "a", search_preset_key: "公開").present? }
    end

    it "履歴" do
      assert { Kiwi::Banana.general_search(current_user: @user, query: "ア", tag: "a", search_preset_key: "履歴").present? }
    end
  end

  describe "削除" do
    before do
      @model_group = ModelGroup[User, Kiwi::Lemon, Kiwi::Banana]
      banana1
    end
    it "Banana を削除しても Lemon は削除されない" do
      assert { @model_group.diff { banana1.destroy! } == [0, 0, -1] }
    end
    it "Lemon を削除すると Kiwi::Banana も連動して削除する" do
      assert { @model_group.diff { banana1.lemon.destroy! } == [0, -1, -1] }
    end
    it "User を削除すると Lemon も Kiwi::Banana も連動して削除する" do
      assert { @model_group.diff { banana1.user.destroy! } == [-1, -1, -1] }
    end
  end

  it "update_from_action" do
    banana1.update_from_action({})
    assert { banana1.saved_changes? == false }
  end
end

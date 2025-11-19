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
# [Warning: Need to add relation] Kiwi::Banana モデルに belongs_to :folder を追加しよう
# [Warning: Need to add relation] Kiwi::Banana モデルに belongs_to :lemon を追加しよう
# [Warning: Need to add relation] Kiwi::Banana モデルに belongs_to :user を追加しよう
# --------------------------------------------------------------------------------

require "rails_helper"

RSpec.describe Api::Kiwi::BananasController, type: :controller, kiwi: true do
  include KiwiSupport

  before(:context) do
    Kiwi::Folder.setup
    Kiwi::Banana.destroy_all
    Kiwi::Lemon.destroy_all
    User.destroy_all
    [
      { key: "alice-public",  user: :alice, folder_key: :public,  },
      { key: "alice-private", user: :alice, folder_key: :private, },
      { key: "bob-public",    user: :bob,   folder_key: :public,  },
      { key: "bob-private",   user: :bob,   folder_key: :private, },
    ].each do |e|
      params = Kiwi::Lemon::PARAMS_EXAMPLE_MP4
      user = User.find_or_create_by!(key: e[:user])
      free_battle = user.free_battles.create!(kifu_body: params[:body], use_key: "kiwi_lemon")
      lemon1 = user.kiwi_lemons.create!(recordable: free_battle, all_params: params[:all_params])
      user.kiwi_bananas.create!(key: e[:key], lemon: lemon1, folder_key: e[:folder_key])
    end
  end

  [
    { action:  :index, params: {},                  status: 200, }, # トップは誰でも見れる

    { action:  :show,  params: { banana_key: "alice-public",  },  login: "alice", status: 200, }, # 自分のなので見れる
    { action:  :show,  params: { banana_key: "alice-private", },  login: "alice", status: 200, }, # 自分のなので見れる
    { action:  :show,  params: { banana_key: "bob-public",    },  login: "alice", status: 200, }, # 他者のpublicなので見れる
    { action:  :show,  params: { banana_key: "bob-private",   },  login: "alice", status: 403, }, # 他者のprivateなので見れない

    { action:  :edit,  params: {},  login: "alice", status: 200, }, # 新規なのでキーはない
    { action:  :edit,  params: { banana_key: "alice-public",  },  login: "alice", status: 200, }, # 自分のなので編集できる
    { action:  :edit,  params: { banana_key: "alice-private", },  login: "alice", status: 200, }, # 自分のなので編集できる

    { action:  :show,  params: { banana_key: "alice-private", },                  status: 403, }, # private はログインしてないから見れない
    { action:  :show,  params: { banana_key: "bob-private",   },  login: "alice", status: 403, }, # ログインしていてもオーナーが違うの見れない

    { action:  :show,  params: { banana_key: :x,              },                  status: 404, }, # 対象の動画がない

    { action:  :edit,  params: { banana_key: "bob-public",    },  login: "alice", status: 404, }, # 他者の編集ページには行けない
    { action:  :edit,  params: { banana_key: "bob-private",   },  login: "alice", status: 404, }, # 他者の編集ページには行けない

    # 権限に関わらずログインしていないので編集には行けない
    { action:  :edit,  params: {},                  status: 403, },
    { action:  :edit,  params: { banana_key: "alice-public",  },                  status: 403, },
    { action:  :edit,  params: { banana_key: "alice-private", },                  status: 403, },
    { action:  :edit,  params: { banana_key: "bob-public",    },                  status: 403, },
    { action:  :edit,  params: { banana_key: "bob-private",   },                  status: 403, },
  ].each do |e|
    it "アクセス制限" do
      if e[:login]
        user_login(User.find_by!(key: e[:login]))
      end
      get e[:action], params: e[:params]
      assert { response.status == e[:status] }
    end
  end
end

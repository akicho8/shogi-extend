require "rails_helper"

module Kiwi
  RSpec.describe Book, type: :model do
    include KiwiSupport

    it "works" do
      Folder.setup
      user1 = User.create!

      # 動画作成
      free_battle1 = user1.free_battles.create!(kifu_body: params1[:body], use_key: "kiwi_lemon")
      lemon1 = user1.kiwi_lemons.create!(recordable: free_battle1, all_params: params1[:all_params])
      lemon1.main_process
      # この時点でサムネは作らない
      assert { lemon1.thumbnail_real_path.exist? == false }
      tp lemon1 if $0 == "-"

      # 動画ライブラリ登録 (フォーム初期値)
      book1 = user1.kiwi_books.build(lemon: lemon1) # => #<Kiwi::Book id: nil, key: nil, user_id: 7, folder_id: nil, lemon_id: 7, title: nil, description: nil, thumbnail_pos: nil, book_messages_count: 0, created_at: nil, updated_at: nil, tag_list: nil>
      book1.form_values_default_assign
      tp book1.attributes if $0 == "-"           # => {"id"=>nil, "key"=>nil, "user_id"=>7, "folder_id"=>nil, "lemon_id"=>7, "title"=>"cover_text", "description"=>"\n", "thumbnail_pos"=>nil, "book_messages_count"=>0, "created_at"=>nil, "updated_at"=>nil, "tag_list"=>["居飛車", "相居飛車"]}
      assert { book1.thumbnail_pos == 0 }
      assert { book1.title == "(cover_text)" }
      assert { book1.description == "(description1)\n(description2)" }
      assert { book1.tag_list == ["居飛車", "相居飛車"] }

      # 確認のためにあれば削除しておく
      lemon1.thumbnail_clean
      assert { !lemon1.thumbnail_real_path.exist? }

      # 登録実行
      # サムネ位置が nil -> 0.5 になることでサムネ作成される
      book1 = user1.kiwi_books.create!(lemon: lemon1, title: "タイトル#{user1.kiwi_books.count.next}" * 4, description: "description" * 4, tag_list: %w(居飛車 嬉野流 右玉), thumbnail_pos: 0.5)
      assert { book1.thumbnail_pos == 0.5 }
      assert { lemon1.thumbnail_real_path.exist? }
      assert { lemon1.thumbnail_browser_path }
      tp book1 if $0 == "-" # => #<Kiwi::Book id: 1, key: "LGISalSHJdp", user_id: 7, folder_id: 9, lemon_id: 7, title: "タイトル1タイトル1タイトル1タイトル1", description: "descriptiondescriptiondescriptiondescription", thumbnail_pos: 0.0, book_messages_count: 0, created_at: "2000-01-01 00:00:00.000000000 +0900", updated_at: "2000-01-01 00:00:00.000000000 +0900", tag_list: ["居飛車", "嬉野流", "右玉"]>

      # コメントされた
      book1.book_messages.create!(user: user1, body: "(message1)")      # => #<Kiwi::BookMessage id: 1, user_id: 7, book_id: 1, body: "(message1)", created_at: "2000-01-01 00:00:00.000000000 +0900", updated_at: "2000-01-01 00:00:00.000000000 +0900">
      user1.kiwi_book_messages.create!(book: book1, body: "(message1)") # => #<Kiwi::BookMessage id: 2, user_id: 7, book_id: 1, body: "(message1)", created_at: "2000-01-01 00:00:00.000000000 +0900", updated_at: "2000-01-01 00:00:00.000000000 +0900">
      user1.kiwi_book_message_speak(book1, "(message1)")                # => #<Kiwi::BookMessage id: 3, user_id: 7, book_id: 1, body: "(message1)", created_at: "2000-01-01 00:00:00.000000000 +0900", updated_at: "2000-01-01 00:00:00.000000000 +0900">
    end

    it "検索" do
      Book.destroy_all
      Folder.setup
      user1 = User.create!
      free_battle1 = user1.free_battles.create!(kifu_body: params1[:body], use_key: "kiwi_lemon")
      lemon1 = user1.kiwi_lemons.create!(recordable: free_battle1, all_params: params1[:all_params])
      book1 = user1.kiwi_books.create!(lemon: lemon1, title: "アヒル", description: "(description)", folder_key: "public", tag_list: ["a", "b"])
      assert { Book.general_search(query: "あひる").present? }
      assert { Book.general_search(query: "(description)").present? }
      assert { Book.general_search(query: "unknown").blank? }
      assert { Book.general_search(tag: "a").present? }
      assert { Book.general_search(tag: "c").blank? }

      # public なので非公開スコープでは表示しない
      assert { Book.general_search(current_user: user1, search_preset_key: "非公開").blank? }
      # private なので非公開で表示する
      book1.update!(folder_key: "private")
      assert { Book.general_search(current_user: user1, search_preset_key: "非公開").present? }
      # private でも自分用の動画はすべてに表示してたけどやめた
      assert { Book.general_search(current_user: user1, search_preset_key: "すべて").blank? }
    end
  end
end

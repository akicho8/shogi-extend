# -*- coding: utf-8 -*-
# == Schema Information ==
#
# アーカイブ (kiwi_books as Kiwi::Book)
#
# |---------------------+---------------------+-------------+---------------------+--------------+-------|
# | name                | desc                | type        | opts                | refs         | index |
# |---------------------+---------------------+-------------+---------------------+--------------+-------|
# | id                  | ID                  | integer(8)  | NOT NULL PK         |              |       |
# | key                 | ユニークなハッシュ  | string(255) | NOT NULL            |              | A!    |
# | user_id             | User                | integer(8)  | NOT NULL            | => ::User#id | C     |
# | folder_id           | Folder              | integer(8)  | NOT NULL            |              | D     |
# | lemon_id            | 動画ファイル        | integer(8)  | NOT NULL            |              | B!    |
# | title               | タイトル            | string(100) | NOT NULL            |              |       |
# | description         | 説明                | text(65535) | NOT NULL            |              |       |
# | thumbnail_pos       | Thumbnail pos       | float(24)   | NOT NULL            |              |       |
# | book_messages_count | Book messages count | integer(4)  | DEFAULT(0) NOT NULL |              | E     |
# | created_at          | 作成日時            | datetime    | NOT NULL            |              |       |
# | updated_at          | 更新日時            | datetime    | NOT NULL            |              |       |
# |---------------------+---------------------+-------------+---------------------+--------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# User.has_one :profile
#--------------------------------------------------------------------------------

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
      book1 = user1.kiwi_books.build(lemon: lemon1) # => #<Kiwi::Book id: nil, key: nil, user_id: 1, folder_id: nil, lemon_id: 1, title: nil, description: nil, thumbnail_pos: nil, book_messages_count: 0, access_logs_count: 0, created_at: nil, updated_at: nil, tag_list: nil>
      book1.form_values_default_assign
      tp book1.attributes if $0 == "-"           # => {"id"=>nil, "key"=>nil, "user_id"=>1, "folder_id"=>nil, "lemon_id"=>1, "title"=>"(cover_text)", "description"=>"(description1)\n(description2)", "thumbnail_pos"=>0.0, "book_messages_count"=>0, "access_logs_count"=>0, "created_at"=>nil, "updated_at"=>nil, "tag_list"=>["居飛車", "相居飛車"]}
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
      tp book1 if $0 == "-" # => #<Kiwi::Book id: 1, key: "YRZcPsCS27n", user_id: 1, folder_id: 3, lemon_id: 1, title: "タイトル1タイトル1タイトル1タイトル1", description: "descriptiondescriptiondescriptiondescription", thumbnail_pos: 0.5, book_messages_count: 0, access_logs_count: 0, created_at: "2000-01-01 00:00:00.000000000 +0900", updated_at: "2000-01-01 00:00:00.000000000 +0900", tag_list: ["居飛車", "嬉野流", "右玉"]>

      # コメントされた
      book1.book_messages.create!(user: user1, body: "(message1)")      # => #<Kiwi::BookMessage id: 1, user_id: 1, book_id: 1, body: "(message1)", created_at: "2000-01-01 00:00:00.000000000 +0900", updated_at: "2000-01-01 00:00:00.000000000 +0900">
      user1.kiwi_book_messages.create!(book: book1, body: "(message1)") # => #<Kiwi::BookMessage id: 2, user_id: 1, book_id: 1, body: "(message1)", created_at: "2000-01-01 00:00:00.000000000 +0900", updated_at: "2000-01-01 00:00:00.000000000 +0900">
      user1.kiwi_book_message_speak(book1, "(message1)")                # => #<Kiwi::BookMessage id: 3, user_id: 1, book_id: 1, body: "(message1)", created_at: "2000-01-01 00:00:00.000000000 +0900", updated_at: "2000-01-01 00:00:00.000000000 +0900">

      # アクセスされた
      book1.access_logs.create!(user: user1)   # => #<Kiwi::AccessLog id: 1, user_id: 1, book_id: 1, created_at: "2000-01-01 00:00:00.000000000 +0900">
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
# >> Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >> |------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> |       errored_at |                                                                                                                                                                                                                                                                     |
# >> |    error_message |                                                                                                                                                                                                                                                                     |
# >> |     successed_at | 2000-01-01 00:00:00 +0900                                                                                                                                                                                                                                           |
# >> |     ffprobe_info | {:pretty_format=>{"streams"=>[{"index"=>0, "codec_name"=>"h264", "codec_long_name"=>"H.264 / AVC / MPEG-4 AVC / MPEG-4 part 10", "profile"=>"High", "codec_type"=>"video", "codec_tag_string"=>"avc1", "codec_tag"=>"0x31637661", "width"=>2, "height"=>2, "code... |
# >> |        file_size | 101106                                                                                                                                                                                                                                                              |
# >> |     content_type | video/mp4                                                                                                                                                                                                                                                           |
# >> |   filename_human | 1_20000101000000_2x2_6s.mp4                                                                                                                                                                                                                                         |
# >> |     browser_path | /system/x-files/fr/ee/1_20000101000000_2x2_6s.mp4                                                                                                                                                                                                                   |
# >> |   process_end_at | 2000-01-01 00:00:00 +0900                                                                                                                                                                                                                                           |
# >> |       all_params | {:sleep=>0, :raise_message=>"", :media_builder_params=>{:recipe_key=>"is_recipe_mp4", :loop_key=>"is_loop_infinite", :page_duration=>1, :end_duration=>2, :viewpoint=>"black", :color_theme_key=>"color_theme_is_real_wood1", :audio_theme_key=>"audio_theme_is_... |
# >> |               id | 1                                                                                                                                                                                                                                                                   |
# >> |          user_id | 1                                                                                                                                                                                                                                                                   |
# >> |  recordable_type | FreeBattle                                                                                                                                                                                                                                                          |
# >> |    recordable_id | 1                                                                                                                                                                                                                                                                   |
# >> | process_begin_at | 2000-01-01 00:00:00 +0900                                                                                                                                                                                                                                           |
# >> |       created_at | 2000-01-01 00:00:00 +0900                                                                                                                                                                                                                                           |
# >> |       updated_at | 2000-01-01 00:00:00 +0900                                                                                                                                                                                                                                           |
# >> |------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> |---------------------+--------------------------------|
# >> |                  id |                                |
# >> |                 key |                                |
# >> |             user_id | 1                              |
# >> |           folder_id |                                |
# >> |            lemon_id | 1                              |
# >> |               title | (cover_text)                   |
# >> |         description | (description1)\n(description2) |
# >> |       thumbnail_pos | 0.0                            |
# >> | book_messages_count | 0                              |
# >> |   access_logs_count | 0                              |
# >> |          created_at |                                |
# >> |          updated_at |                                |
# >> |            tag_list | 居飛車 相居飛車                |
# >> |---------------------+--------------------------------|
# >> ["/Users/ikeda/src/shogi-extend/app/models/kiwi/lemon/thumbnail_methods.rb:10", :thumbnail_build]
# >> |---------------------+----------------------------------------------|
# >> |                  id | 1                                            |
# >> |                 key | YRZcPsCS27n                                  |
# >> |             user_id | 1                                            |
# >> |           folder_id | 3                                            |
# >> |            lemon_id | 1                                            |
# >> |               title | タイトル1タイトル1タイトル1タイトル1         |
# >> |         description | descriptiondescriptiondescriptiondescription |
# >> |       thumbnail_pos | 0.5                                          |
# >> | book_messages_count | 0                                            |
# >> |   access_logs_count | 0                                            |
# >> |          created_at | 2000-01-01 00:00:00 +0900                    |
# >> |          updated_at | 2000-01-01 00:00:00 +0900                    |
# >> |            tag_list | 居飛車 嬉野流 右玉                           |
# >> |---------------------+----------------------------------------------|
# >> ..
# >> 
# >> Top 2 slowest examples (11.71 seconds, 83.9% of total time):
# >>   Kiwi::Book works
# >>     11.06 seconds -:32
# >>   Kiwi::Book 検索
# >>     0.6504 seconds -:76
# >> 
# >> Finished in 13.95 seconds (files took 13.34 seconds to load)
# >> 2 examples, 0 failures
# >> 

# -*- coding: utf-8 -*-

# == Schema Information ==
#
# Article (wkbk_articles as Wkbk::Article)
#
# |---------------------+---------------------+-------------+---------------------+------+-------|
# | name                | desc                | type        | opts                | refs | index |
# |---------------------+---------------------+-------------+---------------------+------+-------|
# | id                  | ID                  | integer(8)  | NOT NULL PK         |      |       |
# | key                 | キー                | string(255) | NOT NULL            |      | A!    |
# | user_id             | User                | integer(8)  | NOT NULL            |      | B     |
# | folder_id           | Folder              | integer(8)  | NOT NULL            |      | C     |
# | lineage_id          | Lineage             | integer(8)  | NOT NULL            |      | D     |
# | init_sfen           | Init sfen           | string(255) | NOT NULL            |      | E     |
# | viewpoint           | Viewpoint           | string(255) | NOT NULL            |      |       |
# | title               | タイトル            | string(100) | NOT NULL            |      |       |
# | description         | 説明                | text(65535) | NOT NULL            |      |       |
# | direction_message   | Direction message   | string(100) | NOT NULL            |      |       |
# | turn_max            | 手数                | integer(4)  | NOT NULL            |      | F     |
# | mate_skip           | Mate skip           | boolean     | NOT NULL            |      |       |
# | moves_answers_count | Moves answers count | integer(4)  | DEFAULT(0) NOT NULL |      |       |
# | difficulty          | Difficulty          | integer(4)  | NOT NULL            |      | G     |
# | answer_logs_count   | Answer logs count   | integer(4)  | DEFAULT(0) NOT NULL |      |       |
# | created_at          | 作成日時            | datetime    | NOT NULL            |      |       |
# | updated_at          | 更新日時            | datetime    | NOT NULL            |      |       |
# |---------------------+---------------------+-------------+---------------------+------+-------|
#
# - Remarks ----------------------------------------------------------------------
# [Warning: Need to add relation] Wkbk::Article モデルに belongs_to :lineage を追加しよう
# [Warning: Need to add relation] Wkbk::Article モデルに belongs_to :user を追加しよう
# --------------------------------------------------------------------------------

require "rails_helper"

RSpec.describe Wkbk::Article, type: :model do
  include WkbkSupportMethods
  include ActiveJob::TestHelper # for perform_enqueued_jobs

  it "valid?" do
    assert { article1.valid? }
  end

  it "sorted" do
    assert { Wkbk::Article.sorted(sort_column: "id",         sort_order: "asc") }
    assert { Wkbk::Article.sorted(sort_column: "user.id",    sort_order: "asc") }
    assert { Wkbk::Article.sorted(sort_column: "books.id",   sort_order: "asc") }
    assert { Wkbk::Article.sorted(sort_column: "lineage.id", sort_order: "asc") }
    assert { Wkbk::Article.sorted(sort_column: "folder.id",  sort_order: "asc") }
  end

  it "tweet_body" do
    assert { article1.tweet_body }
  end

  describe "update_from_action" do
    it "works" do
      user1 = User.create!
      user1.wkbk_books.create!(key: "book1")

      params = {
        :init_sfen        => "position sfen 4k4/9/4GG3/9/9/9/9/9/9 b 2r2b2g4s4n4l18p 1",
        :moves_answers    => [{ "moves_str"=>"4c5b" }],
        :time_limit_clock => "1999-12-31T15:03:00.000Z",
        :tag_list         => ["tag1 tag2", "tag3"],
        :book_keys        => ["book1"],
      }

      # 1つ目を作る
      article = user1.wkbk_articles.build
      perform_enqueued_jobs do
        article.update_from_action(params)
      end

      assert { article.persisted? }
      assert { article.tag_list == ["tag1", "tag2", "tag3"] }
      assert { article.turn_max == 1 }
      assert { article.book_keys == ["book1"] }

      if false
        # 開発者に通知
        mail = ActionMailer::Base.deliveries.last
        assert { mail.to   == ["shogi.extend@gmail.com"] }
        assert { mail.subject.include?("作成") }
        # puts mail.body
      end

      # 同じ2つ目を作る→失敗
      article = user1.wkbk_articles.build
      proc { article.update_from_action(params) }.should raise_error(ActiveRecord::RecordInvalid)
      assert { article.persisted? == false }
      assert { article.turn_max == 0 }
    end
  end

  describe "入力補正" do
    it "works" do
      article1.update!(description: " ａ１　　\n　　ｚ\n ")
      assert { article1.description == "a1\nz" }
    end
  end

  describe "属性" do
    it "works" do
      assert { article1.lineage.name }
    end
  end

  # describe "所在" do
  #   it "works" do
  #     article1.update!(source_about_key: "unknown") # => true
  #     assert { article1.source_about_key == "unknown"   }
  #     assert { article1.source_about.name == "作者不詳" }
  #   end
  # end

  # describe "フォルダ" do
  #   it "初期値" do
  #     assert { article1.folder_key == :public }
  #   end
  #   it "移動方法1" do
  #     user1.wkbk_private_box.articles << article1
  #     assert { article1.folder.class == Wkbk::PrivateBox }
  #   end
  #   it "移動方法2(フォーム用)" do
  #     article1.folder_key = :private
  #     assert { article1.folder_key == :private }
  #   end
  # end

  it "init_sfen" do
    article1.init_sfen = "position sfen 9/9/9/9/9/9/9/9/9 b - 1"
    assert { article1.read_attribute(:init_sfen) == "9/9/9/9/9/9/9/9/9 b - 1" }
    assert { article1.init_sfen == "position sfen 9/9/9/9/9/9/9/9/9 b - 1" }
  end

  it "main_sfen" do
    assert { article1.main_sfen == "position sfen 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l18p 1 moves G*5b" }
  end

  it "info" do
    assert { article1.info }
  end

  it "to_kif" do
    assert { article1.to_kif }
  end

  it "page_url" do
    assert { article1.page_url == "http://localhost:4000/rack/articles/#{article1.key}" }
  end

  it "share_board_png_url" do
    assert { article1.share_board_png_url == "http://localhost:3000/share-board.png?body=position+sfen+4k4%2F9%2F4G4%2F9%2F9%2F9%2F9%2F9%2F9+b+G2r2b2g4s4n4l18p+1+moves+G%2A5b&turn=0&viewpoint=black" }
  end

  it "share_board_url" do
    assert { article1.share_board_url == "http://localhost:4000/share-board?body=position+sfen+4k4%2F9%2F4G4%2F9%2F9%2F9%2F9%2F9%2F9+b+G2r2b2g4s4n4l18p+1+moves+G%2A5b&title=title&turn=0&viewpoint=black"  }
  end

  it "mail_body" do
    assert { article1.mail_body }
  end

  it "mail_subject" do
    assert { article1.mail_subject }
  end

  # it "公開フォルダに移動させたタイミングで投稿通知" do
  #   article1.update!(folder_key: "private")
  #   Wkbk::LobbyMessage.destroy_all
  #
  #   assert { Wkbk::LobbyMessage.count == 0 }
  #
  #   article1.update_from_action(folder_key: "public")
  #   assert { Wkbk::LobbyMessage.count == 1 }
  #
  #   article1.update_from_action(folder_key: "private")
  #   assert { Wkbk::LobbyMessage.count == 1 }
  # end

  # it "message_users" do
  #   article1.messages.create!(user: user1, body: "(body)")
  #   assert { article1.message_users == [user1] }
  # end

  it "turn_max" do
    assert { article1.turn_max == 1 }
    article1.moves_answers.create!("moves_str" => "G*5b 5a5b")
    assert { article1.turn_max == 2 }
  end

  it "destroy" do
    user = User.create!
    article = user.wkbk_articles.create!(init_sfen: "position sfen 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l1p 1")
    article.moves_answers.create!("moves_str" => "G*5b")
    article.destroy!
  end

  describe "form_values_default_assign" do
    it "works" do
      @user = User.create!

      source_article = @user.wkbk_articles.create!(title: "xxx", init_sfen: "position sfen 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l1p 1")
      source_article.default_assign_from_individual_params({})
      source_article.moves_answers.create!("moves_str" => "G*5b")

      article = @user.wkbk_articles.build
      article.default_assign_from_source_article(source_article: source_article)
      article.moves_answer_validate_skip = true
      assert { article.title == "xxxのコピー" }
      assert { article.valid? }
      assert { article.save }
    end
  end
end

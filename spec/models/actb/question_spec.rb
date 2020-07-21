# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Question (actb_questions as Actb::Question)
#
# |---------------------+---------------------+-------------+---------------------+--------------+-------|
# | name                | desc                | type        | opts                | refs         | index |
# |---------------------+---------------------+-------------+---------------------+--------------+-------|
# | id                  | ID                  | integer(8)  | NOT NULL PK         |              |       |
# | key                 | ユニークなハッシュ  | string(255) | NOT NULL            |              | A     |
# | user_id             | User                | integer(8)  | NOT NULL            | => ::User#id | B     |
# | folder_id           | Folder              | integer(8)  | NOT NULL            |              | C     |
# | lineage_id          | Lineage             | integer(8)  | NOT NULL            |              | D     |
# | init_sfen           | Init sfen           | string(255) | NOT NULL            |              | E     |
# | time_limit_sec      | Time limit sec      | integer(4)  |                     |              | F     |
# | difficulty_level    | Difficulty level    | integer(4)  |                     |              | G     |
# | title               | タイトル            | string(255) |                     |              |       |
# | description         | 説明                | string(512) |                     |              |       |
# | hint_desc           | Hint desc           | string(255) |                     |              |       |
# | source_author       | Source author       | string(255) |                     |              |       |
# | source_media_name   | Source media name   | string(255) |                     |              |       |
# | source_media_url    | Source media url    | string(255) |                     |              |       |
# | source_published_on | Source published on | date        |                     |              |       |
# | created_at          | 作成日時            | datetime    | NOT NULL            |              |       |
# | updated_at          | 更新日時            | datetime    | NOT NULL            |              |       |
# | good_rate           | Good rate           | float(24)   | NOT NULL            |              | H     |
# | moves_answers_count | Moves answers count | integer(4)  | DEFAULT(0) NOT NULL |              |       |
# | histories_count     | Histories count     | integer(4)  | DEFAULT(0) NOT NULL |              | I     |
# | good_marks_count    | Good marks count    | integer(4)  | DEFAULT(0) NOT NULL |              | J     |
# | bad_marks_count     | Bad marks count     | integer(4)  | DEFAULT(0) NOT NULL |              | K     |
# | clip_marks_count    | Clip marks count    | integer(4)  | DEFAULT(0) NOT NULL |              | L     |
# | messages_count      | Messages count      | integer(4)  | DEFAULT(0) NOT NULL |              | M     |
# | direction_message   | Direction message   | string(255) |                     |              |       |
# | source_about_id     | Source about        | integer(8)  |                     |              | N     |
# | turn_max            | 手数                | integer(4)  |                     |              | O     |
# |---------------------+---------------------+-------------+---------------------+--------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# User.has_many :actb_room_messages
#--------------------------------------------------------------------------------

require 'rails_helper'

module Actb
  RSpec.describe Question, type: :model do
    include ActbSupportMethods
    include ActiveJob::TestHelper # for perform_enqueued_jobs

    it do
      assert { question1.valid? }
    end

    describe "update_from_js 保存" do
      let :params do
        {
          :init_sfen        => "position sfen 4k4/9/4GG3/9/9/9/9/9/9 b 2r2b2g4s4n4l18p 1",
          :moves_answers    => [{"moves_str"=>"4c5b"}],
          :time_limit_clock => "1999-12-31T15:03:00.000Z",
          :owner_tag_list   => ["tag1 tag2", "tag3"],
        }
      end

      it do
        # 1つ目を作る
        question = user1.actb_questions.build
        perform_enqueued_jobs do
          question.update_from_js(params)
        end
        assert { question.persisted? }
        assert { question.owner_tag_list == ["tag1", "tag2", "tag3"] }
        assert { question.turn_max == 1 }

        # 開発者に通知
        mail = ActionMailer::Base.deliveries.last
        assert { mail.to   == ["shogi.extend@gmail.com"] }
        assert { mail.subject.include?("投稿しました") }

        # 同じ2つ目を作る→失敗
        question = user1.actb_questions.build
        proc { question.update_from_js(params) }.should raise_error(ActiveRecord::RecordInvalid)
        assert { question.persisted? == false }
        assert { question.turn_max == nil }
      end
    end

    describe "入力補正" do
      it do
        question1.update!(description: " ａ　　\n　　ｚ\n ")
        assert { question1.description == "a\nz" }
      end
    end

    describe "属性" do
      it do
        assert { question1.lineage.name == "詰将棋" }
      end
    end

    describe "所在" do
      it do
        question1.update!(source_about_key: "unknown") # => true
        assert { question1.source_about_key == "unknown"   }
        assert { question1.source_about.name == "作者不詳" }
      end
    end

    describe "フォルダ" do
      it "初期値" do
        assert { question1.folder_key == "active" }
      end
      it "移動方法1" do
        user1.actb_trash_box.questions << question1
        assert { question1.folder.class == Actb::TrashBox }
      end
      it "移動方法2(フォーム用)" do
        question1.folder_key = :trash
        assert { question1.folder_key == "trash" }
      end
    end

    it "init_sfen" do
      question1.init_sfen = "position sfen 9/9/9/9/9/9/9/9/9 b - 1"
      assert { question1.read_attribute(:init_sfen) == "9/9/9/9/9/9/9/9/9 b - 1" }
      assert { question1.init_sfen == "position sfen 9/9/9/9/9/9/9/9/9 b - 1" }
    end

    it "main_sfen" do
      assert { question1.main_sfen == "position sfen 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l1p 1 moves G*5b" }
    end

    it "info" do
      # tp question1.info
      assert { question1.info }
    end

    it "to_kif" do
      assert { question1.to_kif }
    end

    it "page_url" do
      assert { question1.page_url == "http://localhost:3000/training?question_id=#{question1.id}" }
    end

    it "share_board_png_url" do
      assert { question1.share_board_png_url == "http://localhost:3000/share-board.png?body=position+sfen+4k4%2F9%2F4G4%2F9%2F9%2F9%2F9%2F9%2F9+b+G2r2b2g4s4n4l1p+1+moves+G%2A5b&image_view_point=black&turn=0" }
    end

    it "share_board_url" do
      assert { question1.share_board_url == "http://localhost:3000/share-board?body=position+sfen+4k4%2F9%2F4G4%2F9%2F9%2F9%2F9%2F9%2F9+b+G2r2b2g4s4n4l1p+1+moves+G%2A5b&image_view_point=black&title=%28title1%29&turn=0" }
    end

    it "公開フォルダに移動させたタイミングで投稿通知" do
      question1.update!(folder_key: "draft")
      Actb::LobbyMessage.destroy_all

      assert { Actb::LobbyMessage.count == 0 }

      question1.update_from_js(folder_key: "active")
      assert { Actb::LobbyMessage.count == 1 }

      question1.update_from_js(folder_key: "draft")
      assert { Actb::LobbyMessage.count == 1 }
    end

    it "message_users" do
      question1.messages.create!(user: user1, body: "(body)")
      assert { question1.message_users == [user1] }
    end

    it "turn_max" do
      assert { question1.turn_max == 1 }
      question1.moves_answers.create!("moves_str" => "4c5b 4c4b 4c5b")
      assert { question1.turn_max == 3 }
    end
  end
end
# >> Run options: exclude {:slow_spec=>true}
# >> .................
# >>
# >> Finished in 2.88 seconds (files took 2.17 seconds to load)
# >> 17 examples, 0 failures
# >>

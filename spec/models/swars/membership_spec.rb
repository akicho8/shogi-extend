# -*- coding: utf-8 -*-

# == Schema Information ==
#
# 対局と対局者の対応 (swars_memberships as Swars::Membership)
#
# |-----------------------+-----------------------+------------+-------------+-------------------------+------------|
# | name                  | desc                  | type       | opts        | refs                    | index      |
# |-----------------------+-----------------------+------------+-------------+-------------------------+------------|
# | id                    | ID                    | integer(8) | NOT NULL PK |                         |            |
# | battle_id             | 対局共通情報          | integer(8) | NOT NULL    |                         | A! B! C! E |
# | user_id               | ユーザー              | integer(8) | NOT NULL    | => User#id              | A! F       |
# | op_user_id            | Op user               | integer(8) |             | => Swars::User#id       | C! G       |
# | grade_id              | 棋力                  | integer(8) | NOT NULL    |                         | H          |
# | position              | 順序                  | integer(4) |             |                         | I          |
# | grade_diff            | Grade diff            | integer(4) | NOT NULL    |                         |            |
# | created_at            | 作成日時              | datetime   | NOT NULL    |                         |            |
# | updated_at            | 更新日時              | datetime   | NOT NULL    |                         |            |
# | think_all_avg         | Think all avg         | integer(4) |             |                         |            |
# | think_end_avg         | Think end avg         | integer(4) |             |                         |            |
# | think_last            | Think last            | integer(4) |             |                         |            |
# | think_max             | Think max             | integer(4) |             |                         |            |
# | ai_drop_total         | Ai drop total         | integer(4) |             |                         |            |
# | judge_id              | Judge                 | integer(8) | NOT NULL    | => Judge#id             | J          |
# | location_id           | Location              | integer(8) | NOT NULL    | => Location#id          | B! K       |
# | style_id              | Style                 | integer(8) |             |                         | L          |
# | ek_score_without_cond | Ek score without cond | integer(4) |             |                         |            |
# | ek_score_with_cond    | Ek score with cond    | integer(4) |             |                         |            |
# | ai_wave_count         | Ai wave count         | integer(4) |             |                         |            |
# | ai_two_freq           | Ai two freq           | float(24)  |             |                         |            |
# | ai_noizy_two_max      | Ai noizy two max      | integer(4) |             |                         |            |
# | ai_gear_freq          | Ai gear freq          | float(24)  |             |                         |            |
# | opponent_id           | Opponent              | integer(8) |             | => Swars::Membership#id | D!         |
# |-----------------------+-----------------------+------------+-------------+-------------------------+------------|
#
# - Remarks ----------------------------------------------------------------------
# Judge.has_many :swars_memberships
# Location.has_many :swars_memberships
# Swars::Membership.belongs_to :opponent
# Swars::User.has_many :op_memberships, foreign_key: :op_user_id
# User.has_one :profile
# --------------------------------------------------------------------------------

require "rails_helper"

RSpec.describe Swars::Membership, type: :model, swars_spec: true do
  describe "タグ" do
    it "works" do
      battle = Swars::Battle.create!
      assert { battle.memberships[0].attack_tag_list  == ["新嬉野流"]                       }
      assert { battle.memberships[1].attack_tag_list  == ["2手目△3二飛戦法"]              }
      assert { battle.memberships[0].defense_tag_list == []                                 }
      assert { battle.memberships[1].defense_tag_list == []                                 }
      assert { battle.memberships[0].note_tag_list    == ["対振り飛車", "対抗形"]           }
      assert { battle.memberships[1].note_tag_list    == ["振り飛車", "対抗形"]             }
    end

    it "タグ検索で LOWER を使う" do
      battle = Swars::Battle.create!
      assert { Swars::Membership.tagged_with("居玉").to_sql.include?("LOWER") }
    end
  end

  describe "相互参照" do
    it "対戦者が即参照できる" do
      battle = Swars::Battle.create!.reload
      assert { battle.memberships[0].op_user }
      assert { battle.memberships[1].op_user }
      assert { battle.memberships[0].op_user == battle.memberships[1].user }
      assert { battle.memberships[1].op_user == battle.memberships[0].user }
    end

    it "相手のレコードを即参照できる" do
      battle = Swars::Battle.create!.reload
      assert { battle.memberships[0].opponent }
      assert { battle.memberships[1].opponent }
      assert { battle.memberships[0].opponent == battle.memberships[1] }
      assert { battle.memberships[1].opponent == battle.memberships[0] }
    end
  end

  it "location_human_name" do
    battle = Swars::Battle.create!(preset_key: "角落ち")
    assert { battle.memberships[0].location_human_name == "下手" }
  end
end

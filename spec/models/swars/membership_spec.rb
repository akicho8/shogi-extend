# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 対局と対局者の対応 (swars_memberships as Swars::Membership)
#
# |-----------------------+-----------------------+------------+-------------+-------------------+------------|
# | name                  | desc                  | type       | opts        | refs              | index      |
# |-----------------------+-----------------------+------------+-------------+-------------------+------------|
# | id                    | ID                    | integer(8) | NOT NULL PK |                   |            |
# | battle_id             | 対局共通情報          | integer(8) | NOT NULL    |                   | A! B! C! D |
# | user_id               | ユーザー              | integer(8) | NOT NULL    | => User#id        | A! E       |
# | op_user_id            | Op user               | integer(8) |             | => Swars::User#id | C! F       |
# | grade_id              | 棋力                  | integer(8) | NOT NULL    |                   | G          |
# | position              | 順序                  | integer(4) |             |                   | H          |
# | grade_diff            | Grade diff            | integer(4) | NOT NULL    |                   |            |
# | created_at            | 作成日時              | datetime   | NOT NULL    |                   |            |
# | updated_at            | 更新日時              | datetime   | NOT NULL    |                   |            |
# | think_all_avg         | Think all avg         | integer(4) |             |                   |            |
# | think_end_avg         | Think end avg         | integer(4) |             |                   |            |
# | two_serial_max        | Two serial max        | integer(4) |             |                   |            |
# | think_last            | Think last            | integer(4) |             |                   |            |
# | think_max             | Think max             | integer(4) |             |                   |            |
# | obt_think_avg         | Obt think avg         | integer(4) |             |                   |            |
# | ai_drop_total          | Obt auto max          | integer(4) |             |                   |            |
# | judge_id              | Judge                 | integer(8) | NOT NULL    | => Judge#id       | I          |
# | location_id           | Location              | integer(8) | NOT NULL    | => Location#id    | B! J       |
# | style_id              | Style                 | integer(8) |             |                   | K          |
# | ek_score_without_cond | Ek score without cond | integer(4) |             |                   |            |
# | ek_score_with_cond    | Ek score with cond    | integer(4) |             |                   |            |
# |-----------------------+-----------------------+------------+-------------+-------------------+------------|
#
#- Remarks ----------------------------------------------------------------------
# Judge.has_many :swars_memberships
# Location.has_many :swars_memberships
# Swars::User.has_many :op_memberships, foreign_key: :op_user_id
# User.has_one :profile
#--------------------------------------------------------------------------------

require "rails_helper"

module Swars
  RSpec.describe Membership, type: :model, swars_spec: true do
    let :record do
      Battle.create!
    end

    describe "タグ" do
      it "works" do
        assert { record.memberships[0].attack_tag_list  == ["新嬉野流"]                   }
        assert { record.memberships[1].attack_tag_list  == ["2手目△３ニ飛戦法"]          }
        assert { record.memberships[0].defense_tag_list == []                             }
        assert { record.memberships[1].defense_tag_list == []                             }
        assert { record.memberships[0].note_tag_list    == ["居飛車", "対振り", "対抗形"] }
        assert { record.memberships[1].note_tag_list    == ["振り飛車", "対抗形"]         }
      end

      it "タグ検索で LOWER を使う" do
        assert { Membership.tagged_with("居玉").to_sql.include?("LOWER") }
      end
    end

    describe "カラム" do
      it "お互いに対戦者がわかる" do
        assert { record.memberships[0].op_user }
        assert { record.memberships[1].op_user }
        assert { record.memberships[0].op_user == record.memberships[1].user }
        assert { record.memberships[1].op_user == record.memberships[0].user }
      end
      # it "お互いの対戦情報がわかる" do
      #   assert { record.memberships[0].opponent }
      #   assert { record.memberships[1].opponent }
      #   assert { record.memberships[0].opponent == record.memberships[1] }
      #   assert { record.memberships[1].opponent == record.memberships[0] }
      # end
    end
  end
end

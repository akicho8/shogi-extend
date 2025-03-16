# -*- coding: utf-8 -*-
# == Swars::Schema Swars::Information ==
#
# Swars::Membership extra (swars_membership_extras as Swars::MembershipExtra)
#
# |-------------------+-------------------+------------+-------------+------+-------|
# | name              | desc              | type       | opts        | refs | index |
# |-------------------+-------------------+------------+-------------+------+-------|
# | id                | ID                | integer(8) | NOT NULL PK |      |       |
# | membership_id     | Swars::Membership        | integer(8) | NOT NULL    |      | A!    |
# | used_piece_counts | Swars::Used piece counts | json       | NOT NULL    |      |       |
# | created_at        | 作成日時          | datetime   | NOT NULL    |      |       |
# | updated_at        | 更新日時          | datetime   | NOT NULL    |      |       |
# |-------------------+-------------------+------------+-------------+------+-------|

require "rails_helper"

RSpec.describe Swars::MembershipExtra, type: :model, swars_spec: true do
  let(:battle)     { Swars::Battle.create!        }
  let(:membership) { battle.memberships[0] }

  it "relation" do
    assert { membership.membership_extra }
    assert { membership.membership_extra.membership }
  end

  it "駒の使用頻度が正しい" do
    assert { membership.membership_extra.used_piece_counts == {"S0" => 2, "P0" => 1} }
  end

  it "membership_extraを持っていないレコードもremakeで生やせる" do
    membership.membership_extra.destroy! # わざと消す
    Swars::Battle.find(battle.id).rebuild        # 作り直す
    assert { Swars::Battle.find(battle.id).memberships[0].membership_extra }
    assert { Swars::Battle.find(battle.id).memberships[0].membership_extra.used_piece_counts.present? }
  end
end

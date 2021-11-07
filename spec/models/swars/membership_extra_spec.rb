# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Membership extra (swars_membership_extras as Swars::MembershipExtra)
#
# |-------------------+-------------------+------------+-------------+------+-------|
# | name              | desc              | type       | opts        | refs | index |
# |-------------------+-------------------+------------+-------------+------+-------|
# | id                | ID                | integer(8) | NOT NULL PK |      |       |
# | membership_id     | Membership        | integer(8) | NOT NULL    |      | A!    |
# | used_piece_counts | Used piece counts | json       | NOT NULL    |      |       |
# | created_at        | 作成日時          | datetime   | NOT NULL    |      |       |
# | updated_at        | 更新日時          | datetime   | NOT NULL    |      |       |
# |-------------------+-------------------+------------+-------------+------+-------|

require "rails_helper"

module Swars
  RSpec.describe MembershipExtra, type: :model do
    before do
      Swars.setup
    end

    let(:battle)     { Battle.create!        }
    let(:membership) { battle.memberships[0] }

    it "relation" do
      assert { membership.membership_extra }
      assert { membership.membership_extra.membership }
    end

    it "駒の使用頻度が正しい" do
      assert { membership.membership_extra.used_piece_counts == {"S0" => 2, "P0" => 1} }
    end

    it "membershipとautosaveで連動しているのでremakeで更新できる" do
      membership.membership_extra.update!(used_piece_counts: {}) # わざと空にする
      assert_used_piece_counts_present
    end

    it "membership_extraを持っていないレコードもremakeで生やせる" do
      membership.membership_extra.destroy! # わざと消す
      assert_used_piece_counts_present
    end

    # 作り直したとき membership_extra が生えて、used_piece_counts にデータも入っている
    def assert_used_piece_counts_present
      Battle.find(battle.id).remake # 作り直す
      assert { Battle.find(battle.id).memberships[0].membership_extra }
      assert { Battle.find(battle.id).memberships[0].membership_extra.used_piece_counts.present? }
    end
  end
end
# >> Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >> .
# >>
# >> Top 1 slowest examples (0.73931 seconds, 25.0% of total time):
# >>   Swars::MembershipExtra works
# >>     0.73931 seconds -:9
# >>
# >> Finished in 2.95 seconds (files took 12.3 seconds to load)
# >> 1 example, 0 failures
# >>

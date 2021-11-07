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

module Swars
  class MembershipExtra < ApplicationRecord
    belongs_to :membership      # プレイヤー対局情報

    before_validation on: :create do
      self.used_piece_counts ||= {}
    end

    # production ではバリデーション不要。DBに任せる
    if Rails.env.development? || Rails.env.test?
      with_options allow_blank: true do
        validates :membership_id, uniqueness: true
      end
    end
  end
end

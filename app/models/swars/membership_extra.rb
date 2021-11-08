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
    class << self
      # cap production deploy:upload FILES=app/models/swars/membership_extra.rb
      # RAILS_ENV=production nohup bundle exec bin/rails r 'Swars::MembershipExtra.create_if_nothing' &
      def create_if_nothing
        # production 更新
        # r = t.advance(days: 0)...t.advance(days: 1)
        # Swars::MembershipExtra.delete_all
        # ActiveRecord::Base.logger = ActiveSupport::Logger.new(STDOUT)
        t = Time.current.midnight
        r = "2021-10-01".to_time..."2021-12-01".to_time
        m = Swars::Membership.membership_extra_missing
        b = Swars::Battle.where(battled_at: r).where(memberships: m)
        total = b.count
        SlackAgent.notify(subject: "create_if_nothing", body: b.count)
        offset = 0
        b.find_in_batches do |av|
          SlackAgent.notify(subject: "create_if_nothing", body: [offset, total])
          av.each(&:membership_extra_create_if_nothing)
          offset += av.size
        end
        # tp Swars::MembershipExtra
        SlackAgent.notify(subject: "create_if_nothing", body: "完了")
      end
    end

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

# -*- coding: utf-8 -*-
# == Schema Information ==
#
# History (actb_histories as Actb::History)
#
# |-------------+----------+------------+-------------+--------------+-------|
# | name        | desc     | type       | opts        | refs         | index |
# |-------------+----------+------------+-------------+--------------+-------|
# | id          | ID       | integer(8) | NOT NULL PK |              |       |
# | user_id     | User     | integer(8) | NOT NULL    | => ::User#id | A     |
# | question_id | Question | integer(8) | NOT NULL    |              | B     |
# | created_at  | 作成日時 | datetime   | NOT NULL    |              |       |
# | updated_at  | 更新日時 | datetime   | NOT NULL    |              |       |
# | ox_mark_id  | Ox mark  | integer(8) | NOT NULL    |              | C     |
# | room_id     | Room     | integer(8) |             |              | D     |
# |-------------+----------+------------+-------------+--------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# User.has_many :actb_room_messages
#--------------------------------------------------------------------------------

# rails r "p Actb::History.first.user"
module Actb
  class History < ApplicationRecord
    include ClipMark::ShareWithHistoryMethods # belongs_to user and question

    cattr_accessor(:notice_trigger_counts) do
      case
      when Rails.env.development? || Rails.env.test? || Rails.env.staging?
        [1, 5, 10]
      else
        [10, 25, 50, 100, 200, 300, 400, 500]
      end
    end

    scope :with_today, -> t = Time.current.midnight { where(created_at: t.midnight...t.midnight.tomorrow) }
    scope :with_ox_mark, -> key { where(ox_mark: OxMark.fetch(key)) }
    scope :with_o, -> { with_ox_mark(:correct) }
    scope :without_o, -> { where.not(ox_mark: OxMark.fetch(:correct)) }

    belongs_to :room, optional: true # 管理画面KPI用

    belongs_to :ox_mark

    before_validation do
      self.ox_mark ||= OxMark.fetch(:mistake)
    end

    concerning :OUcountNotifyMod  do
      included do
        after_save_commit do
          if saved_change_to_attribute?(:ox_mark_id) && ox_mark.key == "correct"
            count = user.today_total_o_ucount
            if v = notice_trigger_counts.bsearch { |e| e >= count }
              if count == v
                user.o_ucount_notify_once
              end
            end
          end
        end
      end
    end
  end
end

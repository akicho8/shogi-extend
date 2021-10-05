# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Grade (swars_grades as Swars::Grade)
#
# |------------+----------+-------------+-------------+------+-------|
# | name       | desc     | type        | opts        | refs | index |
# |------------+----------+-------------+-------------+------+-------|
# | id         | ID       | integer(8)  | NOT NULL PK |      |       |
# | key        | キー     | string(255) | NOT NULL    |      | A!    |
# | priority   | 優先度   | integer(4)  | NOT NULL    |      | B     |
# | created_at | 作成日時 | datetime    | NOT NULL    |      |       |
# | updated_at | 更新日時 | datetime    | NOT NULL    |      |       |
# |------------+----------+-------------+-------------+------+-------|

module Swars
  class Grade < ApplicationRecord
    include MemoryRecordBind::Base

    with_options dependent: :destroy do
      has_many :users
      has_many :memberships
      has_many :battles, through: :memberships
    end

    def grade_info
      pure_info
    end

    def name
      key
    end

    concerning :PriorityMethods do
      included do
        cattr_accessor(:god_key_range) { ["五段", "九段"] }

        delegate :god_priority_range, to: "self.class"

        default_scope { order(:priority) }

        before_validation do
          self.priority ||= grade_info.priority
        end
      end

      class_methods do
        # Range にすると 5..1 になってしまうため sort で数値的な順序にしている
        def god_priority_range
          @god_priority_range ||= Range.new(*god_key_range.collect { |e| GradeInfo.fetch(e).priority }.sort )
        end
      end

      def like_god?
        god_priority_range.cover?(priority)
      end
    end
  end
end

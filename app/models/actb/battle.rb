# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Battle (actb_battles as Actb::Battle)
#
# |------------+------------+------------+-------------+------+-------|
# | name       | desc       | type       | opts        | refs | index |
# |------------+------------+------------+-------------+------+-------|
# | id         | ID         | integer(8) | NOT NULL PK |      |       |
# | room_id    | Room       | integer(8) | NOT NULL    |      | A     |
# | parent_id  | Parent     | integer(8) |             |      | B     |
# | rule_id    | Rule       | integer(8) | NOT NULL    |      | C     |
# | final_id   | Final      | integer(8) | NOT NULL    |      | D     |
# | begin_at   | Begin at   | datetime   | NOT NULL    |      | E     |
# | end_at     | End at     | datetime   |             |      | F     |
# | battle_pos | Battle pos | integer(4) | NOT NULL    |      | G     |
# | created_at | 作成日時   | datetime   | NOT NULL    |      |       |
# | updated_at | 更新日時   | datetime   | NOT NULL    |      |       |
# | practice   | Practice   | boolean    |             |      |       |
# |------------+------------+------------+-------------+------+-------|

# user1 = User.create!
# user2 = User.create!
#
# battle = Actb::Battle.create! do |e|
#   e.memberships.build(user: user1, judge_key: "win")
#   e.memberships.build(user: user2, judge_key: "lose")
# end
#
# battle.room_messages.create!(user: user1, body: "a") # => #<Actb::RoomMessage id: 1, user_id: 31, battle_id: 18, body: "a", created_at: "2020-05-05 07:18:46", updated_at: "2020-05-05 07:18:46">
#
module Actb
  class Battle < ApplicationRecord
    belongs_to :room, counter_cache: true
    belongs_to :final
    belongs_to :rule

    # has_many :messages, class_name: "RoomMessage", dependent: :destroy
    has_many :histories, dependent: :destroy
    has_many :memberships, -> { order(:position) }, class_name: "BattleMembership", dependent: :destroy, inverse_of: :battle
    has_many :users, through: :memberships
    belongs_to :parent, class_name: "Battle", optional: true # 連戦したときの前の部屋

    before_validation do
      if room
        self.rule ||= room.rule
        self.practice ||= room.practice
      end

      if parent
        self.battle_pos ||= parent.battle_pos + 1 # FIXME: これいらない？
      end

      self.final ||= Final.fetch(:f_pending)
      if will_save_change_to_attribute?(:final_id) && final && final.key != "f_pending"
        self.end_at ||= Time.current
      end

      self.begin_at ||= Time.current
      self.rule ||= Rule.fetch(RuleInfo.default_key)
      self.battle_pos ||= 0
    end

    with_options presence: true do
      validates :begin_at
    end

    after_create_commit do
      Actb::BattleBroadcastJob.perform_later(self)
    end

    # 出題
    def best_questions
      BestQuestionsGenerator.new(rule_info: room.rule.pure_info).generate
    end

    def final_info
      final.pure_info
    end

    def battle_chain_create
      room.battle_create_with_members!(parent: self) # --> app/jobs/actb/battle_broadcast_job.rb
    end

    def judge_final_set(target_user, judge_key, final_key)
      BattleJudgeFinalSet.new(self, {
          :target_user => target_user,
          :judge_key   => judge_key,
          :final_key   => final_key,
        }).run
    end

    # 開始時
    def as_json_type1
      as_json({
          only: [:id, :battle_pos],
          include: {
            # rule: { only: [:key], methods: [:strategy_key, :time_limit_sec, :b_score_max_for_win] },
            final: { only: [:key], methods: [:name] },
            room: {},
            memberships: {
              only: [:id],
              include: {
                user: {
                  only: [:id, :name],
                  methods: [:avatar_path, :rating, :skill_key],
                  include: {
                    actb_main_xrecord: {
                      only: [:straight_win_count, :straight_lose_count],
                    },
                  },
                },
              },
            },
          },
          methods: [:best_questions],
        })
    end

    # 結果表示時
    def as_json_type2_for_result
      as_json({
          only: [:id, :battle_pos],
          include: {
            final: {
              only: [:key],
              methods: [:name, :lose_side]
            },
            memberships: {
              only: [:id, :straight_win_count, :straight_lose_count],
              include: {
                user: {
                  only: [:id, :name],
                  methods: [:avatar_path],
                  include: {
                    actb_main_xrecord: {
                      only: [
                        :id,
                        :straight_win_count, :straight_lose_count, :straight_win_max, :straight_lose_max,
                        :rating, :rating_max, :rating_diff,
                        :disconnect_count,
                        :skill_point, :skill_last_diff,
                      ],
                      methods: [
                        :skill_key,
                      ]
                    },
                  },
                },
                judge: {
                  only: [:key, :name],
                },
              },
            }
          }
        })
    end
  end
end
# ~> -:32:in `<module:Actb>': uninitialized constant Actb::ApplicationRecord (NameError)
# ~>    from -:31:in `<main>'

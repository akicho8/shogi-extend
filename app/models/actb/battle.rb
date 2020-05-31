# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Battle (actb_battles as Actb::Battle)
#
# |--------------+--------------+------------+-------------+------+-------|
# | name         | desc         | type       | opts        | refs | index |
# |--------------+--------------+------------+-------------+------+-------|
# | id           | ID           | integer(8) | NOT NULL PK |      |       |
# | room_id      | Room         | integer(8) | NOT NULL    |      | A     |
# | parent_id    | Parent       | integer(8) |             |      | B     |
# | rule_id      | Rule         | integer(8) | NOT NULL    |      | C     |
# | final_id     | Final        | integer(8) | NOT NULL    |      | D     |
# | begin_at     | Begin at     | datetime   | NOT NULL    |      | E     |
# | end_at       | End at       | datetime   |             |      | F     |
# | rensen_index | Rensen index | integer(4) | NOT NULL    |      | G     |
# | created_at   | 作成日時     | datetime   | NOT NULL    |      |       |
# | updated_at   | 更新日時     | datetime   | NOT NULL    |      |       |
# |--------------+--------------+------------+-------------+------+-------|

# user1 = Colosseum::User.create!
# user2 = Colosseum::User.create!
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
    has_many :memberships, -> { order(:position) }, class_name: "BattleMembership", dependent: :destroy, inverse_of: :battle
    has_many :users, through: :memberships
    belongs_to :parent, class_name: "Battle", optional: true # 連戦したときの前の部屋

    before_validation do
      if parent
        self.room ||= parent.room
        self.rensen_index ||= parent.rensen_index + 1
        self.rule ||= parent.rule
      end

      self.final ||= Final.fetch(:f_pending)
      if changes_to_save[:final_id] && final && final.key != "f_pending"
        self.end_at ||= Time.current
      end

      self.begin_at ||= Time.current
      self.rule ||= Rule.fetch(:marathon_rule)
      self.rensen_index ||= 0
    end

    with_options presence: true do
      validates :begin_at
    end

    after_create_commit do
      Actb::BattleBroadcastJob.perform_later(self)
    end

    # 出題
    def best_questions
      s = Question.all
      s = s.joins(:folder).where(Folder.arel_table[:type].eq("Actb::ActiveBox"))
      s = s.order("rand()")
      s = s.limit(Config[:best_questions_limit])

      list = Question.where(id: s.ids).order(:difficulty_level)
      list.collect(&:as_json_type3)
    end

    def final_info
      final.pure_info
    end

    def onaji_heya_wo_atarasiku_tukuruyo
      self.class.create!(parent: self) do |e|
        users.each do |user|
          e.memberships.build(user: user)
        end
      end
      # --> app/jobs/actb/battle_broadcast_job.rb
    end

    def katimashita(target_user, judge_key, final_key)
      if end_at
        raise "すでに終了している"
      end

      judge = Judge.fetch(judge_key)
      final = Final.fetch(final_key)

      ActiveRecord::Base.transaction do
        m1 = memberships.find_by!(user: target_user)
        m2 = (memberships - [m1]).first

        m1.judge = judge
        m2.judge = judge.flip

        if judge.key == "win"
          mm = [m1, m2]
        else
          mm = [m2, m1]
        end

        # 今シーズン用
        c_ratings = mm.collect { |e| e.user.actb_current_xrecord.rating }
        c_ratings = EloRating.rating_update2(*c_ratings)
        c_ratings = c_ratings.collect(&:round)

        # 永続的記録用
        m_ratings = mm.collect { |e| e.user.actb_master_xrecord.rating }
        m_ratings = EloRating.rating_update2(*m_ratings)
        m_ratings = m_ratings.collect(&:round)

        # Actb::SeasonXrecord
        mm.each.with_index do |m, i|
          m.user.actb_current_xrecord.update!(rating: c_ratings[i], judge: m.judge, final: final)
          m.user.actb_master_xrecord.update!(rating: m_ratings[i], judge: m.judge, final: final)
        end

        mm.each(&:save!)

        self.final = final

        save!
      end
    end

    # 開始時
    def as_json_type1
      as_json({
          only: [:id, :rensen_index],
          include: {
            rule: { only: [:key, :name] },
            final: { only: [:key], methods: [:name] },
            room: {},
            memberships: {
              only: [:id, :question_index],
              include: {
                user: {
                  only: [:id, :name],
                  methods: [:avatar_path, :rating],
                  include: {
                    actb_current_xrecord: {
                      only: [:rensho_count, :renpai_count],
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
    def as_json_type2
      as_json({
          only: [:id, :rensen_index],
          include: {
            final: {
              only: [:key],
              methods: [:name, :lose_side]
            },
            rule: {
              only: [:id, :key, :name]
            },
            memberships: {
              only: [:id, :rensho_count, :renpai_count, :question_index],
              include: {
                user: {
                  only: [:id, :name],
                  methods: [:avatar_path],
                  include: {
                    actb_current_xrecord: {
                      only: [:id, :rensho_count, :renpai_count, :rating, :rating_max, :rating_last_diff, :rensho_max, :renpai_max, :disconnect_count],
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

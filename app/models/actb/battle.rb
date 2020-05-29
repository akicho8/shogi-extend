# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Battle (actb_battles as Actb::Battle)
#
# |------------+-----------+-------------+-------------+------+-------|
# | name       | desc      | type        | opts        | refs | index |
# |------------+-----------+-------------+-------------+------+-------|
# | id         | ID        | integer(8)  | NOT NULL PK |      |       |
# | begin_at   | Begin at  | datetime    | NOT NULL    |      | A     |
# | end_at     | End at    | datetime    |             |      | B     |
# | final_key  | Final key | string(255) |             |      | C     |
# | rule_key   | Rule key  | string(255) |             |      | D     |
# | created_at | 作成日時  | datetime    | NOT NULL    |      |       |
# | updated_at | 更新日時  | datetime    | NOT NULL    |      |       |
# |------------+-----------+-------------+-------------+------+-------|

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

    # has_many :messages, class_name: "RoomMessage", dependent: :destroy
    has_many :memberships, -> { order(:position) }, class_name: "BattleMembership", dependent: :destroy, inverse_of: :battle
    has_many :users, through: :memberships
    belongs_to :parent, class_name: "Battle", optional: true # 連戦したときの前の部屋

    before_validation do
      if parent
        self.room ||= parent.room
        self.rensen_index ||= parent.rensen_index + 1
      end

      if final_key
        self.end_at ||= Time.current
      end

      self.begin_at ||= Time.current
      self.rule_key ||= :marathon_rule
      self.rensen_index ||= 0
    end

    with_options presence: true do
      validates :begin_at
      validates :rule_key
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
      list.as_json(only: [:id, :init_sfen, :time_limit_sec, :difficulty_level, :title, :description, :hint_description, :source_desc, :other_twitter_account], include: {:user => { only: [:id, :name, :key], methods: [:avatar_path] }, :moves_answers => {only: [:moves_count, :moves_str, :end_sfen]}})
    end

    def final_info
      FinalInfo.fetch_if(final_key)
    end

    def onaji_heya_wo_atarasiku_tukuruyo
      self.class.create!(rule_key: rule_key, parent: self) do |e|
        users.each do |user|
          e.memberships.build(user: user)
        end
      end
      # --> app/jobs/actb/battle_broadcast_job.rb
    end

    def katimashita(target_user, judge_key, final_key)
      raise "すでに終了している" if end_at

      judge_info = JudgeInfo.fetch(judge_key)

      ActiveRecord::Base.transaction do
        m1 = memberships.find_by!(user: target_user)
        m2 = (memberships - [m1]).first

        m1.judge_key = judge_info.key
        m2.judge_key = judge_info.flip.key

        if judge_info.key == :win
          mm = [m1, m2]
        else
          mm = [m2, m1]
        end

        ab = mm.collect { |e| e.user.actb_newest_profile.rating }
        ab = EloRating.rating_update2(*ab)
        ab = ab.collect(&:round)
        mm.each.with_index do |m, i|
          record = m.user.actb_newest_profile
          record.rating = ab[i]
          record.battle_count = (record.battle_count || 0) + 1
          record.save!
        end

        mm.each(&:save!)
        update!(final_key: final_key)
      end
    end
  end
end

# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Rule (emox_rules as Emox::Rule)
#
# |------------+--------------------+-------------+-------------+------+-------|
# | name       | desc               | type        | opts        | refs | index |
# |------------+--------------------+-------------+-------------+------+-------|
# | id         | ID                 | integer(8)  | NOT NULL PK |      |       |
# | key        | ユニークなハッシュ | string(255) | NOT NULL    |      |       |
# | position   | 順序               | integer(4)  | NOT NULL    |      | A     |
# | created_at | 作成日時           | datetime    | NOT NULL    |      |       |
# | updated_at | 更新日時           | datetime    | NOT NULL    |      |       |
# |------------+--------------------+-------------+-------------+------+-------|

# matching_user_ids
# matching_users
# matching_users_include?(user)
# matching_users_add(user)
# matching_users_delete(user)

module Emox
  class Rule < ApplicationRecord
    class << self
      # 全削除(トリガーなし・デバッグ用)
      def matching_users_clear
        if RuleInfo.any? { |e| redis.del(e.redis_key) >= 1 }
          matching_user_ids_broadcast
        end
      end

      # すべてのルールから除去(トリガーあり)
      def matching_users_delete_from_all_rules(user)
        find_each { |e| e.matching_users_delete(user) }
      end

      # マッチング中のユーザーIDs
      def matching_all_user_ids
        all.flat_map(&:matching_user_ids)
      end

      # JS側に渡す値
      def matching_user_ids_hash
        RuleInfo.inject({}) do |a, e|
          a.merge(e.key => redis.smembers(e.redis_key).collect(&:to_i))
        end
      end

      # 配信
      def matching_user_ids_broadcast(params = {})
        bc_params = {
          matching_user_ids_hash: matching_user_ids_hash,
        }.merge(params)

        ActionCable.server.broadcast("emox/lobby_channel", bc_action: :matching_user_ids_broadcasted, bc_params: bc_params)
      end

      def redis
        Emox::BaseChannel.redis
      end
    end

    include StaticMod

    delegate :redis_key, to: :pure_info
    delegate :redis, :matching_user_ids_broadcast, to: "self.class"

    with_options dependent: :destroy do
      has_many :settings
      has_many :rooms
      has_many :battles
    end

    def matching_user_ids
      redis.smembers(redis_key).collect(&:to_i) # to_i 重要
    end

    def matching_users
      matching_user_ids.collect { |e| User.find(e) }
    end

    def matching_users_include?(user)
      redis.sismember(redis_key, user.id)
    end

    def matching_users_add(user)
      if redis.sadd(redis_key, user.id) # 新規で追加できたときだけ真
        matching_user_ids_broadcast({
            :trigger  => :add,
            :rule_key => key,
            :user => {
              :id          => user.id,
              :name        => user.name,
              :avatar_path => user.avatar_path,
            },
          })
        true
      end
    end

    # このルール内で user を解除
    def matching_users_delete(user)
      if user
        if redis.srem(redis_key, user.id) # 既存のIDを削除できたときだけ真
          matching_user_ids_broadcast(trigger: :delete, user_id: user.id) # このトリガーは未使用
          true
        end
      end
    end
  end
end

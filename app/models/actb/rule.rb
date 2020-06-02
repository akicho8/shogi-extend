# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Rule (actb_rules as Actb::Rule)
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

module Actb
  class Rule < ApplicationRecord
    class << self
      def matching_delete_all
        all.each(&:matching_delete_all)
      end
    end

    include StaticArModel

    delegate :redis_key, to: :pure_info

    with_options(dependent: :destroy) do
      has_many :settings
      has_many :rooms
      has_many :battles
    end

    def matching_users
      redis.smembers(redis_key).collect { |e| Colosseum::User.find(e) }
    end

    def matching_ids
      redis.smembers(redis_key).collect(&:to_i)
    end

    def matching_member?(user)
      redis.sismember(redis_key, user.id)
    end

    def matching_delete_all
      Actb::LobbyChannel.matching_list_rem(*matching_users)
    end

    private

    def redis
      Actb::BaseChannel.redis
    end
  end
end

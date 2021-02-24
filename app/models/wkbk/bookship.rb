# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Bookship (wkbk_bookships as Wkbk::Bookship)
#
# |------------+----------+------------+-------------+--------------+-------|
# | name       | desc     | type       | opts        | refs         | index |
# |------------+----------+------------+-------------+--------------+-------|
# | id         | ID       | integer(8) | NOT NULL PK |              |       |
# | user_id    | User     | integer(8) | NOT NULL    | => ::User#id | B     |
# | book_id    | Book     | integer(8) | NOT NULL    |              | A! C  |
# | article_id | Article  | integer(8) | NOT NULL    |              | A! D  |
# | position   | 順序     | integer(4) | NOT NULL    |              | E     |
# | created_at | 作成日時 | datetime   | NOT NULL    |              |       |
# | updated_at | 更新日時 | datetime   | NOT NULL    |              |       |
# |------------+----------+------------+-------------+--------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# User.has_one :profile
#--------------------------------------------------------------------------------

module Wkbk
  class Bookship < ApplicationRecord
    acts_as_list touch_on_update: false, top_of_list: 0, scope: :book

    belongs_to :user, class_name: "::User"
    belongs_to :book, counter_cache: true, touch: true # 問題集に問題を追加すると問題集の更新日時を更新する
    belongs_to :article

    before_validation on: :create do
      if book
        self.user ||= book.user
      end
      if article
        self.user ||= article.user
      end
    end

    with_options presence: true do
      validates :user_id
      validates :book_id
      validates :article_id
    end

    with_options allow_blank: true do
      validates :article_id, uniqueness: { scope: :book_id }
    end

    validate do
      if changes_to_save[:book_id] || changes_to_save[:article_id] || changes_to_save[:user_id]
        if book && article && user
          unless [book.user, article.user, user].uniq.one?
            errors.add(:base, "問題集と問題の所有者が異なります")
          end
        end
      end
    end

    if Rails.env.development? && false
      after_create do
        SlackAgent.message_send(key: "問題集に問題追加", body: "#{user.name}が#{book.title}に#{article.title}を追加")
      end
      before_destroy do
        SlackAgent.message_send(key: "問題集から問題除去", body: "#{user.name}が#{book.title}から#{article.title}を除去")
      end
    end
  end
end

# -*- coding: utf-8 -*-
# == Schema Information ==
#
# エモーション (actb_emotions as Actb::Emotion)
#
# |------------+----------+-------------+-------------+---------------------------+-------|
# | name       | desc     | type        | opts        | refs                      | index |
# |------------+----------+-------------+-------------+---------------------------+-------|
# | id         | ID       | integer(8)  | NOT NULL PK |                           |       |
# | user_id    | User     | integer(8)  | NOT NULL    | => ::User#id              | A     |
# | folder_id  | Folder   | integer(8)  | NOT NULL    | => Actb::EmotionFolder#id | B     |
# | name       | 鍵       | string(255) | NOT NULL    |                           |       |
# | message    | 伝       | string(255) | NOT NULL    |                           |       |
# | voice      | 声       | string(255) | NOT NULL    |                           |       |
# | position   | 順序     | integer(4)  | NOT NULL    |                           | C     |
# | created_at | 作成日時 | datetime    | NOT NULL    |                           |       |
# | updated_at | 更新日時 | datetime    | NOT NULL    |                           |       |
# |------------+----------+-------------+-------------+---------------------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# User.has_one :profile
# 【警告:リレーション欠如】Actb::EmotionFolderモデルで has_many :actb/emotions されていません
#--------------------------------------------------------------------------------

# -*- compile-command: "rails r 'Actb::EmotionFolder.setup; User.first.emotions_setup(reset: true);'" -*-

module Actb
  class Emotion < ApplicationRecord
    class << self
      def json_type13
        {
          only: [
            :id,
            :name,
            :message,
            :voice,
          ],
          methods: [
            :folder_key,
          ],
        }
      end
    end

    belongs_to :user, class_name: "::User"
    belongs_to :folder, class_name: "Actb::EmotionFolder"

    acts_as_list top_of_list: 0, scope: [:folder_id, :user_id]
    default_scope { order(:position) }

    before_validation do
      if Rails.env.test?
        self.name    ||= "(name)"
        self.message ||= "(message)"
        self.voice   ||= "(voice)"
      end

      self.name    ||= ""
      self.message ||= ""
      self.voice   ||= ""
    end

    with_options presence: true do
      validates :name
    end

    with_options allow_blank: true, uniqueness: { scope: [:user_id, :folder_id, :message, :voice], message: "とか同じのがすでにあります" } do
      validates :name
    end

    def folder_key
      if folder
        folder.key
      end
    end

    def folder_key=(key)
      self.folder = EmotionFolder.fetch_if(key)
    end

    def update_from_js(params)
      update!(params.to_unsafe_h.slice(:id, :name, :message, :voice, :folder_key))
    end
  end
end

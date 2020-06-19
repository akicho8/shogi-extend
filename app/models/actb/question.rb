# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Question (actb_questions as Actb::Question)
#
# |---------------------+---------------------+-------------+---------------------+--------------+-------|
# | name                | desc                | type        | opts                | refs         | index |
# |---------------------+---------------------+-------------+---------------------+--------------+-------|
# | id                  | ID                  | integer(8)  | NOT NULL PK         |              |       |
# | key                 | ユニークなハッシュ  | string(255) | NOT NULL            |              | A     |
# | user_id             | User                | integer(8)  | NOT NULL            | => ::User#id | B     |
# | folder_id           | Folder              | integer(8)  | NOT NULL            |              | C     |
# | lineage_id          | Lineage             | integer(8)  | NOT NULL            |              | D     |
# | init_sfen           | Init sfen           | string(255) | NOT NULL            |              | E     |
# | time_limit_sec      | Time limit sec      | integer(4)  |                     |              | F     |
# | difficulty_level    | Difficulty level    | integer(4)  |                     |              | G     |
# | title               | タイトル            | string(255) |                     |              |       |
# | description         | 説明                | string(512) |                     |              |       |
# | hint_desc           | Hint desc           | string(255) |                     |              |       |
# | other_author        | Other author        | string(255) |                     |              |       |
# | source_media_name   | Source media name   | string(255) |                     |              |       |
# | source_media_url    | Source media url    | string(255) |                     |              |       |
# | source_published_on | Source published on | date        |                     |              |       |
# | created_at          | 作成日時            | datetime    | NOT NULL            |              |       |
# | updated_at          | 更新日時            | datetime    | NOT NULL            |              |       |
# | good_rate           | Good rate           | float(24)   | NOT NULL            |              | H     |
# | moves_answers_count | Moves answers count | integer(4)  | DEFAULT(0) NOT NULL |              |       |
# | histories_count     | Histories count     | integer(4)  | DEFAULT(0) NOT NULL |              | I     |
# | good_marks_count    | Good marks count    | integer(4)  | DEFAULT(0) NOT NULL |              | J     |
# | bad_marks_count     | Bad marks count     | integer(4)  | DEFAULT(0) NOT NULL |              | K     |
# | clip_marks_count    | Clip marks count    | integer(4)  | DEFAULT(0) NOT NULL |              | L     |
# | messages_count      | Messages count      | integer(4)  | DEFAULT(0) NOT NULL |              | M     |
# |---------------------+---------------------+-------------+---------------------+--------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# User.has_many :actb_room_messages
#--------------------------------------------------------------------------------

module Actb
  class Question < ApplicationRecord
    def self.json_type5
      {
        methods: [:folder_key],
        include: [:user, :moves_answers, :lineage, :ox_record],
        only: [
          :id,
          :init_sfen,
          :time_limit_sec,
          :difficulty_level,
          # :display_key,
          :title,
          :description,
          :hint_desc,

          :other_author,
          :source_media_name,
          :source_media_url,
          :source_published_on,

          :moves_answers_count,

          :histories_count,
          :bad_marks_count,
          :good_marks_count,
          :clip_marks_count,

          :good_rate,

          :updated_at,
        ],
      }
    end

    belongs_to :user, class_name: "::User" # 作者
    belongs_to :folder # , class_name: "Actb::Folder"
    belongs_to :lineage # , class_name: "Actb::Lineage"

    has_many :histories, dependent: :destroy # 出題履歴
    has_many :messages, class_name: "Actb::QuestionMessage", dependent: :destroy # コメント

    with_options dependent: :destroy do
      has_many :moves_answers  # 手順一致を正解とする答え集

      has_many :good_marks      # 高評価
      has_many :bad_marks       # 低評価
      has_many :clip_marks      # 保存
    end

    # with_options allow_destroy: true do
    #   accepts_nested_attributes_for :moves_answers
    #   accepts_nested_attributes_for :endpos_answers
    # end

    before_validation do
      if Rails.env.test?
        self.init_sfen ||= "position sfen 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l#{Question.count.next}p 1"
        if moves_answers.empty?
          moves_answers.build(moves_str: "G*5b")
        end
      end

      [
        :title,
        :description,
        :hint_desc,
        :other_author,
        :source_media_name,
        :source_media_url,
        :source_published_on,
      ].each do |key|
        public_send("#{key}=", public_send(key).presence)
      end

      # self.title ||= "#{self.class.count.next}番目の問題"

      # self.difficulty_level ||= 0

      # self.o_count ||= 0
      # self.x_count ||= 0

      self.good_rate ||= 0

      self.lineage ||= Lineage.fetch("詰将棋")

      if user
        self.folder ||= user.actb_active_box
      end

      self.key ||= SecureRandom.hex
    end

    with_options presence: true do
      validates :init_sfen
    end

    with_options allow_blank: true do
      # validates :init_sfen # , uniqueness: { case_sensitive: true }
      # validates :difficulty_level, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
      # validates :display_key, inclusion: DisplayInfo.keys.collect(&:to_s)
    end

    # jsから来たパラメーターでまとめて更新する
    def together_with_params_came_from_js_update(params)
      params = params.deep_symbolize_keys

      question = params[:question]

      ActiveRecord::Base.transaction do
        assign_attributes(question.slice(*[
              :init_sfen,
              :title,
              :description,
              :hint_desc,

              :other_author,
              :source_media_name,
              :source_media_url,
              :source_published_on,

              :difficulty_level,
              :time_limit_sec,
              :folder_key,
            ]))

        if question[:lineage]
          self.lineage = Lineage.fetch(question[:lineage][:key])
        end

        save!

        # 削除
        self.moves_answer_ids = question[:moves_answers].collect { |e| e[:id] }

        # 追加 or 更新
        question[:moves_answers].each do |e|
          moves_answer = moves_answers.find_or_initialize_by(id: e[:id])
          moves_answer.moves_str = e[:moves_str]
          moves_answer.end_sfen = e[:end_sfen]
          moves_answer.save!
        end

      end
    end

    def folder_key
      if folder
        self.folder.class.name.demodulize.underscore.remove("_box")
      end
    end

    def folder_key=(key)
      if user
        self.folder = user.public_send("actb_#{key}_box")
      end
    end

    def init_sfen=(sfen)
      write_attribute(:init_sfen, sfen.to_s.remove(/position sfen /).presence)
    end

    def init_sfen
      if sfen = read_attribute(:init_sfen)
        "position sfen #{sfen}"
      end
    end

    def lineage_key
      if lineage
        lineage.key
      end
    end

    def lineage_key=(key)
      self.lineage = Lineage.fetch_if(key)
    end

    def good_rate_update
      d = good_marks_count + bad_marks_count
      if d.positive?
        self.good_rate = good_marks_count.fdiv(d)
        save!
      end
    end

    def as_json_type3
      as_json({
          only: [
            :id,
            :init_sfen,
            :time_limit_sec,
            :difficulty_level,
            :title,
            :description,
            :hint_desc,
            :other_author,
            :other_author_link,
          ],
          include: {
            user: {
              only: [:id, :name, :key],
              methods: [:avatar_path],
            },
            moves_answers: {
              only: [:moves_count, :moves_str, :end_sfen],
            },
            ox_record: {
              only: [
                :o_rate,
              ],
            },
          },
        })
    end

    concerning :OxRecordtMethdos do
      included do
        has_one :ox_record, dependent: :destroy # 正解率

        after_create do
          create_ox_record!
        end
      end

      def ox_add(column)
        ox_record[column] += 1
        ox_record.save!
      end
    end

    concerning :ImportExportMethdos do
      included do
      end

      class_methods do
        def setup(options = {})
          if Rails.env.staging? || Rails.env.production? || Rails.env.development?
            unless exists?
              import_all
            end
          end
        end

        def export_all
          json = all.as_json({
              only: [
                :key,
                :init_sfen,
                :time_limit_sec,
                :difficulty_level,
                :title,
                :description,
                :hint_desc,
                :other_author,
                :source_media_name,
                :source_media_url,
                :source_published_on,
              ],
              methods: [
                :lineage_key,
              ],
              include: {
                :moves_answers => {
                  only: [
                    :moves_str,
                  ],
                },
              },
            })

          body = json.to_yaml

          file = Rails.root.join("app/models/actb/#{name.demodulize.underscore.pluralize}.yml")
          FileUtils.mkdir_p(file.expand_path.dirname)
          file.write(body)
          puts "write: #{file}"
        end

        def import_all(user = User.sysop)
          persistent_records.each do |e|
            record = user.actb_questions.find_or_initialize_by(key: e[:key])
            record.update!(e.slice(*[
                  :lineage_key,
                  :init_sfen,
                  :time_limit_sec,
                  :difficulty_level,
                  :title,
                  :description,
                  :hint_desc,
                  :other_author,
                  :source_media_name,
                  :source_media_url,
                  :source_published_on,
                ]))
            record.moves_answers.clear
            e[:moves_answers].each do |e|
              record.moves_answers.create!(moves_str: e[:moves_str])
            end
          end
        end

        private

        def persistent_file
          Rails.root.join("app/models/actb/#{name.demodulize.underscore.pluralize}.yml")
        end

        def persistent_records
          body = []
          if persistent_file.exist?
            body = YAML.load(persistent_file.read)
            puts "load: #{persistent_file}"
          end
          body.collect(&:deep_symbolize_keys)
        end
      end
    end
  end
end

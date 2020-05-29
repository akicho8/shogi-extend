# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Question (actb_questions as Actb::Question)
#
# |-----------------------+-----------------------+-------------+---------------------+-----------------------+-------|
# | name                  | desc                  | type        | opts                | refs                  | index |
# |-----------------------+-----------------------+-------------+---------------------+-----------------------+-------|
# | id                    | ID                    | integer(8)  | NOT NULL PK         |                       |       |
# | user_id               | User                  | integer(8)  |                     | => Colosseum::User#id | A     |
# | folder_id             | Folder                | integer(8)  |                     |                       | B     |
# | lineage_id            | Lineage               | integer(8)  |                     |                       | C     |
# | init_sfen             | Init sfen             | string(255) | NOT NULL            |                       | D     |
# | time_limit_sec        | Time limit sec        | integer(4)  |                     |                       | E     |
# | difficulty_level      | Difficulty level      | integer(4)  |                     |                       | F     |
# | title                 | タイトル              | string(255) |                     |                       |       |
# | description           | 説明                  | string(512) |                     |                       |       |
# | hint_description      | Hint description      | string(255) |                     |                       |       |
# | source_desc           | Source desc           | string(255) |                     |                       |       |
# | other_twitter_account | Other twitter account | string(255) |                     |                       |       |
# | created_at            | 作成日時              | datetime    | NOT NULL            |                       |       |
# | updated_at            | 更新日時              | datetime    | NOT NULL            |                       |       |
# | moves_answers_count   | Moves answers count   | integer(4)  | DEFAULT(0) NOT NULL |                       | G     |
# | endpos_answers_count  | Endpos answers count  | integer(4)  | DEFAULT(0) NOT NULL |                       | H     |
# | o_count               | O count               | integer(4)  | NOT NULL            |                       | I     |
# | x_count               | X count               | integer(4)  | NOT NULL            |                       | J     |
# | bad_count             | Bad count             | integer(4)  | NOT NULL            |                       |       |
# | good_count            | Good count            | integer(4)  | NOT NULL            |                       |       |
# | histories_count       | Histories count       | integer(4)  | DEFAULT(0) NOT NULL |                       |       |
# | favorites_count       | Favorites count       | integer(4)  | DEFAULT(0) NOT NULL |                       |       |
# | bad_marks_count       | Bad marks count       | integer(4)  | DEFAULT(0) NOT NULL |                       |       |
# | good_marks_count      | Good marks count      | integer(4)  | DEFAULT(0) NOT NULL |                       |       |
# | clip_marks_count      | Clip marks count      | integer(4)  | DEFAULT(0) NOT NULL |                       |       |
# |-----------------------+-----------------------+-------------+---------------------+-----------------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# Colosseum::User.has_one :actb_profile
#--------------------------------------------------------------------------------

module Actb
  class Question < ApplicationRecord
    def self.index_and_form_json_columns
      [
        :id,
        :init_sfen,
        :time_limit_sec,
        :difficulty_level,
        # :display_key,
        :title,
        :description,
        :hint_description,
        :source_desc,
        :other_twitter_account,
        :moves_answers_count,
        :endpos_answers_count,
        :o_count,
        :x_count,
        :bad_count,
        :good_count,
        :histories_count,
        :favorites_count,
        :bad_marks_count,
        :good_marks_count,
        :clip_marks_count,
      ]
    end

    belongs_to :user, class_name: "Colosseum::User" # 作者
    belongs_to :folder # , class_name: "Actb::Folder"
    belongs_to :lineage # , class_name: "Actb::Lineage"

    has_many :histories, dependent: :destroy # 出題履歴
    has_many :messages, class_name: "Actb::QuestionMessage", dependent: :destroy # コメント

    with_options dependent: :destroy do
      has_many :moves_answers  # 手順一致を正解とする答え集
      has_many :endpos_answers # 最後の局面を正解とする答え集

      has_many :clip_marks     # クリップ
      has_many :favorites      # Good
      # has_many :bad_marks       # Bad
    end

    # with_options allow_destroy: true do
    #   accepts_nested_attributes_for :moves_answers
    #   accepts_nested_attributes_for :endpos_answers
    # end

    before_validation do
      if Rails.env.test?
        self.init_sfen ||= "4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l#{Question.count.next}p 1"
        if moves_answers.empty?
          moves_answers.build(moves_str: "G*5b")
        end
      end

      [
        :title,
        :description,
        :hint_description,
        :source_desc,
        :other_twitter_account,
      ].each do |key|
        public_send("#{key}=", public_send(key).presence)
      end

      # self.title ||= "#{self.class.count.next}番目の問題"

      # self.difficulty_level ||= 0

      self.o_count ||= 0
      self.x_count ||= 0

      self.bad_count ||= 0
      self.good_count ||= 0

      self.lineage ||= Lineage.fetch("詰将棋")
      self.folder_key ||= :active
    end

    with_options presence: true do
      validates :init_sfen
      # validates :difficulty_level
    end

    with_options allow_blank: true do
      # validates :init_sfen # , uniqueness: { case_sensitive: true }
      # validates :difficulty_level, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
      # validates :display_key, inclusion: DisplayInfo.keys.collect(&:to_s)
    end

    # jsから来たパラメーターでまとめて更新する
    def together_with_params_came_from_js_update(params)
      params = params.deep_symbolize_keys

      # params = {
      #   "question" => {
      #     "init_sfen" => "4k4/9/4GG3/9/9/9/9/9/9 b 2r2b2g4s4n4l18p #{rand(1000000)}",
      #     "moves_answers"=>[{"moves_str"=>"4c5b"}],
      #     "time_limit_clock"=>"1999-12-31T15:03:00.000Z",
      #   },
      # }.deep_symbolize_keys

      question = params[:question]

      # record = h.current_user.actb_questions.find_or_initialize_by(id: question[:id])

      ActiveRecord::Base.transaction do
        assign_attributes(question.slice(*[
              :init_sfen,
              :title,
              :description,
              :hint_description,
              :source_desc,
              :other_twitter_account,
              :difficulty_level,
              :time_limit_sec,
              :folder_key,
            ]))

        if question[:lineage]
          self.lineage = Lineage.fetch(question[:lineage][:key])
        end

        # if Rails.env.development?
        #   if new_record?
        #     parts = init_sfen.split
        #     parts.pop
        #     parts.push(self.class.count.next)
        #     self.init_sfen = parts.join(" ")
        #     p ["#{__FILE__}:#{__LINE__}", __method__, init_sfen]
        #   end
        # end

        # a = Time.zone.parse(question[:time_limit_clock])
        # b = Time.zone.parse("2000-01-01")
        # self.time_limit_sec = a - b

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

      # question = h.current_user.actb_questions.create! do |e|
      #   e.assign_attributes(params[:question])
      #   # e.init_sfen = "4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l18p 1"
      #   e.moves_answers.build(moves_str: "G*5b")
      #   e.endpos_answers.build(end_sfen: "4k4/4G4/4G4/9/9/9/9/9/9 w 2r2b2g4s4n4l18p 2")
      # end
    end

    # jsに渡すパラメータを作る
    # def create_the_parameters_to_be_passed_to_the_js
    #   as_json
    #
    #   hash = attributes
    #   hash = hash.merge(moves_answers: moves_answers)
    #   hash
    # end

    def folder_key
      if folder
        self.folder.class.name.demodulize.underscore.remove("_box")
      end
    end

    def folder_key=(key)
      self.folder = user.public_send("actb_#{key}_box")
    end
  end
end

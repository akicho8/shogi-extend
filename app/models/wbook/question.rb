# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Question (wbook_questions as Wbook::Question)
#
# |---------------------+---------------------+-------------+---------------------+------+-------|
# | name                | desc                | type        | opts                | refs | index |
# |---------------------+---------------------+-------------+---------------------+------+-------|
# | id                  | ID                  | integer(8)  | NOT NULL PK         |      |       |
# | key                 | ユニークなハッシュ  | string(255) | NOT NULL            |      | A     |
# | user_id             | User                | integer(8)  | NOT NULL            |      | B     |
# | folder_id           | Folder              | integer(8)  | NOT NULL            |      | C     |
# | lineage_id          | Lineage             | integer(8)  | NOT NULL            |      | D     |
# | init_sfen           | Init sfen           | string(255) | NOT NULL            |      | E     |
# | time_limit_sec      | Time limit sec      | integer(4)  |                     |      | F     |
# | difficulty_level    | Difficulty level    | integer(4)  |                     |      | G     |
# | title               | タイトル            | string(255) |                     |      |       |
# | description         | 説明                | string(512) |                     |      |       |
# | hint_desc           | Hint desc           | string(255) |                     |      |       |
# | source_author       | Source author       | string(255) |                     |      |       |
# | source_media_name   | Source media name   | string(255) |                     |      |       |
# | source_media_url    | Source media url    | string(255) |                     |      |       |
# | source_published_on | Source published on | date        |                     |      |       |
# | source_about_id     | Source about        | integer(8)  |                     |      | H     |
# | turn_max            | 手数                | integer(4)  |                     |      | I     |
# | mate_skip           | Mate skip           | boolean     |                     |      |       |
# | direction_message   | Direction message   | string(255) |                     |      |       |
# | created_at          | 作成日時            | datetime    | NOT NULL            |      |       |
# | updated_at          | 更新日時            | datetime    | NOT NULL            |      |       |
# | good_rate           | Good rate           | float(24)   |                     |      | J     |
# | moves_answers_count | Moves answers count | integer(4)  | DEFAULT(0) NOT NULL |      |       |
# | histories_count     | Histories count     | integer(4)  | DEFAULT(0) NOT NULL |      | K     |
# | good_marks_count    | Good marks count    | integer(4)  | DEFAULT(0) NOT NULL |      | L     |
# | bad_marks_count     | Bad marks count     | integer(4)  | DEFAULT(0) NOT NULL |      | M     |
# | clip_marks_count    | Clip marks count    | integer(4)  | DEFAULT(0) NOT NULL |      | N     |
# | messages_count      | Messages count      | integer(4)  | DEFAULT(0) NOT NULL |      | O     |
# |---------------------+---------------------+-------------+---------------------+------+-------|
#
#- Remarks ----------------------------------------------------------------------
# [Warning: Need to add relation] Wbook::Question モデルに belongs_to :lineage を追加してください
# [Warning: Need to add relation] Wbook::Question モデルに belongs_to :source_about を追加してください
# [Warning: Need to add relation] Wbook::Question モデルに belongs_to :user を追加してください
#--------------------------------------------------------------------------------

module Wbook
  class Question < ApplicationRecord
    include FolderMod
    include ImportExportMod
    include InfoMod

    # 自演評価の無効化
    def self.good_bad_click_by_owner_reject_all
      p [GoodMark.count, BadMark.count]
      find_each(&:good_bad_click_by_owner_reject)
      p [GoodMark.count, BadMark.count]
    end

    # rails r 'Wbook::Question.tag_normalize_all; tp Wbook::Question'
    def self.tag_normalize_all
      find_each do |e|
        e.owner_tag_list = e.owner_tag_list.collect { |s|
          s = hankaku_format(s)
          s = s.gsub(/\A(\d+)手詰め\z/, '\1手詰')
          s
        }.uniq
        e.save!(validate: false, touch: false)
      end
    end

    def self.mock_question
      raise if Rails.env.production? || Rails.env.staging?

      user1 = User.find_or_create_by!(name: "user1", email: "user1@localhost")
      user2 = User.find_or_create_by!(name: "user2", email: "user2@localhost")
      user3 = User.find_or_create_by!(name: "user3", email: "user3@localhost")
      question = user1.wbook_questions.create_mock1
      question.messages.create!(user: user2, body: "user2のコメント")
      question.messages.create!(user: user3, body: "user3のコメント")
      question
    end

    # Vueでリアクティブになるように空でもカラムは作っておくこと
    def self.default_attributes
      default = {
        :title               => nil,
        :description         => nil,
        :hint_desc           => nil,
        :direction_message   => nil,
        :owner_tag_list      => [],
        :time_limit_sec      => 10.seconds,
        :moves_answers       => [],
        :init_sfen           => "position sfen 4k4/9/9/9/9/9/9/9/9 b 2r2b4g4s4n4l18p 1",
        :mate_skip           => false,

        :difficulty_level    => 1,
        :lineage_key         => "詰将棋",
        :folder_key          => "active",

        # 他者が作者
        :source_about_key    => "ascertained",
        :source_author       => nil,
        :source_media_name   => nil,
        :source_media_url    => nil,
        :source_published_on => nil,
      }

      if Rails.env.development?

        # 他者が作者
        default[:source_author]       = "渡瀬荘二郎"
        default[:source_media_name]   = "Wikipedia"
        default[:source_media_url]    = "https://ja.wikipedia.org/wiki/%E5%AE%9F%E6%88%A6%E5%9E%8B%E8%A9%B0%E5%B0%86%E6%A3%8B"
        default[:source_published_on] = "1912-03-04"

        default.update({
            :title            => "(title)",
            :time_limit_sec   => 30.seconds,

            # :init_sfen => "position sfen 7gk/9/7GG/7N1/9/9/9/9/9 b 2r2bg4s3n4l18p 1",
            # :moves_answers => [
            #   :moves_str => "1c1b",
            #   :end_sfen  => "7gk/8G/7G1/7N1/9/9/9/9/9 w 2r2bg4s3n4l18p 2",
            # ],

            :init_sfen => "position sfen 7nl/7k1/9/7pp/6N2/9/9/9/9 b GS2r2b3g3s2n3l16p 1",
            :moves_answers => [
              { :moves_str => "S*2c 2b3c G*4c",            },
              { :moves_str => "S*2c 2b1c 2c1b+ 1c1b G*2c", },
              { :moves_str => "S*2c 2b1c 2c1b+ 1a1b G*2c", },
              { :moves_str => "S*2c 2b3a G*3b",            },
            ],

          })
      end

      default
    end

    # 一覧・編集用
    def self.json_type5
      {
        methods: [
          :folder_key,
          :lineage_key,
          :source_about_key,
        ],
        include: [
          :user,
          :moves_answers,
          :ox_record,
        ],
        only: [
          :id,
          :init_sfen,
          :time_limit_sec,
          :difficulty_level,
          # :display_key,
          :title,
          :description,
          :owner_tag_list,
          :hint_desc,
          :direction_message,
          :turn_max,
          :mate_skip,

          :source_author,
          :source_media_name,
          :source_media_url,
          :source_published_on,

          :moves_answers_count,

          :histories_count,
          :bad_marks_count,
          :good_marks_count,
          :clip_marks_count,
          :messages_count,

          :good_rate,

          :created_at,
          :updated_at,
        ],
      }
    end

    attribute :moves_answer_validate_skip

    belongs_to :user, class_name: "::User" # 作者
    belongs_to :lineage
    belongs_to :source_about

    has_many :histories, dependent: :destroy # 出題履歴
    has_many :messages, class_name: "Wbook::QuestionMessage", dependent: :destroy # コメント
    has_many :message_users, through: :messages, source: :user                   # コメントしたユーザー(複数)

    acts_as_taggable_on :user_tags  # 閲覧者が自由につけれるタグ(未使用)
    acts_as_taggable_on :owner_tags # 作成者が自由につけれるタグ

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
      normalize_zenkaku_to_hankaku(*[
          :title,
          :description,
          :hint_desc,
          :direction_message,
          :source_author,
          :source_media_name,
        ])

      normalize_blank_to_nil(*[
          :title,
          :description,
          :hint_desc,
          :direction_message,
          :source_author,
          :source_media_name,
          :source_media_url,
          :source_published_on,
        ])

      if Rails.env.test?
        self.title ||= "(title#{self.class.count.next})"
      end

      if source_author.to_s.match(/不詳|不明/)
        self.source_author = nil
        self.source_about_key = :unknown
      end

      self.good_rate ||= nil

      if Rails.env.test?
        self.lineage_key ||= "手筋"
      end

      self.lineage_key ||= "詰将棋"

      self.source_about ||= SourceAbout.fetch(:ascertained)

      self.key ||= SecureRandom.hex

      if lineage.pure_info.mate_validate_on
        self.mate_skip ||= false
      else
        # 手筋などのときは詰みチェックをニュートラルにしとく
        self.mate_skip = nil
      end
    end

    with_options presence: true do
      validates :title
      validates :init_sfen
    end

    with_options allow_blank: true do
      validates :title, uniqueness: { scope: :user_id, case_sensitive: true, message: "が重複しています" }
      validates :description, length: { maximum: 512 }

      # validates :init_sfen # , uniqueness: { case_sensitive: true }
      # validates :difficulty_level, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
    end

    def page_url(options = {})
      # UrlProxy.wrap2("/wbook/questions/#{id}")
      UrlProxy.wrap2("/training?question_id=#{id}")
      # Rails.application.routes.url_helpers.url_for([:wbook, {only_path: false, question_id: id}.merge(options)])
    end

    def share_board_png_url
      Rails.application.routes.url_helpers.url_for([:share_board, {only_path: false, format: "png", **share_board_params}])
    end

    def share_board_url
      Rails.application.routes.url_helpers.url_for([:share_board, {only_path: false, title: title, **share_board_params}])
    end

    def share_board_params
      { body: main_sfen, turn: 0, abstract_viewpoint: "black" }
    end

    # Twitter画像が表示できる url_for にそのまま渡すパラメータ
    def shared_image_params
      [:share_board, body: main_sfen, only_path: false, format: "png", turn: 0, abstract_viewpoint: "black"]
    end

    def title_with_author
      [title, author_saku].join(" ")
    end

    def author_saku
      if source_about.key == "unknown"
        "作者不詳"
      else
        [source_author || user.name, "作"].join
      end
    end

    def mock_attrs_set
      if Rails.env.test?
        self.init_sfen ||= "position sfen 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l#{Question.count.next}p 1"
        if moves_answers.empty?
          moves_answers.build(moves_str: "G*5b")
        end
      end
    end

    # jsから来たパラメーターでまとめて更新する
    #
    #   params = {
    #     "title"            => "(title)",
    #     "init_sfen"        => "4k4/9/4GG3/9/9/9/9/9/9 b 2r2b2g4s4n4l18p 1",
    #     "moves_answers"    => [{"moves_str"=>"4c5b"}],
    #     "time_limit_clock" => "1999-12-31T15:03:00.000Z",
    #   }
    #   question = user.wbook_questions.build
    #   question.update_from_js(params)
    #   question.moves_answers.collect{|e|e.moves_str} # => ["4c5b"]
    #
    def update_from_js(params)
      question = params.deep_symbolize_keys
      @save_before_hash = current_hash

      ActiveRecord::Base.transaction do
        attrs = question.slice(*[
              :init_sfen,
              :title,
              :description,
              :hint_desc,
              :direction_message,
              :mate_skip,

              :source_about_key,
              :source_author,
              :source_media_name,
              :source_media_url,
              :source_published_on,
              :owner_tag_list,

              :difficulty_level,
              :time_limit_sec,
              :folder_key,
              :lineage_key,
            ])

        assign_attributes(attrs)

        save!

        if records = question[:moves_answers]

          # 削除
          # [1, 2, 3] があるとき [1, 3] をセットすることで [2] が削除される
          self.moves_answer_ids = records.collect { |e| e[:id] }

          # 追加 or 更新
          records.each do |e|
            if v = e[:id]
              moves_answer = moves_answers.find(v)
            else
              moves_answer = moves_answers.build
            end

            moves_answer.moves_str = e[:moves_str]
            moves_answer.end_sfen = e[:end_sfen]
            moves_answer.save!
          end
        end
      end

      # 「公開」フォルダに移動させたときに通知する
      # created_at をトリガーにすると下書きを作成したときにも通知してしまう
      if state = saved_after_state
        SlackAgent.message_send(key: "問題#{state}", body: [title, page_url].join(" "))
        ApplicationMailer.developper_notice(subject: "#{user.name}さんが「#{title}」を#{state}しました", body: info.to_t).deliver_later
        User.bot.lobby_speak("#{user.name}さんが#{linked_title}を#{state}しました")
      end
    end

    def source_about_key
      source_about.key
    end

    def source_about_key=(key)
      self.source_about = SourceAbout.fetch(key)
    end

    def source_about_unknown_name
      if source_about.key == "unknown"
        "作者不詳"
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
      else
        self.good_rate = nil
      end
      save!(touch: false)
    end

    # 配置 + 1問目
    def main_sfen
      if moves_answers.blank?
        init_sfen
      else
        "#{init_sfen} moves #{moves_answers.first.moves_str}"
      end
    end

    # 出題用
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
            :direction_message,
            :mate_skip,
            :owner_tag_list,
            :source_author,
            :source_media_url,
          ],
          methods: [
            :source_about_key,
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
                :ox_total,
              ],
            },
          },
        })
    end

    # 詳細用
    def as_json_type6
      as_json({
          methods: [
            :source_about_key,
            :lineage_key,
          ],
          include: {
            user: {
              only: [:id, :key, :name],
              methods: [:avatar_path],
            },
            ox_record: {},
            moves_answers: {},
            folder: { only: [], methods: [:key, :name, :type] },
            messages: QuestionMessage.json_struct_type8,
          },
        })
    end

    def linked_title(options = {})
      ApplicationController.helpers.link_to(title, page_url(only_path: true))
    end

    # 自演評価の無効化
    def good_bad_click_by_owner_reject
      good_marks.where(user: user).destroy_all
      bad_marks.where(user: user).destroy_all
    end

    private

    # 保存直後の状態
    def saved_after_state
      case
      when active_folder_posted?
        "投稿"
      when folder_key === "active" && current_hash != @save_before_hash
        "更新"
      end
    end

    # 公開した直後か？
    def active_folder_posted?
      saved_change_to_attribute?(:folder_id) && folder_key === "active"
    end

    # 変更を検知するためのハッシュ(重要なデータだけにする)
    def current_hash
      ary = [
        init_sfen,
        *moves_answers.collect(&:moves_str),
      ]
      Digest::MD5.hexdigest(ary.join(":"))
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
  end
end

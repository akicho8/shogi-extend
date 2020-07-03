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
    # Vueでリアクティブになるように空でもカラムは作っておくこと
    def self.default_attributes
      default = {
        :title               => nil,
        :description         => nil,
        :hint_desc           => nil,
        :time_limit_sec      => 10.seconds,
        :moves_answers       => [],
        :init_sfen           => "position sfen 4k4/9/9/9/9/9/9/9/9 b 2r2b4g4s4n4l18p 1",

        :difficulty_level    => 1,
        :lineage             => { key: "詰将棋" },
        :folder_key          => "active",

        # 他者が作者
        :other_author        => nil,
        :source_media_name   => nil,
        :source_media_url    => nil,
        :source_published_on => nil,
      }

      if Rails.env.development?

        # 他者が作者
        default[:other_author]        = "渡瀬荘二郎"
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

    # 一覧用
    def self.json_type5
      {
        methods: [
          :folder_key,
        ],
        include: [
          :user,
          :moves_answers,
          :lineage,
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
          :messages_count,

          :good_rate,

          :created_at,
          :updated_at,
        ],
      }
    end

    belongs_to :user, class_name: "::User" # 作者
    belongs_to :folder
    belongs_to :lineage

    has_many :histories, dependent: :destroy # 出題履歴
    has_many :messages, class_name: "Actb::QuestionMessage", dependent: :destroy # コメント

    scope :active_only, -> { joins(:folder).where(Folder.arel_table[:type].eq("Actb::ActiveBox")) }

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

      normalize_blank_to_nil(*[
          :title,
          :description,
          :hint_desc,
          :other_author,
          :source_media_name,
          :source_media_url,
          :source_published_on,
        ])

      normalize_zenkaku_to_hankaku(*[
          :title,
          :description,
          :hint_desc,
          :other_author,
          :source_media_name,
        ])

      if Rails.env.test?
        self.title ||= "(title#{self.class.count.next})"
      end

      self.good_rate ||= 0

      self.lineage ||= Lineage.fetch("詰将棋")

      if user
        self.folder ||= user.actb_active_box
      end

      self.key ||= SecureRandom.hex
    end

    with_options presence: true do
      validates :title
      validates :init_sfen
    end

    with_options allow_blank: true do
      validates :title, uniqueness: { scope: :user_id, case_sensitive: true, message: "が重複しています" }

      # validates :init_sfen # , uniqueness: { case_sensitive: true }
      # validates :difficulty_level, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
      # validates :display_key, inclusion: DisplayInfo.keys.collect(&:to_s)
    end

    after_create_commit do
      SlackAgent.message_send(key: "問題登録", body: [title, page_url].join(" "))
    end

    def page_url
      Rails.application.routes.url_helpers.url_for([:training, {only_path: false, question_id: id}])
    end

    def share_board_png_url
      Rails.application.routes.url_helpers.url_for([:share_board, {only_path: false, format: "png", **share_board_params}])
    end

    def share_board_url
      Rails.application.routes.url_helpers.url_for([:share_board, {only_path: false, title: title, **share_board_params}])
    end

    def share_board_params
      { body: main_sfen, turn: 0, image_view_point: "black" }
    end

    # Twitter画像が表示できる url_for にそのまま渡すパラメータ
    def shared_image_params
      [:share_board, body: main_sfen, only_path: false, format: "png", turn: 0, image_view_point: "black"]
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

    # 初期配置 + 1問目
    def main_sfen
      "#{init_sfen} moves #{moves_answers.first.moves_str}"
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
                :ox_total,
              ],
            },
          },
        })
    end

    # 詳細用
    def as_json_type6
      as_json({
          include: {
            user: {
              only: [:id, :key, :name],
              methods: [:avatar_path],
            },
            ox_record: {},
            moves_answers: {},
            lineage: { only: [:key] },
            messages: {
              only: [:id, :body, :created_at],
              include: {
                user: {
                  only: [:id, :key, :name],
                  methods: [:avatar_path],
                },
              },
            },
          },
        })
    end

    concerning :InfoMethods do
      def parsed_info
        @parsed_info ||= Bioshogi::Parser.parse(main_sfen)
      end

      def to_kif
        str = parsed_info.to_kif

        str = str.gsub(/^.*の備考.*\n/, "")
        str = str.gsub(/^まで.*\n/, "")

        info.collect { |k, v| "#{k}：#{v}\n" }.join + str
      end

      def to_oneline_ki2
        parsed_info.mediator.to_ki2_a.join(" ")
      end

      def info
        a = {}

        a["タイトル"] = title

        if other_author
          a["投稿者"] = user.name
        else
          a["作者"] = user.name
        end

        a["詳細URL"]    = page_url
        a["画像URL"]    = share_board_png_url
        a["共有将棋盤"] = share_board_url

        a["種類"] = lineage.key
        a["フォルダ"] = folder.pure_info.name

        a["制限時間"] = "#{time_limit_sec}秒"

        a["難易度"] = "★" * (difficulty_level || 0)

        a["出題回数"]   = histories_count
        a["正解率"]     = "%.2f %%" % (ox_record.o_rate * 100)
        a["正解数"]     = ox_record.o_count
        a["誤答数"]     = ox_record.x_count

        a["高評価率"]   = "%.2f %%" % (good_rate * 100)
        a["高評価数"]   = good_marks_count
        a["低評価数"]   = bad_marks_count

        a["コメント数"] = messages_count

        if true
          if other_author
            a["作者"] = other_author
          end
          if source_media_name
            a["出典"] = source_media_name
          end
          if source_published_on
            a["出典年月日"] = source_published_on
          end
          if source_media_url
            a["出典URL"] = source_media_url
          end
        end

        if v = hint_desc.presence
          a["ヒント"] = v
        end

        a["作成日時"] = created_at.to_s(:ymdhm)
        a["SFEN"] = main_sfen

        if v = description.presence
          a["解説"] = v.squish
        end

        a["人間向けの解答"] = to_oneline_ki2

        a
      end
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
          # if Rails.env.staging? || Rails.env.production? || Rails.env.development?
          #   unless exists?
          #     import_all
          #   end
          # end
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

          body = json.to_yaml(line_width: -1)

          file = Rails.root.join("app/models/actb/#{name.demodulize.underscore.pluralize}.yml")
          FileUtils.mkdir_p(file.expand_path.dirname)
          file.write(body)
          puts "write: #{file} (#{count})"
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
            puts "load: #{persistent_file} (#{body.count})"
          end
          body.collect(&:deep_symbolize_keys)
        end
      end
    end
  end
end

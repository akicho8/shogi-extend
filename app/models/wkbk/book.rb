# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Book (wkbk_books as Wkbk::Book)
#
# |----------------+--------------------+--------------+---------------------+--------------+-------|
# | name           | desc               | type         | opts                | refs         | index |
# |----------------+--------------------+--------------+---------------------+--------------+-------|
# | id             | ID                 | integer(8)   | NOT NULL PK         |              |       |
# | key            | ユニークなハッシュ | string(255)  | NOT NULL            |              | A     |
# | user_id        | User               | integer(8)   | NOT NULL            | => ::User#id | B     |
# | folder_id      | Folder             | integer(8)   | NOT NULL            |              | C     |
# | title          | タイトル           | string(255)  |                     |              |       |
# | description    | 説明               | string(1024) |                     |              |       |
# | created_at     | 作成日時           | datetime     | NOT NULL            |              |       |
# | updated_at     | 更新日時           | datetime     | NOT NULL            |              |       |
# | articles_count | Articles count     | integer(4)   | DEFAULT(0) NOT NULL |              |       |
# |----------------+--------------------+--------------+---------------------+--------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# User.has_one :profile
#--------------------------------------------------------------------------------

module Wkbk
  class Book < ApplicationRecord
    include FolderMod
    include InfoMod

    def self.mock_book
      raise if Rails.env.production? || Rails.env.staging?

      user1 = User.find_or_create_by!(name: "user1", email: "user1@localhost")
      book = user1.wkbk_books.create_mock1
      book
    end

    # Vueでリアクティブになるように空でもカラムは作っておくこと
    def self.default_attributes
      default = {
        :title       => nil,
        :description => nil,
        :hint_desc   => nil,
        :folder_key  => "active",
      }

      if Rails.env.development?
        default.update({
                         :title            => "(title)",
                       })
      end

      default
    end

    # 一覧・編集用
    def self.json_type5
      {
        methods: [
          :folder_key,
        ],
        include: {
          user: { only: [:id, :name, :key], methods: [:avatar_path] },
        },
        only: [
          :id,
          :title,
          :description,
          :owner_tag_list,
          :articles_count,
          :created_at,
          :updated_at,
        ],
      }
    end

    def self.json_type5a
      {
        methods: [
          :folder_key,
        ],
        include: {
          user: { only: [:id, :name, :key], methods: [:avatar_path] },
          articles: {
            methods: [
              :folder_key,
              :lineage_key,
              :source_about_key,
            ],
            include: {
              user: { only: [:id, :name, :key], methods: [:avatar_path],},
              moves_answers: {
                only: [
                  # :id,
                  # :article_id,
                  :moves_count,
                  :moves_str,
                  :end_sfen,
                  :moves_human_str,
                ],
              },
            },
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

              # :histories_count,
              # :bad_marks_count,
              # :good_marks_count,
              # :clip_marks_count,
              # :messages_count,

              # :good_rate,

              # :created_at,
              # :updated_at,
            ],

          },
        },
        only: [
          :id,
          :title,
          :description,
          :owner_tag_list,
          :articles_count,
          :created_at,
          :updated_at,
        ],
      }
    end

    belongs_to :user, class_name: "::User"
    # belongs_to :book

    acts_as_taggable_on :user_tags  # 閲覧者が自由につけれるタグ(未使用)
    acts_as_taggable_on :owner_tags # 作成者が自由につけれるタグ

    has_many :articles, dependent: :nullify # 記事

    before_validation do
      if Rails.env.test?
        self.title ||= "(title#{self.class.count.next})"
      end

      self.key ||= SecureRandom.hex

      normalize_zenkaku_to_hankaku(:title, :description)
      normalize_blank_to_nil(:title, :description)
    end

    # with_options presence: true do
    #   validates :title
    #   validates :init_sfen
    # end

    with_options allow_blank: true do
      validates :title, uniqueness: { scope: :user_id, case_sensitive: true, message: "が重複しています" }
      validates :description, length: { maximum: 1024 }

      # validates :init_sfen # , uniqueness: { case_sensitive: true }
      # validates :difficulty_level, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
    end

    def page_url(options = {})
      # UrlProxy.wrap2("/wkbk/books/#{id}")
      UrlProxy.wrap2("/library/books/#{id}")
      # Rails.application.routes.url_helpers.url_for([:wkbk, {only_path: false, book_id: id}.merge(options)])
    end
    #
    # def share_board_png_url
    #   Rails.application.routes.url_helpers.url_for([:share_board, {only_path: false, format: "png", **share_board_params}])
    # end
    #
    # def share_board_url
    #   Rails.application.routes.url_helpers.url_for([:share_board, {only_path: false, title: title, **share_board_params}])
    # end
    #
    # def share_board_params
    #   { body: main_sfen, turn: 0, abstract_viewpoint: "black" }
    # end
    #
    # # Twitter画像が表示できる url_for にそのまま渡すパラメータ
    # def shared_image_params
    #   [:share_board, body: main_sfen, only_path: false, format: "png", turn: 0, abstract_viewpoint: "black"]
    # end

    # def title_with_author
    #   [title, author_saku].join(" ")
    # end
    #
    # def author_saku
    #   if source_about.key == "unknown"
    #     "作者不詳"
    #   else
    #     [source_author || user.name, "作"].join
    #   end
    # end

    def mock_attrs_set
      if Rails.env.test?
        self.init_sfen ||= "position sfen 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l#{Book.count.next}p 1"
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
    #   book = user.wkbk_books.build
    #   book.update_from_js(params)
    #   book.moves_answers.collect{|e|e.moves_str} # => ["4c5b"]
    #
    def update_from_js(params)
      book = params.deep_symbolize_keys
      @save_before_hash = current_hash

      ActiveRecord::Base.transaction do
        attrs = book.slice(*[
                             :title,
                             :description,
                             :owner_tag_list,
                             :folder_key,
                           ])
        assign_attributes(attrs)
        save!
      end

      # 「公開」フォルダに移動させたときに通知する
      # created_at をトリガーにすると下書きを作成したときにも通知してしまう
      if state = saved_after_state
        SlackAgent.message_send(key: "問題#{state}", body: [title, page_url].join(" "))
        ApplicationMailer.developper_notice(subject: "#{user.name}さんが「#{title}」を#{state}しました", body: info.to_t).deliver_later
      end
    end

    # def source_about_key
    #   source_about.key
    # end
    #
    # def source_about_key=(key)
    #   self.source_about = SourceAbout.fetch(key)
    # end
    #
    # def source_about_unknown_name
    #   if source_about.key == "unknown"
    #     "作者不詳"
    #   end
    # end

    # def init_sfen=(sfen)
    #   write_attribute(:init_sfen, sfen.to_s.remove(/position sfen /).presence)
    # end

    # def init_sfen
    #   if sfen = read_attribute(:init_sfen)
    #     "position sfen #{sfen}"
    #   end
    # end

    # def lineage_key
    #   if lineage
    #     lineage.key
    #   end
    # end
    #
    # def lineage_key=(key)
    #   self.lineage = Lineage.fetch_if(key)
    # end

    # # 配置 + 1問目
    # def main_sfen
    #   if moves_answers.blank?
    #     init_sfen
    #   else
    #     "#{init_sfen} moves #{moves_answers.first.moves_str}"
    #   end
    # end

    # 出題用
    def as_json_type3
      as_json({
                only: [
                  :id,
                  # :init_sfen,
                  # :time_limit_sec,
                  # :difficulty_level,
                  :title,
                  :description,
                  # :hint_desc,
                  # :direction_message,
                  # :mate_skip,
                  :owner_tag_list,
                  # :source_author,
                  # :source_media_url,
                ],
                methods: [
                  # :source_about_key,
                ],
                include: {
                  user: {
                    only: [:id, :name, :key],
                    methods: [:avatar_path],
                  },
                  # moves_answers: {
                  #   only: [:moves_count, :moves_str, :end_sfen],
                  # },
                },
              })
    end

    # 詳細用
    def as_json_type6
      as_json({
                methods: [
                  # :source_about_key,
                  # :lineage_key,
                ],
                include: {
                  user: {
                    only: [:id, :key, :name],
                    methods: [:avatar_path],
                  },
                  moves_answers: {},
                  folder: { only: [], methods: [:key, :name, :type] },
                  # messages: BookMessage.json_struct_type8,
                },
              })
    end

    def linked_title(options = {})
      ApplicationController.helpers.link_to(title, page_url(only_path: true))
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
        # init_sfen,
        # *moves_answers.collect(&:moves_str),
        title,
        description,
        articles_count,
      ]
      Digest::MD5.hexdigest(ary.join(":"))
    end
  end
end

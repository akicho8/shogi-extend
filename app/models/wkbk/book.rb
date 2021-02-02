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
# | sequence_id    | Sequence           | integer(8)   | NOT NULL            |              | D     |
# | title          | タイトル           | string(255)  |                     |              |       |
# | description    | 説明               | string(1024) |                     |              |       |
# | articles_count | Articles count     | integer(4)   | DEFAULT(0) NOT NULL |              |       |
# | created_at     | 作成日時           | datetime     | NOT NULL            |              |       |
# | updated_at     | 更新日時           | datetime     | NOT NULL            |              |       |
# |----------------+--------------------+--------------+---------------------+--------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# User.has_one :profile
#--------------------------------------------------------------------------------

module Wkbk
  class Book < ApplicationRecord
    include FolderMod
    include InfoMod

    class << self
      def setup(options = {})
        if Rails.env.development?
          mock_setup
          tp self
        end
      end

      def mock_setup
        [
          { id: 1, user: :sysop, folder_key: :public,  },
          { id: 2, user: :sysop, folder_key: :private, },
          { id: 3, user: :bot,   folder_key: :public,  },
          { id: 4, user: :bot,   folder_key: :private, },
        ].each do |e|
          Book.where(id: e[:id]).destroy_all
          book = User.public_send(e[:user]).wkbk_books.create!(id: e[:id], folder_key: e[:folder_key], title: "#{e[:user]} - #{e[:folder_key]} - #{e[:id]}")
          Article.where(id: e[:id]).destroy_all
          article = book.articles.create!(id: e[:id], title: "#{e[:user]} - #{e[:folder_key]} - #{e[:id]}")
        end
      end

      def mock_book
        raise if Rails.env.production? || Rails.env.staging?

        user1 = User.find_or_create_by!(name: "user1", email: "user1@localhost")
        book = user1.wkbk_books.create_mock1
        book
      end
    end

    # Vueでリアクティブになるように空でもカラムは作っておくこと
    def self.default_attributes
      attrs = {
        # :id           => nil,
        # :title        => nil,
        # :description  => nil,
        :folder_key   => :private,
        :sequence_key => :shuffle,
      }

      if Rails.env.development?
        attrs[:title] ||= "(title)"
      end

      attrs
    end

    # 一覧・編集用
    def self.json_type5
      {
        methods: [
          :folder_key,
          :sequence_key,
          :tweet_body,
        ],
        include: {
          user: { only: [:id, :name, :key], methods: [:avatar_path] },
        },
        only: [
          :id,
          :title,
          :description,
          :articles_count,
          :created_at,
          :updated_at,
        ],
      }
    end

    # 出題
    def self.show_json_struct
      {
        only: [
          :id,
          :title,
          :description,
          :articles_count,
          :created_at,
          :updated_at,
        ],
        methods: [
          :folder_key,
          :sequence_key,
          :tweet_body,
          :og_meta,
        ],
        include: {
          user: {
            only: [:id, :name, :key],
            methods: [:avatar_path],
          },
        },
      }
    end

    def self.show_articles_json_struct
      {
        only: [
          :id,
          :init_sfen,
          :title,
          :description,
          :direction_message,
          :turn_max,
        ],
        methods: [
          :lineage_key,
        ],
        include: {
          moves_answers: {
            only: [
              :moves_str,
            ],
          },
        },
      }
    end

    # article edit の form の選択肢用
    def self.json_type7
      {
        only: [:id, :title],
        methods: [:folder_key],
      }
    end

    belongs_to :user, class_name: "::User"
    # belongs_to :book

    has_many :articles, dependent: :nullify # 記事

    before_validation do
      if Rails.env.test? || Rails.env.development?
        self.title       ||= "あ" * 80
        self.description ||= "い" * 256
      end

      self.folder_key ||= :private
      self.sequence_key ||= :shuffle
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
      UrlProxy.wrap2("/library/books/#{id}")
    end

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
                             :folder_key,
                             :sequence_key,
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
                  :title,
                  :description,
                  :owner_tag_list,
                ],
                methods: [
                ],
                include: {
                  user: {
                    only: [:id, :name, :key],
                    methods: [:avatar_path],
                  },
                },
              })
    end

    # 詳細用
    def as_json_type6
      as_json({
                methods: [
                ],
                include: {
                  user: {
                    only: [:id, :key, :name],
                    methods: [:avatar_path],
                  },
                  moves_answers: {},
                  folder: { only: [], methods: [:key, :name] },
                  sequence: { only: [], methods: [:key, :name] },
                },
              })
    end

    def linked_title(options = {})
      ApplicationController.helpers.link_to(title, page_url(only_path: true))
    end

    def owner_editable_p(current_user)
      folder_key_eq(:public) || user == current_user
    end

    def ordered_articles
      sequence.pure_info.apply[articles]
    end

    def og_image_path
      articles.sample&.og_image_path
    end

    def og_meta
      if new_record?
        {
          :title       => "新規 - 問題集",
          :description => description || "",
          :og_image    => "library-books",
        }
      else
        {
          :title       => [title, user.name].join(" - "),
          :description => description || "",
          :og_image    => og_image_path || "library-books",
        }
      end
    end

    def tweet_body
      o = []
      o << title
      # o << description
      o << "#" + "みんなの将棋問題集"
      o << page_url
      o.join("\n")
    end

    private

    # 保存直後の状態
    def saved_after_state
      case
      when public_folder_posted?
        "投稿"
      when folder_key_eq(:public) && current_hash != @save_before_hash
        "更新"
      end
    end

    # 公開した直後か？
    def public_folder_posted?
      saved_change_to_attribute?(:folder_id) && folder_key_eq(:public)
    end

    # 変更を検知するためのハッシュ(重要なデータだけにする)
    def current_hash
      ary = [
        title,
        description,
        articles_count,
      ]
      Digest::MD5.hexdigest(ary.join(":"))
    end

    concerning :SequenceMethods do
      included do
        belongs_to :sequence
      end

      def sequence_key_eq(key)
        sequence_key.to_s == key.to_s
      end

      def sequence_key
        sequence&.key
      end

      def sequence_key=(key)
        self.sequence = Sequence.fetch(key)
      end
    end
  end
end

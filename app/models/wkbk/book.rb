# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Book (wkbk_books as Wkbk::Book)
#
# |-----------------+--------------------+--------------+---------------------+--------------+-------|
# | name            | desc               | type         | opts                | refs         | index |
# |-----------------+--------------------+--------------+---------------------+--------------+-------|
# | id              | ID                 | integer(8)   | NOT NULL PK         |              |       |
# | key             | ユニークなハッシュ | string(255)  | NOT NULL            |              | A!    |
# | user_id         | User               | integer(8)   | NOT NULL            | => ::User#id | B     |
# | folder_id       | Folder             | integer(8)   | NOT NULL            |              | C     |
# | sequence_id     | Sequence           | integer(8)   | NOT NULL            |              | D     |
# | title           | タイトル           | string(100)  | NOT NULL            |              |       |
# | description     | 説明               | string(5000) | NOT NULL            |              |       |
# | bookships_count | Bookships count    | integer(4)   | DEFAULT(0) NOT NULL |              |       |
# | created_at      | 作成日時           | datetime     | NOT NULL            |              |       |
# | updated_at      | 更新日時           | datetime     | NOT NULL            |              |       |
# |-----------------+--------------------+--------------+---------------------+--------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# User.has_one :profile
#--------------------------------------------------------------------------------

module Wkbk
  class Book < ApplicationRecord
    include FolderMod
    include InfoMod
    include AvatarMod
    include JsonStruct

    class << self
      def setup(options = {})
        if Rails.env.development?
          mock_setup
          tp self
        end
      end

      def mock_setup
        [
          { key: 1, user: :sysop, folder_key: :public,  },
          { key: 2, user: :sysop, folder_key: :private, },
          { key: 3, user: :bot,   folder_key: :public,  },
          { key: 4, user: :bot,   folder_key: :private, },
        ].each do |e|
          user = User.public_send(e[:user])
          title = "#{e[:user]} - #{e[:folder_key]} - #{e[:key]}"
          Book.where(key: e[:key]).destroy_all
          book = user.wkbk_books.create!(key: e[:key], folder_key: e[:folder_key], title: title)
          Article.where(key: e[:key]).destroy_all
          book.articles << user.wkbk_articles.create!(key: e[:key], title: title, folder_key: e[:folder_key])
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
    # def self.default_attributes
    #   attrs = {
    #     # :id           => nil,
    #     # :title        => nil,
    #     # :description  => nil,
    #     :folder_key   => :private,
    #     :sequence_key => :bookship_shuffle,
    #   }
    #
    #   if Rails.env.development?
    #     attrs[:title] ||= "(title)"
    #   end
    #
    #   attrs
    # end

    belongs_to :user, class_name: "::User"

    before_validation do
      self.folder_key ||= :private
      self.sequence_key ||= :bookship_shuffle
      self.key ||= secure_random_urlsafe_base64_token

      if Rails.env.test? || Rails.env.development?
        self.title       ||= key
        self.description ||= "(description)"
      end

      normalize_zenkaku_to_hankaku(:title, :description)
      normalize_blank_to_empty_string(:title, :description)
    end

    # with_options presence: true do
    #   validates :title
    #   validates :init_sfen
    # end

    with_options allow_blank: true do
      validates :title, uniqueness: { scope: :user_id, case_sensitive: true, message: "が重複しています" }
      validates :title, length: { maximum: 100 }
      validates :description, length: { maximum: 5000 }

      # validates :init_sfen # , uniqueness: { case_sensitive: true }
      # validates :difficulty, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
    end

    def page_url(options = {})
      UrlProxy.wrap2("/rack/books/#{key}")
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
                             :new_file_src,    # nil 以外が来たらそれで画像作成
                             :raw_avatar_path, # nil が来たら画像削除
                           ])
        assign_attributes(attrs)
        save!

        ids = book[:ordered_bookships].collect { |e| e.fetch(:id) }
        bookships_order_by_ids(ids)
      end

      # 「公開」フォルダに移動させたときに通知する
      # created_at をトリガーにすると下書きを作成したときにも通知してしまう
      if state = saved_after_state
        SlackAgent.message_send(key: "問題#{state}", body: [title, page_url].join(" "))
        ApplicationMailer.developper_notice(subject: "#{user.name}さんが「#{title}」を#{state}しました", body: info.to_t).deliver_later
      end
    end

    # articles の並び替え
    #
    #   user = User.create!
    #   book = user.wkbk_books.create!
    #   book.articles << user.wkbk_articles.create!(key: "a")
    #   book.articles << user.wkbk_articles.create!(key: "b")
    #
    #   book.articles.order(:position).pluck(:key) # => ["a", "b"]
    #   book.bookships_order_by_ids(["b", "a"])
    #   book.articles.order(:position).pluck(:key) # => ["b", "a"]
    #
    # 次の方法の方がわかりやすいかもしれないけどSQLがさらに articles.count 回発生する
    #
    #   Bookship.acts_as_list_no_update do
    #     keys.each.with_index do |key, i|
    #       bookship = book.bookships.joins(:article).find_by!(Article.arel_table[:key].eq(key))
    #       bookship.position = i
    #       bookship.save!(validate: false, touch: false)
    #     end
    #   end
    #
    def bookships_order_by_ids(ids)
      table = bookships.inject({}) {|a, e| a.merge(e.id => e) }
      Bookship.acts_as_list_no_update do
        ids.each.with_index do |id, i|
          e = table.fetch(id)
          e.position = i
          e.save!(validate: false, touch: false)
        end
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

    # # 出題用
    # def as_json_type3
    #   as_json({
    #             only: [
    #               :id,
    #               :title,
    #               :description,
    #               :owner_tag_list,
    #             ],
    #             methods: [
    #             ],
    #             include: {
    #               user: {
    #                 only: [:key, :id, :name],
    #                 methods: [:avatar_path],
    #               },
    #             },
    #           })
    # end

    # # 詳細用
    # def as_json_type6
    #   as_json({
    #             methods: [
    #             ],
    #             include: {
    #               user: {
    #                 only: [:id, :key, :name],
    #                 methods: [:avatar_path],
    #               },
    #               moves_answers: {},
    #               folder: { only: [], methods: [:key, :name] },
    #               sequence: { only: [], methods: [:key, :name] },
    #             },
    #           })
    # end

    def linked_title(options = {})
      ApplicationController.helpers.link_to(title, page_url(only_path: true))
    end

    # def show_can(current_user)
    #   # case
    #   # when :show
    #   folder_eq(:public) || user == current_user
    #   # when :edit
    #   #   user && current_user && (user == current_user)
    #   # else
    #   #   raise "must not happen"
    #   # end
    # end

    # def show_can(action, current_user)
    #   case
    #   when :show
    #     folder_eq(:public) || user == current_user
    #   when :edit
    #     user && current_user && (user == current_user)
    #   else
    #     raise "must not happen"
    #   end
    # end

    def og_image_path
      # articles.sample&.og_image_path
      avatar_path
    end

    def og_meta
      if new_record?
        {
          :title       => "新規 - 問題集",
          :description => description || "",
          :og_image    => "rack-books",
        }
      else
        {
          :title       => [title, user.name].join(" - "),
          :description => description || "",
          :og_image    => og_image_path || "rack-books",
        }
      end
    end

    def tweet_body
      o = []
      o << title
      # o << description
      o << "#" + "インスタント将棋問題集"
      o << page_url
      o.join("\n")
    end

    def default_assign
      self.folder_key ||= :public
      self.sequence_key ||= :bookship_shuffle

      if user
        self.title ||= "#{user.name}のインスタント将棋問題集第#{user.wkbk_books.count.next}弾(仮)"
      end

      if Rails.env.development?
        self.title       ||= "あ" * 80
        self.description ||= "い" * 256
      end

      self.title       ||= ""
      self.description ||= ""
    end

    private

    # 保存直後の状態
    def saved_after_state
      case
      when public_folder_posted?
        "投稿"
      when folder_eq(:public) && current_hash != @save_before_hash
        "更新"
      end
    end

    # 公開した直後か？
    def public_folder_posted?
      saved_change_to_attribute?(:folder_id) && folder_eq(:public)
    end

    # 変更を検知するためのハッシュ(重要なデータだけにする)
    def current_hash
      ary = [
        title,
        description,
        bookships_count,
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

      def sequenced_articles(current_user)
        s = bookships.access_restriction_by(current_user)
        s = sequence.pure_info.apply[s]
        s = s.joins(:article).includes(article: :moves_answers)
        s.collect(&:article)
      end
    end

    concerning :BookshipMethods do
      included do
        has_many :bookships, dependent: :destroy do # 問題集と問題の中間情報たち
          def access_restriction_by(current_user)
            s = all
            if proxy_association.owner.user != current_user
              s = s.merge(Article.public_or_limited)
            end
            s
          end
        end

        has_many :articles, through: :bookships  # 自分に入っている問題たち

        has_many :ordered_bookships, -> { order(:position) }, dependent: :destroy, class_name: "Bookship" # 一発でjsonにしたいため

        attribute :current_user
        # attribute :bookships_count_by_current_user
      end

      # bookの下にあるものを全削除(超危険)
      # 中間情報経由で articles.destroy_all は空振りする(articles は削除されない)
      def dependent_records_destroy_all
        articles.each(&:destroy!)
        bookships.destroy_all
      end

      # アクセス可能な問題の数
      # current_user を考慮して決まるため book.as_json では出せない
      # なので筋悪だけどあらかじめ current_user を設定してから book.as_json する
      def bookships_count_by_current_user
        bookships.joins(:article).access_restriction_by(current_user).count
      end
    end
  end
end

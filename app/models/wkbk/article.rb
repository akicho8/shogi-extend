# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Article (wkbk_articles as Wkbk::Article)
#
# |---------------------+---------------------+--------------+---------------------+--------------+-------|
# | name                | desc                | type         | opts                | refs         | index |
# |---------------------+---------------------+--------------+---------------------+--------------+-------|
# | id                  | ID                  | integer(8)   | NOT NULL PK         |              |       |
# | key                 | ユニークなハッシュ  | string(255)  | NOT NULL            |              | A     |
# | user_id             | User                | integer(8)   | NOT NULL            | => ::User#id | B     |
# | lineage_id          | Lineage             | integer(8)   | NOT NULL            |              | C     |
# | book_id             | Book                | integer(8)   |                     |              | D     |
# | init_sfen           | Init sfen           | string(255)  | NOT NULL            |              | E     |
# | viewpoint           | Viewpoint           | string(255)  | NOT NULL            |              |       |
# | title               | タイトル            | string(255)  |                     |              |       |
# | description         | 説明                | string(1024) |                     |              |       |
# | turn_max            | 手数                | integer(4)   |                     |              | F     |
# | mate_skip           | Mate skip           | boolean      |                     |              |       |
# | direction_message   | Direction message   | string(255)  |                     |              |       |
# | moves_answers_count | Moves answers count | integer(4)   | DEFAULT(0) NOT NULL |              |       |
# | created_at          | 作成日時            | datetime     | NOT NULL            |              |       |
# | updated_at          | 更新日時            | datetime     | NOT NULL            |              |       |
# |---------------------+---------------------+--------------+---------------------+--------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# User.has_one :profile
#--------------------------------------------------------------------------------

module Wkbk
  class Article < ApplicationRecord
    include ImportExportMod
    include InfoMod

    # 自演評価の無効化
    def self.good_bad_click_by_owner_reject_all
      p [GoodMark.count, BadMark.count]
      find_each(&:good_bad_click_by_owner_reject)
      p [GoodMark.count, BadMark.count]
    end

    # rails r 'Wkbk::Article.tag_normalize_all; tp Wkbk::Article'
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

    # def self.new_og_meta
    #   {
    #     :title       => "新規 - 問題",
    #     :description => "",
    #     :og_image    => "library-books",
    #   }
    # end

    # def self.mock_article
    #   raise if Rails.env.production? || Rails.env.staging?
    #
    #   user1 = User.find_or_create_by!(name: "user1", email: "user1@localhost")
    #   user2 = User.find_or_create_by!(name: "user2", email: "user2@localhost")
    #   user3 = User.find_or_create_by!(name: "user3", email: "user3@localhost")
    #   article = user1.wkbk_articles.create_mock1
    #   article.messages.create!(user: user2, body: "user2のコメント")
    #   article.messages.create!(user: user3, body: "user3のコメント")
    #   article
    # end

    # # Vueでリアクティブになるように空でもカラムは作っておくこと
    # def self.default_attributes
    #   default = {
    #     :id                  => nil,
    #     :book_id             => nil,
    #     :title               => nil,
    #     :description         => nil,
    #     :direction_message   => nil,
    #     :owner_tag_list      => [],
    #     :moves_answers       => [],
    #     :init_sfen           => "position sfen 4k4/9/9/9/9/9/9/9/9 b 2r2b4g4s4n4l18p 1",
    #     :viewpoint           => "black",
    #     :mate_skip           => false,
    #     :lineage_key         => nil,
    #     # :folder_key        => "public",
    #   }
    #
    #   if Rails.env.development?
    #     default.update({
    #                      :title            => "(title)",
    #
    #                      # :init_sfen => "position sfen 7gk/9/7GG/7N1/9/9/9/9/9 b 2r2bg4s3n4l18p 1",
    #                      # :moves_answers => [
    #                      #   :moves_str => "1c1b",
    #                      #   :end_sfen  => "7gk/8G/7G1/7N1/9/9/9/9/9 w 2r2bg4s3n4l18p 2",
    #                      # ],
    #
    #                      :init_sfen => "position sfen 7nl/7k1/9/7pp/6N2/9/9/9/9 b GS2r2b3g3s2n3l16p 1",
    #                      :moves_answers => [
    #                        { :moves_str => "S*2c 2b3c G*4c",            },
    #                        { :moves_str => "S*2c 2b1c 2c1b+ 1c1b G*2c", },
    #                        { :moves_str => "S*2c 2b1c 2c1b+ 1a1b G*2c", },
    #                        { :moves_str => "S*2c 2b3a G*3b",            },
    #                      ],
    #
    #                    })
    #   end
    #
    #   default
    # end

    # def self.default_attributes2
    #   [
    #     { :moves_str => "S*2c 2b3c G*4c",            },
    #     { :moves_str => "S*2c 2b1c 2c1b+ 1c1b G*2c", },
    #     { :moves_str => "S*2c 2b1c 2c1b+ 1a1b G*2c", },
    #     { :moves_str => "S*2c 2b3a G*3b",            },
    #   ]
    # end

    # 一覧・編集用
    def self.json_type5
      {
        methods: [
          # :folder_key,
          :lineage_key,
        ],
        include: {
          user: { only: [:id, :name, :key], methods: [:avatar_path],},
          moves_answers: {},
          book: {
            only: [
              :id,
              :title,
              :articles_count,
            ],
            methods: [
              :folder_key,
            ],
          },
        },
        only: [
          :id,
          :book_id,
          :init_sfen,
          :viewpoint,
          :title,
          :description,
          :owner_tag_list,
          :direction_message,
          :turn_max,
          :mate_skip,
          :moves_answers_count,
          :created_at,
          :updated_at,
        ],
      }
    end

    def self.show_json_struct
      {
        methods: [
          # :folder_key,
          :lineage_key,
        ],
        include: {
          user: { only: [:id, :name, :key], methods: [:avatar_path],},
          lineage: { only: [:id, :key], methods: [:name]},
          moves_answers: {},
          book: {
            only: [
              :id,
              :title,
              :articles_count,
            ],
            include: {
              folder: { only: [:id, :name],},
            },
            methods: [
              :folder_key,
            ],
          },
        },
        only: [
          :id,
          :book_id,
          :init_sfen,
          :viewpoint,
          :title,
          :description,
          :owner_tag_list,
          :direction_message,
          :turn_max,
          :mate_skip,
          :moves_answers_count,
          :created_at,
          :updated_at,
        ],
      }
    end

    attribute :moves_answer_validate_skip

    belongs_to :user, class_name: "::User" # 作者
    belongs_to :lineage
    belongs_to :book, required: false, counter_cache: true, touch: true

    acts_as_taggable_on :user_tags  # 閲覧者が自由につけれるタグ(未使用)
    acts_as_taggable_on :owner_tags # 作成者が自由につけれるタグ

    with_options dependent: :destroy do
      has_many :moves_answers  # 手順一致を正解とする答え集
    end

    before_validation do
      if book
        self.user ||= book.user
      end

      if Rails.env.development? || Rails.env.test?
        self.title ||= SecureRandom.hex
        self.init_sfen ||= "position sfen 7nl/7k1/9/7pp/6N2/9/9/9/9 b GS2r2b3g3s2n3l16p 1"
      end

      if Rails.env.test?
        self.title ||= "(title#{self.class.count.next})"
      end

      # if Rails.env.test?
      #   self.lineage_key ||= "手筋"
      # end

      self.viewpoint ||= "black"
      self.lineage_key ||= "次の一手"
      self.key ||= SecureRandom.hex

      if lineage.pure_info.mate_validate_on
        self.mate_skip ||= false
      else
        # 手筋などのときは詰みチェックをニュートラルにしとく
        self.mate_skip = nil
      end

      # if changes_to_save[:book_id]
      #   if book
      #     self.folder_key = book.folder_key
      #   else
      #     self.folder_key = :private
      #   end
      # else
      #   self.folder_key ||= :private
      # end

      normalize_zenkaku_to_hankaku(*[
                                     :title,
                                     :description,
                                     :direction_message,
                                   ])

      normalize_blank_to_nil(*[
                               :title,
                               :description,
                               :direction_message,
                             ])
    end

    with_options presence: true do
      validates :title
      validates :init_sfen
      validates :viewpoint
    end

    with_options allow_blank: true do
      validates :title, uniqueness: { scope: :user_id, case_sensitive: true, message: "が重複しています" }
      validates :description, length: { maximum: 1024 }
    end

    validate do
      if changes_to_save[:book_id] || changes_to_save[:user_id]
        if book && user
          if book.user != user
            errors.add(:base, "問題集の所有者と問題の所有者が異なります")
          end
        end
      end
    end

    # validate do
    #   if false
    #     if changes_to_save[:book_id] && book
    #       if book.folder_key == :public && folder_key === :private
    #         errors.add(:base, "公開している問題集に非公開の問題は入れられません")
    #       end
    #     end
    #   end
    # end

    def page_url(options = {})
      UrlProxy.wrap2("/library/articles/#{id}/edit")
    end

    def share_board_png_url
      Rails.application.routes.url_helpers.url_for([:share_board, {only_path: false, format: "png", **share_board_params}])
    end

    def share_board_url
      Rails.application.routes.url_helpers.url_for([:share_board, {only_path: false, title: title, **share_board_params}])
    end

    def share_board_params
      { body: main_sfen, turn: 0, abstract_viewpoint: viewpoint }
    end

    # Twitter画像が表示できる url_for にそのまま渡すパラメータ
    def shared_image_params
      [:share_board, body: main_sfen, only_path: false, format: "png", turn: 0, abstract_viewpoint: viewpoint]
    end

    def mock_attrs_set
      if Rails.env.test?
        self.init_sfen ||= "position sfen 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l#{Article.count.next}p 1"
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
    #   article = user.wkbk_articles.build
    #   article.update_from_js(params)
    #   article.moves_answers.collect{|e|e.moves_str} # => ["4c5b"]
    #
    def update_from_js(params)
      article = params.deep_symbolize_keys
      @save_before_hash = current_hash

      ActiveRecord::Base.transaction do
        attrs = article.slice(*[
                                :book_id,
                                :init_sfen,
                                :viewpoint,
                                :title,
                                :description,
                                :direction_message,
                                :mate_skip,
                                :owner_tag_list,
                                :lineage_key,
                              ])

        assign_attributes(attrs)

        save!

        if records = article[:moves_answers]

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
            # moves_answer.end_sfen = e[:end_sfen]
            moves_answer.save!
          end
        end
      end

      # 「公開」フォルダに移動させたときに通知する
      # created_at をトリガーにすると下書きを作成したときにも通知してしまう
      if state = saved_after_state
        SlackAgent.message_send(key: "問題#{state}", body: [title, page_url].join(" "))
        ApplicationMailer.developper_notice(subject: "#{user.name}さんが「#{title}」を#{state}しました", body: info.to_t).deliver_later
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
                  :viewpoint,
                  :title,
                  :description,
                  :direction_message,
                  :mate_skip,
                  :owner_tag_list,
                ],
                methods: [
                ],
                include: {
                  user: { only: [:id, :name, :key], methods: [:avatar_path],},
                  moves_answers: {
                    only: [:moves_count, :moves_str],
                  },
                },
              })
    end

    # 詳細用
    def as_json_type6
      raise

      as_json({
                methods: [
                  :lineage_key,
                ],
                include: {
                  user: {
                    only: [:id, :key, :name],
                    methods: [:avatar_path],
                  },
                  moves_answers: {},
                  folder: { only: [], methods: [:key, :name, :type] },
                },
              })
    end

    def linked_title(options = {})
      ApplicationController.helpers.link_to(title, page_url(only_path: true))
    end

    # 本があれば本の権限に従う
    # 本がなければ所有者のみ編集可能
    def owner_editable_p(current_user)
      if book
        book.owner_editable_p(current_user)
      else
        user == current_user
      end
    end

    def og_image_path
      if persisted?
        v = {}
        v[:turn]               = 0
        v[:body]               = init_sfen
        v[:abstract_viewpoint] = viewpoint
        "/share-board.png?#{v.to_query}"
      end
    end

    def og_meta
      if new_record?
        {
          :title       => "新規 - 問題",
          :description => "",
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

    def default_assign
      self.init_sfen      ||= "position sfen 4k4/9/9/9/9/9/9/9/9 b 2r2b4g4s4n4l18p 1"
      self.viewpoint      ||= "black"
      self.mate_skip      ||= false
      self.owner_tag_list ||= []

      if Rails.env.development?
        moves_answers.build(:moves_str => "S*2c 2b3c G*4c")
        moves_answers.build(:moves_str => "S*2c 2b1c 2c1b+ 1c1b G*2c")
      end
    end

    private

    # 保存直後の状態
    def saved_after_state
      if new_record?
        "投稿"
      else
        "更新"
      end
    end

    # 公開した直後か？
    # def public_folder_posted?
    #   saved_change_to_attribute?(:folder_id) && folder.kind_of?(PublicFolder)
    # end

    # 変更を検知するためのハッシュ(重要なデータだけにする)
    def current_hash
      ary = [
        init_sfen,
        *moves_answers.collect(&:moves_str),
        title,
        description,
      ]
      Digest::MD5.hexdigest(ary.join(":"))
    end
  end
end
# ~> -:30:in `<module:Wkbk>': uninitialized constant Wkbk::ApplicationRecord (NameError)
# ~>    from -:29:in `<main>'

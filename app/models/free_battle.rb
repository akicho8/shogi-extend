# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 棋譜投稿 (free_battles as FreeBattle)
#
# |-------------------+--------------------+----------------+-------------+-----------------------------------+-------|
# | name              | desc               | type           | opts        | refs                              | index |
# |-------------------+--------------------+----------------+-------------+-----------------------------------+-------|
# | id                | ID                 | integer(8)     | NOT NULL PK |                                   |       |
# | key               | ユニークなハッシュ | string(255)    | NOT NULL    |                                   | A!    |
# | kifu_url          | 棋譜URL            | string(255)    |             |                                   |       |
# | kifu_body         | 棋譜               | text(16777215) | NOT NULL    |                                   |       |
# | turn_max          | 手数               | integer(4)     | NOT NULL    |                                   | F     |
# | meta_info         | 棋譜ヘッダー       | text(65535)    | NOT NULL    |                                   |       |
# | battled_at        | Battled at         | datetime       | NOT NULL    |                                   | E     |
# | outbreak_turn     | Outbreak turn      | integer(4)     |             |                                   | B     |
# | use_key           | Use key            | string(255)    | NOT NULL    |                                   | C     |
# | accessed_at       | Accessed at        | datetime       | NOT NULL    |                                   |       |
# | created_at        | 作成日時           | datetime       | NOT NULL    |                                   |       |
# | updated_at        | 更新日時           | datetime       | NOT NULL    |                                   |       |
# | colosseum_user_id | 所有者ID           | integer(8)     |             | :owner_user => Colosseum::User#id | D     |
# | title             | タイトル           | string(255)    |             |                                   |       |
# | description       | 説明               | text(65535)    | NOT NULL    |                                   |       |
# | start_turn        | 開始局面           | integer(4)     |             |                                   | G     |
# | critical_turn     | 開戦               | integer(4)     |             |                                   | H     |
# | saturn_key        | 公開範囲           | string(255)    | NOT NULL    |                                   | I     |
# | sfen_body         | SFEN形式棋譜       | string(8192)   | NOT NULL    |                                   |       |
# | image_turn        | OGP画像の局面      | integer(4)     |             |                                   |       |
# | preset_key        | Preset key         | string(255)    | NOT NULL    |                                   |       |
# | sfen_hash         | Sfen hash          | string(255)    | NOT NULL    |                                   |       |
# |-------------------+--------------------+----------------+-------------+-----------------------------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# Colosseum::User.has_many :free_battles, foreign_key: :colosseum_user_id
#--------------------------------------------------------------------------------

require "open-uri"

class FreeBattle < ApplicationRecord
  include BattleModelMod
  include StrangeKifuBodyParserMod

  class << self
    def setup(options = {})
      super

      # if Rails.env.development?
      #   unless exists?
      #     30.times { create!(kifu_body: "") }
      #   end
      # end

      if AppConfig[:free_battles_import]
        Pathname.glob(Rails.root.join("config/app_data/free_battles/**/0*.kif")).each { |file| file_import(file) }
      end

      # if Rails.env.development?
      #   Pathname("~/src/bioshogi").expand_path.glob("experiment/必死道場/*.kif").sort.each do |file|
      #     name = file.basename(".*").to_s
      #     key = Digest::MD5.hexdigest(file.to_s)
      #
      #     if record = find_by(key: key)
      #       record.destroy!
      #     end
      #
      #     record = find_by(key: key) || new(key: key)
      #     record.owner_user = Colosseum::User.find_by(name: Rails.application.credentials.production_my_user_name) || Colosseum::User.sysop
      #     record.kifu_body = file.read.toutf8
      #     record.title = "必死道場 #{name}"
      #     record.start_turn = 0
      #     record.save!
      #     p [file.to_s, record.id]
      #   end
      # end
    end

    def file_import(file)
      kifu_body = file.read

      if md = file.basename(".*").to_s.match(/(?<number>\w+?)_(?<key>\w+?)_(?<saturn_key>.)_(?<title_with_desc>.*)/)
        title, description = md["title_with_desc"].split("__")
        record = find_by(key: md["key"]) || new(key: md["key"])
        record.owner_user = Colosseum::User.find_by(name: Rails.application.credentials.production_my_user_name) || Colosseum::User.sysop
        record.kifu_body = kifu_body
        record.title = title.gsub(/_/, " ")

        if description
          if md2 = description.match(/\As(?<start_turn>\d+)_?(?<rest>.*)/)
            record.start_turn = md2["start_turn"].to_i
            description = md2["rest"]
          end

          record.description = description.to_s.gsub(/_/, " ").strip
        end

        # record.public_send("#{:kifu_body}_will_change!") # 強制的にパースさせるため

        if saturn_info = SaturnInfo.find { |e| e.char_key == md["saturn_key"] }
          record.saturn_key = saturn_info.key
        end

        error = nil
        begin
          # record.parser_exec    # かならずパースする
          if kifu_body.blank?
            if record.persisted?
              record.destroy!
            end
          else
            record.save!
          end
        rescue => error
          pp record
          pp record.errors.full_messages
          pp error
          raise error
        end

        p [record.id, record.title, record.description, error]
      end
    end

    def old_record_destroy(params = {})
      params = {
        expires_in: 4.weeks,
      }.merge(params)

      all.where(use_key: "adapter").where(arel_table[:accessed_at].lteq(params[:expires_in].ago)).find_in_batches(batch_size: 100) do |g|
        begin
          g.each(&:destroy)
        rescue ActiveRecord::Deadlocked => error
          puts error
        end
      end
    end
  end

  has_secure_token :key

  attribute :kifu_file

  belongs_to :owner_user, :class_name => "Colosseum::User", :foreign_key => "colosseum_user_id", required: false

  class << self
    def generate_unique_secure_token
      if Rails.env.test?
        return "#{name.demodulize.underscore}#{count.next}"
      end
      SecureRandom.hex
    end
  end

  before_validation do
    if Rails.env.test?
      self.kifu_body ||= Pathname(__dir__).join("嬉野流.kif").read
    end

    self.title ||= default_title
    self.description ||= ""
    self.kifu_body ||= ""

    if kifu_file
      v = kifu_file.read
      v = v.to_s.toutf8 rescue nil
      self.kifu_body = v
    end

    if changes_to_save[:kifu_url]
      if v = kifu_url.presence
        self.kifu_body = http_get_body(v)
        self.kifu_url = nil
      end
    end

    if changes_to_save[:kifu_body]
      if kifu_body
        url_in_kifu_body
      end
    end
  end

  before_save do
    if changes_to_save[:kifu_body]
      if kifu_body
        # 「**候補手」のようなのがついていると容量が大きすぎてDBに保存できなくなるためコメントを除外する
        # コメントは残したいので ** で始まるものだけ除去する
        if Bioshogi::Parser::KifParser.accept?(kifu_body)
          self.kifu_body = Bioshogi::Parser.source_normalize(kifu_body).gsub(/^\*\*.*\R/, "")
        end
        parser_exec
      end
    end
  end

  def to_param
    key
  end

  def battle_decorator_class
    BattleDecorator::FreeBattleDecorator
  end

  concerning :SaturnMethods do
    included do
      before_validation do
        self.saturn_key ||= "public"
      end
    end

    def saturn_info
      SaturnInfo.fetch(saturn_key)
    end
  end

  # ここは nil でよくね？
  def tournament_name
    if v = safe_meta_info
      v.dig(:header, "棋戦")
    end
  end

  # コントローラーでは meta_info を除外しているため取れない場合がある
  # そういうとき meta_info にアクセスする用
  def safe_meta_info
    if has_attribute?(:meta_info)
      meta_info
    else
      self.class.where(id: id).pluck(:meta_info).first
    end
  end

  def default_title
    # "#{self.class.count.next}番目の何かの棋譜"
    ""
  end

  def safe_title
    title.presence || key
  end

  # 01060_77dacfcf0a24e8315ddd51e86152d3b2_横歩取り_急戦1__飛車先を受けずに互いに攻め合うと封じ込まれて後手有利.kif
  # のような形式にする
  def download_filename
    if use_info.key == :adapter
      return key
    end

    parts = []
    parts << "%05d" % id
    parts << "_"
    parts << key
    parts << "_"
    parts << saturn_info.char_key
    parts << "_"
    parts << title.gsub(/\p{Space}+/, "_")
    if description.present?
      parts << "__"

      if start_turn
        parts << "s#{start_turn}" + "_"
      end

      parts << description.truncate(80, omission: "").gsub(/\p{Space}+/, "_")
    end
    parts.join
  end

  def http_get_body(url)
    connection = Faraday.new do |builder|
      builder.response :follow_redirects # リダイレクト先をおっかける
      builder.adapter :net_http
    end

    response = connection.get(url)
    s = response.body

    s = s.toutf8
    s = s.gsub(/\\n/, "") # 棋王戦のKIFには備考に改行コードではない '\n' という文字が入っていることがある
  end

  concerning :UseInfoMethods do
    included do
      before_validation do
        self.use_key ||= UseInfo.fetch(:basic).key
      end

      with_options presence: true do
        validates :use_key
      end

      with_options allow_blank: true do
        validates :use_key, inclusion: UseInfo.keys.collect(&:to_s)
      end
    end

    def use_info
      UseInfo.fetch(use_key)
    end
  end

  concerning :TimeChartMod do
    # FreeBattle の方は preset_info がないため
    def preset_info
      @preset_info ||= fast_parsed_info.preset_info
    end

    def time_chart_datasets
      Bioshogi::Location.collect do |location|
        {
          label: location.name,
          data: time_chart_xy_list(location),
        }
      end
    end
  end
end

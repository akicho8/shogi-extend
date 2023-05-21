# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 棋譜投稿 (free_battles as FreeBattle)
#
# |---------------+---------------+-------------+-------------+--------------+-------|
# | name          | desc          | type        | opts        | refs         | index |
# |---------------+---------------+-------------+-------------+--------------+-------|
# | id            | ID            | integer(8)  | NOT NULL PK |              |       |
# | key           | キー          | string(255) | NOT NULL    |              | A!    |
# | title         | タイトル      | string(255) |             |              |       |
# | kifu_body     | 棋譜          | text(65535) | NOT NULL    |              |       |
# | sfen_body     | SFEN形式棋譜  | text(65535) | NOT NULL    |              |       |
# | turn_max      | 手数          | integer(4)  | NOT NULL    |              | B     |
# | meta_info     | 棋譜ヘッダー  | text(65535) | NOT NULL    |              |       |
# | battled_at    | Battled at    | datetime    | NOT NULL    |              | C     |
# | use_key       | Use key       | string(255) | NOT NULL    |              | D     |
# | accessed_at   | 参照日時      | datetime    | NOT NULL    |              | E     |
# | user_id       | User          | integer(8)  |             | => User#id   | F     |
# | description   | 説明          | text(65535) | NOT NULL    |              |       |
# | sfen_hash     | Sfen hash     | string(255) | NOT NULL    |              |       |
# | start_turn    | 開始局面      | integer(4)  |             |              | G     |
# | critical_turn | 開戦          | integer(4)  |             |              | H     |
# | outbreak_turn | Outbreak turn | integer(4)  |             |              | I     |
# | image_turn    | OGP画像の局面 | integer(4)  |             |              |       |
# | created_at    | 作成日時      | datetime    | NOT NULL    |              |       |
# | updated_at    | 更新日時      | datetime    | NOT NULL    |              |       |
# | preset_id     | Preset        | integer(8)  |             | => Preset#id | J     |
# |---------------+---------------+-------------+-------------+--------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# Preset.has_many :swars_battles
# User.has_one :profile
#--------------------------------------------------------------------------------

require "open-uri"

class FreeBattle < ApplicationRecord
  include BattleModelMethods
  include PresetMethods
  include ShareBoardMethods

  class << self
    def setup(options = {})
      super
    end

    def cleanup(...)
      Cleanup.new(...).call
    end
  end

  has_secure_token :key

  belongs_to :user, required: false

  scope :old_only,        -> expires_in { where(arel_table[:accessed_at].lteq(expires_in.seconds.ago)) } # 古いもの
  scope :deleteable_only, -> { where(arel_table[:use_key].eq_any(["adapter", "share_board"])) }          # 削除していいもの

  class << self
    def generate_unique_secure_token(*)
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

    if respond_to?(:saturn_key)
      self.saturn_key ||= ""
    end

    if will_save_change_to_attribute?(:kifu_body) && kifu_body
      if v = KifuExtractor.extract(kifu_body)
        self.kifu_body = v
      end
    end
  end

  before_save do
    if will_save_change_to_attribute?(:kifu_body)
      if kifu_body
        # 「**候補手」のようなのがついていると容量が大きすぎてDBに保存できなくなるためコメントを除外する
        # コメントは残したいので ** で始まるものだけ除去する
        if Bioshogi::Parser::KifParser.accept?(kifu_body)
          self.kifu_body = Bioshogi::Source.wrap(kifu_body).to_s.gsub(/^\*.*\R/, "")
        end
        parser_exec

        # コメントとして active_record_value_too_long を入れると確認できる
        if kifu_body.include?("active_record_value_too_long")
          raise ActiveRecord::ValueTooLong, "(active_record_value_too_long)"
        end
      end
    end
  end

  def to_param
    key
  end

  def battle_decorator_class
    BattleDecorator::FreeBattleDecorator
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

  def fast_parser_options
    if use_info.key == :share_board || use_info.key == :kiwi_lemon
      # めちゃくちゃな操作でもエラーにしない
      {
        :candidate_enable => false,
        :validate_enable  => false,
      }
    else
      {}
    end
  end

  # 野良棋譜の場合、手合割は解析しないとわからない
  # ウォーズはあらかじめわかっているのでこの処理はいれない
  def preset_key_set(info)
    self.preset_key = info.formatter.preset_info.key
  end

  def parser_exec_after(info)
    self.meta_info = info.container.players.inject({}) do |a, player|
      a.merge(player.location.key => player.skill_set.to_h)
    end

    if use_info.key == :basic || use_info.key == :kiwi_lemon
      self.defense_tag_list = ""
      self.attack_tag_list = ""
      self.technique_tag_list = ""
      self.note_tag_list = ""
      # self.other_tag_list = ""

      defense_tag_list.add   info.container.players.flat_map { |e| e.skill_set.defense_infos.normalize.flat_map { |e| [e.name, *e.alias_names] } }
      attack_tag_list.add    info.container.players.flat_map { |e| e.skill_set.attack_infos.normalize.flat_map  { |e| [e.name, *e.alias_names] } }
      technique_tag_list.add info.container.players.flat_map { |e| e.skill_set.technique_infos.normalize.flat_map  { |e| [e.name, *e.alias_names] } }
      note_tag_list.add      info.container.players.flat_map { |e| e.skill_set.note_infos.normalize.flat_map  { |e| [e.name, *e.alias_names] } }
    end
  end

  # free_battle = FreeBattle.same_body_fetch(body: "68銀")
  # free_battle.simple_versus_desc # =>  "▲嬉野流 vs △その他"
  def simple_versus_desc
    if meta_info
      if meta_info.kind_of?(Hash)
        if meta_info.has_key?(:black)
          hash = meta_info.inject({}) { |a, (location_key, hash)|
            name = []
            name += hash[:attack]
            name += hash[:defense]
            a.merge(location_key => name)
          }
          if hash.values.any?(&:present?)
            hash.collect { |location_key, e|
              [LocationInfo.fetch(location_key).pentagon_mark, (e.presence || ["その他"]).join(" ")].join
            }.join(" vs ")
          end
        end
      end
    end
  end

  def info
    {
      "id"       => id,
      "key"      => key,
      "オーナー" => user&.name,
      "use_key"  => use_key,
      "作成"     => created_at.to_fs(:ymd),
      "参照"     => accessed_at.to_fs(:ymd),
    }
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

  concerning :HelperMethods do
    def piyo_shogi_base_params
      decorator = mini_battle_decorator
      a = {}
      a[:game_name] = decorator.normalized_full_tournament_name
      names = LocationInfo.collect { |e| [decorator.player_name_for(e), decorator.grade_name_for(e)].compact.join(" ") }
      a.update([:sente_name, :gote_name].zip(names).to_h)
      a
    end
  end

  concerning :AdapterMethods do
    class_methods do
      # 成功
      #   rails r 'tp FreeBattle.adapter_post(input_text: "68銀")'
      #   rails r 'tp FreeBattle.adapter_post(input_text: "")'
      # 失敗
      #   rails r 'FreeBattle.adapter_post(input_text: "58金") rescue (p $!.message)'
      def adapter_post(params)
        begin
          record = FreeBattle.create!(kifu_body: params[:input_text], use_key: "adapter")
          attrs = record.as_json({
              methods: [
                :all_kifs,
                :display_turn,
                :piyo_shogi_base_params,
              ],
            })
        rescue Bioshogi::BioshogiError => error
          adapter_notify(params, record, error)
          raise error
        end
        adapter_notify(params, record)
        { record: attrs }
      end

      private

      def adapter_notify(params, record, error = nil)
        emoji = ":成功:"

        if error
          emoji = ":失敗:"
        end

        turn_max = nil
        if record
          turn_max = record.turn_max
          # 最大0手の場合は詰将棋の局面なので失敗の絵文字にしてはいけない
          if false
            if turn_max.zero?
              emoji = ":失敗:"
            end
          end
        end

        subject = []
        subject << "なんでも棋譜変換"
        if params[:current_user]
          subject << params[:current_user].name
        end
        if turn_max
          subject << "手数#{turn_max}"
        end
        if error
          subject << error.class.name
        end
        subject = subject.join(" ")

        body = []
        if params[:current_user]
          body << params[:current_user].info.to_t.strip
          body << ""
        end
        if error
          body << "▼エラー"
          body << error.message.strip
          body << ""
        end

        body << "▼棋譜(入力)"
        body << params[:input_text].strip
        body << ""

        if record
          body << "▼棋譜(変換後)"
          body << record.to_xxx(:kif)
          body << ""
        end

        body = body.join("\n")

        AppLog.important(subject: subject, body: body, emoji: emoji)
      end
    end
  end
end

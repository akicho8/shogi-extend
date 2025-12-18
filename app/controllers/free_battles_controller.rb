# -*- coding: utf-8 -*-

# == Schema Information ==
#
# 棋譜投稿 (free_battles as FreeBattle)
#
# |---------------+---------------+----------------+-------------+--------------+-------|
# | name          | desc          | type           | opts        | refs         | index |
# |---------------+---------------+----------------+-------------+--------------+-------|
# | id            | ID            | integer(8)     | NOT NULL PK |              |       |
# | key           | キー          | string(255)    | NOT NULL    |              | A!    |
# | kifu_body     | 棋譜          | text(65535)    |             |              |       |
# | turn_max      | 手数          | integer(4)     | NOT NULL    |              | C     |
# | meta_info     | 棋譜ヘッダー  | text(16777215) | NOT NULL    |              |       |
# | battled_at    | Battled at    | datetime       | NOT NULL    |              | B     |
# | created_at    | 作成日時      | datetime       | NOT NULL    |              |       |
# | updated_at    | 更新日時      | datetime       | NOT NULL    |              |       |
# | user_id       | User          | integer(8)     |             | => User#id   | H     |
# | title         | タイトル      | string(255)    |             |              |       |
# | description   | 説明          | text(65535)    | NOT NULL    |              |       |
# | start_turn    | 開始局面      | integer(4)     |             |              |       |
# | critical_turn | 開戦          | integer(4)     |             |              | D     |
# | saturn_key    | Saturn key    | string(255)    | NOT NULL    |              | E     |
# | sfen_body     | SFEN形式棋譜  | text(65535)    | NOT NULL    |              |       |
# | image_turn    | OGP画像の局面 | integer(4)     |             |              |       |
# | use_key       | Use key       | string(255)    | NOT NULL    |              | G     |
# | outbreak_turn | Outbreak turn | integer(4)     |             |              | F     |
# | accessed_at   | 参照日時      | datetime       | NOT NULL    |              | I     |
# | sfen_hash     | Sfen hash     | string(255)    | NOT NULL    |              |       |
# | preset_id     | Preset        | integer(8)     |             | => Preset#id | J     |
# |---------------+---------------+----------------+-------------+--------------+-------|
#
# - Remarks ----------------------------------------------------------------------
# Preset.has_many :swars_battles
# User.has_one :profile
# --------------------------------------------------------------------------------

class FreeBattlesController < ApplicationController
  include ModulableCrud::All
  include BattleControllerBaseMethods
  include BattleControllerSbSupportMethods
  include AdapterMethods

  private

  def current_index_scope
    @current_index_scope ||= current_scope
  end

  def current_record
    @current_record ||= yield_self do
      record = nil

      if id = params[:id]
        if Rails.env.production? || Rails.env.staging?
        else
          record ||= current_model.find_by(id: id)
        end
        record ||= current_model.find_by!(key: id)
      end

      record ||= current_model.new

      record.tap do |e|
        # 初期値設定
        if current_edit_mode == :adapter
          e.use_key ||= UseInfo.fetch(:adapter).key
        else
          e.use_key ||= UseInfo.fetch(:basic).key
        end
      end
    end
  end

  def current_record_params
    v = super

    # ショートカット
    # http://localhost:3000/x/new?body=xxx
    # のときの xxx などを拾う
    {
      :title       => :title,
      :body        => :kifu_body,
      :description => :description,
    }.each do |key, column|
      if s = params[key].presence
        v[column] = s
      end
    end

    v
  end
end

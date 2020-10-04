# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 棋譜投稿 (free_battles as FreeBattle)
#
# |---------------+--------------------+----------------+-------------+------------+-------|
# | name          | desc               | type           | opts        | refs       | index |
# |---------------+--------------------+----------------+-------------+------------+-------|
# | id            | ID                 | integer(8)     | NOT NULL PK |            |       |
# | key           | ユニークなハッシュ | string(255)    | NOT NULL    |            | A!    |
# | kifu_url      | 棋譜URL            | string(255)    |             |            |       |
# | kifu_body     | 棋譜               | text(16777215) | NOT NULL    |            |       |
# | turn_max      | 手数               | integer(4)     | NOT NULL    |            | E     |
# | meta_info     | 棋譜ヘッダー       | text(65535)    | NOT NULL    |            |       |
# | battled_at    | Battled at         | datetime       | NOT NULL    |            | D     |
# | outbreak_turn | Outbreak turn      | integer(4)     |             |            | B     |
# | use_key       | Use key            | string(255)    | NOT NULL    |            | C     |
# | accessed_at   | Accessed at        | datetime       | NOT NULL    |            |       |
# | created_at    | 作成日時           | datetime       | NOT NULL    |            |       |
# | updated_at    | 更新日時           | datetime       | NOT NULL    |            |       |
# | user_id       | User               | integer(8)     |             | => User#id | I     |
# | title         | タイトル           | string(255)    |             |            |       |
# | description   | 説明               | text(65535)    | NOT NULL    |            |       |
# | start_turn    | 開始局面           | integer(4)     |             |            | F     |
# | critical_turn | 開戦               | integer(4)     |             |            | G     |
# | saturn_key    | 公開範囲           | string(255)    | NOT NULL    |            | H     |
# | sfen_body     | SFEN形式棋譜       | string(8192)   | NOT NULL    |            |       |
# | image_turn    | OGP画像の局面      | integer(4)     |             |            |       |
# | preset_key    | Preset key         | string(255)    | NOT NULL    |            |       |
# | sfen_hash     | Sfen hash          | string(255)    | NOT NULL    |            |       |
# |---------------+--------------------+----------------+-------------+------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# User.has_one :profile
#--------------------------------------------------------------------------------

class FreeBattlesController < ApplicationController
  include ModulableCrud::All
  include BattleControllerBaseMethods
  include BattleControllerSharedMethods
  include AdapterMod

  # http://0.0.0.0:3000/x.json?config_fetch=true
  def index
    if request.format.json?
      if params[:config_fetch]
        render json: js_edit_options
        return
      end
    end

    super
  end

  def create
    if request.format.json?
      if current_edit_mode === :adapter
        if params[:input_text]
          # なんでも棋譜変換
          adapter_process
          if performed?
            return
          end
        end
      end
    end

    super
  end

  private

  def current_index_scope
    @current_index_scope ||= current_scope
  end

  let :current_record do
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
        e.saturn_key ||= SaturnInfo.fetch(:private).key
        e.use_key ||= UseInfo.fetch(:adapter).key
      else
        e.use_key ||= UseInfo.fetch(:basic).key
        if current_user
          e.saturn_key ||= SaturnInfo.fetch(:private).key
        else
          e.saturn_key ||= SaturnInfo.fetch(:public).key
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

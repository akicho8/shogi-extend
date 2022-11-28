# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 将棋ウォーズ対戦情報 (swars_battles as Swars::Battle)
#
# |---------------+------------------+-------------+-------------+-------------------+-------|
# | name          | desc             | type        | opts        | refs              | index |
# |---------------+------------------+-------------+-------------+-------------------+-------|
# | id            | ID               | integer(8)  | NOT NULL PK |                   |       |
# | key           | 対局ユニークキー | string(255) | NOT NULL    |                   | A!    |
# | battled_at    | 対局日時         | datetime    | NOT NULL    |                   | B     |
# | csa_seq       | 棋譜             | text(65535) | NOT NULL    |                   |       |
# | win_user_id   | 勝者             | integer(8)  |             | => Swars::User#id | C     |
# | turn_max      | 手数             | integer(4)  | NOT NULL    |                   | D     |
# | meta_info     | メタ情報         | text(65535) | NOT NULL    |                   |       |
# | accessed_at   | 最終アクセス日時 | datetime    | NOT NULL    |                   | E     |
# | sfen_body     | SFEN形式棋譜     | text(65535) | NOT NULL    |                   |       |
# | sfen_hash     | Sfen hash        | string(255) | NOT NULL    |                   |       |
# | start_turn    | 開始局面         | integer(4)  |             |                   | F     |
# | critical_turn | 開戦             | integer(4)  |             |                   | G     |
# | outbreak_turn | Outbreak turn    | integer(4)  |             |                   | H     |
# | image_turn    | OGP画像の局面    | integer(4)  |             |                   |       |
# | created_at    | 作成日時         | datetime    | NOT NULL    |                   |       |
# | updated_at    | 更新日時         | datetime    | NOT NULL    |                   |       |
# | xmode_id      | Xmode            | integer(8)  | NOT NULL    |                   | I     |
# | preset_id     | Preset           | integer(8)  | NOT NULL    | => Preset#id      | J     |
# | rule_id       | Rule             | integer(8)  | NOT NULL    |                   | K     |
# | final_id      | Final            | integer(8)  | NOT NULL    |                   | L     |
# |---------------+------------------+-------------+-------------+-------------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# Preset.has_many :swars_battles
# 【警告:リレーション欠如】Swars::Userモデルで has_many :swars/battles されていません
#--------------------------------------------------------------------------------

# http://localhost:3000/w.json?query=DevUser1
module Swars
  class BattlesController < ApplicationController
    include ModulableCrud::All
    include BattleControllerBaseMethods
    include BattleControllerSharedMethods
    include ZipDl::ActionMethods
    include IndexMethods
    include ShowMethods

    before_action do
      @xnotice = Xnotice.new
    end

    rescue_from "Swars::Agent::BaseError" do |exception|
      SlackSos.notify_exception(exception)
      render json: { message: exception.message }, status: exception.status
    end

    rescue_from "Swars::KeyVo::InvalidKey" do |exception|
      render json: { message: exception.message }, status: 404
    end

    rescue_from "Faraday::ConnectionFailed" do |exception|
      SlackSos.notify_exception(exception)
      render json: { message: "混み合っています<br>しばらくしてからアクセスしてください" }, status: 408
    end

    rescue_from "ActiveRecord::RecordNotUnique" do |exception|
      SlackSos.notify_exception(exception, backtrace_lines_max: 0)
      render json: { message: "連打したのでぶっこわれました" }, status: 500
    end

    rescue_from "ActiveRecord::Deadlocked" do |exception|
      SlackSos.notify_exception(exception, backtrace_lines_max: 0)
      render json: { message: "データベースが死にそうです" }, status: 500
    end
  end
end

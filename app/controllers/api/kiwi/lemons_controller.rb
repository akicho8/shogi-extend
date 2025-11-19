# -*- coding: utf-8 -*-

# == Schema Information ==
#
# 動画 (kiwi_lemons as Kiwi::Lemon)
#
# |------------------+--------------------------+-------------+-------------+------+-------|
# | name             | desc                     | type        | opts        | refs | index |
# |------------------+--------------------------+-------------+-------------+------+-------|
# | id               | ID                       | integer(8)  | NOT NULL PK |      |       |
# | user_id          | 所有者                   | integer(8)  | NOT NULL    |      | A     |
# | recordable_type  | 棋譜情報(クラス名)       | string(255) | NOT NULL    |      | B     |
# | recordable_id    | 棋譜情報                 | integer(8)  | NOT NULL    |      | B     |
# | all_params       | 変換用全パラメータ       | text(65535) | NOT NULL    |      |       |
# | process_begin_at | 開始日時                 | datetime    |             |      | C     |
# | process_end_at   | 終了日時(失敗時も入る)   | datetime    |             |      | D     |
# | successed_at     | 正常終了日時             | datetime    |             |      | E     |
# | errored_at       | 失敗終了日時             | datetime    |             |      | F     |
# | error_message    | エラー文言               | text(65535) |             |      |       |
# | content_type     | 動画タイプ               | string(255) |             |      |       |
# | file_size        | 動画サイズ               | integer(4)  |             |      |       |
# | ffprobe_info     | ffprobeの内容            | text(65535) |             |      |       |
# | browser_path     | 動画WEBパス              | string(255) |             |      |       |
# | filename_human   | 動画の人間向けファイル名 | string(255) |             |      |       |
# | created_at       | 作成日時                 | datetime    | NOT NULL    |      | G     |
# | updated_at       | 更新日時                 | datetime    | NOT NULL    |      |       |
# |------------------+--------------------------+-------------+-------------+------+-------|
#
# - Remarks ----------------------------------------------------------------------
# [Warning: Need to add relation] Kiwi::Lemon モデルに belongs_to :recordable, polymorphic: true を追加しよう
# [Warning: Need to add relation] Kiwi::Lemon モデルに belongs_to :user を追加しよう
# --------------------------------------------------------------------------------

module Api
  module Kiwi
    class LemonsController < ApplicationController
      FAST_RESPONSE = nil
      VALIDATE_TURN_MAX = 1525

      before_action only: [
        :retry_run,
        :destroy_run,
        :all_info_reload,
        :zombie_kill_now,
        :background_job_kick,
      ] do
        if !staff?
          raise ActionController::RoutingError, "No route matches [#{request.method}] #{request.path_info.inspect}"
        end
      end

      # 起動時に実行
      # curl http://localhost:3000/api/kiwi/lemons/xresource_fetch.json
      # ../../../../nuxt_side/components/Kiwi/KiwiLemonNew/KiwiLemonNew
      def xresource_fetch
        render json: {
          :background_job_active_hours => ::Kiwi::Lemon.background_job_range.to_a,
        }
      end

      # フォームPOST時
      # curl -d _method=post http://localhost:3000/api/kiwi/lemons/record_create.json
      # ../../../../nuxt_side/components/Kiwi/KiwiLemonNew/app_form.js
      def record_create
        if !current_user
          render html: "ログインしよう"
          return
        end

        # 予約数制限
        if c = Xsetting[:user_lemon_queue_max]
          if current_user.kiwi_lemons.not_done_only.count >= c
            render json: { error_message: "投入しすぎです" }
            return
          end
        end

        free_battle = FreeBattle.create!(kifu_body: params[:body], use_key: "kiwi_lemon", user: current_user)
        if free_battle.turn_max > VALIDATE_TURN_MAX
          render json: { error_message: "手数が長すぎます" }
          return
        end

        # みんな実行を連打するため前回と同じパラメータなら戻す
        if true
          str = params.to_unsafe_h.to_s
          hash = Digest::MD5.hexdigest(str)
          key = [current_user.id, controller_path, action_name, hash].join(":")
          value = Rails.cache.read(key)
          if value
            render json: { error_message: "すでに同じパラメータで投入しています" }
            return
          end
          Rails.cache.write(key, true, expires_in: 3.days)
        end

        # 将来的には KIF などはここですぐ返したらいいんでは？
        if FAST_RESPONSE && free_battle.turn_max <= FAST_RESPONSE
          media_builder = MediaBuilder.new(free_battle, params[:all_params])
          media_builder.not_exist_then_build
          render json: {
            response_hash: {
              url: media_builder.browser_url,
              free_battle: free_battle.as_json, # フロント側では未使用
            }
          }
          return
        end

        lemon = current_user.kiwi_lemons.create!(recordable: free_battle, all_params: params.to_unsafe_h[:all_params])
        lemon.create_notify
        current_user.kiwi_my_lemons_singlecast
        ::Kiwi::Lemon.everyone_broadcast
        ::Kiwi::Lemon.zombie_kill                   # ゾンビを成仏させる
        ::Kiwi::Lemon.background_job_kick_if_period # 時間内なら変換する

        render json: {
          response_hash: {
            :posted_record => lemon.as_json,
            :message       => "#{lemon.id} 番で予約しました",
            :alert_message => ::Kiwi::Lemon.background_job_inactive_message,
          }
        }
      end

      # 定期的に呼び出してゾンビ削除
      # curl -d _method=post http://localhost:3000/api/kiwi/lemons/zombie_kill.json
      # ../../../../nuxt_side/components/Kiwi/KiwiLemonNew/app_zombie.js
      def zombie_kill
        ::Kiwi::Lemon.zombie_kill
        # ::Kiwi::Lemon.background_job_kick_if_period
        render json: { status: "success" }
      end

      ################################################################################

      # リトライ (管理者専用)
      # http://localhost:3000/api/kiwi/lemons/retry_run.json?id=1
      # curl -d _method=post http://localhost:3000/api/kiwi/lemons/retry_run.json
      # ../../../../nuxt_side/components/Kiwi/KiwiLemonNew/app_form.js
      def retry_run
        lemon = ::Kiwi::Lemon.find(params[:id])
        lemon.retry_run
        current_user.kiwi_admin_info_singlecasted
        render json: {
          response_hash: {
            :posted_record => lemon.as_json,
            :message => "#{lemon.id} 番で再予約しました",
          },
        }
      end

      # 削除 (管理者専用)
      # http://localhost:3000/api/kiwi/lemons/destroy_run.json?id=1
      # curl -d _method=post http://localhost:3000/api/kiwi/lemons/destroy_run.json
      # ../../../../nuxt_side/components/Kiwi/KiwiLemonNew/app_form.js
      def destroy_run
        lemon = ::Kiwi::Lemon.find(params[:id])
        lemon.destroy_run
        current_user.kiwi_admin_info_singlecasted
        render json: {
          response_hash: {
            :destroyed_record => lemon.as_json, # 未使用
            :message => "#{lemon.id} 番を削除しました",
          },
        }
      end

      # 直近の一覧 (管理者専用)
      # http://localhost:3000/api/kiwi/lemons/all_info_reload
      # curl -d _method=post http://localhost:3000/api/kiwi/lemons/all_info_reload.json
      def all_info_reload
        current_user.kiwi_admin_info_singlecasted
        render json: {
          response_hash: {
            :message => "管理用情報のリロード完了",
          },
        }
      end

      # 強制ゾンビ抹殺 (管理者専用)
      # ただし何も動いてないときのみ
      # http://localhost:3000/api/kiwi/lemons/zombie_kill_now
      # curl -d _method=post http://localhost:3000/api/kiwi/lemons/zombie_kill_now.json
      def zombie_kill_now
        count = 0
        if ::Kiwi::Lemon.sidekiq_task_count.zero?
          count = ::Kiwi::Lemon.zombie_kill(expires_in: 0.minutes)
          current_user.kiwi_admin_info_singlecasted # リロードも実行しておく
        end
        render json: {
          response_hash: {
            :message => "ゾンビを#{count}匹成仏させました",
          },
        }
      end

      # 時間に関係なくjob実行 (管理者専用)
      # ただし何も動いてないときのみ
      # http://localhost:3000/api/kiwi/lemons/background_job_kick
      # curl -d _method=post http://localhost:3000/api/kiwi/lemons/background_job_kick.json
      def background_job_kick
        ::Kiwi::Lemon.background_job_kick
        render json: {
          response_hash: {
            :message => "OK",
          },
        }
      end
    end
  end
end

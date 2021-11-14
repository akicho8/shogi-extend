# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 動画 (kiwi_lemons as Kiwi::Lemon)
#
# |------------------+--------------------------+-------------+-------------+----------------------------+-------|
# | name             | desc                     | type        | opts        | refs                       | index |
# |------------------+--------------------------+-------------+-------------+----------------------------+-------|
# | id               | ID                       | integer(8)  | NOT NULL PK |                            |       |
# | user_id          | 所有者                   | integer(8)  | NOT NULL    | => User#id                 | A     |
# | recordable_type  | 棋譜情報(クラス名)       | string(255) | NOT NULL    | SpecificModel(polymorphic) | B     |
# | recordable_id    | 棋譜情報                 | integer(8)  | NOT NULL    | => (recordable_type)#id    | B     |
# | all_params       | 変換用全パラメータ       | text(65535) | NOT NULL    |                            |       |
# | process_begin_at | 開始日時                 | datetime    |             |                            | C     |
# | process_end_at   | 終了日時(失敗時も入る)   | datetime    |             |                            | D     |
# | successed_at     | 正常終了日時             | datetime    |             |                            | E     |
# | errored_at       | 失敗終了日時             | datetime    |             |                            | F     |
# | error_message    | エラー文言               | text(65535) |             |                            |       |
# | content_type     | 動画タイプ               | string(255) |             |                            |       |
# | file_size        | 動画サイズ               | integer(4)  |             |                            |       |
# | ffprobe_info     | ffprobeの内容            | text(65535) |             |                            |       |
# | browser_path     | 動画WEBパス              | string(255) |             |                            |       |
# | filename_human   | 動画の人間向けファイル名 | string(255) |             |                            |       |
# | created_at       | 作成日時                 | datetime    | NOT NULL    |                            | G     |
# | updated_at       | 更新日時                 | datetime    | NOT NULL    |                            |       |
# |------------------+--------------------------+-------------+-------------+----------------------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# User.has_one :profile
#--------------------------------------------------------------------------------

module Api
  module Kiwi
    class LemonsController < ApplicationController
      FAST_RESPONSE = nil
      VALIDATE_TURN_MAX = 1525

      # 未使用
      # http://localhost:3000/api/kiwi/lemons/index.json
      # http://localhost:3000/api/kiwi/lemons/index.json?query=a&tag=b,c
      def index
        if Rails.env.production?
          raise ActionController::RoutingError, "No route matches [#{request.method}] #{request.path_info.inspect}"
        end
        retv = {}
        retv[:lemons] = current_lemons.as_json(::Kiwi::Lemon.json_struct_for_index)
        retv[:meta]  = AppEntryInfo.fetch(:kiwi_lemon_index).og_meta
        render json: retv
      end

      # こちらは対象にしない
      # 見るのは banana の方
      # http://localhost:3000/api/kiwi/lemons/sitemap.json
      # http://localhost:4000/sitemap.xml
      # def sitemap
      #   if Rails.env.production?
      #     raise ActionController::RoutingError, "No route matches [#{request.method}] #{request.path_info.inspect}"
      #   end
      #   retv = {}
      #   retv[:lemons] = ::Kiwi::Lemon.public_only.order(updated_at: :desc).limit(1000).as_json(only: [:key])
      #   render json: retv
      # end

      # curl http://localhost:3000/api/kiwi/lemons/latest_info_reload.json
      # ../../../nuxt_side/components/Kiwi/KiwiApp.vue
      def latest_info_reload
        if !current_user
          render json: {}
          return
        end

        render json: {}
        return
      end

      # curl -d _method=post http://localhost:3000/api/kiwi/lemons/record_create.json
      # ../../../nuxt_side/components/Kiwi/app_form.js
      def record_create
        if !current_user
          render html: "ログインしてください"
          return
        end

        # 予約数制限
        if c = current_user_lemon_queue_max
          if current_user.kiwi_lemons.not_done_only.count > c
            render json: { error_message: "投入しすぎです" }
            return
          end
        end

        free_battle = FreeBattle.create!(kifu_body: params[:body], use_key: "kiwi_lemon", user: current_user)

        if free_battle.turn_max > VALIDATE_TURN_MAX
          render json: { error_message: "手数が長すぎます" }
          return
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

        # if !current_user
        #   render html: "ログインしてください"
        #   return
        # end

        # if lemon = ::Kiwi::Lemon.find_by(recordable: current_record)
        #   # render html: lemon.to_html
        #   render html: [lemon.status_key, ::Kiwi::Lemon.info.to_html].join.html_safe
        #   return
        # end

        lemon = current_user.kiwi_lemons.create!(recordable: free_battle, all_params: params.to_unsafe_h[:all_params])
        if false
          lemon.main_process
        else
          current_user.kiwi_my_lemons_singlecast
          ::Kiwi::Lemon.everyone_broadcast
          ::Kiwi::Lemon.zombie_kill # ゾンビを成仏させる
          ::Kiwi::Lemon.background_job_kick_if_period
          render json: {
            response_hash: {
              :lemon   => lemon.as_json,
              :message => "#{lemon.id} 番で予約しました",
            }
          }
          return
        end
      end

      # http://localhost:3000/api/kiwi/lemons/retry_run.json?id=1
      # curl -d _method=post http://localhost:3000/api/kiwi/lemons/retry_run.json
      # ../../../nuxt_side/components/Kiwi/app_form.js
      def retry_run
        lemon = ::Kiwi::Lemon.find(params[:id])
        lemon.retry_run
        # if staff?
        #   current_user.kiwi_all_info_singlecasted
        # end
        render json: {
          response_hash: {
            :lemon   => lemon.as_json,
            :message => "#{lemon.id} 番で再予約しました",
          },
        }
      end

      # http://localhost:3000/api/kiwi/lemons/all_info_reload
      # curl -d _method=post http://localhost:3000/api/kiwi/lemons/all_info_reload.json
      def all_info_reload
        if staff?
          current_user.kiwi_all_info_singlecasted
        end
        render json: {}
      end

      # curl -d _method=post http://localhost:3000/api/kiwi/lemons/zombie_kill.json
      # ../../../nuxt_side/components/Kiwi/app_zombie.js
      def zombie_kill
        ::Kiwi::Lemon.zombie_kill
        # ::Kiwi::Lemon.background_job_kick_if_period
        render json: { status: "success" }
      end

      def current_user_lemon_queue_max
        if current_user
          if current_user.permit_tag_list.include?("staff") && false
            nil
          else
            user_lemon_queue_max_default
          end
        else
          0
        end
      end

      # 予約可能な数(処理中を含む)
      def user_lemon_queue_max_default
        (params[:user_lemon_queue_max].presence || ::Kiwi::Lemon.user_lemon_queue_max).to_i
      end

      private

      def current_lemons
        @current_lemons ||= -> {
          s = ::Kiwi::Lemon.all

          # ログインしていればプライベートな問題集も混ぜる
          # if current_user
          #   s = s.or(current_user.kiwi_lemons.joins(:folder))
          # end

          s = s.search(params)
          s = s.order(updated_at: :desc)
          s = page_scope(s)       # page_methods.rb

          # # visible_articles_count のため
          # s.each do |e|
          #   e.current_user = current_user
          # end

          s
        }.call
      end

      # PageMethods override
      def default_per
        50
      end
    end
  end
end

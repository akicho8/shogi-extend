# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 動画 (kiwi_lemons as Kiwi::Lemon)
#
# |------------------+------------------+-------------+-------------+----------------------------+-------|
# | name             | desc             | type        | opts        | refs                       | index |
# |------------------+------------------+-------------+-------------+----------------------------+-------|
# | id               | ID               | integer(8)  | NOT NULL PK |                            |       |
# | user_id          | User             | integer(8)  | NOT NULL    | => User#id                 | A     |
# | recordable_type  | Recordable type  | string(255) | NOT NULL    | SpecificModel(polymorphic) | B     |
# | recordable_id    | Recordable       | integer(8)  | NOT NULL    | => (recordable_type)#id    | B     |
# | all_params       | All params       | text(65535) | NOT NULL    |                            |       |
# | process_begin_at | Process begin at | datetime    |             |                            | C     |
# | process_end_at   | Process end at   | datetime    |             |                            | D     |
# | successed_at     | Successed at     | datetime    |             |                            | E     |
# | errored_at       | Errored at       | datetime    |             |                            | F     |
# | error_message    | Error message    | text(65535) |             |                            |       |
# | content_type     | Content type     | string(255) |             |                            |       |
# | file_size        | File size        | integer(4)  |             |                            |       |
# | ffprobe_info     | Ffprobe info     | text(65535) |             |                            |       |
# | browser_path     | Browser path     | string(255) |             |                            |       |
# | filename_human   | Filename human   | string(255) |             |                            |       |
# | created_at       | 作成日時         | datetime    | NOT NULL    |                            | G     |
# | updated_at       | 更新日時         | datetime    | NOT NULL    |                            |       |
# |------------------+------------------+-------------+-------------+----------------------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# User.has_one :profile
#--------------------------------------------------------------------------------

module Api
  module Kiwi
    class LemonsController < ApplicationController
      FAST_RESPONSE = nil
      VALIDATE_TURN_MAX = 1525

      # http://localhost:3000/api/kiwi/lemons/index.json
      # http://localhost:3000/api/kiwi/lemons/index.json?query=a&tag=b,c
      def index
        retv = {}
        retv[:lemons] = current_lemons.as_json(::Kiwi::Lemon.json_struct_for_index)
        retv[:meta]  = AppEntryInfo.fetch(:kiwi_lemon_index).og_meta
        render json: retv
      end

      # http://localhost:3000/api/kiwi/lemons/sitemap.json
      # http://localhost:4000/sitemap.xml
      def sitemap
        retv = {}
        retv[:lemons] = ::Kiwi::Lemon.public_only.order(updated_at: :desc).limit(1000).as_json(only: [:key])
        render json: retv
      end

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
        if c = current_reserve_limit
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
          ::Kiwi::Lemon.background_job_kick
          render json: {
            response_hash: {
              lemon: lemon.as_json,
              free_battle: free_battle.as_json,
              # kiwi_info: ::Kiwi::Lemon.kiwi_info,
            }
          }
          return
        end

        # # render html: url
        # # return
        #
        # if media_builder.file_exist?
        #   send_file_or_redirect(media_builder)
        #   return
        # end
        #
      end

      # curl -d _method=post http://localhost:3000/api/kiwi/lemons/zombie_kill.json
      # ../../../nuxt_side/components/Kiwi/app_zombie.js
      def zombie_kill
        ::Kiwi::Lemon.zombie_kill
        # ::Kiwi::Lemon.background_job_kick
        render json: { status: "success" }
      end

      def current_reserve_limit
        if current_user
          if current_user.permit_tag_list.include?("staff") && false
            nil
          else
            reserve_limit_default
          end
        else
          0
        end
      end

      # 予約可能な数(処理中を含む)
      def reserve_limit_default
        (params[:reserve_limit].presence || ::Kiwi::Lemon.user_queue_max).to_i
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

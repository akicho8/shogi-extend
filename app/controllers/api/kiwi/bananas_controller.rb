# -*- coding: utf-8 -*-

# == Schema Information ==
#
# ライブラリ (kiwi_bananas as Kiwi::Banana)
#
# |-----------------------+----------------+-------------+---------------------+------+-------|
# | name                  | desc           | type        | opts                | refs | index |
# |-----------------------+----------------+-------------+---------------------+------+-------|
# | id                    | ID             | integer(8)  | NOT NULL PK         |      |       |
# | key                   | キー           | string(255) | NOT NULL            |      | A!    |
# | user_id               | 所有者         | integer(8)  | NOT NULL            |      | C     |
# | folder_id             | 公開設定       | integer(8)  | NOT NULL            |      | D     |
# | lemon_id              | 動画ファイル   | integer(8)  | NOT NULL            |      | B!    |
# | title                 | タイトル       | string(100) | NOT NULL            |      |       |
# | description           | 説明           | text(65535) | NOT NULL            |      |       |
# | thumbnail_pos         | サムネ位置(秒) | float(24)   | NOT NULL            |      |       |
# | banana_messages_count | コメント数     | integer(4)  | DEFAULT(0) NOT NULL |      | E     |
# | access_logs_count     | アクセス数     | integer(4)  | DEFAULT(0) NOT NULL |      | F     |
# | created_at            | 作成日時       | datetime    | NOT NULL            |      |       |
# | updated_at            | 更新日時       | datetime    | NOT NULL            |      |       |
# |-----------------------+----------------+-------------+---------------------+------+-------|
#
# - Remarks ----------------------------------------------------------------------
# [Warning: Need to add relation] Kiwi::Banana モデルに belongs_to :folder を追加しよう
# [Warning: Need to add relation] Kiwi::Banana モデルに belongs_to :lemon を追加しよう
# [Warning: Need to add relation] Kiwi::Banana モデルに belongs_to :user を追加しよう
# --------------------------------------------------------------------------------

module Api
  module Kiwi
    class BananasController < ApplicationController
      before_action :api_login_required, only: [:edit, :save, :destroy, :download]

      # http://localhost:3000/api/kiwi/bananas.json
      # http://localhost:3000/api/kiwi/bananas.json?scope=everyone
      # http://localhost:3000/api/kiwi/bananas.json?scope=public
      # http://localhost:3000/api/kiwi/bananas.json?scope=private
      def index
        retval = {}
        retval[:bananas] = current_bananas.sorted(sort_info).as_json(::Kiwi::Banana.json_struct_for_index)
        retval[:total] = current_bananas.total_count
        # retval[:meta]  = AppEntryInfo.fetch(:kiwi).og_meta
        render json: retval
      end

      # http://localhost:3000/api/kiwi/bananas/show.json?banana_key=6&_user_id=1
      # http://localhost:3000/api/kiwi/bananas/show.json?banana_key=5
      def show
        retval = {}
        retval[:config] = ::Kiwi::Config
        banana = ::Kiwi::Banana.find_by!(key: params[:banana_key])
        show_can!(banana)
        if axios_process_client? # 2度呼ばれるため仕方なく
          banana.access_logs.create!(user: current_user)
        end
        v = banana.as_json(::Kiwi::Banana.json_struct_for_show)
        retval[:banana] = v
        render json: retval
      end

      # 問題編集用
      #
      # http://localhost:3000/api/kiwi/bananas/edit.json
      # http://localhost:3000/api/kiwi/bananas/edit.json?banana_key=1
      # http://localhost:4000/video/watch/new
      # http://localhost:4000/video/watch/1/edit
      def edit
        retval = {}
        retval[:config] = ::Kiwi::Config
        s = current_user.kiwi_bananas
        if v = params[:banana_key]
          banana = s.find_by!(key: v)
          # edit_permission_valid!(banana)
        else
          banana = s.build
          if current_lemon
            banana.lemon = current_lemon
          end
          banana.form_values_default_assign
        end
        retval[:banana] = banana.as_json(::Kiwi::Banana.json_struct_for_edit)
        # retval[:meta] = banana.og_meta
        # sleep(3)
        render json: retval
      end

      # POST http://localhost:3000/api/kiwi/bananas/save
      # nginx の client_max_body_size を調整が必要
      def save
        if v = params[:banana][:key]
          banana = current_user.kiwi_bananas.find_by!(key: v)
        else
          banana = current_user.kiwi_bananas.build
        end
        render json: banana.update_from_action(params.to_unsafe_h[:banana])
      end

      # DELETE http://localhost:3000/api/kiwi/bananas/destroy
      def destroy
        current_user.kiwi_bananas.find(params[:banana_id]).destroy!
        render json: {}
      end

      def download
        banana = ::Kiwi::Banana.find_by!(key: params[:banana_key])
        show_can!(banana)
        send_data(*banana.to_send_data_params(params.merge(current_user: current_user)))
      end

      private

      # def banana_counts
      #   ::Kiwi::BananaIndexScopeInfo.inject({}) do |a, e|
      #     a.merge(e.key => e.query_func[current_user].count)
      #   end
      # end

      def current_bananas
        @current_bananas ||= yield_self do
          # s = current_banana_scope_info.query_func[current_user]
          if current_user
            s = current_user.kiwi_bananas
          else
            s = ::Kiwi::Banana.none
          end
          if v = params[:tag].to_s.split(/[,\s]+/).presence
            s = s.tagged_with(v)
          end
          s = page_scope(s)       # page_methods.rb
        end
      end

      # PageMethods override
      def default_per
        ::Kiwi::Config[:api_bananas_fetch_per]
      end

      def current_lemon
        if v = params[:source_id].presence
          if current_user
            current_user.kiwi_lemons.find(v)
          end
        end
      end
    end
  end
end

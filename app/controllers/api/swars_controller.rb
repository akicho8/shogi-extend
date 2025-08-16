# -*- coding: utf-8 -*-

# == Schema Information ==
#
# ユーザー (users as User)
#
# |------------------------+----------------------------+-------------+---------------------+------+-------|
# | name                   | desc                       | type        | opts                | refs | index |
# |------------------------+----------------------------+-------------+---------------------+------+-------|
# | id                     | ID                         | integer(8)  | NOT NULL PK         |      |       |
# | key                    | ユニークなハッシュ         | string(255) | NOT NULL            |      | A!    |
# | name                   | 名前                       | string(255) | NOT NULL            |      |       |
# | cpu_brain_key          | CPUの思考タイプ            | string(255) |                     |      |       |
# | user_agent             | User agent                 | string(255) | NOT NULL            |      |       |
# | race_key               | 種族                       | string(255) | NOT NULL            |      | F     |
# | created_at             | 作成日                     | datetime    | NOT NULL            |      |       |
# | updated_at             | 更新日                     | datetime    | NOT NULL            |      |       |
# | email                  | メールアドレス             | string(255) | NOT NULL            |      | B!    |
# | encrypted_password     | 暗号化パスワード           | string(255) | NOT NULL            |      |       |
# | reset_password_token   | Reset password token       | string(255) |                     |      | C!    |
# | reset_password_sent_at | パスワードリセット送信時刻 | datetime    |                     |      |       |
# | remember_created_at    | ログイン記憶時刻           | datetime    |                     |      |       |
# | sign_in_count          | ログイン回数               | integer(4)  | DEFAULT(0) NOT NULL |      |       |
# | current_sign_in_at     | 現在のログイン時刻         | datetime    |                     |      |       |
# | last_sign_in_at        | 最終ログイン時刻           | datetime    |                     |      |       |
# | current_sign_in_ip     | 現在のログインIPアドレス   | string(255) |                     |      |       |
# | last_sign_in_ip        | 最終ログインIPアドレス     | string(255) |                     |      |       |
# | confirmation_token     | パスワード確認用トークン   | string(255) |                     |      | D!    |
# | confirmed_at           | パスワード確認時刻         | datetime    |                     |      |       |
# | confirmation_sent_at   | パスワード確認送信時刻     | datetime    |                     |      |       |
# | unconfirmed_email      | 未確認Eメール              | string(255) |                     |      |       |
# | failed_attempts        | 失敗したログイン試行回数   | integer(4)  | DEFAULT(0) NOT NULL |      |       |
# | unlock_token           | Unlock token               | string(255) |                     |      | E!    |
# | locked_at              | ロック時刻                 | datetime    |                     |      |       |
# | name_input_at          | Name input at              | datetime    |                     |      |       |
# |------------------------+----------------------------+-------------+---------------------+------+-------|

module Api
  class SwarsController < ::Api::ApplicationController
    concerning :CustomSearchMethods do
      # curl http://localhost:3000/api/swars/custom_search_setup
      def custom_search_setup
        render json: Swars::CustomSearchSetup.new.call
      end
    end

    # concerning :SwarsUserKeyDirectDownloadMethods do
    #   # GET http://localhost:3000/api/swars/download_config_fetch?query=YamadaTaro
    #   def download_config_fetch
    #     render json: main_builder.as_json
    #   end
    #
    #   def main_builder
    #     @main_builder ||= Swars::ZipDl::MainBuilder.new(params.to_unsafe_h.merge({
    #           :current_user => current_user,
    #         }))
    #   end
    # end

    # プレイヤー情報
    concerning :UserStatMethods do
      # http://localhost:3000/api/swars/user_stat?user_key=YamadaTaro&query=%E6%8C%81%E3%81%A1%E6%99%82%E9%96%93:10%E5%88%86
      def user_stat
        render json: Swars::User.find_by!(user_key: params[:user_key]).stat(params.to_unsafe_h.to_options)
      end
    end
  end
end

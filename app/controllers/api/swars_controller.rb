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
    # curl -d _method=post http://0.0.0.0:3000/api/swars/users/devuser1/download_yoyaku
    # http://0.0.0.0:3000/api/swars/users/devuser1/download_yoyaku
    def download_yoyaku
      no = ::Swars::CrawlReservation.madanoyatu.count
      record = current_user.swars_crawl_reservations.create(crawl_reservation_params)
      if record.errors.present?
        error_messages = record.errors.full_messages.join(" ")
        render json: { notice_collector: NoticeCollector.single(:danger, error_messages, method: "dialog") }
        return
      end
      notice_collector = NoticeCollector.single(:success, "予約が完了しました<br>(#{no}人待ち)", title: "予約完了", method: "dialog")
      n = ::Swars::CrawlReservation.madanoyatu.count
      slack_message(key: "棋譜取得の予約(#{n})", body: record.to_t)
      render json: { notice_collector: notice_collector }
    end

    def crawler_run
      before_count = ::Swars::CrawlReservation.madanoyatu.count
      Swars::Crawler::ReservationCrawler.new.run
      after_count = ::Swars::CrawlReservation.madanoyatu.count
      notice_collector = NoticeCollector.single(:success, "取得処理実行完了(#{before_count}→#{after_count})")
      render json: { notice_collector: notice_collector }
    end

    private

    def crawl_reservation_params
      params.permit![:crawl_reservation]
    end
  end
end

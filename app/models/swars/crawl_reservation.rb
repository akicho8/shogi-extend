# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Crawl reservation (swars_crawl_reservations as Swars::CrawlReservation)
#
# |-----------------+-----------------+-------------+-------------+--------------+-------|
# | name            | desc            | type        | opts        | refs         | index |
# |-----------------+-----------------+-------------+-------------+--------------+-------|
# | id              | ID              | integer(8)  | NOT NULL PK |              |       |
# | user_id         | User            | integer(8)  | NOT NULL    | => ::User#id | A     |
# | target_user_key | Target user key | string(255) | NOT NULL    |              |       |
# | to_email        | To email        | string(255) | NOT NULL    |              |       |
# | attachment_mode | Attachment mode | string(255) | NOT NULL    |              | B     |
# | processed_at    | Processed at    | datetime    |             |              |       |
# | created_at      | 作成日時        | datetime    | NOT NULL    |              |       |
# | updated_at      | 更新日時        | datetime    | NOT NULL    |              |       |
# |-----------------+-----------------+-------------+-------------+--------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# User.has_one :profile
#--------------------------------------------------------------------------------

module Swars
  class CrawlReservation < ApplicationRecord
    cattr_accessor(:maximum_reservation_number_of_per_capita) { Rails.env.development? ? 3 : 10 } # 一人当たりの予約件数

    belongs_to :user, class_name: "::User"
    # belongs_to :user, counter_cache: true, touch: :last_reception_at

    scope :madanoyatu, -> { where(processed_at: nil) }

    with_options presence: true do
      validates :attachment_mode
      validates :target_user_key
    end

    # with_options allow_blank: true do
    #   validates :target_user_key, uniqueness: { scope: :user_id, message: "a" }
    # end

    validate :on => :create do
      if errors.empty?
        if maximum_reservation_number_of_per_capita
          if user
            n = user.swars_crawl_reservations.madanoyatu.count
            if n >= maximum_reservation_number_of_per_capita
              errors.add(:base, "#{user.name}さんはもう#{n}件も予約してるので次のは明日以降にしてください")
            end
          end
        end
      end

      if errors.empty?
        if user && target_user_key
          if user.swars_crawl_reservations.madanoyatu.where(target_user_key: target_user.key).exists?
            errors.add(:base, "#{user.name}さんはもう#{target_user_key}さんの棋譜取得を予約しています")
          end
        end
      end
    end

    def zip_binary
      t = Time.current

      zip_buffer = Zip::OutputStream.write_buffer do |zos|
        zip_scope.each do |battle|
          if str = battle.to_cached_kifu(kifu_format_info.key)
            zos.put_next_entry("#{battle.key}.#{kifu_format_info.key}")
            if current_body_encode == :sjis
              str = str.tosjis
            end
            zos.write(str)
          end
        end
      end

      sec = "%.2f s" % (Time.current - t)
      # slack_message(key: "ZIP #{sec}", body: zip_filename)
      SlackAgent.message_send(key: "ZIP #{sec}", body: zip_filename)
      # send_data(zip_buffer.string, type: Mime[params[:format]], filename: zip_filename, disposition: "attachment")
      zip_buffer.string
    end

    def zip_scope
      Swars::Battle.all

      # target_user.battles
      # target_user.battles.order(battled_at: :desc)
    end

    def zip_filename
      parts = []
      parts << "shogiwars"
      parts << target_user.key
      parts << Time.current.strftime("%Y%m%d%H%M%S")
      parts << kifu_format_info.key
      parts << current_body_encode
      parts << zip_scope.count
      str = parts.compact.join("-") + ".zip"
      str.public_send("to#{current_body_encode}")
    end

    def kifu_format_info
      @kifu_format_info ||= Bioshogi::KifuFormatInfo.fetch(zip_kifu_info.key)
    end

    def zip_kifu_info
      ZipKifuInfo.fetch(zip_kifu_key)
    end

    def zip_kifu_key
      "kif"
    end

    def target_user
      @target_user ||= User.find_by!(key: target_user_key)
    end

    def current_body_encode
      "utf8"
    end
  end
end

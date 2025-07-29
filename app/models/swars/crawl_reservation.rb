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
# | attachment_mode | Attachment mode | string(255) | NOT NULL    |              | B     |
# | processed_at    | Processed at    | datetime    |             |              |       |
# | created_at      | 作成日時        | datetime    | NOT NULL    |              |       |
# | updated_at      | 更新日時        | datetime    | NOT NULL    |              |       |
# |-----------------+-----------------+-------------+-------------+--------------+-------|
#
# - Remarks ----------------------------------------------------------------------
# User.has_one :profile
# --------------------------------------------------------------------------------

module Swars
  class CrawlReservation < ApplicationRecord
    # 一人当たりの予約件数
    cattr_accessor(:maximum_reservation_number_of_per_capita) { Rails.env.development? ? 3 : 50 }

    belongs_to :user, class_name: "::User"

    scope :active_only, -> { where(processed_at: nil) } # 未処理のものたち

    after_create_commit :create_notify

    before_validation on: :create do
      self.attachment_mode ||= "with_zip"
    end

    with_options presence: true do
      validates :attachment_mode
      validates :target_user_key
    end

    with_options allow_blank: true do
      validates :attachment_mode, inclusion: ["nothing", "with_zip"]
    end

    validate on: :create do
      if errors.empty?
        if maximum_reservation_number_of_per_capita
          if user
            n = user.swars_crawl_reservations.active_only.count
            if n >= maximum_reservation_number_of_per_capita
              errors.add(:base, "もう#{n}件も予約してるので次のは明日以降にしてください")
            end
          end
        end
      end

      if errors.empty?
        if user && target_user_key
          if user.swars_crawl_reservations.active_only.where(target_user_key: target_user.key).exists?
            errors.add(:base, "すでに #{target_user_key} さんの棋譜取得を予約済みです")
          end
        end
      end
    end

    def crawl!(params = {})
      if processed_at
        raise "すでにクローズ済み"
      end

      other_options = BattleCountDiff.new.call(target_user_key) do
        Importer::CompleteImporter.new(params.merge(user_key: target_user_key)).call
      end

      update!(processed_at: Time.current)

      UserMailer.battle_fetch_notify(self, other_options).deliver_later
    end

    def to_zip
      t = Time.current

      io = Zip::OutputStream.write_buffer do |zos|
        zip_dl_scope.each do |battle|
          if str = battle.to_xxx(kifu_format_info.key)
            body_encodes.each do |encode|
              entry = Zip::Entry.new(zos, "#{target_user.key}/#{encode}/#{battle.key}.#{kifu_format_info.key}")
              entry.time = Zip::DOSTime.from_time(battle.battled_at)
              zos.put_next_entry(entry)
              s = str
              if encode == "Shift_JIS"
                s = s.encode(encode)
              end
              zos.write(s)
            end
          end
        end
      end

      sec = "%.2f s" % (Time.current - t)
      AppLog.info(subject: "ZIP #{sec}", body: zip_filename)

      io
    end

    def zip_dl_scope
      target_user.battles
    end

    def target_user
      @target_user ||= User.find_by!(key: target_user_key)
    end

    def zip_filename
      parts = []
      parts << "shogiwars"
      parts << target_user.key
      parts << zip_dl_scope.count
      parts << Time.current.strftime("%Y%m%d%H%M%S")
      parts << kifu_format_info.key
      # parts << body_encodes
      str = parts.flatten.compact.join("-") + ".zip"
      str
    end

    # rails r "Swars::CrawlReservation.last.create_notify"
    def create_notify
      body = []
      s = user.swars_crawl_reservations
      count = s.where(target_user_key: target_user.key).count
      total = s.count
      subject = []
      subject << "棋譜取得予約"
      subject << user.name
      subject << "全体#{total}回目"
      subject << "個別#{count}回目"
      subject << "対象:#{target_user.key.inspect}"
      if attachment_mode == "with_zip"
        subject << "(要ZIP添付)"
      end
      subject = subject.join(" ")
      AppLog.info(emoji: ":目覚まし時計:", subject: subject, body: attributes.to_t)
    end

    private

    def kifu_format_info
      @kifu_format_info ||= Bioshogi::KifuFormatInfo.fetch(zip_dl_format_info.key)
    end

    def zip_dl_format_info
      ZipDlFormatInfo.fetch(format_key)
    end

    def format_key
      "kif"
    end

    def body_encodes
      ["UTF-8", "Shift_JIS"]
    end
  end
end

class UserMailer < ApplicationMailer
  # 棋譜取得完了
  # UserMailer.battle_fetch_notify(Swars::CrawlReservation.first).deliver_later
  # http://localhost:3000/rails/mailers/user/battle_fetch_notify
  def battle_fetch_notify(record, other_options = {})
    subject = []
    subject << EmojiInfo.fetch(":棋譜ZIP:")
    subject << "[将棋ウォーズ棋譜検索]"
    subject << "#{record.target_user.key}さんの棋譜取得完了"
    subject = subject.join(" ")

    diff_count = other_options[:diff_count] || 0

    body = []
    body << "追加: #{diff_count} 件"
    body << "全体: #{record.zip_dl_scope.count} 件"
    body << ""

    body << "▼#{record.target_user.key}さんの棋譜"
    body << UrlProxy.full_url_for(path: "/swars/search", query: { query: record.target_user_key })
    body << ""

    if record.attachment_mode == "nothing" || Rails.env.development?
      body << "※棋譜を添付するには「ZIPファイルの添付」を有効にしよう"
      body << ""
    end

    body << "--"
    body << "SHOGI-EXTEND"
    body << url_for(:root)

    if Rails.env.development?
      body << record.to_t
      if other_options.present?
        body << other_options.to_t
      end
    end

    body = body.join("\n")
    body = body_normalize(body)

    user = record.user

    if record.attachment_mode == "with_zip"
      attachments[record.zip_filename] = record.to_zip.string
    end

    mail(subject: subject, to: "#{user.name} <#{user.email}>", body: body)
  end
end

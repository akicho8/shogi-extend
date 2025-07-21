# 設計を間違えて通常セッションに QuickScript 系の履歴を詰まりすぎてこれ以上書き込めなくなっているため全削除する
# 本来は別のところに保存しないといけなかった
# いまは DB に保存している

module QuickScript
  class SessionCleaner
    def call(session)
      keys = session.keys.grep(/QuickScript::/)
      if keys.present?
        AppLog.info(subject: "QuickScriptのセッション掃除", body: keys.inspect)
        keys.each do |key|
          session.delete(key)
          Rails.logger.debug("session.delete('#{key}')")
        end
      end
    end
  end
end

class MainBatch
  def call
    AppLog.important(subject: "cronを開始します", body: "OK")
    public_send(Rails.env)
    AppLog.important(subject: "cronは正常に終了しました", body: "OK")
  end

  def production
    # 動画変換
    Tsl::League.setup(verbose: false)
    Kiwi::Lemon.background_job_for_cron   # 動画変換。job時間が 0...0 ならcronで実行する

    # 将棋ウォーズ棋譜検索クロール
    Swars::Crawler::ReservationCrawler.call
    Swars::Crawler::ActiveUserCrawler.call
    Swars::Crawler::MomentumCrawler.call

    # 削除シリーズ
    Kiwi::Lemon.cleanup(execute: true)   # ライブラリ登録していないものを削除する(x-files以下の対応ファイルも削除する)
    XfilesCleanup.new(execute: true).call # public/system/x-files 以下の古い png と rb を削除する
    FreeBattle.cleanup(execute: true)
    MediaBuilder.old_media_file_clean(execute: true, keep: 3)

    # GeneralCleaner シリーズ
    Swars::Battle.drop_scope1.cleaner(subject: "一般", execute: true).call  # 30分かかる
    Swars::Battle.drop_scope2.cleaner(subject: "特別", execute: true).call
    Swars::SearchLog.old_only(100.days).cleaner(subject: "棋譜検索ログ", execute: true).call
    GoogleApi::ExpirationTracker.old_only(50.days).cleaner(subject: "スプレッドシート", execute: true).call
    AppLog.old_only(2.weeks).cleaner(subject: "アプリログ", execute: true).call

    # 集計
    QuickScript::Swars::GradeStatScript.primary_aggregate_run
    QuickScript::Swars::TacticStatScript.primary_aggregate_run

    # チェック
    Swars::SystemValidator.new.call
  end

  def staging
    Swars::Crawler::ReservationCrawler.call
  end
end

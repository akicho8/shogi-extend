class MainBatch
  def call
    AppLog.important(subject: "バッチ処理 開始")
    public_send(Rails.env)
    AppLog.important(subject: "バッチ処理 終了")
  end

  def production
    # 奨励会三段リーグ
    Ppl::League.setup(verbose: false)

    # 動画変換
    Kiwi::Lemon.background_job_for_cron   # 動画変換。job時間が 0...0 ならcronで実行する

    # 将棋ウォーズ棋譜検索クロール
    if Rails.env.production?
      Swars::Crawler::ReserveUserCrawler.call    # 棋譜取得の予約者
      Swars::Crawler::MainActiveUserCrawler.call # 活動的なプレイヤー
      # Swars::Crawler::SemiActiveUserCrawler.call # 直近数日で注目されているユーザー
    end

    # 削除シリーズ
    Kiwi::Lemon.cleaner(execute: true).call   # ライブラリ登録していないものを削除する(x-files以下の対応ファイルも削除する)
    XfileCleaner.call(execute: true)          # public/system/x-files 以下の古い png と rb を削除する
    MediaBuilder.old_media_file_clean(keep: 3, execute: true)

    # GeneralCleaner シリーズ
    FreeBattle.destroyable.old_only(30.days).cleaner(subject: "FreeBattle", execute: true).call
    Swars::Battle.destroyable_n.cleaner(subject: "一般", execute: true).call  # 30分かかる
    Swars::Battle.destroyable_s.cleaner(subject: "特別", execute: true).call
    Swars::SearchLog.old_only(100.days).cleaner(subject: "棋譜検索ログ", execute: true).call
    GoogleApi::ExpirationTracker.old_only(50.days).cleaner(subject: "スプレッドシート", execute: true).call
    AppLog.old_only(1.weeks).cleaner(subject: "アプリログ", execute: true).call
    ShareBoard::ChatMessage.old_only(30.days).cleaner(subject: "共有将棋盤チャット発言", execute: true).call

    # 集計 (自動的に cache_write があるクラスを集めるのも考えたがそれはやりすぎなので絶対やるなよ)
    QuickScript::Swars::RuleWiseWinRateScript.new.cache_write  # 統計
    QuickScript::Swars::SprintWinRateScript.new.cache_write    # 棋力毎のスプリント先後勝率

    QuickScript::Swars::UserDistScript.new.cache_write         # 棋力分布
    QuickScript::Swars::HourlyActiveUserScript.new.cache_write # 時間帯別対局者情報
    QuickScript::Swars::TacticStatScript.new.cache_write       # 戦法一覧・戦法勝率ランキング
    QuickScript::Swars::GradeSegmentScript.new.cache_write     # 棋力別の情報
    QuickScript::Swars::TacticCrossScript.new.cache_write      # 将棋ウォーズ戦法人気ランキング (棋力別)

    # BattleIdMining 系
    QuickScript::Swars::TacticBattleMiningScript.new.cache_write # 戦法
    QuickScript::Swars::GradeBattleMiningScript.new.cache_write  # 棋力
    QuickScript::Swars::PresetBattleMiningScript.new.cache_write # 手合
    QuickScript::Swars::StyleBattleMiningScript.new.cache_write  # スタイル

    # 検証
    Swars::SystemValidator.new.call
  end

  def staging
    production
  end
end

class QuickScript::Swars::BattleDownloadScript
  class Summary
    attr_reader :base

    def initialize(base)
      @base = base
    end

    def info
      {
        "ログインユーザー名"               => base.current_user.name,
        "検索クエリ(ウォーズIDを含む)"     => base.query,
        # "クエリから抽出した対象ウォーズID" => base.swars_user.try { key },
        # "対局総数"                         => base.swars_user.try { battles.count },
        "指定したスコープ"                 => base.scope_info.name,
        "指定した件数"                     => base.max_info.key,
        "実際に取得した件数"               => base.main_scope.size,
        "文字コード"                       => base.encode_info.key,
        "ファイル名"                       => base.download_filename,
        "処理時間"                         => base.processed_second.try { "%.2fs" % self },
        "今回を除くダウンロード総数"       => base.swars_zip_dl_logs.count,
      }
    end
  end
end

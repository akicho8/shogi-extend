class QuickScript::Swars::BattleDownloadScript
  class Summary
    def initialize(base)
      @base = base
    end

    def info
      {
        "ユーザー" => @base.current_user.name,
        "件数"     => @base.main_scope.size,
        "対象"     => @base.swars_user.key,
        "スコープ" => @base.scope_info.name,
        "ファイル" => @base.download_filename,
        "処理時間" => @base.processed_sec.try { "%.2fs" % self },
      }
    end
  end
end

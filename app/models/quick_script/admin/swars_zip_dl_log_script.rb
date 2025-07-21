# http://localhost:4000/lab/admin/app-log-search2

module QuickScript
  module Admin
    class SwarsZipDlLogScript < Base
      self.title = "将棋ウォーズ棋譜ダウンロード履歴"
      self.description = "将棋ウォーズの棋譜をダウンロードした人を表示する"
      self.title_link = :force_reload

      def call
        pagination_for(::Swars::ZipDlLog.order(created_at: :desc), always_table: true) do |scope|
          scope.collect do |record|
            {
              "ID"       => record.id,
              "取得者"   => "#{record.user.name}(#{record.user.swars_zip_dl_logs.count})",
              "クエリ"   => record.query,
              "DL件数"   => record.dl_count,
              "begin_at" => record.begin_at.to_fs(:ymdhm),
              "end_at"   => record.end_at.to_fs(:ymdhm),
              "実行日時" => record.created_at.to_fs(:ymdhms),
            }
          end
        end
      end
    end
  end
end

module BackendScript
  class SwarsZipDlLogScript < ::BackendScript::Base
    include SortMethods

    self.category = "swars"
    self.script_name = "将棋ウォーズ棋譜検索 ダウンロード"

    def script_body
      s = Swars::ZipDlLog.all
      s = sort_scope(s)
      s = page_scope(s)
      rows = s.collect(&method(:row_build))
      out = "".html_safe
      out << rows.to_html
      out << basic_paginate(s)
    end

    def row_build(record)
      {
        "ID"       => record.id,
        "取得者"   => user_link_to("#{record.user.name}(#{record.user.swars_zip_dl_logs.count})", record.user),
        "対象棋譜" => record.swars_user.user_key,
        "クエリ"   => record.query,
        "個数"     => record.dl_count,
        "個数"     => record.dl_count,
        "範囲"     => record.begin_at.to_s(:ymdhm),
        "...範囲"  => record.end_at.to_s(:ymdhm),
        "DL日時"   => record.created_at.to_s(:ymdhms),
      }
    end
  end
end

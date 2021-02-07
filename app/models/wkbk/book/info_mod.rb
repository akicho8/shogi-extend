module Wkbk
  class Book
    concern :InfoMod do
      def info
        a = {}
        a["ID"]       = id
        a["タイトル"] = title
        a["投稿者"]   = user.name
        a["詳細URL"]  = page_url
        a["フォルダ"] = folder.name
        a["出題順序"] = sequence.pure_info.name
        a["作成日時"] = created_at.to_s(:ymdhm)
        a["備考"]     = description.presence.to_s.squish
        a
      end
    end
  end
end

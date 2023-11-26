module BackendScript
  class SwarsUserSearchScript < ::BackendScript::Base
    include SwarsUserSearchMethods

    self.category = "swars"
    self.script_name = "棋譜検索 ユーザー 検索"

    def script_body
      s = Swars::User.search(swars_user_search_query)
      s = s.order(:created_at, :id)
      s = page_scope(s)
      rows = s.collect(&:to_h)
      out = "".html_safe
      out << rows.to_html
      out << basic_paginate(s)
    end
  end
end

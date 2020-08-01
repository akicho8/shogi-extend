module BackendScript
  class UserSearchScript < ::BackendScript::Base
    include SortMod

    self.category = "その他"
    self.script_name = "ユーザー検索"

    def form_parts
      [
        {
          :label   => "IDs",
          :key     => :user_ids,
          :type    => :string,
          :default => current_user_ids,
        },
        {
          :label   => "名前",
          :key     => :query,
          :type    => :string,
          :default => current_query,
        },
      ]
    end

    def script_body
      s = User.all
      if v = current_user_ids
        s = s.where(id: v)
      end
      if v = current_query
        s = s.where(["name like ?", "%#{v}%"])
      end
      s = sort_scope(s)
      s = page_scope(s)
      rows = s.collect(&method(:row_build))

      out = "".html_safe
      out << rows.to_html
      out << basic_paginate(s)
    end

    def row_build(user)
      row = user.info_hash
      row.merge("操作" => [
          h.link_to("ミュート", UserMuteScript.script_link_path(target_user_ids: user.id)),
          h.link_to("削除", UserDestroyScript.script_link_path(target_user_ids: user.id)),
        ].join(" ").html_safe)
    end

    def current_query
      params[:query].to_s.strip.presence
    end

    def current_user_ids
      params[:user_ids].to_s.scan(/\d+/).collect(&:to_i).uniq.presence
    end
  end
end

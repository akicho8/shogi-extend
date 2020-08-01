module BackendScript
  class UserTagShowScript < ::BackendScript::Base
    self.category = "その他"
    self.script_name = "ユーザータグ確認"

    def script_body
      tags = User.tag_counts_on(:permit_tags, order: "count")
      names = tags.collect(&:name)
      users = User.tagged_with(names, any: true, on: :permit_tags)
      users.collect do |user|
        {
          "ID"   => user_link_to(user.id, user),
          "名前" => user.name,
          "タグ" => user.permit_tag_list.join(" "),
        }
      end
    end
  end
end

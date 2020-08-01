module BackendScript
  class UserTagEditScript < ::BackendScript::Base
    include AtomicScript::PostRedirectMod
    include TargeUserMethods

    self.category = "その他"
    self.script_name = "ユーザータグ編集"

    def form_parts
      super + [
        {
          :label   => "追加タグ",
          :key     => :add_tags,
          :type    => :check_box,
          :elems   => templete_tag_elems,
          :default => params[:add_tags].presence,
        },
        {
          :label   => "削除タグ",
          :key     => :sub_tags,
          :type    => :check_box,
          :elems   => templete_tag_elems,
          :default => params[:sub_tags].presence,
        },
      ]
    end

    def script_body
      current_target_users.collect do |user|
        user.permit_tag_list += current_add_tags
        user.permit_tag_list -= current_sub_tags
        user.save!

        {
          "ID"   => user_id_link(user),
          "名前" => user.name,
          "タグ" => user.permit_tag_list.join(" "),
        }
      end
    end

    def current_add_tags
      Array(params[:add_tags])
    end

    def current_sub_tags
      Array(params[:sub_tags])
    end

    def templete_tag_elems
      {
        "管理スタッフ"         => :staff,
        "ロビーチャット非表示" => :lobby_message_hidden,
        "問題新規作成禁止"     => :question_new_hidden,
      }
    end
  end
end

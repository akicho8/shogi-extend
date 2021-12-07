module UserChoreMethods
  extend ActiveSupport::Concern

  class_methods do
    def ghost_destroy_all
      ids = TimeRecord.all.pluck("user_id").uniq
      s = User.all
      s = s.where.not(id: ids)
      s = s.where(["email like ?", "%@localhost%"])
      s = s.where("sign_in_count <= 1")
      s = s.where(["name like ?", "%名無し%"])
      s = s.limit(100)
      Actb.count_diff do
        s.each do |r|
          if r.actb_histories.count == 0 && r.actb_questions.count == 0
            r.destroy!
          end
        end
      end
    end
  end

  def show_path
    Rails.application.routes.url_helpers.url_for([self, only_path: true])
  end

  # ユーザー詳細
  def as_json_simple_public_profile
    as_json({
        only: [
          :id,
          :key,
          :name,
          :permit_tag_list,
        ],
        methods: [
          :avatar_path,
          :description,
          :twitter_key,
          :email_valid?,        # for nuxt_login_required
        ],
      })
  end

  # rails r 'User.sysop.change_notify'
  def change_notify
    if saved_changes? || profile.saved_changes?
      change_notify_force
    end
  end

  # rails r 'User.sysop.change_notify_force'
  def change_notify_force
    body = [
      self,
      profile,
    ].collect { |e|
      e.saved_changes.collect { |attr, (before, after)|
        {
          "属性"   => attr,
          "変更前" => before,
          "変更後" => after,
        }
      }.to_t
    }.join
    body = info.to_t + body

    SystemMailer.notify(fixed: true, subject: "【プロフィール変更】#{name}", body: body).deliver_later
  end

  def info
    {
      "ID"                => id,
      "名前"              => name,
      "名前確定日時"      => name_input_at&.to_s(:distance),
      "メールアドレス"    => email,
      "プロバイダ"        => auth_infos.collect(&:provider).join(", "),
      "Twitter URL"       => twitter_url,
      "ログイン回数"      => sign_in_count,
      "最終ログイン日時"  => current_sign_in_at&.to_s(:distance),
      "登録日時"          => created_at&.to_s(:distance),
      "IP"                => current_sign_in_ip,
      "タグ"              => permit_tag_list,
      "自己紹介"          => description.truncate(64),
    }
  end
end

class User
  module ChoreMethods
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
        s.each do |r|
          r.destroy!
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

    # rails r 'User.admin.change_notify'
    def change_notify
      if saved_changes? || profile.saved_changes?
        change_notify_force
      end
    end

    # rails r 'User.admin.change_notify_force'
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

      AppLog.important(subject: "【プロフィール変更】#{name}", body: body)
    end
  end
end

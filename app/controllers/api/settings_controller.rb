module Api
  class SettingsController < ::Api::ApplicationController
    before_action :api_login_required

    # curl -d _method=put http://localhost:3000/api/settings/profile_update.json
    def profile_update
      user = current_user

      if v = params[:croped_image]
        bin = ApplicationRecord.data_uri_scheme_to_bin(v)
        io = StringIO.new(bin)
        user.avatar.attach(io: io, filename: "avatar.png")
        # user.avatar_blob.saved_changes? # => true
      end

      user.name = params[:name]
      user.name_input_at ||= Time.current
      user.profile.description = params[:profile_description]
      user.profile.twitter_key = params[:profile_twitter_key]
      user_save(user)
      return if performed?

      if user.saved_change_to_attribute?(:name_input_at)
        if v = user.saved_change_to_attribute(:name)
          pair = v.join("→")
          SystemMailer.notify(fixed: true, subject: "【名前確定】#{pair}", body: user.info.to_t).deliver_later
        end
      end

      # 変更したかもしれないレコードたち
      changed_records = [
        user,
        user.profile,
        user.avatar_blob, # ← 上で user.save! しちゃったせいで saved_changes? は常に false になっとるっぽい
      ]

      saved_changes_p = changed_records.any?(&:saved_changes?) || params[:croped_image]
      if saved_changes_p
        xnotice = Xnotice.add("変更しました", type: "is-success")
      else
        xnotice = Xnotice.add("変更はありませんでした", type: "is-info")
      end
      render json: { xnotice: xnotice }
    end

    # curl -d _method=put http://localhost:3000/api/settings/email_fetch.json
    def email_fetch
      render json: { email: current_user.email }
    end

    def email_update
      user = current_user

      if user.email == params[:email]
        render json: { xnotice: Xnotice.add("変更はありませんでした", type: "is-info") }
        return
      end

      # 確認なしで設定
      # user.email_invalid?
      if AppConfig[:email_direct_set]
        user.email = params[:email]
        user.skip_reconfirmation! # メールを飛ばさずに既存ユーザーのメールアドレスを変更する
        user_save(user)
        return if performed?
        render json: { xnotice: Xnotice.add("メールアドレスを更新しました", type: "is-success") }
        return
      end

      # 以前のメールアドレスが生きていて新しいメールアドレスを設定
      user.email = params[:email]
      user_save(user)
      return if performed?
      render json: { xnotice: Xnotice.add("新しいメールアドレスにメールを送信しました。本文の「アカウントの確認」リンクを踏んでメールアドレスの変更を確定させてください", type: "is-success", method: :dialog, title: "もう少し") }
    end

    # curl -d _method=put http://localhost:3000/api/settings/swars_user_key_fetch.json
    def swars_user_key_fetch
      render json: { swars_user_key: current_user.key }
    end

    def swars_user_key_update
      xnotice = Xnotice.add("変更しました(嘘)", type: "is-success")
      render json: { xnotice: xnotice }
    end

    private

    def user_save(user)
      unless user.save
        error_messages = user.errors.full_messages.join(" ")
        render json: { xnotice: Xnotice.add(error_messages, type: "is-danger", method: :dialog) }
      end
    end

    # def required_return_value
    #   (params[:required_return_value].presence || "simple_profile").to_sym
    # end
  end
end

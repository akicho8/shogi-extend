module Api
  class SettingsController < ::Api::ApplicationController
    before_action :api_login_required

    DIRECCT_EMAIL_SET = true

    # curl -d _method=put http://localhost:3000/api/settings/profile_update.json
    def profile_update
      user = current_user

      if v = params[:croped_image]
        bin = data_uri_scheme_to_bin(v)
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
          ApplicationMailer.developer_notice(subject: "【名前確定】#{pair}", body: user.info.to_t).deliver_later
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
        notice_collector = NoticeCollector.single(:success, "変更しました")
      else
        notice_collector = NoticeCollector.single(:info, "変更はありませんでした")
      end
      render json: { notice_collector: notice_collector }
    end

    # curl -d _method=put http://localhost:3000/api/settings/email_fetch.json
    def email_fetch
      render json: { email: current_user.email }
    end

    def email_update
      user = current_user

      if user.email == params[:email]
        notice_collector = NoticeCollector.single(:info, "変更はありませんでした")
        render json: { notice_collector: notice_collector }
        return
      end

      # メールアドレス未設定なら即設定
      if user.email_invalid? || DIRECCT_EMAIL_SET
        user.email = params[:email]
        user.skip_reconfirmation!
        user_save(user)
        return if performed?
        notice_collector = NoticeCollector.single(:success, "メールアドレスを更新しました")
        render json: { notice_collector: notice_collector }
        return
      end

      # 以前のメールアドレスが生きていて新しいメールアドレスを設定
      user.email = params[:email]
      user_save(user)
      return if performed?
      notice_collector = NoticeCollector.single(:success, "メールを送信したので変更を確定させてください", method: "dialog")
      render json: { notice_collector: notice_collector }
    end

    # curl -d _method=put http://localhost:3000/api/settings/swars_user_key_fetch.json
    def swars_user_key_fetch
      render json: { swars_user_key: current_user.key }
    end

    def swars_user_key_update
      notice_collector = NoticeCollector.single(:success, "変更しました(嘘)")
      render json: { notice_collector: notice_collector }
    end

    private

    def user_save(user)
      unless user.save
        error_messages = user.errors.full_messages.join(" ")
        render json: { notice_collector: NoticeCollector.single(:danger, error_messages, method: "dialog") }
      end
    end

    # def required_return_value
    #   (params[:required_return_value].presence || "simple_profile").to_sym
    # end
  end
end

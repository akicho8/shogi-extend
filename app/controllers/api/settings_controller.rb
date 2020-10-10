module Api
  class SettingsController < ::Api::ApplicationController
    # curl -d _method=put http://localhost:3000/api/settings/profile_update.json
    def profile_update
      raise "must not happen" unless current_user

      user = current_user

      if v = params[:croped_image]
        bin = data_base64_body_to_binary(v)
        io = StringIO.new(bin)
        user.avatar.attach(io: io, filename: "avatar.png")
        # user.avatar_blob.saved_changes? # => true
      end

      user.name = params[:name]
      user.name_input_at ||= Time.current
      user.profile.description = params[:profile_description]
      user.profile.twitter_key = params[:profile_twitter_key]
      if user.invalid?
        error_messages = user.errors.full_messages.join(" ")
        render json: {
          notice_collector: NoticeCollector.single(:danger, error_messages, method: "dialog"),
        }
        return
      end
      user.save!

      if user.saved_change_to_attribute?(:name_input_at)
        if v = user.saved_change_to_attribute(:name)
          pair = v.join("→")
          ApplicationMailer.developper_notice(subject: "【名前確定】#{pair}", body: user.info.to_t).deliver_later
        end
      end

      # 変更したかもしれないレコードたち
      changed_records = [
        user,
        user.profile,
        user.avatar_blob, # ← 上で user.save! しちゃったせいで saved_changes? は常に false になっとるっぽい
      ]

      if changed_records.any?(:saved_changes?) || params[:croped_image]
        notice_collector = NoticeCollector.single(:success, "保存しました")
      else
        notice_collector = NoticeCollector.single(:info, "変更はありませんでした")
      end

      render json: { notice_collector: notice_collector }
    end

    private

    # def required_return_value
    #   (params[:required_return_value].presence || "simple_profile").to_sym
    # end

    def data_base64_body_to_binary(data_base64_body)
      md = data_base64_body.match(/\A(data):(?<content_type>.*?);base64,(?<base64_bin>.*)/)
      md or raise ArgumentError, "Data URL scheme 形式になっていません : #{data_base64_body.inspect.truncate(80)}"
      Base64.decode64(md["base64_bin"])
    end
  end
end

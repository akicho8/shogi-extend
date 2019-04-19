class UserMailer < ApplicationMailer
  # UserMailer.user_created.deliver_now
  def user_created(user)
    mail(subject: "#{subject_prefix}#{user.name}さんが登録されました", body: user.attributes.to_t)
  end
end

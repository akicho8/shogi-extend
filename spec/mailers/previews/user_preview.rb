# http://0.0.0.0:3000/rails/mailers/user

class UserPreview < ActionMailer::Preview
  def user_created
    if false
    # 次のようにして user を作ると初回は成功する
    #
    #   user = FactoryBot.create(:colosseum_user)
    #
    # しかし、コードを変更して再読み込みすると次のエラーになる
    #
    #   ArgumentError in Rails::MailersController#preview
    #   A copy of Colosseum::Chronicle has been removed from the module tree but is still active!
    #
    # このアプリ以外でも同様のことがおきる
    else
      user = Colosseum::User.create!
    end

    UserMailer.user_created(user)
  end
end

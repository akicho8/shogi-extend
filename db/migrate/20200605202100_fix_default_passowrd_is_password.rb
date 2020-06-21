class FixDefaultPassowrdIsPassword < ActiveRecord::Migration[5.2]
  def change
    User.reset_column_information

    User.all.each do |user|
      if user.valid_password?("password")
        user.password = Devise.friendly_token(32)
        user.save! if Rails.env.production?
        p user.name
      end
    end
    User.all.each do |user|
      if user.valid_password?("password")
        raise if Rails.env.production?
      end
    end
    if user = User.find_by(key: :sysop)
      if user.valid_password?("password")
        user.update!(password: Rails.application.credentials.sysop_password)
      end
    end
  end
end

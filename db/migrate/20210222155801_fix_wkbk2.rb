class FixWkbk2 < ActiveRecord::Migration[6.0]
  def change
    if Rails.env.production? || Rails.env.staging?
      key = "932ed39bb18095a2fc73e0002f94ecf1"
      user = User.find_by!(key: key)
      Wkbk::KifuDataImport.new(user: user).run
    end
  end
end

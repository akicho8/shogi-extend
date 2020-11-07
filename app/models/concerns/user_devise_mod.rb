module UserDeviseMod
  extend ActiveSupport::Concern

  included do
    has_many :auth_infos, dependent: :destroy
    accepts_nested_attributes_for :auth_infos

    devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :confirmable
    devise :omniauthable, omniauth_providers: [:google, :twitter, :github]
  end

  def provider_names
    auth_infos.collect(&:provider)
  end

  def email_valid?
    if Rails.env.test?
      return true
    end

    !email_invalid?
  end

  def email_invalid?
    email.blank?
  end
end

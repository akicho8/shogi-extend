# class CreateUrlHandlings < ActiveRecord::Migration[5.1]
#   def up
#     create_table :url_handlings, force: true do |t|
#       t.string :key,            null: false, index: { unique: true }
#       t.string :original_url,   null: false, index: { unique: true }
#       t.timestamps              null: false
#     end
#   end
# end

class UrlHandling < ApplicationRecord
  class << self
    def fetch(params)
      if params[:key].present?
        find_by!(key: params[:key])
      else
        url = params[:original_url]
        key = Digest::MD5.hexdigest(url)
        find_by(key: key) || create!(key: key, original_url: url)
      end
    end

    def action(c)
      record = fetch(c.params)
      if c.request.format.html?
        c.redirect_to record.original_url
      else
        c.render json: record
      end
    end
  end

  before_validation do
    self.key ||= Digest::MD5.hexdigest(original_url)
  end

  with_options presence: true do
    validates :key
    validates :original_url
  end

  with_options allow_blank: true do |o|
    validates :key, uniqueness: true
  end

  after_create do
    AppLog.info(subject: "短縮URL", body: attributes.to_t, mail_notify: true)
  end

  def short_url
    Rails.application.routes.url_helpers.url_for(:root) + "url/#{key}"
  end
end

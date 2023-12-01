# http://localhost:3000/rails/mailers/application

class SystemPreview < ActionMailer::Preview
  def notify
    SystemMailer.notify(body: ENV.to_h, table_format: true)
  end
end

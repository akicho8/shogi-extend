# http://0.0.0.0:3000/rails/mailers/application

class ApplicationPreview < ActionMailer::Preview
  def fixed_track
    SystemMailer.fixed_track(body: ENV.to_h.to_t)
  end
  def simple_track
    SystemMailer.simple_track(body: ENV.to_h.to_t)
  end
end

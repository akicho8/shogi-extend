# http://localhost:3000/rails/mailers/kifu

class KifuPreview < ActionMailer::Preview
  # http://localhost:3000/rails/mailers/kifu/basic_mail
  def basic_mail
    KifuMailer.basic_mail(KifuMailAdapter.mock_params)
  end
end

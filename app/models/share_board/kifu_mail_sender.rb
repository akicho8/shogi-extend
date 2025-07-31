module ShareBoard
  class KifuMailSender
    attr_reader :params

    def initialize(params)
      @params = params
    end

    def call
      mail = KifuMailer.basic_mail(params) # deliver_later する前に mail にアクセスしてはいけないため別々に生成している
      AppLog.info(subject: "[棋譜メール] #{mail.subject} #{mail.to}", body: mail.text_part.decoded)

      KifuMailer.basic_mail(params).deliver_later
      { message: "#{params[:user].email} 宛に送信しました" }
    end
  end
end

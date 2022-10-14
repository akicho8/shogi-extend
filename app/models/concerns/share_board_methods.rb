module ShareBoardMethods
  extend ActiveSupport::Concern

  class_methods do
    def same_body_fetch(params)
      body = nil
      if v = params[:xbody].presence
        body ||= Base64.urlsafe_decode64(v)
      else
        body ||= params[:body].presence
        body ||= "position #{Bioshogi::Sfen::STARTPOS_EXPANSION}"
        body = DotSfen.unescape(body)
      end
      sfen_hash = Digest::MD5.hexdigest(body)
      record = find_by(sfen_hash: sfen_hash, use_key: :share_board)
      record ||= create!(kifu_body: body, use_key: :share_board)
    end
  end
end

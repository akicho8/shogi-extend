module ShareBoardMethods
  extend ActiveSupport::Concern

  class_methods do
    def same_body_fetch(params)
      body = params[:body].presence || "position #{Bioshogi::Sfen::STARTPOS_EXPANSION}"
      end
      body = DotSfen.unescape(body)
      sfen_hash = Digest::MD5.hexdigest(body)
      record = find_by(sfen_hash: sfen_hash, use_key: :share_board)
      record ||= create!(kifu_body: body, use_key: :share_board)
    end
  end
end

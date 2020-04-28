module ShareBoardMod
  extend ActiveSupport::Concern

  class_methods do
    def same_body_fetch(params)
      body = params[:body] || "position startpos"
      body = body.sub(Bioshogi::Sfen::STARTPOS_EXPANSION, "startpos")
      sfen_hash = Digest::MD5.hexdigest(body)
      find_by(sfen_hash: sfen_hash, use_key: :share_board) || create!(kifu_body: body, use_key: :share_board, saturn_key: :private)
    end
  end
end

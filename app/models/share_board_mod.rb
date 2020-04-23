module ShareBoardMod
  extend ActiveSupport::Concern

  class_methods do
    def same_body_fetch(params)
      body = params[:body] || "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1"
      sfen_hash = Digest::MD5.hexdigest(body)
      find_by(sfen_hash: sfen_hash, use_key: :share_board) || create!(kifu_body: body, use_key: :share_board)
    end
  end
end

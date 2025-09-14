module ShareBoardMethods
  extend ActiveSupport::Concern

  class_methods do
    def same_body_fetch(params)
      body = nil
      if v = params[:xbody].presence
        body ||= SafeSfen.decode(v)
      else
        body ||= params[:body].presence
        body ||= "position #{Bioshogi::Sfen::STARTPOS_EXPANSION}"
        body = DotSfen.unescape(body) # sfen 以外が来るのも想定しておく
        body = Bioshogi::Sfen.startpos_remove(body) # startpos を取る
      end

      # 例えば "68S" だったりすると SFEN ではないので sfen_hash とは一致しない
      # body が綺麗な SFEN だったときだけキャッシュの効果がある

      sfen_hash = Digest::MD5.hexdigest(body)
      record = find_by(sfen_hash: sfen_hash, use_key: :share_board)
      record ||= create!(kifu_body: body, use_key: :share_board)
    end
  end
end

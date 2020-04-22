class RelayBoardsController < ApplicationController
  include EncodeMod

  helper_method :relay_board_options

  let :relay_board_options do
    {
      post_path: url_for([controller_name.singularize, format: "json"]),
    }
  end

  def show
    if request.format.png?
      sfen_hash = Digest::MD5.hexdigest(params[:position])
      record = FreeBattle.find_by(sfen_hash: sfen_hash, use_key: :relay2)
      unless record
        raise
        record = FreeBattle.create!(kifu_body: params[:position], use_key: :relay2)
      end

      turn = record.turn_max
      png = record.to_dynamic_png(params.merge(turn: turn))
      turn = record.adjust_turn(turn)
      send_data png, type: Mime[:png], disposition: current_disposition, filename: "#{record.to_param}-#{turn}.png"
      return
    end
  end

  def create
  end
end

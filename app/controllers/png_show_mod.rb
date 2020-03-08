#
# 注意点
#
# 1. iPhone でダウンロードとしたときだけ文字化けする対策をしてはいけない
#
#   if mobile_agent?
#     text_body = text_body.tosjis
#   end
#   とすれば文字化けしなくなるが、ぴよ将棋で読めなくなる
#
# 2. 激指ではクリップボードは UTF8 でないと読めないのでこれを入れてはいけない
#
#   if filename_sjis?
#     text_body = text_body.tosjis
#   end
#
module PngShowMod
  extend ActiveSupport::Concern

  private

  # http://localhost:3000/x?description=&modal_id=8452d6171728a6ca1a2fbfbbc3aea23d&title=&turn=1
  # http://localhost:3000/x/8452d6171728a6ca1a2fbfbbc3aea23d.png?turn=1
  def png_file_send

    disposition = params[:disposition] || :inline

    # 手数の指定があればリアルタイムに作成
    if turn = current_force_turn
      turn = current_record.adjust_turn(turn)
      options = current_record.param_as_to_png_options(params.to_unsafe_h)
      cache_key_source = [current_record.sfen_body, options]
      if Rails.env.development?
        Rails.logger.debug ["#{__FILE__}:#{__LINE__}", __method__, cache_key_source]
      end
      hex = Digest::MD5.hexdigest(cache_key_source.to_s)
      cache_key = [current_record.to_param, "png", turn, hex].join(":")
      png = Rails.cache.fetch(cache_key, expires_in: 1.week) do
        parser = Bioshogi::Parser.parse(current_record.existing_sfen, bioshogi_parser_options.merge(turn_limit: turn))
        parser.to_png(options)
      end
      send_data png, type: Mime[:png], disposition: disposition, filename: "#{current_record.to_param}-#{turn}.png"
      return
    end

    # 画像がなければ1回だけ作る
    current_record.image_auto_cerate_onece(params.to_unsafe_h)
    if AppConfig[:force_convert_for_twitter_image]
      key = current_record.tweet_image.processed.key
    else
      key = current_record.thumbnail_image.key
    end
    path = ActiveStorage::Blob.service.path_for(key)
    send_file path, type: current_record.thumbnail_image.content_type, disposition: disposition, filename: "#{current_record.to_param}.png"
  end

  # PNGを最速で生成するため戦術チェックなどスキップできるものはぜんぶスキップする
  def bioshogi_parser_options
    {
      # :skill_monitor_enable           => false,
      # :skill_monitor_technique_enable => false,
      :typical_error_case => :embed, # validate_skip しているのでこのオプションは使わない？
      :candidate_skip     => true,
      :validate_skip      => true,
      :mediator_class     => Bioshogi::MediatorFast,
    }
  end
end

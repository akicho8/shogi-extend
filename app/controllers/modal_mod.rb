module ModalMod
  extend ActiveSupport::Concern

  included do
    helper_method :modal_record
    helper_method :record_to_twitter_options
  end

  # TODO: モデルに移動させる
  def record_to_twitter_options(e)
    if e
      options = {}

      v = current_force_turn || e.og_turn

      # 99手までのとき -1 を指定すると99手目にする
      if v.negative?
        v = e.turn_max + v + 1
      end

      # 99手までのとい 100 を指定すると99手目にする
      v = v.clamp(0, e.turn_max)

      options[:title] = params[:title].presence || "#{e.title}【#{v}手目】"

      if v = current_force_turn
        options[:url] = e.modal_on_index_url(turn: v)
      else
        options[:url] = e.modal_on_index_url
      end

      if v = current_force_turn
        options[:image] = twitter_card_image_url(e, turn: v)
      else
        options[:image] = twitter_card_image_url(e)
      end

      options[:description] = params[:description].presence || e.description

      options
    end
  end

  let :js_modal_record do
    if modal_record
      js_modal_record_for(modal_record)
    end
  end

  let :modal_record do
    if v = params[:modal_id]
      # record = current_scope.find_by(key: v) || current_scope.find_by(id: v)

      s = current_model

      record = s.find_by(key: v) # スコープを無視すること

      # 元々公開しているものは id にアクセスできる
      unless record
        record = s.where(saturn_key: :public).find_by(id: v)
      end

      if record
        access_log_create(record)
      end

      record
    end
  end

  def js_modal_record_for(e)
    js_record_for(e).tap do |a|
      a[:sfen_body] ||= e.existing_sfen
      if v = current_force_turn
        a[:force_turn] = v
      end
    end
  end
end

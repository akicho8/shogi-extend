module ModalMod
  extend ActiveSupport::Concern

  included do
    helper_method :modal_record
    # helper_method :to_twitter_card_params
  end

  # def to_twitter_card_params(record)
  #   if record
  #     record.to_twitter_card_params(self)
  #   end
  # end

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

      if current_model.columns_hash["saturn_key"]
        # 元々公開しているものは id にアクセスできる
        unless record
          record = s.where(saturn_key: :public).find_by(id: v)
        end
      end

      if record
        access_log_create(record)
      end

      record
    end
  end

  def js_modal_record_for(e)
    js_record_for(e).tap do |a|
      a[:sfen_body] ||= e.sfen_body_or_create

      # 明示的に turn が指定されているときのみ設定
      # turn は sp_show.vue で拾う
      if v = current_turn
        a[:turn] = e.adjust_turn(v)
      end

      if !current_flip.nil?
        a[:flip] = current_flip
      end
    end
  end
end

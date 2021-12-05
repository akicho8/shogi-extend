module Api
  class AdaptersController < ::Api::ApplicationController
    # curl -d _method=post http://localhost:3000/api/adapter/record_create.json
    def record_create
      begin
        record = FreeBattle.create!(kifu_body: params[:input_text], use_key: "adapter")
        attrs = record.as_json({
            methods: [
              :all_kifs,
              :display_turn,
              :piyo_shogi_base_params,
            ],
          })
      rescue Bioshogi::BioshogiError => error
        adapter_notify(error)
        raise error
      end

      adapter_notify
      render json: { record: attrs }
    end

    # curl http://localhost:3000/api/adapter/formal_sheet.json?key=xxx
    def formal_sheet
      record = FreeBattle.find_by!(key: params[:key], use_key: "adapter")
      # record = FreeBattle.first
      render json: record.battle_decorator(params.to_unsafe_h.to_options.merge(view_context: view_context))
    end

    private

    def adapter_notify(error = nil)
      if error
        emoji = ":成功:"
      else
        emoji = ":失敗:"
      end

      subject = []
      subject << "なんでも棋譜変換"
      if current_user
        subject << current_user.name
      end
      if error
        subject << error.class.name
      end
      subject = subject.join(" ")

      body = []
      if current_user
        body << current_user.info.to_t.strip
        body << ""
      end
      if error
        body << "▼エラー"
        body << error.message.strip
        body << ""
      end
      body << "▼棋譜"
      body << params[:input_text].strip
      body = body.join("\n")

      SystemMailer.notify(fixed: true, subject: subject, body: body, emoji: emoji).deliver_later
    end
  end
end

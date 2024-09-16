module QuickScript
  module Swars
    class PiyoShogiConfigScript < Base
      self.title = "ぴよ将棋の設定"
      self.description = "このブラウザでぴよ将棋ボタンを表示する条件を設定する (Mac ユーザー向け)"
      self.form_method = :post
      self.button_label = "保存"

      def form_parts
        super + [
          {
            :label        => "ぴよ将棋ボタンをいつ表示する？ (ブラウザ毎に設定する)",
            :key          => :piyo_shogi_type_key,
            :type         => :radio_button,
            :ls_sync      => { parent_key: :user_settings, child_key: :piyo_shogi_type_key, loader: :force, writer: :force },
            :dynamic_part => -> {
              {
                :elems   => PiyoShogiTypeInfo.to_form_elems,
                :default => piyo_shogi_type_key,
              }
            },
          },
        ]
      end

      def call
        if request_post?
          flash[:notice] = "保存しました"
          piyo_shogi_reload!
        end
        nil
      end

      def piyo_shogi_type_key
        PiyoShogiTypeInfo.lookup_key_or_first(params[:piyo_shogi_type_key])
      end

      def piyo_shogi_type_info
        PiyoShogiTypeInfo.fetch(piyo_shogi_type_key)
      end
    end
  end
end

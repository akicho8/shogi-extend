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
            :label        => "ぴよ将棋ボタンをいつ表示する？ (ブラウザ毎に保存)",
            :key          => :piyo_shogi_type_key,
            :type         => :radio_button,
            :elems        => { "スマホ" => "auto", "常時" => "native", },
            :default      => params[:piyo_shogi_type_key].presence || "auto",
            :help_message => "常時はぴよ将棋を最近の Mac にインストールしている人向け。将棋ウォーズ棋譜検索を Mac から操作しているとき、Mac にインストールしたぴよ将棋を起動できるようになる。",
            :ls_sync      => {:ls_key => "user_settings"},
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
    end
  end
end

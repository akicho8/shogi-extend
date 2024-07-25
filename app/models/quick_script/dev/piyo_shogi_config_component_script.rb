module QuickScript
  module Dev
    class PiyoShogiConfigComponentScript < Base
      self.title = "ぴよ将棋の設定"
      self.description = "ぴよ将棋ボタンを表示する条件を設定する"

      def call
        # 直接飛ばす方法
        # redirect_to "/settings/piyo_shogi"

        # 外側では何もせずにコンポーネントに委譲する
        { _component: "UserEditPiyoShogiMini" }
      end
    end
  end
end

module QuickScript
  module Swars
    class ProScript < Base
      self.title = "プロの棋力"
      self.description = "プロ棋士のウォーズの段位をまとめて表示する (棋力一覧に遷移する)"

      def call
        query = { order_by: :grade, user_items_text: user_items_text.lines.shuffle.join }
        redirect_to UserGroupScript.qs_path + "?" + query.to_query
      end

      def user_items_text
        <<~EOS
藤森哲也 BOUYATETSU5
伊藤真吾 itoshinTV
戸辺誠   TOBE_CHAN
中村太地 Taichan0601
村中秀史 MurachanLions
折田翔吾 pagagm
井出隼平 ideon_shogi
小山怜央 Odenryu
山本真也 chanlili
鈴木大介 Dsuke213
竹内雄悟 GOMUNINGEN
山本博志 Y_Hiroshi_316
谷合廣紀 T_Hiroki_323
EOS
      end
    end
  end
end

module QuickScript
  module Swars
    class ProScript < Base
      self.title = "プロの棋力"
      self.description = "プロ棋士のウォーズの段位をまとめて表示する (棋力一覧に遷移する)"

      def call
        query = { order_by: :grade, swars_user_keys: ::Swars::User::Vip.group(:pro).sort * " " }
        redirect_to UserGroupScript.qs_path + "?" + query.to_query
      end
    end
  end
end

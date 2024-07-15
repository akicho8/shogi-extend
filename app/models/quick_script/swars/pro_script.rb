module QuickScript
  module Swars
    class ProScript < Base
      self.title = "プロの棋力"
      self.description = "プロ棋士のウォーズの段位をまとめて表示する"

      def call
        query = { order_by: :grade, user_keys: ::Swars::User::Vip.group(:pro).sort * " " }
        redirect_to UserScript.qs_link_path + "?" + query.to_query
      end
    end
  end
end

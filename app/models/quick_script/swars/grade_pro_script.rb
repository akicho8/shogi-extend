module QuickScript
  module Swars
    class GradeProScript < Base
      self.title = "プロの棋力"
      self.description = "プロ棋士のウォーズの段位をまとめて表示する"

      def call
        redirect_to GradeScript.link_path + "?" + { user_keys: ::Swars::User::Vip.group(:pro).sort * " " }.to_query
      end
    end
  end
end

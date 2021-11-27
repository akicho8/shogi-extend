module Wkbk
  class Book
    concern :AccessLogMethods do
      included do
        has_many :access_logs, class_name: "Wkbk::AccessLog", dependent: :destroy # アクセス記録たち
        has_many :access_log_users, through: :access_logs, source: :user          # アクセスしたユーザーたち
      end
    end
  end
end

module ShortUrl
  class Component < ApplicationRecord
    class << self
      # コントローラー用
      begin
        # 作成 curl http://localhost:3000/api/short_url/components.json -d "original_url=/"
        # 移動 curl -I http://localhost:3000/u/UaswCQacfXi.html
        #
        # 注意:
        #   curl -I http://localhost:3000/u/UaswCQacfXi
        #   とした場合は request.format.json? が有効になるのはなぜ？
        #
        def show_action(c)
          record = fetch(c.params)
          record.access_logs.create! # アクセスログは本当にリダイレクトする直前に記録する
          c.redirect_to record.original_url
        end

        def create_action(c)
          c.render json: from(c.params[:original_url]).compact_url
        end
      end

      # key からレコードを取得する
      def fetch(params)
        fetch_by_id_param(params) || find_by!(key: params[:key])
      end

      def fetch_by_id_param(params)
        if Rails.env.local?
          if id = params[:id].presence
            find(id)
          end
        end
      end

      # 長いURLから短縮URLに直接変換する
      def from(original_url)
        original_url.present? or raise ArgumentError
        key = AlnumHash.call(original_url)
        record = find_by(key: key)
        record ||= create!(key: key, original_url: original_url)
      end

      def root_url
        Rails.application.routes.url_helpers.url_for(:root)
      end
    end

    has_many :access_logs, class_name: "ShortUrl::AccessLog", dependent: :destroy # アクセス記録たち

    before_validation do
      self.key ||= AlnumHash.call(original_url)
    end

    with_options presence: true do
      validates :key
      validates :original_url
    end

    after_create do
      AppLog.info(emoji: ":短縮URL:", subject: "短縮URL作成完了", body: compact_url, mail_notify: true)
    end

    def compact_url
      "#{self.class.root_url}u/#{key}"
    end

    def as_json(*)
      super.merge(compact_url: compact_url)
    end
  end
end

module ShortUrl
  class Component < ApplicationRecord
    class << self
      # コントローラー用
      def action(c)
        record = fetch(c.params)
        if c.request.format.html?
          record.access_logs.create! # アクセスログは本当にリダイレクトする直前に記録する
          c.redirect_to record.original_url
        else
          c.render json: record.compact_url
        end
      end

      # 長いURLから短縮URLに直接変換する
      def from(url)
        fetch(original_url: url).compact_url
      end

      # params[:any] または params[:original_url] によって探したり作ったりする
      def fetch(params)
        if Rails.env.local?
          case
          when id = params[:id].presence
            record = find(id)
          when key = params[:key].presence
            record = find_by!(key: key)
          end
        end

        unless record
          case
          when any = params[:any].presence
            record = find_by!(key: any)
          when original_url = params[:original_url].presence
            key = AlnumHash.call(original_url)
            record = find_by(key: key)
            record ||= create!(key: key, original_url: original_url)
          else
            raise "must not happen"
          end
        end

        record
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
      AppLog.info(subject: "短縮URL作成", body: compact_url, mail_notify: true)
    end

    def compact_url
      "#{self.class.root_url}url/#{key}"
    end

    def as_json(*)
      super.merge(compact_url: compact_url)
    end
  end
end

module Swars
  class User < ApplicationRecord
    include GradeMethods
    include BanMethods
    include SearchMethods

    class << self
      def [](key)
        find_by(key: key)
      end

      def fetch(key)
        find_by!(key: key)
      end
    end

    alias_attribute :key, :user_key

    has_one :profile, dependent: :destroy, autosave: true # プロフィール

    has_many :memberships, dependent: :destroy # 対局時の情報(複数)
    has_many :battles, through: :memberships   # 対局(複数)

    has_many :op_memberships, class_name: "Membership", foreign_key: "op_user_id", dependent: :destroy # (対戦相手の)対局時の情報(複数)
    has_many :op_users, through: :op_memberships, source: :user

    has_many :search_logs, dependent: :destroy # 明示的に取り込んだ日時の記録

    scope :recently_only, -> { where.not(last_reception_at: nil).order(last_reception_at: :desc) } # 最近使ってくれた人たち順
    scope :regular_only,  -> { order(search_logs_count: :desc)                                   } # 検索回数が多い人たち順
    scope :great_only,    -> { joins(:grade).order(Grade.arel_table[:priority].asc)              } # 段級位が高い人たち順

    before_validation do
      if Rails.env.local?
        self.key ||= "#{self.class.name.demodulize.underscore}#{self.class.count.next}"
      end
      self.key ||= SecureRandom.hex
      self.latest_battled_at ||= Time.current
    end

    before_validation on: :create do
      profile || build_profile
    end

    with_options presence: true do
      validates :key
      validates :latest_battled_at
    end

    def to_param
      key
    end

    def stat(params = {})
      User::Stat::Main.new(self, params)
    end

    def to_h
      {
        "ID"           => id,
        "ウォーズID"   => key,
        "段級"         => grade.name,
        "最終対局日時" => latest_battled_at&.to_fs(:ymdhms),
        "対局数"       => memberships.size,
        "BAN日時"      => ban_at&.to_fs(:ymdhms),
        "BAN確認数"    => profile.ban_crawled_count,
        "BAN確認日時"  => profile.ban_crawled_at&.to_fs(:ymdhms),
        "検索数"       => search_logs_count,
        "直近検索"     => last_reception_at&.to_fs(:ymdhms),
        "登録日時"     => created_at.to_fs(:ymdhms),
        "現在日時"     => Time.current.to_fs(:ymdhms),
      }
    end
  end
end

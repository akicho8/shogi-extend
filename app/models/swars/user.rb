module Swars
  class User < ApplicationRecord
    alias_attribute :key, :user_key

    has_one :profile, dependent: :destroy, autosave: true # プロフィール
    has_many :ban_crawl_requests, dependent: :destroy     # 垢BAN確認リクエストたち

    has_many :memberships, dependent: :destroy # 対局時の情報(複数)
    has_many :battles, through: :memberships   # 対局(複数)

    has_many :op_memberships, class_name: "Membership", foreign_key: "op_user_id", dependent: :destroy # (対戦相手の)対局時の情報(複数)
    has_many :op_users, through: :op_memberships, source: :user

    has_many :search_logs, dependent: :destroy # 明示的に取り込んだ日時の記録

    scope :recently_only, -> { where.not(last_reception_at: nil).order(last_reception_at: :desc)              } # 最近使ってくれた人たち順
    scope :regular_only,  -> { order(search_logs_count: :desc)                                                } # 検索回数が多い人たち順
    scope :great_only,    -> { joins(:grade).order(Grade.arel_table[:priority].asc)                           } # 段級位が高い人たち順

    before_validation do
      if Rails.env.local?
        self.user_key ||= "#{self.class.name.demodulize.underscore}#{self.class.count.next}"
      end
      self.user_key ||= SecureRandom.hex
      self.latest_battled_at ||= Time.current

      profile || build_profile
    end

    with_options presence: true do
      validates :user_key
      validates :latest_battled_at
    end

    with_options allow_blank: true do
      validates :user_key, uniqueness: { case_sensitive: true } # FIXME: これ取る
    end

    def to_param
      user_key
    end

    def user_info(params = {})
      UserInfo::Main.new(self, params)
    end

    concerning :GradeMethods do
      included do
        custom_belongs_to :grade, ar_model: Grade, st_model: GradeInfo, default: "30級" # すべてのモードのなかで一番よい段級位

        if Rails.env.local?
          before_validation do
            if Grade.count.zero?
              Swars.setup
            end
          end
        end
      end

      # 指定の grade の方が段位が上であれば設定する
      def grade_update_if_new(new_grade)
        if grade
          if new_grade.priority < grade.priority
            self.grade = new_grade
          end
        else
          self.grade = grade
        end
        save!
      end

      def name_with_grade
        "#{user_key} #{grade.name}"
      end
    end

    concerning :SearchMethods do
      included do
        scope :search, -> (query = {}) { UserSearch.new(all, query).call }

        scope :ban_only,               -> { where.not(ban_at: nil)                                                        } # BANされた人たち
        scope :ban_except,             -> { where(ban_at: nil)                                                            } # BANされた人たちを除く
        scope :pro_except,             -> { where.not(grade: Grade.fetch("十段"))                                         } # プロを除く
        scope :pro_only,               -> { where(grade: Grade.fetch("十段"))                                             } # プロのみ
        scope :ban_crawled_count_lteq, -> c { joins(:profile).merge(Profile.ban_crawled_count_lteq(c))                    } # 垢BANチェック指定回数以下
        scope :ban_crawled_at_lt,      -> time { joins(:profile).merge(Profile.ban_crawled_at_lt(time))                   } # 垢BANチェックの前回が指定日時より過去
        scope :latest_battled_at_lt,   -> time { where(arel_table[:latest_battled_at].lt(time))                           } # 最終対局が指定の日時よりも古い
        scope :ban_crawl_then_battled, -> { joins(:profile).where(arel_table[:latest_battled_at].gt(Profile.arel_table[:ban_crawled_at])) } # 垢BANチェックしたあとで対局したものたち
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

    concerning :BanMethods do
      # included do
      #   # BAN確認対象者
      #   scope :search, -> (options = {}) { ban_except.pro_except.search(options) }
      # end

      class_methods do
        # ショートカット
        # rails r 'Swars::User.ban_crawl'
        def ban_crawl(...)
          BanCrawler.new(...).call
        end
      end

      # 完全に初期状態に戻す
      def ban_reset
        self.ban_at = nil
        profile.ban_at = nil
        profile.ban_crawled_count = nil
        profile.ban_crawled_at = nil
        save!
      end

      # 保存しない
      def ban_set(state)
        time = Time.current
        value = nil
        if state
          value = time
        end
        self.ban_at = value
        profile.ban_at = value
        profile.ban_crawled_at = time
        profile.ban_crawled_count += 1
        save!
      end

      def ban!
        ban_set(true)
      end

      def ban?
        ban_at
      end
    end
  end
end

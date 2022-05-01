# rails r Swars::Battle.cleanup
module Swars
  class Battle
    concern :CleanupMethods do
      included do
        # 削除対象
        scope :cleanup_scope, -> (params = {}) {
          params = {
            expires_in: 80.days,
            skip_users: (Rails.env.production? || Rails.env.staging?) ? Rails.application.credentials[:battles_destroy_skip_users] : ["devuser1"],
          }.merge(params)

          s = all
          s = s.not_accessed_scope(params[:expires_in])  # アクセスされないまましばらく経過したもの
          s = s.clearn_reject_scope1
          s = s.clearn_reject_scope2
          s = s.user_rejected_scope(params[:skip_users]) # 特定ユーザーは除外
          s
        }

        # アクセスが今から expires_in 秒前より古いもの
        scope :not_accessed_scope, -> expires_in {
          where(arel_table[:accessed_at].lteq(expires_in.seconds.ago))
        }

        scope :clearn_reject_scope1, -> { where.not(xmode: Xmode.fetch("指導"))       } # 指導対局を除外
        scope :clearn_reject_scope2, -> { where.not(id: Grade.fetch("十段").battles)  } # 十段の対局を除外

        # 指定ユーザーのバトルを除外したもの
        scope :user_rejected_scope, proc { |user_keys|
          users = User.where(user_key: user_keys)
          # FIXME: Rails 6.1 からは Battle.xxx は scope を継承されなくなるので unscoped は不要
          if true
            skip_battles = Battle.unscoped.joins(memberships: :user).merge(Membership.where(user: users)).distinct # JOIN版
          else
            skip_battles = Battle.unscoped.where(id: Membership.where(user: users).pluck(:battle_id).uniq) # JOIN使わない版
          end
          where.not(id: skip_battles)
        }
      end

      class_methods do
        # 参照されていないレコードを消していく
        #
        #   ActiveRecord::Base.logger = nil
        #   Swars::Battle.cleanup(time_limit: nil)
        #
        def cleanup(params = {})
          params = {
            time_limit: 4.hours,  # 最大処理時間(朝2時に実行したら6時には必ず終了させる)
            sleep: 0,
          }.merge(params)

          memo = {}
          rows = []
          errors = []
          t = Time.current
          memo["前"] = count
          cleanup_scope(params).find_in_batches(batch_size: 1000) do |g|
            row = {}
            rows << row
            row["日時"] = Time.current.to_s(:ymdhms)
            row["個数"] = g.size
            row["成功"] = 0
            row["失敗"] = 0
            if params[:time_limit] && params[:time_limit] <= (Time.current - t)
              break
            end
            g.each do |e|
              begin
                e.destroy!
                row["成功"] += 1
              rescue ActiveRecord::RecordNotDestroyed, ActiveRecord::Deadlocked => invalid
                row["失敗"] += 1
                errors << invalid
              end
              sleep(params[:sleep])
            end
          end
          memo["後"] = count
          memo["差"] = memo["後"] - memo["前"]
          memo["開始"] = t.to_s(:ymdhms)
          memo["終了"] = Time.current.to_s(:ymdhms)

          body = [
            memo.to_t,
            rows.to_t,
            errors.to_t,
          ].reject(&:blank?).join("\n")

          SystemMailer.notify(fixed: true, subject: "バトル削除", body: body).deliver_later
        end
      end
    end
  end
end

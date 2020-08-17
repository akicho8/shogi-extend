module Actb
  concern :ActiveUsersNotifyMod do
    class_methods do
      # 全削除して通知(緊急用)
      # redis.del は削除した個数を返す
      def active_users_clear
        if redis.del(redis_key) >= 1   # set.clear
          active_users_status_broadcast
        end
      end

      # 全員をアクティブ状態にする(開発用)
      def active_users_add_all
        User.find_each(&method(:active_users_add))
      end

      # 現在アクティブなユーザーIDs
      def active_user_ids
        redis.smembers(redis_key).collect(&:to_i) # set.to_a
      end

      # 現在アクティブなユーザー配列
      def active_users
        active_user_ids.collect { |e| User.find(e) }
      end

      # 指定のユーザーをアクティブにする
      # 期限切れにしようとしたが SET 型だと値に対して個別にTTLを設定できない。つまり SET にするべきではなかった？→あってる
      # が、個別揮発しないのはどうしたらいいんだろう？
      def active_users_add(user)
        if user
          if redis.sadd(redis_key, user.id) # set.add(user.id)
            active_users_status_broadcast
          end
        end
      end

      # 指定のユーザーを非アクテイブにする
      def active_users_delete(user)
        if user
          if redis.srem(redis_key, user.id) # set.delete(user.id)
            active_users_status_broadcast
          end
        end
      end

      private

      def active_users_status_broadcast
        ActionCable.server.broadcast("actb/school_channel", bc_action: :active_users_status_broadcasted, bc_params: bc_params)
      end

      def bc_params
        { redis_key => active_user_ids }
      end

      def redis_key
        raise NotImplementedError, "#{__method__} is not implemented"
      end
    end
  end
end

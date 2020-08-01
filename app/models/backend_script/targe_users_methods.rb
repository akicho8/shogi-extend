module BackendScript
  concern :TargeUsersMethods do
    def form_parts
      super + [
        {
          :label   => "対象ユーザーIDs",
          :key     => :target_user_ids,
          :type    => :string,
          :default => current_target_user_ids.join(" "),
        },
      ]
    end

    private

    def current_target_user_ids
      params[:target_user_ids].to_s.scan(/\d+/).collect(&:to_i).uniq
    end

    def current_target_users
      if v = current_target_user_ids
        User.find(v)
      end
    end
  end
end

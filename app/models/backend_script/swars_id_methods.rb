module BackendScript
  concern :SwarsIdMethods do
    def form_parts
      super + [
        {
          :label   => "対象のウォーズID",
          :key     => :swars_id,
          :type    => :string,
          :default => params[:swars_id] || current_swars_id_default,
        },
      ]
    end

    private

    def current_swars_id
      params[:swars_id].presence || current_swars_id_default
    end

    def current_swars_id_default
      if Rails.env.local?
        Swars::User.first&.user_key
      else
        "SugarHuuko"
      end
    end
  end
end

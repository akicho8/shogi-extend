module BackendScript
  class SqlScript < Base
    self.category = "コンソール"
    self.label_name = "SQL"

    def form_parts
      [
        {
          :label   => "SQL",
          :key     => :sql,
          :type    => :text,
          :default => current_sql,
        },
      ]
    end

    def script_body
      if current_sql
        # ApplicationRecord.select_all(current_sql).collect(&:to_h)
        ActiveRecord::Base.connection.select_all(current_sql).collect(&:to_h)
      end
    end

    def current_sql
      params[:sql].presence
    end
  end
end

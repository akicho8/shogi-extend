module BackendScript
  module SortMethods
    include ::SortMethods

    # created_at には index がないため id にしておく
    def sort_column_default
      "id"
    end
  end
end

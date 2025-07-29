class Fix71 < ActiveRecord::Migration[6.0]
  def up
    change_column_null(:permanent_variables, :value, true)

    PermanentVariable.find_each do |e|
      if e.value == {}
        e.destroy!
      end
    end
  end
end

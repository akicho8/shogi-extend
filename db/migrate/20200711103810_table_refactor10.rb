class TableRefactor10 < ActiveRecord::Migration[6.0]
  def up
    change_column :profiles, :description, :string, limit: 512
  end
end

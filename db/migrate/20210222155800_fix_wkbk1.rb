class FixWkbk1 < ActiveRecord::Migration[6.0]
  def change
    change_table :wkbk_articles do |t|
      t.change :description, :text, limit: 5000
    end

    change_table :wkbk_books do |t|
      t.change :description, :text, limit: 5000
    end
  end
end

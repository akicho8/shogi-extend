class CreateHolidays < ActiveRecord::Migration[6.0]
  def change
    create_table :holidays do |t|
      t.string :name, null: false
      t.date :holiday_on, null: false, index: { unique: true }, comment: "祝日"
    end

    Holiday.setup
  end
end

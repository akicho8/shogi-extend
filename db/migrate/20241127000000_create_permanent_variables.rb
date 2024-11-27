class CreatePermanentVariables < ActiveRecord::Migration[6.0]
  def up
    create_table :permanent_variables, force: true do |t|
      t.string :key, null: false, index: { unique: true }, comment: "キー"
      t.json :value, null: false, index: false,            comment: "値" # 最大 1G
      t.timestamps
    end
  end
end

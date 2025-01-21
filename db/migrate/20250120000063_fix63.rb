class Fix63 < ActiveRecord::Migration[6.0]
  def change
    MigrateRunner.new.call
  end
end

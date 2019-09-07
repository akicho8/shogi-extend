class UpdateXyRecords2 < ActiveRecord::Migration[5.1]
  def change
    XyRecord.find_each(&:save!)
  end
end

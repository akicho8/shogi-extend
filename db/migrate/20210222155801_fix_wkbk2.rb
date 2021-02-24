class FixWkbk2 < ActiveRecord::Migration[6.0]
  def change
    Wkbk::KifuDataImport.new.run
  end
end

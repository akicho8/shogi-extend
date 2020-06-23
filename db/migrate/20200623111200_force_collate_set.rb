class ForceCollateSet < ActiveRecord::Migration[6.0]
  def change
    ActiveRecord::Base.connection.tables.each do |table|
      sql = "alter table #{table} convert to character set utf8mb4 collate utf8mb4_bin"
      puts sql
      ActiveRecord::Base.connection.execute(sql)
    end
  end
end

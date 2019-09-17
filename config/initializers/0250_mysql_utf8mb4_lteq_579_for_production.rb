# /usr/local/var/rbenv/versions/2.6.1/lib/ruby/gems/2.6.0/gems/activerecord-6.0.0/lib/active_record/connection_adapters/mysql/schema_statements.rb:144
# で、 MySQL 5.7.9 以上であれば自動的に ROW_FORMAT になる
# しかしさくらサーバーでは
# ssh s mysql --version
# mysql  Ver 14.14 Distrib 5.5.45, for Linux (x86_64) using readline 5.1
# なので次のコードが必要

if Rails.env.production?
  # http://3.1415.jp/mgeu6lf5/
  module InnodbRowFormat
    def create_table(table_name, options = {}, **)
      table_options = options.reverse_merge(:options => 'ENGINE=InnoDB ROW_FORMAT=DYNAMIC')
      create_table_without_innodb_row_format(table_name, table_options) do |td|
        yield td if block_given?
      end
    end
  end

  ActiveSupport.on_load :active_record do
    class ActiveRecord::ConnectionAdapters::AbstractMysqlAdapter
      prepend InnodbRowFormat
    end
  end
end

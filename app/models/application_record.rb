class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  class << self
    def setup(options = {})
    end

    # rails r 'Swars::SearchLog.old_only(100.days).cleaner.call'
    def cleaner(options = {})
      GeneralCleaner.new(options.merge(scope: all))
    end

    def han(*args)
      human_attribute_name(*args)
    end

    def xquery_parse(v)
      SimpleQueryParser.parse(v)
    end

    def custom_belongs_to(key, options = {})
      options = {
        optional: false,
      }.merge(options)

      ar_model = options[:ar_model]
      st_model = options[:st_model]
      default = options[:default] # 投了

      belongs_to key, **options.slice(:optional, :class_name)     # belongs_to :final

      if default
        before_validation do                                      # before_validation do
          if !public_send("#{key}_id")                            #   if !final_id
            public_send("#{key}_id=", ar_model.fetch(default).id) #     self.final_id = Final.fetch("投了").id
          end                                                     #   end
        end                                                       # end
      end

      # if Rails.env.local?
      #   with_options presence: true do
      #     validates :final_key
      #   end
      #
      #   with_options allow_blank: true do
      #     validates :final_key, inclusion: FinalInfo.keys.collect(&:to_s)
      #   end
      # end
      if Rails.env.local?
        if !options[:optional]
          with_options presence: true do
            validates "#{key}_id".to_sym
          end
        end
        with_options allow_blank: true do
          validates "#{key}_key".to_sym, inclusion: st_model.keys.collect(&:to_s)
        end
      end

      scope "s_group_#{key}_key".to_sym,    ->   { joins(key).group(ar_model.arel_table[:key])       }
      scope "s_pluck_#{key}_key".to_sym,    ->   { joins(key).pluck(ar_model.arel_table[:key])       }
      scope "s_where_#{key}_key_eq".to_sym, -> v { joins(key).where(ar_model.arel_table[:key].eq(v)) }

      # 検索用

      scope "#{key}_eq".to_sym, -> v {                 # scope :final_eq, -> v {
        where(key => ar_model.fetch_from_array(v))           #   where(final: Final.fetch_from_array(v))
      }                                                # }

      scope "#{key}_not_eq".to_sym, -> v {             # scope :final_not_eq, -> v {
        where.not(key => ar_model.fetch_from_array(v))       #   where.not(final: Final.fetch_from_array(v))
      }                                                # }

      scope "#{key}_ex".to_sym, proc { |v; s, g|       # scope :final_ex, proc { |v; s, g|
        s = all                                        #   s = all
        g = SimpleQueryParser.parse_array(v)           #   g = SimpleQueryParser.parse_array(v)
        if g[true]                                     #   if g[true]
          s = s.public_send("#{key}_eq", g[true])      #     s = s.final_eq(g[true])
        end                                            #   end
        if g[false]                                    #   if g[false]
          s = s.public_send("#{key}_not_eq", g[false]) #     s = s.final_not_eq(g[false])
        end                                            #   end
        s                                              #   s
      }                                                # }

      define_method("#{key}_key=") do |v|              # def final_key=(v)
        public_send("#{key}=", ar_model[v])            #   self.final = Final[v]
      end                                              # end

      define_method("#{key}_key") do                   # def final_key
        public_send(key)&.key                          #   self.final&.key
      end                                              # end

      define_method("#{key}_info") do                  # def final_info
        if record = public_send(key)                   #   if final
          record.pure_info                             #     final.pure_info
        end                                            #   end
      end                                              # end
    end

    # 使用禁止
    # これ↓に置き換える
    #
    #   normalizes :foo, with: -> e { column_value_db_truncate(:foo, e) }
    #
    def truncate(*colum_names, **options)
      before_validation(options) do
        colum_names.each do |colum_name|
          if str = public_send(colum_name)
            str = self.class.column_value_db_truncate(colum_name, str)
            public_send("#{colum_name}=", str)
          end
        end
      end
    end

    # normalizes :foo, with: -> e { column_value_db_truncate(:foo, e) }
    def column_value_db_truncate(colum_name, str)
      if str
        column = columns_hash[colum_name.to_s]
        if max = column.limit
          if connection.adapter_name.match?(/Mysql2|Trilogy/i)
            if column.type == :text
              max = max / "🍄".bytesize
            end
          end
          if str.size > max
            str = str.first(max)
          end
        end
      end
      str
    end
  end

  # def truncate(*colum_names)
  #   colum_names.each do |colum_name|
  #     column = self.class.columns_hash[colum_name.to_s]
  #     if max = column.limit
  #       if self.class.connection.adapter_name == "Mysql2"
  #         if column.type == :text
  #           max = max / "🍄".bytesize
  #         end
  #       end
  #       if str = public_send(colum_name)
  #         if str.size > max
  #           str = str.first(max)
  #           public_send("#{colum_name}=", str)
  #         end
  #       end
  #     end
  #   end
  # end

  # "" → nil
  def normalize_blank_to_nil(*keys)
    keys.each do |key|
      if will_save_change_to_attribute?(key)
        if v = public_send(key)
          public_send("#{key}=", v.presence)
        end
      end
    end
  end

  # "" or nil → ""
  def normalize_blank_to_empty_string(*keys)
    keys.each do |key|
      public_send("#{key}=", public_send(key).to_s)
    end
  end

  # 半角化
  def normalize_zenkaku_to_hankaku(*keys)
    keys.each do |key|
      if will_save_change_to_attribute?(key)
        if v = public_send(key)
          public_send("#{key}=", StringSupport.hankaku_format(v))
        end
      end
    end
  end
end

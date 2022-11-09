class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  class << self
    def setup(options = {})
    end

    def han(*args)
      human_attribute_name(*args)
    end

    delegate *StringUtil::DELEGATE_METHODS, to: :StringUtil

    # r = plus_minus_query_parse(["a", "-b", "c", "-d"])
    # r[true]  # => ["a", "c"]
    # r[false] # => ["b", "d"]
    #
    # r = plus_minus_query_parse("a")
    # r[true]  # => ["a"]
    # r[false] # => nil
    def xquery_parse(v)
      Array(v).collect { |e|
        e.match(/(?<not>[!-])?(?<value>.*)/)
      }.compact.group_by { |e|
        !e[:not]
      }.transform_values { |e|
        e.collect { |e| e[:value] }
      }
    end

    # belongs_to :final
    #
    # before_validation do
    #   self.final_id  ||= Final.fetch("投了").id
    # end
    #
    # if Rails.env.development? || Rails.env.test?
    #   with_options presence: true do
    #     validates :final_key
    #   end
    #
    #   with_options allow_blank: true do
    #     validates :final_key, inclusion: FinalInfo.keys.collect(&:to_s)
    #   end
    # end
    #
    # scope :group_by_final_key, -> { joins(:final).group(Final.arel_table[:key]) }
    # scope :final_eq,     -> v { where(    final: Final.array_from(v)) }
    # scope :final_not_eq, -> v { where.not(final: Final.array_from(v)) }
    # scope :final_ex,     proc { |v; s, g|
    #   s = all
    #   g = xquery_parse(v)
    #   if g[true]
    #     s = s.final_eq(g[true])
    #   end
    #   if g[false]
    #     s = s.final_not_eq(g[false])
    #   end
    #   s
    # }
    #
    # def final_key
    #   self.final&.key
    # end
    #
    # def final_key=(v)
    #   self.final = Final[v]
    # end
    #
    # def final_info
    #   if final
    #     final.pure_info
    #   end
    # end
    #
    def custom_belongs_to(key, options = {})
      ar_model = options[:ar_model]
      st_model = options[:st_model]
      default = options[:default]

      belongs_to key

      if default
        before_validation do
          if !public_send("#{key}_id")
            public_send("#{key}_id=", ar_model.fetch(default).id)
          end
        end
      end

      if Rails.env.development? || Rails.env.test?
        with_options presence: true do
          validates "#{key}_id".to_sym
        end

        with_options allow_blank: true do
          validates "#{key}_key".to_sym, inclusion: st_model.keys.collect(&:to_s)
        end
      end

      scope "s_group_#{key}_key".to_sym,    ->   { joins(key).group(ar_model.arel_table[:key])       }
      scope "s_pluck_#{key}_key".to_sym,    ->   { joins(key).pluck(ar_model.arel_table[:key])       }
      scope "s_where_#{key}_key_eq".to_sym, -> v { joins(key).where(ar_model.arel_table[:key].eq(v)) }

      # 検索用
      scope "#{key}_eq".to_sym,     -> v { where(key => ar_model.array_from(v)) }
      scope "#{key}_not_eq".to_sym, -> v { where.not(key => ar_model.array_from(v)) }
      scope "#{key}_ex".to_sym, proc { |v; s, g|
        s = all
        g = xquery_parse(v)
        if g[true]
          s = s.public_send("#{key}_eq", g[true])
        end
        if g[false]
          s = s.public_send("#{key}_not_eq", g[false])
        end
        s
      }

      define_method("#{key}_key=") do |v|
        public_send("#{key}=", ar_model[v])
      end

      define_method("#{key}_key") do
        if record = public_send(key)
          record.key
        end
      end

      define_method("#{key}_info") do
        if record = public_send(key)
          record.pure_info
        end
      end
    end
  end

  delegate *StringUtil::DELEGATE_METHODS, to: :StringUtil

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
          public_send("#{key}=", hankaku_format(v))
        end
      end
    end
  end
end

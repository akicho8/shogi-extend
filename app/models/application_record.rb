class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  class << self
    def setup(options = {})
    end

    def han(*args)
      human_attribute_name(*args)
    end

    # 半角化
    def hankaku_format(s)
      s = s.gsub(/\p{Blank}+/, " ")
      s = s.tr("０-９Ａ-Ｚａ-ｚ", "0-9A-Za-z")
      s = s.tr("＃", "#")       # 問題番号を表わすのに「＃１」と書く人が実際にいたため
      s = s.tr("（）", "()")    # 問題番号を表わすのに「（１）」と書く人がいそうなため
      s = s.lines.collect(&:strip).join("\n")
      s = s.strip
    end

    def strip_tags(s)
      ActionController::Base.helpers.strip_tags(s)
    end

    # HTMLタグのうち script のみをエスケープする
    def script_tag_escape(s)
      Loofah.fragment(s).scrub!(:escape).to_s
    end

    # 複数の空行を1つにする
    def double_blank_lines_to_one_line(s)
      s.gsub(/\R{3,}/, "\n\n")
    end

    # devise では欲しい長さの4/3倍の文字数が得られるのを予測して3/4倍しているがこれはいまいち
    # 実際はおおよそ4/3倍なので指定の文字数に足りない場合がある
    # なのでN文字欲しければN文字以上生成させて先頭からN文字拾えばよい
    # わかりやすい名前はARの内部のメソッドとかぶりそうなので注意
    # rails r 'tp 10.times.collect { ApplicationRecord.secure_random_urlsafe_base64_token }'
    def secure_random_urlsafe_base64_token(length = 11)
      if false
        SecureRandom.urlsafe_base64(length).slice(0, length)
      else
        v = SecureRandom.urlsafe_base64(length * 2)
        v = v.gsub(/[-_]/, "")
        v = v.slice(/[a-z].{#{length-1}}/i)
        v or raise "must not happen"
      end
    end

    # FIXME: とる
    begin
      def data_uri_scheme_to_bin(data_base64_body)
        DataUriScheme.new(data_base64_body).binary
      end

      def data_uri_scheme_to_content_type(data_base64_body)
        DataUriScheme.new(data_base64_body).content_type
      end
    end

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
          unless public_send("#{key}_id")
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

  delegate *[
    :hankaku_format,
    :strip_tags,
    :script_tag_escape,
    :double_blank_lines_to_one_line,
    :secure_random_urlsafe_base64_token,
  ], to: "self.class"

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

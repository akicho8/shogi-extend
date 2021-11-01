# required は form の required でしかない
class AvailableXsetting
  def self.app_data
    list = []
    if Rails.env.test? || Rails.env.development?
      list += [
        { :key => :t_string_var,   :var_type => :string,   :name => "(string)",   :default => "(t_string_var.default)", :form_type => nil, :form_enable => true, },
        { :key => :t_text_var,     :var_type => :text,     :name => "(text)",     :default => "(t_text_var.default)",   :form_type => nil, :form_enable => true, },
        { :key => :t_integer_var,  :var_type => :integer,  :name => "(integer)",  :default => 1,                        :form_type => nil, :form_enable => true, },
        { :key => :t_float_var,    :var_type => :float,    :name => "(float)",    :default => 1.5,                      :form_type => nil, :form_enable => true, },
        { :key => :t_boolean_var,  :var_type => :boolean,  :name => "(boolean)",  :default => true,                     :form_type => nil, :form_enable => true, },
        { :key => :t_symbol_var,   :var_type => :symbol,   :name => "(symbol)",   :default => :value,                   :form_type => nil, :form_enable => true, },
        { :key => :t_datetime_var, :var_type => :datetime, :name => "(datetime)", :default => "2000-01-02 12:34",       :form_type => nil, :form_enable => true, },
        { :key => :t_date_var,     :var_type => :date,     :name => "(date)",     :default => "2000-01-02",             :form_type => nil, :form_enable => true, },
        { :key => :t_presece_var,  :var_type => :string,   :name => "(required)", :default => "required",               :form_type => nil, :form_enable => true, :other_form_options => {:required => true}, },
      ]
    end
    if true
      list += [
        {:key => :xsetting_lock_version,                  :var_type => :integer, :name => "管理ツールの設定の排他制御用", :default => 0, :form_type => nil, :form_enable => false, :other_form_options => {:required => true}},
        {:key => :kiwi_lemon_background_job_active_begin, :var_type => :integer, :name => "動画変換開始(hour)",           :default => 2, :form_type => nil, :form_enable => true},
        {:key => :kiwi_lemon_background_job_active_end,   :var_type => :integer, :name => "動画変換終了(hour)",           :default => 6, :form_type => nil, :form_enable => true},
      ]
    end
    list
  end

  include ApplicationMemoryRecord
  memory_record app_data

  def tags
    Array.wrap(attributes[:tags])
  end

  def form_box_type
    form_type || var_type
  end

  def other_form_options
    attributes[:other_form_options] || {}
  end

  def form_part
    {
      :label    => name,
      :key      => key,
      :prefix   => :xsetting,
      :type     => form_box_type,
      :tooltip  => true,
      :default  => Xsetting[key],
    }.merge(other_form_options)
  end
end

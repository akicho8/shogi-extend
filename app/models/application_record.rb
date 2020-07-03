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
      s = s.to_s
      s = s.gsub(/\p{Blank}+/, " ")
      s = s.tr("０-９Ａ-Ｚａ-ｚ", "0-9A-Za-z")
      s = s.lines.collect(&:strip).join("\n")
      s = s.strip
      s.presence
    end
  end

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

  # 半角化
  def normalize_zenkaku_to_hankaku(*keys)
    keys.each do |key|
      if will_save_change_to_attribute?(key)
        if v = public_send(key)
          public_send("#{key}=", self.class.hankaku_format(v))
        end
      end
    end
  end
end

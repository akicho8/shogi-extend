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
      s = s.lines.collect(&:strip).join("\n")
      s = s.strip
    end

    # HTMLタグのうち script のみをエスケープする
    def script_tag_escape(s)
      Loofah.fragment(s).scrub!(:escape).to_s
    end

    # 複数の空行を1つにする
    def double_blank_lines_to_one_line(s)
      s.gsub(/\R{3,}/, "\n\n")
    end
  end

  delegate *[
    :hankaku_format,
    :script_tag_escape,
    :double_blank_lines_to_one_line,
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

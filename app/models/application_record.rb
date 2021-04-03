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

  # devise では欲しい長さの4/3倍の文字数が得られるのを予測して3/4倍しているがこれはいまいち
  # 実際はおおよそ4/3倍なので指定の文字数に足りない場合がある
  # なのでN文字欲しければN文字以上生成させて先頭からN文字拾えばよい
  # わかりやすい名前はARの内部のメソッドとかぶりそうなので注意
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
end

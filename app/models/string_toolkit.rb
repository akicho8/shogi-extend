module StringToolkit
  extend self

  # 半角化
  def hankaku_format(s)
    s = s.gsub(/\p{Blank}+/, " ")
    s = s.tr("０-９Ａ-Ｚａ-ｚ", "0-9A-Za-z")
    s = s.tr("＃", "#")       # 問題番号を表わすのに「＃１」と書く人が実際にいたため
    s = s.tr("（）", "()")    # 問題番号を表わすのに「（１）」と書く人がいそうなため
    s = s.lines.collect(&:strip).join("\n")
    s = s.strip
  end

  def split(s)
    s.split(/[,[:blank:]]+/)
  end

  # タグを取る
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
  # rails r 'tp 10.times.collect { StringToolkit.secure_random_urlsafe_base64_token }'
  def secure_random_urlsafe_base64_token(length = 11)
    s = SecureRandom.urlsafe_base64(length * 2)
    s = s.gsub(/[-_]/, "")              # 扱いにくい文字は削除する
    s = s.slice(/[a-z].{#{length-1}}/i) # アルファベットから初まる length 文字
    s or raise "must not happen"
  end

  def plus_minus_split(s)
    v = split(s).group_by { |e| !e.start_with?("-") }
    v = v.transform_values { |e| e.collect { |e| e.delete_prefix("-") } }
    [true, false].inject({}) { |a, e| a.merge(e => (v[e] || []).uniq) }
  end

  def path_normalize(s)
    s = s.gsub(/\P{Graph}/, "_")
    s = s.gsub(/\p{Punct}/, "_")
  end
end

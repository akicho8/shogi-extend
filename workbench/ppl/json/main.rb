require "open-uri"
require "pathname"
require "json"
require "kconv"
require "nokogiri"
require "active_support/all"
require "table_format"

def ox_normalize(str)
  ox_replace(str.scan(/[○□●■]+/).join)
end

def ox_replace(str)
  str.tr("○□●■", "ooxx")
end

def delete_dan(str)
  str.gsub(/[一二三四五六七八九]段/, "")
end

# https://www.ne.jp/asahi/yaston/shogi/syoreikai/yobi_and_Akumi/index.htm

list = [
  { name: "S31前", url: "https://www.ne.jp/asahi/yaston/shogi/syoreikai/yobi_and_Akumi/league/31nendo_yobi0102.htm" },
  { name: "S31後", url: "https://www.ne.jp/asahi/yaston/shogi/syoreikai/yobi_and_Akumi/league/31nendo_yobi0102.htm" },
  { name: "S32前", url: "https://www.ne.jp/asahi/yaston/shogi/syoreikai/yobi_and_Akumi/league/32nendo_yobi0304.htm" },
  { name: "S32後", url: "https://www.ne.jp/asahi/yaston/shogi/syoreikai/yobi_and_Akumi/league/32nendo_yobi0304.htm" },
  { name: "S33前", url: "https://www.ne.jp/asahi/yaston/shogi/syoreikai/yobi_and_Akumi/league/33nendo_yobi0506.htm" },
  { name: "S33後", url: "https://www.ne.jp/asahi/yaston/shogi/syoreikai/yobi_and_Akumi/league/33nendo_yobi0506.htm" },
  { name: "S34前", url: "https://www.ne.jp/asahi/yaston/shogi/syoreikai/yobi_and_Akumi/league/34nendo1_yobi07.htm" },
  { name: "S34後", url: "https://www.ne.jp/asahi/yaston/shogi/syoreikai/yobi_and_Akumi/league/34nendo2_yobi08.htm" },
  { name: "S35前", url: "https://www.ne.jp/asahi/yaston/shogi/syoreikai/yobi_and_Akumi/league/35nendo1_yobi09.htm" },
  { name: "S35後", url: "https://www.ne.jp/asahi/yaston/shogi/syoreikai/yobi_and_Akumi/league/35nendo2_yobi10.htm" },
  { name: "S36前", url: "https://www.ne.jp/asahi/yaston/shogi/syoreikai/yobi_and_Akumi/league/36nendo1_yobi11.htm" },
  { name: "S36後", url: "https://www.ne.jp/asahi/yaston/shogi/syoreikai/yobi_and_Akumi/league/36nendo2_yobi12.htm" },
  { name: "S37前", url: "https://www.ne.jp/asahi/yaston/shogi/syoreikai/yobi_and_Akumi/league/37nendo1_Akumi13.htm" },
  { name: "S37後", url: "https://www.ne.jp/asahi/yaston/shogi/syoreikai/yobi_and_Akumi/league/37nendo2_Akumi14.htm" },
  { name: "S38前", url: "https://www.ne.jp/asahi/yaston/shogi/syoreikai/yobi_and_Akumi/league/38nendo1_Akumi15.htm" },
  { name: "S38後", url: "https://www.ne.jp/asahi/yaston/shogi/syoreikai/yobi_and_Akumi/league/38nendo2_Akumi16.htm" },
  { name: "S39前", url: "https://www.ne.jp/asahi/yaston/shogi/syoreikai/yobi_and_Akumi/league/39nendo1_Akumi17.htm" },
  { name: "S39後", url: "https://www.ne.jp/asahi/yaston/shogi/syoreikai/yobi_and_Akumi/league/39nendo2_Akumi18.htm" },
  { name: "S40前", url: "https://www.ne.jp/asahi/yaston/shogi/syoreikai/yobi_and_Akumi/league/40nendo1_Akumi19.htm" },
  { name: "S40後", url: "https://www.ne.jp/asahi/yaston/shogi/syoreikai/yobi_and_Akumi/league/40nendo2_Akumi20.htm" },
  { name: "S41前", url: "https://www.ne.jp/asahi/yaston/shogi/syoreikai/yobi_and_Akumi/league/41nendo1_Akumi21.htm" },
  { name: "S41後", url: "https://www.ne.jp/asahi/yaston/shogi/syoreikai/yobi_and_Akumi/league/41nendo2_Akumi22.htm" },
  { name: "S42前", url: "https://www.ne.jp/asahi/yaston/shogi/syoreikai/yobi_and_Akumi/league/42nendo1_Akumi23.htm" },
  { name: "S42後", url: "https://www.ne.jp/asahi/yaston/shogi/syoreikai/yobi_and_Akumi/league/42nendo2_Akumi24.htm" },
  { name: "S43前", url: "https://www.ne.jp/asahi/yaston/shogi/syoreikai/yobi_and_Akumi/league/43nendo1_Akumi25.htm" },
  { name: "S43後", url: "https://www.ne.jp/asahi/yaston/shogi/syoreikai/yobi_and_Akumi/league/43nendo2_Akumi26.htm" },
  { name: "S44前", url: "https://www.ne.jp/asahi/yaston/shogi/syoreikai/yobi_and_Akumi/league/44nendo1_Akumi27.htm" },
  { name: "S44後", url: "https://www.ne.jp/asahi/yaston/shogi/syoreikai/yobi_and_Akumi/league/44nendo2_Akumi28.htm" },
  { name: "S45前", url: "https://www.ne.jp/asahi/yaston/shogi/syoreikai/yobi_and_Akumi/league/45nendo1_Akumi29.htm" },
  { name: "S45後", url: "https://www.ne.jp/asahi/yaston/shogi/syoreikai/yobi_and_Akumi/league/45nendo2_Akumi30.htm" },
  { name: "S46前", url: "https://www.ne.jp/asahi/yaston/shogi/syoreikai/yobi_and_Akumi/league/46nendo1_Akumi31.htm" },
  { name: "S46後", url: "https://www.ne.jp/asahi/yaston/shogi/syoreikai/yobi_and_Akumi/league/46nendo2_Akumi32.htm" },
  { name: "S47前", url: "https://www.ne.jp/asahi/yaston/shogi/syoreikai/yobi_and_Akumi/league/47nendo1_Akumi33.htm" },
  { name: "S47後", url: "https://www.ne.jp/asahi/yaston/shogi/syoreikai/yobi_and_Akumi/league/47nendo2_Akumi34.htm" },
  { name: "S48前", url: "https://www.ne.jp/asahi/yaston/shogi/syoreikai/yobi_and_Akumi/league/48nendo1_Akumi35.htm" },
  { name: "S48後", url: "https://www.ne.jp/asahi/yaston/shogi/syoreikai/yobi_and_Akumi/league/48nendo2_Akumi36.htm" },
].each do |e|
  puts e[:url]
  body = URI(e[:url]).read.toutf8
  body = NKF.nkf("-w -Z1", body)
  doc = Nokogiri::HTML(body)
  text = doc.text
  name = /(\S+)[一二三四五六七八九]段/

  promote_users = text.scan(/昇段者\s+(\S+)/).flatten
  promote_users = promote_users.collect { it.split(/、/) }.flatten
  promote_users = promote_users.collect { delete_dan(it) }
  tp("昇段者" => promote_users)

  a = ox_replace(text).scan(/関東\s*#{name}\s*([ox])-([ox])\s*#{name}\s*関西/).flatten
  kessho_hv = {}
  if a.present?
    name1, r1, r2, name2 = a
    kessho_hv[name1] = r1
    kessho_hv[name2] = r2
    tp("決勝" => kessho_hv)
  end

  rows = []
  doc.search("table tr").each do |tr|
    values = tr.search("td").collect { |e| e.text.to_s.remove(/\p{Space}+/) }
    unless values[0].match?(/\A\d+期\z/)
      next
    end
    row = {}
    row.update(["参加期", "順位", "氏名", "段位"].zip(values).to_h)
    row.update(["師匠", "年齢", "出身"].zip(values[4].split(/・/)).to_h)
    row.update(["勝敗", "新順位"].zip(values.last(2)).to_h)
    row["勝数"] = 0
    row["敗数"] = 0
    if md = row["勝敗"].match(/(?<win>\d+)-(?<lose>\d+)/)
      row["勝数"] = md[:win].to_i
      row["敗数"] = md[:lose].to_i
      row.delete("勝敗")
    end

    ox = ox_normalize(values.join)

    if row["勝数"] && (row["勝数"] != ox.count("o"))
      p [row["氏名"], "勝数とoの数の不一致", row["勝数"], ox.count("o")]
    end
    if row["敗数"] && (row["敗数"] != ox.count("x"))
      p [row["氏名"], "敗数とoの数の不一致", row["敗数"], ox.count("x")]
    end

    if kessho_ox = kessho_hv[row["氏名"]]
      p [row["氏名"], ox]
      ox += kessho_ox
      p [row["氏名"], ox]
      if kessho_ox == "o"
        row["勝数"] += 1
      else
        row["敗数"] += 1
      end
    end

    row["ox"] = ox
    row["結果"] = promote_users.include?(row["氏名"]) ? "昇段" : nil
    rows << row
  end
  tp rows
  Pathname("#{e[:name]}.json").write(JSON.pretty_generate(rows))
end

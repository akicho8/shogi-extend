# rails r QuickScript::Swars::TacticCrossScript::LegendGenerator.generate
class QuickScript::Swars::TacticCrossScript::LegendGenerator
  def self.generate
    new.display
  end

  def top_names
    [
      # "居飛車", "振り飛車",
      # "急戦", "持久戦",
      # "短手数", "長手数",
      # "手損角交換型", "手得角交換型",
      #
      # "大駒全ブッチ", "大駒コンプリート",
      # "力戦", "居玉",
      #
      # "相掛かり", "原始棒銀", "棒銀", "腰掛け銀", "角換わり早繰り銀",
      #
      # "角換わり", "一手損角換わり",
      # "ショーダンオリジナル", "村田システム",
      #
      # "嬉野流", "新嬉野流", "飯島流引き角戦法",
      #
      # "アヒル戦法", "筋違い角", "相筋違い角",
      #
      # "右四間飛車", "右四間飛車急戦",
      #
      # "原始中飛車", "ゴキゲン中飛車",
      #
      # "四間飛車", "ノーマル四間飛車", "角道オープン四間飛車", "耀龍四間飛車", "角交換振り飛車", "はく式四間飛車", "やばボーズ流",
      #
      # "三間飛車", "初手▲7八飛戦法", "早石田", "石田流", "石田流本組み", "xaby角戦法",
      #
      # "向かい飛車", "ショーダンシステム", "菜々河流△4四角", "天彦流▲6六角", "菜々河流向かい飛車", "ゴリゴリ金",
      #
      # "メイドシステム", "初手▲7八飛戦法", "2手目△3二銀システム",
      #
      # "オザワシステム",
      #
      # "無敵囲い",
      # "いちご囲い",
      # "総矢倉",
      # "舟囲い",
      # "端玉銀冠",
      # "穴熊",
      # "片美濃囲い", "美濃囲い", "四枚美濃", "ダイヤモンド美濃",
      # "金無双",
      #
      # "位の確保",
      # "居飛車の税金",
      # "こびん攻め",
      # "たたきの歩",
      # "垂れ歩",
      # "連打の歩",
      # "継ぎ歩",
      # "土下座の歩",
      # "端玉には端歩",
      # "遠見の角"
    ]
  end

  def aggregate
    # api_url = "http://localhost:3000/api/lab/swars/tactic-cross.json?json_type=general"
    api_url = "https://www.shogi-extend.com/api/lab/swars/tactic-cross.json?json_type=general"

    raw_data = URI.open(api_url).read
    items = JSON.parse(raw_data)

    # categories = ["備考", "手筋", "戦法", "囲い"]
    categories = ["戦法", "囲い", "手筋", "備考"]
    group = items.group_by { |e| e["種類"] }
    sorted_items = categories.flat_map do |category|
      # group[category].sort_by { |e| -e["人気度"] }
      group[category].sort_by do |e|
        if tag = Bioshogi::Analysis::TagIndex.lookup(e["名前"])
          tag.code
        else
          Float::INFINITY
        end
      end
    end

    all_names = sorted_items.collect { |e| e["名前"] }.uniq
    sorted_names = top_names + (all_names - top_names)

    sorted_names
  end

  def as_json
    aggregate.as_json
  end

  def display
    puts JSON.pretty_generate(as_json)
  end
end

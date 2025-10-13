import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"
import { Gs } from "@/components/models/gs.js"
import { Quiz } from "./quiz.js"

export class QuizTemplateInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      // 笑える系
      { subject: "朝起きて最初にするのは？", left_value: "スマホチェック",           right_value: "二度寝",               },
      { subject: "おにぎりを握るなら？",     left_value: "三角",                     right_value: "俵型",                 },

      // スプラトゥーン
      { subject: "朝食はどっち派？",               left_value: "ごはん",                   right_value: "パン",                     },
      // { subject: "どっちがお好き？",               left_value: "赤いきつね",               right_value: "緑のたぬき",               },
      { subject: "午後の紅茶対決！",               left_value: "レモンティー",             right_value: "ミルクティー",             },
      { subject: "自分を例えるなら？",             left_value: "キリギリス",               right_value: "アリ",                     },
      { subject: "まんざいするなら？",             left_value: "ボケ",                     right_value: "ツッコミ",                 },
      { subject: "どっちが好き？",                 left_value: "イカ",                     right_value: "タコ",                     },
      { subject: "世界を救うのはどっち？",         left_value: "愛",                       right_value: "おカネ",                   },
      { subject: "食べたいのはどっち？",           left_value: "山の幸",                   right_value: "海の幸",                   },
      { subject: "欲しいのはどっち？",             left_value: "カンペキなカラダ",         right_value: "カンペキな頭脳",           },
      // { subject: "どっちを選ぶ？",                 left_value: "ポケモン赤",               right_value: "ポケモン緑",               },
      { subject: "どっち派？",                     left_value: "ガンガンいこうぜ",         right_value: "いのちだいじに",           },
      { subject: "おにぎりの具といえば？",         left_value: "ツナマヨ",                 right_value: "紅しゃけ",                 },
      { subject: "行くならどっち？",               left_value: "オシャレなパーティ",       right_value: "コスプレパーティ",         },
      { subject: "どっち派？",                     left_value: "きのこの山",               right_value: "たけのこの里",             },
      { subject: "どっちを聴く？",                 left_value: "ロック",                   right_value: "ポップ",                   },
      { subject: "どっちがお好き？",               left_value: "マヨネーズ",               right_value: "ケチャップ",               },
      { subject: "からあげにレモンかける？",       left_value: "かける",                   right_value: "かけない",                 },
      { subject: "どっちを観る？",                 left_value: "アクション",               right_value: "コメディ",                 },
      { subject: "どっちを応援する？",             left_value: "王者",                     right_value: "挑戦者",                   },
      { subject: "どっちを選ぶ？",                 left_value: "花",                       right_value: "団子",                     },
      { subject: "どっちが好み？",                 left_value: "つぶあん",                 right_value: "こしあん",                 },
      { subject: "どっちになりたい？",             left_value: "騎士",                     right_value: "魔法使い",                 },
      { subject: "どっちが勝つ？",                 left_value: "ウサギ",                   right_value: "カメ",                     },
      { subject: "酢豚にパイン入ってるのって",     left_value: "ナシ",                     right_value: "アリ",                     },
      { subject: "どっちの世界を望む？",           left_value: "混沌",                     right_value: "秩序",                     },

      // ChatGPT
      // { subject: "決闘に持参するのは？",        left_value: "剣",                       right_value: "銃",                       },
      { subject: "旅行に行くなら？",               left_value: "海外",                     right_value: "国内",                     },
      { subject: "どっちが好み？",                 left_value: "和食",                     right_value: "洋食",                     },
      // { subject: "スポーツするなら？",          left_value: "個人競技",                 right_value: "団体競技",                 },
      // { subject: "ドラマはどっちが好み？",      left_value: "コメディもの",             right_value: "サスペンスもの",           },
      // { subject: "音楽聞くなら？",              left_value: "邦楽",                     right_value: "洋楽",                     },
      { subject: "どっち派？",                     left_value: "インドア派",               right_value: "アウトドア派",             },
      // { subject: "クルマ買うなら？",               left_value: "国産車",                   right_value: "外車",                     },
      { subject: "映画を見るなら？",               left_value: "SF",                       right_value: "ホラー",                   },
      { subject: "ペットを飼うなら？",             left_value: "猫",                       right_value: "犬",                       },
      { subject: "犬を飼うなら？",                 left_value: "ゴールデンレトリバー",     right_value: "ボーダーコリー",           },
      { subject: "どっちがお好き？",               left_value: "和菓子",                   right_value: "洋菓子",                   },
      { subject: "アニメ見るなら？",               left_value: "青春もの",                 right_value: "ファンタジーもの",         },
      { subject: "どっちがお好き？",               left_value: "文系",                     right_value: "理系",                     },
      { subject: "どっちがお好み？",               left_value: "もんじゃ焼き",             right_value: "お好み焼き",               },
      { subject: "どっちがお好み？",               left_value: "メロン",                   right_value: "スイカ",                   },
      { subject: "休日は？",                       left_value: "のんびり過ごす",           right_value: "アクティブに過ごす",       },
      // { subject: "スマホを持つなら？",             left_value: "iPhone",                   right_value: "Android",                  },
      { subject: "パソコン使うなら？",             left_value: "Mac",                      right_value: "Windows",                  },
      { subject: "どっちがお好み？",               left_value: "ビール",                   right_value: "ワイン",                   },
      { subject: "どっちがお好み？",               left_value: "小説",                     right_value: "漫画",                     },
      { subject: "どちらに行きたい？",             left_value: "山",                       right_value: "海",                       },
      { subject: "どっちを読みたい？",             left_value: "芥川賞",                   right_value: "直木賞",                   },
      // { subject: "どっちを読みたい？",             left_value: "伊坂幸太郎",               right_value: "奥田英郎",                 },
      // { subject: "どっちを読みたい？",             left_value: "東野圭吾",                 right_value: "伊坂幸太郎",               },
      // { subject: "どっちを読みたい？",             left_value: "歌野晶午",                 right_value: "東野圭吾",                 },
      // { subject: "どっちを読みたい？",             left_value: "松本清張",                 right_value: "横山秀夫",                 },
      { subject: "自転車乗るなら？",               left_value: "ロードバイク",             right_value: "クロスバイク",             },

      { subject: "読書するなら？",                 left_value: "ミステリー小説",           right_value: "ノンフィクション小説",     },
      // { subject: "AIがこれ以上進化すると？",       left_value: "心配",                     right_value: "平気",                     },
      // { subject: "台風が来ると？",                 left_value: "嬉しくなる",               right_value: "心配になる",               },

      // 将棋編
      // { subject: "三間飛車のイメージは？",         left_value: "職人",                     right_value: "陰湿",                     },
      { subject: "将棋漫画といえば？",             left_value: "月下の棋士",               right_value: "ハチワンダイバー",         },
      // { subject: "将棋の勉強をするなら？",         left_value: "詰将棋",                   right_value: "次の一手",                 },

      // ゲーム
      // { subject: "スト2といえば？",                left_value: "リュウ",                   right_value: "春麗",                     },
      // { subject: "スト2どっちが強い？",            left_value: "ガイル",                   right_value: "ダルシム",                 },
      // { subject: "テトリスはどっちを開ける？",     left_value: "右",                       right_value: "左",                       },

      // アニメ
      // { subject: "京アニの作品どっちが好き？",     left_value: "けいおん！",               right_value: "氷菓",                     },
      // { subject: "アニメどっちが好き？",           left_value: "STEINS;GATE",              right_value: "エヴァンゲリオン",         },
      // { subject: "アニメどっちが好き？",           left_value: "キルラキル",               right_value: "化物語",                   },
      // { subject: "アニメどっちが好き？",           left_value: "がっこうぐらし",           right_value: "ひぐらしのなく頃に",       },
      // { subject: "アニメどっちが好き？",           left_value: "僕は友達が少ない",         right_value: "とらドラ",                 },

      // 映画
      { subject: "ジブリ作品どっちがお好み？",     left_value: "天空の城ラピュタ",         right_value: "風の谷のナウシカ",         },
      { subject: "ジブリ作品どっちがお好み？",     left_value: "コクリコ坂から",           right_value: "耳をすませば",             },
      { subject: "ジブリ作品どっちがお好み？",     left_value: "紅の豚",                   right_value: "風立ちぬ",                 },
      { subject: "どっちがお好み？",               left_value: "君の名は",                 right_value: "天気の子",                 },
      // { subject: "どっちがお好み？",               left_value: "シックスセンス",           right_value: "トップガン",               },
      // { subject: "どっちがお好み？",               left_value: "ロードオブザリング",       right_value: "タイタニック",             },
      // { subject: "どっちがお好み？",               left_value: "バックトゥザフューチャー", right_value: "アバター",                 },
      // { subject: "どっちがお好み？",               left_value: "ニューシネマパラダイス",   right_value: "ショーシャンクの空に",     },
      // { subject: "どっちがお好み？",               left_value: "カメラを止めるな！",       right_value: "SAW",                      },
      { subject: "どっちがお好み？",               left_value: "スタンドバイミー",         right_value: "グーニーズ",               },

      // 食べ物
      // { subject: "ラーメンに白飯は？",             left_value: "アリ",                     right_value: "ナシ",                     },
      // { subject: "どっちがお好み？",               left_value: "ピザ",                     right_value: "寿司",                     },
      { subject: "どっちがお好み？",               left_value: "ハンバーガー",             right_value: "ラーメン",                 },
      { subject: "どっちがお好み？",               left_value: "カレーライス",             right_value: "オムライス",               },
      { subject: "どっちがお好み？",               left_value: "牛丼",                     right_value: "天丼",                     },
      { subject: "どっちがお好み？",               left_value: "あんぱん",                 right_value: "クリームパン",             },
      // { subject: "どっちがお好み？",               left_value: "グラタン",                 right_value: "シチュー",                 },
      { subject: "どっちがお好み？",               left_value: "オムレツ",                 right_value: "カレー",                   },
      // { subject: "どっちがお好み？",               left_value: "シュークリーム",           right_value: "エクレア",                 },
      { subject: "どっちがお好み？",               left_value: "じゃがいも",               right_value: "さつまいも",               },
      // { subject: "どっちがお好み？",               left_value: "麻婆豆腐",                 right_value: "回鍋肉",                   },
      // { subject: "どっちがお好み？",               left_value: "キャロットケーキ",         right_value: "チーズケーキ",             },
      // { subject: "どっちがお好み？",               left_value: "カリフラワー",             right_value: "ブロッコリー",             },
      // { subject: "どっちがお好み？",               left_value: "焼きそば",                 right_value: "かた焼きそば",             },
      { subject: "どっちがお好み？",               left_value: "塩ラーメン",               right_value: "味噌ラーメン",             },
      { subject: "どっちがお好み？",               left_value: "りんご",                   right_value: "梨",                       },
      // { subject: "どっちがお好み？",               left_value: "そば",                     right_value: "スパゲッティ",             },
      { subject: "どっちがお好み？",               left_value: "そば",                     right_value: "うどん",                   },
      // { subject: "どっちがお好み？",               left_value: "たい焼き",                 right_value: "今川焼き",                 },
      // { subject: "どっちがお好み？",               left_value: "プリン",                   right_value: "茶碗蒸し",                 },

      // 動物
      { subject: "どっちが好き？",                 left_value: "カブトムシ",               right_value: "クワガタムシ",             },

      // スポーツ
      // { subject: "卓球するなら？",                 left_value: "ペン",                     right_value: "シェーク",                 },
      // { subject: "卓球するなら？",                 left_value: "ドライブマン",             right_value: "カットマン",               },

      // ゲーム
      // { subject: "どっちがお好み？",               left_value: "Life is Strange",          right_value: "Detroit: Become Human",    },
      // { subject: "どっちがお好み？",               left_value: "スプラトゥーン",           right_value: "マリオカート",             },
      // { subject: "どっちがお好み？",               left_value: "スプラトゥーン",           right_value: "スマブラ",                 },
      { subject: "RPGと言えば？",                  left_value: "FF",                          right_value: "ドラクエ",                 },
      // { subject: "レースゲームするなら？",         left_value: "グランツーリスモ",         right_value: "リッジレーサー",           },
      // { subject: "レースゲームするなら？",         left_value: "グランツーリスモ",         right_value: "マリオカート",             },
      // { subject: "どっちがお好み？",               left_value: "スペランカー",             right_value: "アトランチスの謎",         },
      // { subject: "ゲームやるなら？",               left_value: "夢工場ドキドキパニック",   right_value: "スーパーマリオブラザーズ", },
      // { subject: "ゲームやるなら？",               left_value: "いっき",                   right_value: "スペランカー",             },
      // { subject: "落ちゲーやるなら？",             left_value: "ぷよぷよ",                 right_value: "テトリス",                 },
      // { subject: "ゲームやるなら？",               left_value: "アイスクライマー",         right_value: "レッキングクルー",         },
      // { subject: "ゲームやるなら？",               left_value: "たけしの挑戦状",           right_value: "バンゲリングベイ",         },
      // { subject: "ゲームやるなら？",               left_value: "ロードランナー",           right_value: "ボンバーマン",             },
      // { subject: "STGやるなら？",                  left_value: "ゼビウス",                 right_value: "ツインビー",               },
      // { subject: "STGやるなら？",                  left_value: "ザナック",                 right_value: "スターソルジャー",         },
      // { subject: "STGやるなら？",                  left_value: "グラディウス",             right_value: "R-TYPE",                   },
      // { subject: "ゲームやるなら？",               left_value: "バンゲリングベイ",         right_value: "スターフォース",           },
      // { subject: "格ゲーやるなら？",               left_value: "スパルタンX",              right_value: "カラテカ",                 },
      // { subject: "格ゲーやるなら？",               left_value: "イー・アル・カンフー",     right_value: "ストリートファイター",     },
      // { subject: "アドベンチャーゲームやるなら？", left_value: "ポートピア連続殺人事件",   right_value: "ファミコン探偵倶楽部",     },
      // { subject: "恋愛ｼﾐｭﾚｰｼｮﾝｹﾞｰﾑといえば？",     left_value: "中山美穂のﾄｷﾒｷﾊｲｽｸｰﾙ",     right_value: "ときめきメモリアル",       },
      // { subject: "ゲームやるなら？",               left_value: "アマガミ",                 right_value: "キミキス",                 },

      // その他
      { subject: "事務所入るなら？",               left_value: "ホロライブ",               right_value: "にじさんじ",               },
      // { subject: "左利きに？",                     left_value: "あこがれる",               right_value: "あこがれない",             },
      // { subject: "早起きは？",                     left_value: "得",                       right_value: "損",                       },
      // { subject: "飛行機に乗ったこと",             left_value: "ある",                     right_value: "ない",                     },
      // { subject: "AT限定免許",                      left_value: "恥ずかしい",               right_value: "恥ずかしくない",           },
      // { subject: "熱帯魚を飼うなら？",             left_value: "ネオンテトラ",             right_value: "グッピー",                 },
      // { subject: "彼岸花をみて感じるのは",         left_value: "不吉",                     right_value: "情熱",                     },
      { subject: "夏の植物と言えば？",             left_value: "あさがお",                 right_value: "ひまわり",                 },
      // { subject: "どっち派？",                     left_value: "断捨離",                   right_value: "コレクター",               },
      // { subject: "認知症は？",                     left_value: "こわい",                   right_value: "気にしてない",             },
      // { subject: "食品添加物は？",                 left_value: "なるべく避ける",           right_value: "気にしたことがない",       },
    ]
  }

  static get sample() {
    return Gs.ary_sample(this.values)?.to_quiz
  }

  get to_quiz() {
    return Quiz.create({subject: this.subject, items: this.shuffled_items})
  }

  get shuffled_items() {
    return Gs.ary_shuffle([this.left_value, this.right_value])
  }
}

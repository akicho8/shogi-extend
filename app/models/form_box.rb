# フォームのinputをハッシュから構築する
#
#   ツールチップを設定するには？
#
#     :tooltip => "x",
#     :popover => {:title => "x", :content => "x"},
#     :popover => "x",  # この場合はラベルがタイトルに入る
#
#   値を変更させずに値を返すには？
#
#     :freeze => true
#
#   disabled や readonly を簡単に使いたい
#
#     かわりに freeze を使うこと。
#     readonly にしてもセレクトボックスは「変更できる」あいまい仕様のため使わない方がいい
#     disabled にすると固定されるけど、今度は値が送られない
#     なので freeze オプションをつければ「hidden_buildを埋め込みつつdisabled」にする
#
#   type はそのままで一時的に hidden 化するには？
#
#     :hidden => true
#
#   ラベルのツールチップ何かを表示するには？
#
#     :tooltip => "あ"
#
#   ラベルのツールチップにキーを表示するには？
#
#     :tooltip => true
#
#   ラベルのツールチップの本文にも表示するには？
#
#     :tooltip => true
#     :toolbody => "本文"
#
module FormBox
  class << self
    def hash_to_hidden_form_parts(hash)
      hash.collect { |k, v|
        if v.kind_of?(Hash)
          raise "FIXME: v がハッシュの場合はここで展開しないといけない"
        end
        {
          :key     => k,
          :type    => :hidden,
          :default => v,          # 配列は内部で展開する
        }
      }
    end

    # def inputs_render(*args)
    #   Default.inputs_render(*args)
    # end

    # def form_box_example_form_parts(binding)
    #   example_str_form_parts.collect { |e| eval(e, binding) }
    # end

    # フォームパーツ例
    def example_str_form_parts
      [
        <<~EOT,
      {
        :label        => "固定テキスト",
        :type         => :static,
        :default      => "あいうえお",
      }
      EOT
        <<~EOT,
      {
        :label        => "テキスト入力",
        :key          => :str1,
        :type         => :string,
        :default      => params[:str1].presence || "初期値",
      }
      EOT
        <<~EOT,
      {
        :label        => "ラジオボタン(選択肢がハッシュ)",
        :key          => :key1,
        :type         => :radio,
        :elems        => {"選択1" => :v1, "選択2" => :v2, "選択3" => :v3},
        :default      => params[:key1].presence || :v1,
      }
      EOT
        <<~EOT,
      {
        :label        => "ラジオボタン(選択肢が配列)",
        :key          => :key1a,
        :type         => :radio,
        :elems        => [:v1, :v2, :v3],
        :default      => params[:key1a].presence || :v1,
      }
      EOT
        <<~EOT,
      {
        :label        => "チェックボックス(選択肢がハッシュ)",
        :key          => :key4,
        :type         => :check_box,
        :elems        => {"選択1" => :v1, "選択2" => :v2, "選択3" => :v3},
        :default      => params[:key4].presence || "v1",
      }
      EOT
        <<~EOT,
      {
        :label        => "チェックボックス(選択肢が配列の場合)",
        :key          => :key5,
        :type         => :check_box,
        :elems        => [:r, :w, :x],
        :default      => params[:key5].to_s.scan(/\w+/).presence || [:r, :x],
      }
      EOT
        <<~EOT,
      {
        :label        => "ラジオボタン(選択肢が配列)",
        :key          => :key3,
        :type         => :radio,
        :elems        => [10, 20, 30, 50, 100],
        :default      => params[:key3].presence || 10,
      }
      EOT
        <<~EOT,
      {
        :label        => "ブーリアン",
        :right_label  => "右側に表示する文字列",
        :key          => :key6,
        :type         => :boolean,
        :default      => params[:key6].presence || "true",
      }
      EOT
        <<~EOT,
      {
        :label        => "プルダウン(選択肢がハッシュ)",
        :key          => :key2,
        :type         => :select,
        :elems        => {"選択1" => :v1, "選択2" => :v2, "選択3" => :v3},
        :default      => params[:key2].presence || "v1",
      }
      EOT
        <<~EOT,
      {
        :label        => "プルダウン(選択肢がハッシュの、アイテム選択例)",
        :key          => :item_id,
        :type         => :select,
        :elems        => {"薬草" => :yakusou, "こんぼう" => :konbou},
        :default      => params[:item_id].presence,
      }
      EOT
        <<~EOT,
      {
        :label        => "プルダウン(複数選択可)",
        :key          => :key2a,
        :type         => :select,
        :multiple     => true,
        :elems        => {"選択1" => "v1", "選択2" => "v2", "選択3" => "v3"},
        :default      => params[:key2a].presence || ["v1", "v3"],
      }
      EOT
        <<~EOT,
      {
        :label        => "ネストしたプルダウン",
        :key          => :key2b,
        :type         => :nested_select,
        :elems        => {
          "あ"        => {"悪口雑言" => 1, "悪逆無道" => 2},
          "い"        => {"一病息災" => 3, "一朝一夕" => 4},
        },
        :default      => params[:key2b].presence || 2,
      }
      EOT
        <<~EOT,
      {
        :label        => "ファイル(複数)",
        :key          => :key_f,
        :type         => :file,
        :multiple     => true,
      }
      EOT
        <<~EOT,
      {
        :label        => "日時入力",
        :key          => :key7,
        :type         => :datetime,
        :default      => params[:key7].presence || "2001/02/03 01:02",
      }
      EOT
        <<~EOT,
      {
        :label        => "日時入力(分まで)",
        :key          => :key7a,
        :type         => :datetime,
        :second_skip  => true,
        :default      => params[:key7].presence || "2001/02/03 01:02",
      }
      EOT
        <<~EOT,
      {
        :label        => "日付入力",
        :key          => :key8,
        :type         => :date,
        :default      => params[:key8].presence || "2001/02/03",
      }
      EOT
        <<~EOT,
      {
        :label        => "日時入力(datetime_picker)",
        :key          => :key7,
        :type         => :datetime_picker,
        :default      => params[:key8a].presence || "2001/02/03 01:02",
      }
      EOT
        <<~EOT,
      {
        :label        => "日付入力(date_picker)",
        :key          => :key7,
        :type         => :date_picker,
        :default      => params[:key8ab].presence || "2001/02/03 01:02",
      }
      EOT
        <<~EOT,
      {
        :label        => "文章入力系",
        :key          => :text1,
        :type         => :text,
        :default      => params[:text1].presence || "はじめまして",
      }
      EOT
        <<~EOT,
      {
        :label        => "hidden",
        :key          => :key60,
        :type         => :hidden,
        :default      => params[:key60].presence || "foo",
      }
      EOT
        <<~EOT,
      {
        :label        => "boolean (変更不可+hidden_field)",
        :key          => :key50,
        :type         => :boolean,
        :default      => params[:key50].presence || "true",
        :freeze       => true,
      }
      EOT
        <<~EOT,
      {
        :label        => "check_box (変更不可+hidden_field)",
        :key          => :key51,
        :type         => :check_box,
        :elems        => ["true", "false"],
        :default      => params[:key51].presence || "true",
        :freeze       => true,
      }
      EOT
        <<~EOT,
      {
        :label        => "表示幅変更(廃止予定)",
        :key          => :str2,
        :type         => :string,
        :default      => "初期値",
        :right_width  => 5, # ← 幅の係数
        :help_message => "ここの説明",
      }
      EOT
      ]
    end
  end
end

# ls_sync の引数まとめ
#
# |--------------------------------------------------------------------------------+-------------------------------------------------|
# | localStorage 同期設定                                                          | 意味                                            |
# |--------------------------------------------------------------------------------+-------------------------------------------------|
# | { global_key: :a, child_key: :b, loader: :force,  writer: :force }             | localStorage[:a] を読み書きする (基本)          |
# | { parent_key: :a, child_key: :b, loader: :force,  writer: :force }             | localStorage[:a][:b] を読み書きする             |
# | { global_key: :a, child_key: :b, loader: :skip,   writer: :skip  }             | 読み出しも書き込みもしない (指定なしと同じ)     |
# | { global_key: :a, child_key: :b, loader: :if_default_is_nil, writer: :force  } | サーバー側から送った値が nil のときだけ読み出す |
# |--------------------------------------------------------------------------------+-------------------------------------------------|
#
# - loader は force, skip, if_default_is_nil の3択
# - writer は force, skip の2択

module QuickScript
  module Dev
    class FormScript < Base
      self.title = "form"
      self.description = "form_parts のテスト"
      self.form_method = :get

      def form_parts
        super + [
          {
            :label   => "hidden",
            :key     => :hidden1,
            :type    => :hidden,
            :default => params[:hidden1].presence || "(hidden)",
          },
          {
            :label   => "file",
            :key     => :file1,
            :type    => :file,
            :default => nil,
          },

          ################################################################################ 文字列

          {
            :label        => "string",
            :key          => :str1_a,
            :type         => :string,
            :default      => params[:str1_a].presence || "a",
            :help_message => "補完: なし",
          },
          {
            :label        => "string",
            :key          => :str1_b,
            :type         => :string,
            :ac_by        => :html5,
            :elems        => ["foo", "bar", "baz"],
            :default      => params[:str1_b].presence || "a",
            :help_message => "補完: HTML5 の datalist",
          },
          {
            :label        => "string ",
            :key          => :str1_c,
            :type         => :string,
            :ac_by        => :b_autocomplete,
            :elems        => ["foo", "bar", "baz"],
            :default      => params[:str1_c].presence || "a",
            :help_message => "補完: Buefy の b-autocomplete",
          },

          ################################################################################ 多数の中から選択

          {
            :label   => "select (array)",
            :key     => :select1,
            :type    => :select,
            :elems   => ["a", "b", "c"],
            :default => params[:select1].presence || "a",
          },
          {
            :label   => "select (hash)",
            :key     => :select2,
            :type    => :select,
            :elems   => {"a" => "選択1", "b" => "選択2", "c" => "選択3"},
            :default => params[:select2].presence || "a",
          },

          ################################################################################

          {
            :label   => "タグ入力",
            :key     => :tag1,
            :type    => :taginput,
            :elems   => ["foo", "bar", "baz"],
            :default => params[:tag1].presence || "",
          },

          ################################################################################


          {
            :label   => "static",
            :key     => :static1,
            :type    => :static,
            :default => params[:static1].presence || "固定文字列",
            :help_message => "(help_message)",
          },

          ################################################################################

          {
            :label   => "localStorage 同期",
            :key     => :str_ls,
            :type    => :string,
            :default => params[:str_ls].presence || "(string)",
            :ls_sync => { parent_key: :"(parent_key)", child_key: :str_ls, loader: :force, writer: :force }, # localStorage["(parent_key)"].update(str_ls: "値")
            # :ls_sync => {global_key: :str_ls, loader: :force, writer: :force },                      # localStorage["str_ls"] = "値"
            # :ls_sync => {global_key: :str_ls, loader: :if_default_is_nil, writer: :force },                      # loader: :if_default_is_nil なら default: nil なら localStorage の方を書き込む
            :help_message => "最初の fetch の直後に localStorage の方が null でなければ上書きし GET POST したタイミングで localStorage に書き込む。バリデーションはない。",
          },

          ################################################################################

          {
            :label   => "text",
            :key     => :text1,
            :type    => :text,
            :default => params[:text1].presence || "(text)",
          },
          {
            :label   => "integer",
            :key     => :int1,
            :type    => :numeric,
            :default => (params[:int1].presence || "1").to_i,
          },

          {
            :label   => "radio (array)",
            :key     => :radio1,
            :type    => :radio_button,
            :elems   => ["a", "b", "c"],
            :default => params[:radio1].presence || "a",
          },
          {
            :label   => "radio (hash)",
            :key     => :radio2,
            :type    => :radio_button,
            :elems   => {"a" => "選択1", "b" => "選択2", "c" => "選択3"},
            :default => params[:radio2].presence || "a",
          },
          {
            :label   => "checkbox (array)",
            :key     => :checkbox1,
            :type    => :checkbox_button,
            :elems   => ["a", "b", "c"],
            :default => Array(params[:checkbox1].presence || "a"),
          },
          {
            :label   => "チェックボックスで elems の要素が1つの文字列の場合",
            :key     => :checkbox2,
            :type    => :checkbox_button,
            :elems   => "a",
            :default => Array(params[:checkbox1].presence || "a"),
          },
        ]
      end

      def call
        params
      end
    end
  end
end

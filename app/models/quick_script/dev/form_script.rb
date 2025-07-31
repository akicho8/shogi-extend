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
      self.title = "フォーム入力要素のテスト"
      self.description = "form_parts のテスト"
      self.form_method = :get

      def form_parts
        super + [
          {
            :label   => "hidden",
            :key     => :hidden1,
            :type    => :hidden,
            :dynamic_part => -> {
              {
                :default => params[:hidden1].presence || "(hidden)",
              }
            },
          },
          {
            :label   => "file",
            :key     => :file1,
            :type    => :file,
            :dynamic_part => -> {
              {
                :default => nil,
              }
            },
          },

          ################################################################################ 文字列

          {
            :label        => "string",
            :key          => :str1_a,
            :type         => :string,
            :dynamic_part => -> {
              {
                :default => params[:str1_a].presence || "a",
                :help_message => "補完: なし",
              }
            },
          },
          {
            :label        => "string (html5)",
            :key          => :str1_b,
            :type         => :string,
            :dynamic_part => -> {
              {
                :auto_complete_by => :html5,
                :elems            => ["foo", "bar", "baz"],
                :default          => params[:str1_b].presence || "a",
                :help_message     => "補完: HTML5 の datalist",
              }
            },
          },
          {
            :label        => "string (b_autocomplete)",
            :key          => :str1_c,
            :type         => :string,
            :dynamic_part => -> {
              {
                :auto_complete_by => :b_autocomplete,
                :elems            => ["foo", "bar", "baz"],
                :default          => params[:str1_c].presence || "a",
                :help_message     => "補完: Buefy の b-autocomplete",
              }
            },
          },
          ################################################################################ 多数の中から選択

          {
            :label   => "select (array)",
            :key     => :select1,
            :type    => :select,
            :dynamic_part => -> {
              {
                :elems   => ["a", "b", "c"],
                :default => params[:select1].presence || "a",
              }
            },
          },
          {
            :label   => "select (hash)",
            :key     => :select2,
            :type    => :select,
            :dynamic_part => -> {
              {
                :elems   => { "a" => "選択1", "b" => "選択2", "c" => "選択3" },
                :default => params[:select2].presence || "a",
              }
            }
          },
          ################################################################################

          {
            :label   => "タグ入力",
            :key     => :tag1,
            :type    => :b_taginput,
            :dynamic_part => -> {
              {
                :elems   => ["foo", "bar", "baz"],
                :default => params[:tag1].presence || "",
              }
            },
          },

          ################################################################################

          {
            :label   => "static",
            :key     => :static1,
            :type    => :static,
            :dynamic_part => -> {
              {
                :default => params[:static1].presence || "固定文字列",
                :help_message => "変更はできないがフォームにポストする。key を nil にすればポストしない。",
              }
            },
          },

          {
            :label   => "real_static_value",
            :key     => nil,
            :type    => :real_static_value,
            :dynamic_part => -> {
              {
                :value => h_stack([
                    { _nuxt_link: "リンク1", _v_bind: { to: { name: "lab-qs_group_key-qs_page_key", params: { qs_group_key: "dev", qs_page_key: "calc" }, query: { lhv: 100 }, }, }, :class => "has-text-weight-bold", },
                    { _nuxt_link: "リンク2", _v_bind: { to: { name: "lab-qs_group_key-qs_page_key", params: { qs_group_key: "dev", qs_page_key: "calc" }, query: { lhv: 100 }, }, }, :class => "has-text-weight-bold", },
                  ]),
                :help_message => "static とは異なり、value を本文のように表示する。key は nil にしておくこと。",
              }
            },
          },

          ################################################################################

          {
            :label   => "localStorage 同期",
            :key     => :str_ls,
            :type    => :string,
            :ls_sync => { parent_key: :"(parent_key)", child_key: :str_ls, loader: :force, writer: :force }, # localStorage["(parent_key)"].update(str_ls: "値")
            # :ls_sync => {global_key: :str_ls, loader: :force, writer: :force },                      # localStorage["str_ls"] = "値"
            # :ls_sync => {global_key: :str_ls, loader: :if_default_is_nil, writer: :force },                      # loader: :if_default_is_nil なら default: nil なら localStorage の方を書き込む
            :dynamic_part => -> {
              {
                :default => params[:str_ls].presence || "(string)",
                :help_message => "最初の fetch の直後に localStorage の方が null でなければ上書きし GET POST したタイミングで localStorage に書き込む。バリデーションはない。",
              }
            },
          },

          ################################################################################

          {
            :label   => "text",
            :key     => :text1,
            :type    => :text,
            :dynamic_part => -> {
              {
                :default => params[:text1].presence || "(text)",
              }
            },
          },
          {
            :label   => "integer",
            :key     => :int1,
            :type    => :numeric,
            :dynamic_part => -> {
              {
                :default => (params[:int1].presence || "1").to_i,
              }
            },
          },

          {
            :label   => "radio (array)",
            :key     => :radio1,
            :type    => :radio_button,
            :dynamic_part => -> {
              {
                :elems   => ["a", "b", "c"],
                :default => params[:radio1].presence || "a",
              }
            },
          },
          {
            :label   => "radio (hash)",
            :key     => :radio2,
            :type    => :radio_button,
            :dynamic_part => -> {
              {
                :elems   => { "a" => "選択1", "b" => "選択2", "c" => "選択3" },
                :default => params[:radio2].presence || "a",
              }
            },
          },

          ################################################################################

          {
            :label   => "checkbox (array)",
            :key     => :checkbox1,
            :type    => :checkbox_button,
            :dynamic_part => -> {
              {
                :elems   => ["a", "b", "c"],
                :default => Array(params[:checkbox1].presence || "a"),
              }
            },
          },
          {
            :label   => "チェックボックスで elems の要素が1つの文字列の場合",
            :key     => :checkbox2,
            :type    => :checkbox_button,
            :dynamic_part => -> {
              {
                :elems   => "a",
                :default => Array(params[:checkbox1].presence || "a"),
              }
            },
          },

          # checkbox_button の場合は次のようにしないとだめかも ← いや不要
          #
          #   {
          #     :label        => "ログレベル",
          #     :key          => :log_level_keys,
          #     :type         => :checkbox_button,
          #     :dynamic_part => -> {
          #       {
          #         :elems   => LogLevelInfo.form_part_elems,
          #         :default => log_level_keys,
          #       }
          #     },
          #   },
          #
          #   def log_level_keys
          #     Array(params[:log_level_keys]).compact_blank
          #   end

          ################################################################################

          {
            :label        => "スイッチ",
            :key          => :switch_key,
            :type         => :b_switch,
            :dynamic_part => -> {
              {
                :on_label => "有効",
                :default  => params[:dl_switch_key],
              }
            },
          },
        ]
      end

      def call
        params
      end
    end
  end
end

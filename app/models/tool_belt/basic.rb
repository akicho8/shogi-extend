module ToolBelt
  class Basic < Base
    private

    def build
      out = super

      if v = h.content_for(:twitter_card_registry)
        out << h.tag.b("twitter_card_registry")
        out << h.tag.pre(v.gsub(/\>/, ">\n"))
      end

      out << h.tag.div(:class => "buttons") do
        [
          link_to_eval("ユーザーセットアップ")                                { "Colosseum::User.setup"                                                   },
          link_to_eval("ユーザー全削除")                                      { "Colosseum::User.destroy_all"                                             },
          link_to_eval("ユーザー追加")                                        { "Colosseum::User.create!"                                                 },
          link_to_eval("1 + 2")                                               { "1 + 2"                                                                   },
          link_to_eval("1 / 0", redirect_to: :root)                           { "1 / 0"                                                                   },
          link_to_eval("find(0)", redirect_to: :root)                         { "Colosseum::User.find(0)"                                                 },
          link_to_eval("部屋作成")                                            { "Colosseum::Battle.create!"                                               },
          link_to_eval("部屋削除")                                            { "Colosseum::Battle.last&.destroy!"                                        },
          link_to_eval("部屋全削除")                                          { "Colosseum::Battle.destroy_all"                                           },
          link_to_eval("flash確認", redirect_to: h.root_path(debug: "true"))  { ""                                                                        },
          link_to_eval("Swars::Battle.destroy_all")                           { "Swars::Battle.destroy_all"                                               },
          link_to_eval("itoshinTV 取り込み", redirect_to: [:swars, :battles]) { "Swars::Battle.user_import(user_key: 'itoshinTV', run_remote: true)"      },
          link_to_eval("misaka_level5 取り込み", redirect_to: [:swars, :battles]) { "Swars::Battle.user_import(user_key: 'misaka_level5', run_remote: true)"      },
          link_to_eval("aika0603 取り込み", redirect_to: [:swars, :battles]) { "Swars::Battle.user_import(user_key: 'aika0603', run_remote: true)"      },
          link_to_eval("chrono_ 取り込み", redirect_to: [:swars, :battles]) { "Swars::Battle.user_import(user_key: 'chrono_', run_remote: true)"      },
          link_to_eval("Yamamoto_Hiroshi 取り込み (指導対局)")                  { "Swars::Battle.user_import(user_key: 'Yamamoto_Hiroshi', run_remote: true)" },
          link_to_eval("kinakom0chi 取り込み")                                { "Swars::Battle.user_import(user_key: 'kinakom0chi', run_remote: true)"    },
          link_to_eval("メール書式確認", redirect_to: "/rails/mailers")       { ""                                                                        },
          link_to_eval("RegularCrawler")                                      { "Swars::Crawler::RegularCrawler.new.run"                                  },
          link_to_eval("FreeBattle.destroy_all")                              { "FreeBattle.destroy_all"                                                  },
          link_to_eval("FreeBattle.setup")                                    { "FreeBattle.setup"                                                        },
          h.link_to("将棋のエラーを発生(盤面なし)", [:root, bioshogi_error1: true], :class => "button is-small"),
          h.link_to("将棋のエラーを発生(盤面あり)", [:root, bioshogi_error2: true], :class => "button is-small"),
          h.link_to("将棋ウォーズ棋譜用紙", [:swars, :battle, id: "devuser1-Yamada_Taro-20190111_230933", formal_sheet: true], :class => "button is-small"),
          h.link_to("将棋ウォーズ棋譜用紙(デバッグ)", [:swars, :battle, id: "devuser1-Yamada_Taro-20190111_230933", formal_sheet: true, formal_sheet_debug: true], :class => "button is-small"),
          h.link_to("将棋ウォーズ棋譜用紙(白紙)", [:swars, :battle, id: "devuser1-Yamada_Taro-20190111_230933", formal_sheet: true, formal_sheet_blank: true], :class => "button is-small"),

        ].compact.join.html_safe
      end

      list = Colosseum::User.all.limit(25).collect do |e|
        {}.tap do |row|
          row[:id] = h.link_to(e.id, e)
          row[:name] = h.link_to(e.name, e)
          row["操作"] = [
            link_to_eval("login")    { "current_user_set_id(#{e.id})"                                                    },
            link_to_eval("削除")     { "Colosseum::User.find(#{e.id}).destroy!"                                          },
            link_to_eval("online")   { "Colosseum::User.find(#{e.id}).update!(joined_at: Time.current)" if !e.joined_at  },
            link_to_eval("offline")  { "Colosseum::User.find(#{e.id}).update!(joined_at: nil)" if e.joined_at            },
            link_to_eval("logout")   { "reset_session" if e == h.current_user                                            },
            link_to_eval("名前変更") { "Colosseum::User.find(#{e.id}).update!(name: SecureRandom.hex)"                   },
          ].compact.join(" ").html_safe
        end
      end

      out << list.to_html
    end
  end
end

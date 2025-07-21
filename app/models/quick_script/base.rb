# |------------------------------------------------+--------------------------------------------------------------------------|
# | Method                                         | Result                                                                   |
# |------------------------------------------------+--------------------------------------------------------------------------|
# | QuickScript::Dev::FooBarBazScript.qs_group_key | "dev"                                                                    |
# | QuickScript::Dev::FooBarBazScript.qs_page_key  | "foo_bar_baz"                                                            |
# | QuickScript::Dev::FooBarBazScript.qs_key       | "dev/foo_bar_baz"                                                        |
# | QuickScript::Dev::FooBarBazScript.qs_path      | "/lab/dev/foo-bar-baz"                                                   |
# | QuickScript::Dev::FooBarBazScript.qs_url       | "http://localhost:4000/lab/dev/foo-bar-baz"                              |
# | QuickScript::Dev::FooBarBazScript.qs_api_url   | "http://localhost:3000/api/lab/dev/foo_bar_baz.json"                     |
# | QuickScript::Dev::FooBarBazScript.title        | "スクリプト名のテスト"                                                   |
# | QuickScript::Dev::FooBarBazScript.description  | "スクリプト名にハイフンを含むため URL では foo-bar-baz となるのが正しい" |
# |------------------------------------------------+--------------------------------------------------------------------------|

module QuickScript
  class Base
    class << self
      def qs_group_key
        @qs_group_key ||= name.deconstantize.demodulize.underscore
      end

      def qs_page_key
        @qs_page_key ||= name.demodulize.underscore.remove(/_script\z/)
      end

      def qs_key
        @qs_key ||= [qs_group_key, qs_page_key].join("/")
      end

      # ハイフンがつくのはここだけ
      def qs_path
        @qs_path ||= "/" + [path_prefix, qs_key].join("/").dasherize
      end

      def qs_url
        @qs_url ||= UrlProxy.full_url_for(qs_path)
      end

      def qs_api_url(format = :json)
        api_server_root_url + "api" + qs_path.underscore + ".#{format}"
      end

      def qs_group_info
        QsGroupInfo.fetch(qs_group_key)
      end

      def title_for_index
        if false
          title.to_s.remove(/\A#{qs_group_info.name}\s*/) # "将棋ウォーズ囚人検索" => "囚人検索"
        else
          title
        end
      end

      def api_server_root_url
        url_helpers.url_for(:root)
      end

      def url_helpers
        Rails.application.routes.url_helpers
      end

      def __script_meta__
        {
          :qs_group_key  => qs_group_key,
          :qs_page_key   => qs_page_key,
          :qs_path       => qs_path,
          :qs_group_info => qs_group_info,
        }
      end

      private

      def path_prefix
        "lab"
      end
    end

    begin
      class_attribute :deep_subclasses, default: []

      class << self
        attr_accessor :abstract_script # 有効にすると Dispatcher.all に現れなくなる
      end

      def self.inherited(subclass)
        super
        deep_subclasses << subclass
      end
    end

    class_attribute :title,       default: nil
    class_attribute :description, default: nil
    class_attribute :debug_mode,  default: false

    attr_accessor :params

    delegate :url_helpers, to: :"self.class"

    def initialize(params = {}, options = {})
      @params = params_deserialize(params)
      @options = default_options.merge(options)
    end

    def default_options
      {}
    end

    def as_json(*)
      {
        :body            => safe_call, # form_parts よりも前で実行すること
        :__script_meta__ => self.class.__script_meta__,
      }
    end

    def before_call
    end

    def call
    end

    def safe_call
      if @__performed__
        raise QuickScriptDoubleCall, self.class.inspect
      end
      before_call
      result = nil
      begin
        result = call
      ensure
        @__performed__ = true
      end
      result
    end

    def meta
      {
        :title        => title,
        :description  => description,
      }
    end

    # fetch() が呼ばれるときのインデックスで 0 から始まる
    # GET のときに初回か、フォームからボタンを押して GET したかの判定に使う
    # 例えばページに飛んだ瞬間にスプレッドシートの出力をさせたくない場合は fetch_index >= 1 で弾けばよい
    def fetch_index
      params[:fetch_index].to_i
    end

    def params_deserialize(params)
      params.dup
    end

    # 必ずいるっぽいやつ
    prepend FormMod
    prepend MetaMod
    prepend BackgroundMod          # for QuickScriptJob
    prepend LayoutMod              # MainNavbar の表示管理など

    # なくてもいいがあると便利なやつ
    prepend Middleware::ControllerMod          # GET POST の判別
    prepend Middleware::SessionMod             # フォーム値の永続化等
    prepend Middleware::PaginationMod
    prepend Middleware::LoginUserMod
    prepend Middleware::ThrottleMod            # 連打対策
    prepend Middleware::ExceptionRescueMod     # 例外を捕捉して表示する
    prepend Middleware::PrimaryErrorMessageMod # 404 のときなどに表示するメッセージを指定する
    prepend Middleware::FlashMod
    prepend Middleware::InvisibleMod
    prepend Middleware::RedirectMod
    prepend Middleware::HelperMod              # for h, tag
    prepend Middleware::BulmaMod               # for bulma_messsage
    prepend Middleware::AutoexecMod
    prepend Middleware::OrderMod               # for index_script.rb
    prepend Middleware::ProcessTypeMod         # process.client か process.server のどちらで呼ばれたか把握する
    prepend Middleware::CustomStyleMod
    prepend Middleware::SidebarMod
    prepend Middleware::ParentLinkMod        # parent_link
    prepend Middleware::TitleLinkMod         # title_link
    prepend Middleware::ComponentWrapperMod  # for v_stack, h_stack
    prepend Middleware::GeneralApiMod        # for as_general_json
    prepend Middleware::HeaderLinkMod
    prepend Middleware::HeadMod              # フォームより上に表示するコンテンツを追加する

    # Middleware だけど他のところにあるやつ
    prepend GoogleApi::Helper      # for hyper_link
  end
end

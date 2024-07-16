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

      def qs_link_path
        @qs_link_path ||= "/" + [Main.path_prefix, qs_key].join("/").dasherize
      end

      def qs_api_url(format = :json)
        Rails.application.routes.url_helpers.url_for(:root) + "api" + qs_link_path.underscore + ".#{format}"
      end

      def qs_group_info
        QsGroupInfo.fetch(qs_group_key)
      end

      def title_for_index
        title.to_s.remove(/\A#{qs_group_info.name}\s*/) # "将棋ウォーズ囚人検索" => "囚人検索"
      end

      def __script_meta__
        {
          :qs_group_key  => qs_group_key,
          :qs_page_key   => qs_page_key,
          :qs_link_path  => qs_link_path,
          :qs_group_info => qs_group_info,
        }
      end
    end

    class_attribute :title,        default: nil
    class_attribute :description,  default: nil

    attr_reader :params

    def initialize(params = {}, options = {})
      @params = params
      @options = {
      }.merge(options)
    end

    def as_json(*)
      {
        :body            => safe_call, # form_parts よりも前で実行すること
        :__script_meta__ => self.class.__script_meta__,
      }
    end

    def call
    end

    def safe_call
      call
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
      params[:__fetch_index__].to_i
    end

    prepend FormMod
    prepend PaginationMod
    prepend LoginUserMod
    prepend ControllerMod
    prepend ThrottleMod
    prepend ExceptionRescueMod     # 例外を捕捉して表示する
    prepend PrimaryErrorMessageMod # 404 のときなどに表示するメッセージを指定する
    prepend FlashMod
    prepend MetaMod
    prepend InvisibleMod
    prepend RedirectMod
    prepend HelperMod
    prepend AutoexecMod
    prepend OrderMod               # for index_script.rb
    prepend ProcessTypeMod         # process.client か process.server のどちらで呼ばれたか把握する
    prepend LayoutMod              # MainNavbar の表示管理など
  end
end

module QuickScript
  class Base
    prepend FormMod
    prepend PaginationMod
    prepend LoginUserMod
    prepend ControllerMod
    prepend ThrottleMod
    prepend ExceptionRescueMod  # 例外を捕捉して表示する
    prepend FlashMod
    prepend MetaMod
    prepend InvisibleMod
    prepend RedirectMod
    prepend HelperMod
    prepend AutoexecMod
    prepend OrderMod            # for index_script.rb
    prepend ProcessTypeMod      # process.client か process.server のどちらで呼ばれたか把握する
    prepend LayoutMod           # MainNavbar の表示管理など

    class << self
      def link_path
        @link_path ||= "/bin/#{qs_group_key}/#{qs_page_key}"
      end

      def qs_group_key
        @qs_group_key ||= name.deconstantize.demodulize.underscore.dasherize
      end

      def qs_group_info
        QsGroupInfo.fetch(qs_group_key)
      end

      def qs_page_key
        @qs_page_key ||= name.demodulize.underscore.remove(/_script\z/).dasherize
      end

      def __script_meta__
        {
          :qs_group_key  => qs_group_key,
          :qs_page_key   => qs_page_key,
          :link_path     => link_path,
          :qs_group_info => qs_group_info,
        }
      end
    end

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

    # fetch() が呼ばれるときのインデックスで 0 から始まる
    # GET のときに初回か、フォームからボタンを押して GET したかの判定に使う
    # 例えばページに飛んだ瞬間にスプレッドシートの出力をさせたくない場合は fetch_index >= 1 で弾けばよい
    def fetch_index
      params[:fetch_index].to_i
    end
  end
end

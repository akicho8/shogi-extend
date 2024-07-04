module QuickScript
  class Base
    prepend PaginationMod
    prepend LoginUserMod
    prepend ControllerMod
    prepend RescueMod
    prepend FlashMod
    prepend MetaMod
    prepend RedirectMod

    attr_reader :params

    class_attribute :button_label, default: "実行"
    class_attribute :get_submit_key, default: "exec"

    class << self
      def link_path
        @link_path ||= "/bin/#{qs_group_key}/#{qs_page_key}"
      end

      def qs_group_key
        @qs_group_key ||= full_parts.first.dasherize
      end

      def qs_group_info
        QsGroupInfo.fetch(qs_group_key)
      end

      def qs_page_key
        @qs_page_key ||= full_parts.last.dasherize
      end

      def full_parts
        @path_parts ||= yield_self do
          path = name.underscore                             # => "quick_script/chore/calc_script"
          path.remove("quick_script/", "_script").split("/") # => ["chore", "calc"]
        end
      end
    end

    def initialize(params = {}, options = {})
      @params = params
      @options = {
      }.merge(options)
    end

    def as_json(*)
      {
        :body                => safe_call, # form_parts よりも前で実行すること
        :qs_page_key              => params[:qs_page_key],
        :button_label        => button_label,
        :get_submit_key      => get_submit_key,
        :form_parts          => form_parts,
        :__received_params__ => params,
      }
    end

    def call
    end

    def safe_call
      call
    end

    private

    def form_parts
      []
    end
  end
end

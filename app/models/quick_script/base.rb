module QuickScript
  class Base
    prepend FormMod
    prepend PaginationMod
    prepend LoginUserMod
    prepend ControllerMod
    prepend ThrottleMod
    prepend RescueMod
    prepend FlashMod
    prepend MetaMod
    prepend RedirectMod
    prepend HelperMod

    attr_reader :params

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
  end
end

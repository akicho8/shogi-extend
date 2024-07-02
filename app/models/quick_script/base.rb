module QuickScript
  class Base
    prepend PaginationMod
    prepend SessionMod

    attr_reader :params

    class_attribute :title, default: nil
    class_attribute :description, default: nil
    class_attribute :og_image_key, default: nil

    class << self
      def link_path
        @link_path ||= "/bin/#{qs_group_key}/#{qs_key}"
      end

      def qs_group_key
        @qs_group_key ||= full_parts.first.dasherize
      end

      def qs_group_info
        QsGroupInfo.fetch(qs_group_key)
      end

      def qs_key
        @qs_key ||= full_parts.last.dasherize
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
        :qs_key                => params[:qs_key],
        :body                => call,
        :body_guess         => body_guess,
        :get_button_show_p   => get_button_show_p,
        :button_label        => button_label,
        :meta                => meta,
        :form_parts          => form_parts,
        :__received_params__ => params,
      }
    end

    def call
    end

    private

    def form_parts
      []
    end

    def get_button_show_p
      false
    end

    def button_label
      "実行"
    end

    # auto, raw_html, pre_string, escaped_string, value_type_is_hash_array
    def body_guess
    end

    def meta
      {
        :title        => title,
        :description  => description,
        :og_image_key => og_image_key,
      }
    end
  end
end

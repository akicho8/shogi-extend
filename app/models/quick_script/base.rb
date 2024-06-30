module QuickScript
  class Base
    attr_reader :params

    class_attribute :title, default: nil
    class_attribute :description, default: nil
    class_attribute :og_image_key, default: nil

    class << self
      def link_path
        @link_path ||= "/bin/#{sgroup}/#{skey}"
      end

      def sgroup
        @sgroup ||= full_parts.first
      end

      def sgroup_info
        SgroupInfo.fetch(sgroup)
      end

      def skey
        @skey ||= full_parts.last
      end

      def full_parts
        @path_parts ||= yield_self do
          path = name.underscore                             # => "quick_script/chore/calc_script"
          path.remove("quick_script/", "_script").split("/") # => ["chore", "calc"]
        end
      end
    end

    attr_accessor :page_params

    def initialize(params = {}, options = {})
      @params = params
      @options = {
      }.merge(options)

      @page_params = {
        :paginated    => false,
        :total        => 0,
        :current_page => 1,
        :per_page     => 100,
      }
    end

    def as_json(*)
      {
        :skey                => params[:skey],
        :body                => call,
        :body_layout         => :auto,
        :get_button_show_p   => get_button_show_p,
        :button_label        => button_label,
        :meta                => meta,
        :form_parts          => form_parts,
        :page_params     => page_params,
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

    # auto, raw_html, pre_string, escaped_string, hash_array_table
    def body_layout
      :auto
    end

    def meta
      {
        :title        => title,
        :description  => description,
        :og_image_key => og_image_key,
      }
    end

    def admin_user
      @options[:admin_user]
    end

    def current_user
      @options[:current_user]
    end
  end
end

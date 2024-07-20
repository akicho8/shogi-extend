# frozen-string-literal: true

module QuickScript
  class Dispatcher
    class << self
      def all
        Rails.autoloaders.main.eager_load_namespace(QuickScript)
        Base.subclasses
      end

      def info
        all.collect do |e|
          {
            :model       => e,
            :qs_key      => e.qs_key,
            "OGP画像"    => e.og_card_path.exist? ? "○" : "",
            :title       => e.title,
            :description => e.description,
          }
        end
      end

      def path_prefix
        :lab
      end

      def dispatch(...)
        new(...).dispatch
      end

      def background_dispatch(params, options)
        options = {
          :current_user    => User.find_by(id: options[:current_user_id]),
          :background_mode => true,
        }
        new(params, options).action.tap(&:call)
      end
    end

    def initialize(params, options = {})
      @params = params
      @options = options

      prepare
    end

    def dispatch
      action.tap(&:render_all)
    end

    def action
      action_klass.new(@params, @options)
    end

    private

    def prepare
      @params = @params.merge({
          :qs_group_key => @params[:qs_group_key].to_s.underscore,
          :qs_page_key  => @params[:qs_page_key].to_s.underscore,
        })

      if @params[:qs_page_key] == "__qs_page_key_is_blank__"
        @params = @params.merge(qs_group_only: @params[:qs_group_key], qs_group_key: "chore", qs_page_key: "index")
      end
    end

    def action_klass
      path = "quick_script/#{@params[:qs_group_key]}/#{@params[:qs_page_key]}_script"
      path.classify.safe_constantize || Chore::NotFoundScript
    end
  end
end

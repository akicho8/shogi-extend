# frozen-string-literal: true

module QuickScript
  class Dispatcher
    class << self
      def all
        @all ||= yield_self do
          Rails.autoloaders.main.eager_load_namespace(QuickScript)
          if false
            # 直下だけなので継承を継承したクラスはでてこない
            Base.subclasses.reject(&:abstract_script)
          else
            # 継承の継承を含む
            Base.deep_subclasses.reject(&:abstract_script)
          end
        end
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
    end

    def dispatch
      action.tap(&:render_anything)
    end

    def action
      parameter.receiver_klass.new(parameter.params, @options)
    end

    def parameter
      @parameter ||= Parameter.new(@params)
    end
  end
end

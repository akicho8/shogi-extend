module ShortUrl
  module Root
    delegate :from, :transform, :[], :key, to: Component

    ################################################################################

    def table_name_prefix
      name.underscore.gsub("/", "_") + "_"
    end

    # rails r 'ShortUrl.setup(reset: true)'
    def setup(options = {})
      if options[:reset]
        ShortUrl.destroy_all
      end
      Component.setup(options)
    end

    def destroy_all
      [
        Component,
      ].each do |e|
        e.find_each(&:destroy!)
      end
    end

    def reset_all
      destroy_all
      setup
    end
  end
end

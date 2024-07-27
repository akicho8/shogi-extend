# |----------------------------------+----------------------------|
# | server side                      | client side                |
# |----------------------------------+----------------------------|
# | redirect_to url                  | this.$router.push(url)     |
# | redirect_to url, type: :hard     | location.href = url        |
# | redirect_to url, type: :tab_open | window.open(url, "_blank") |
# |----------------------------------+----------------------------|

module QuickScript
  module Middleware
    concern :RedirectMod do
      def as_json(*)
        super.merge(redirect_to: @redirect_to_options)
      end

      def redirect_to(path, options = {})
        if @redirect_to_options
          raise QuickScriptDoubleRedirect, "redirect_to を二重に呼ぶべからず : #{path.inspect}"
        end
        @redirect_to_options = { to: path, **options }
        nil
      end

      def page_reload
        redirect_to self.class.qs_url, type: :hard
      end
    end
  end
end

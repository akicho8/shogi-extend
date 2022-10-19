module BackendScript
  class ShellScript < ::BackendScript::Base
    self.category = "コンソール"
    self.script_name = "シェル実行"

    def form_parts
      [
        {
          :label    => "コマンド",
          :key      => :command,
          :type     => :text,
          :default  => current_command,
        },
      ]
    end

    def script_body
      return if !submitted?
      return if !current_command

      stdout, stderr, status = Open3.capture3(current_command, :chdir => Rails.root)
      out = ""
      if stderr.present?
        out << h.bootstrap_label_tag("エラーコード #{status.exitstatus}", :color => :danger)
        out << h.bootstrap_alert(stderr, :tag => :pre, :type => :danger)
      end
      if !stdout.empty?
        out << h.content_tag(:pre, stdout)
      end
      out
    end

    def current_command
      params[:command].presence&.strip
    end
  end
end

module TaskHelper
  def system!(command)
    command.each_line(chomp: true) do |command|
      puts "> \e[1;32m#{command}\e[m"
      system command, exception: true
    end
  end
end

module Princely
  class Executable
    attr_reader :path

    def initialize(path=nil)
      @path = path || default_executable_path

      check_for_executable
    end

    def check_for_executable
      raise "Cannot find prince command-line app in $PATH" if !@path || @path.length == 0
      raise "Cannot find prince command-line app at #{@exe_path}" unless File.executable?(@path)
    end

    def default_executable_path
      if Princely.ruby_platform =~ /mswin32|minigw32/
        "C:/Program Files/Prince/Engine/bin/prince"
      else
        `which prince`.chomp
      end
    end

    def join(options)
      ([path] + Array(options)).join(' ')
    end
  end
end
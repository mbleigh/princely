module Princely
  class PDF
    attr_accessor :exe_path, :style_sheets, :logger, :log_file

    # Initialize method
    #
    def initialize(options={})
      # Finds where the application lives, so we can call it.
      @exe_path = options[:path] || find_prince_executable
      raise "Cannot find prince command-line app in $PATH" if @exe_path.length == 0
      raise "Cannot find prince command-line app at #{@exe_path}" if @exe_path && !File.executable?(@exe_path)
      @style_sheets = ''
      @log_file = options[:log_file]
      @logger = options[:logger]
    end

    # Returns the instance logger or Princely default logger
    def logger
      @logger || Princely::Logging.logger
    end

    # Returns the instance log file or Princely default log file
    def log_file
      @log_file || Princely::Logging.filename
    end

    # Sets stylesheets...
    # Can pass in multiple paths for css files.
    #
    def add_style_sheets(*sheets)
      @style_sheets += sheets.map { |sheet| " -s #{sheet} " }
    end

    # Returns fully formed executable path with any command line switches
    # we've set based on our variables.
    #
    def exe_path
      # Add any standard cmd line arguments we need to pass
      @exe_path << " --input=html --server --log=#{log_file} "
      @exe_path << @style_sheets
      @exe_path
    end

    # Makes a pdf from a passed in string.
    #
    # Returns PDF as a stream, so we can use send_data to shoot
    # it down the pipe using Rails.
    #
    def pdf_from_string(string, output_file = '-')
      pdf = initialize_pdf_from_string(string, output_file, {:output_to_log_file => false})
      pdf.close_write
      result = pdf.gets(nil)
      pdf.close_read
      result.force_encoding('BINARY') if RUBY_VERSION >= "1.9"

      result
    end

    def pdf_from_string_to_file(string, output_file)
      pdf = initialize_pdf_from_string(string, output_file)
      pdf.close
    end

    protected
    def initialize_pdf_from_string(string, output_file, options = {})
      options = {:log_command => true, :output_to_log_file => true}.merge(options)
      path = exe_path
      # Don't spew errors to the standard out...and set up to take IO
      # as input and output
      path << " --silent - -o #{output_file}"
      path << " >> '#{log_file}' 2>> '#{log_file}'" if options[:output_to_log_file]

      log_command path if options[:log_command]

      # Actually call the prince command, and pass the entire data stream back.
      pdf = IO.popen(path, "w+")
      pdf.puts string
      pdf
    end

    def find_prince_executable
      if ruby_platform =~ /mswin32/
        "C:/Program Files/Prince/Engine/bin/prince"
      else
        `which prince`.chomp
      end
    end

    def log_command(path)
      logger.info "\n\nPRINCE XML PDF COMMAND"
      logger.info path
      logger.info ''
    end

    def ruby_platform
      RUBY_PLATFORM
    end
  end
end

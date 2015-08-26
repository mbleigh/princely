require 'timeout'

module Princely
  class Pdf
    attr_accessor :executable, :style_sheets, :logger, :log_file, :server_flag, :media, :javascript_flag, :timeout

    # Initialize method
    #
    def initialize(options={})
      options = {
        :path => nil,
        :executable => Princely.executable,
        :log_file => nil,
        :logger => nil,
        :server_flag => true,
        :media => nil,
        :javascript_flag => false
      }.merge(options)
      @executable = options[:path] ? Princely::Executable.new(options[:path]) : options[:executable]
      @style_sheets = ''
      @log_file = options[:log_file]
      @logger = options[:logger]
      @server_flag = options[:server_flag]
      @media = options[:media]
      @javascript_flag = options[:javascript_flag]
      @timeout = options[:timeout]
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
      @style_sheets << sheets.map { |sheet| " -s #{sheet} " }.join(' ')
    end

    # Returns fully formed executable path with any command line switches
    # we've set based on our variables.
    #
    def exe_path
      @executable.join(executable_options)
    end

    def executable_options
      options = []
      options << "--input=html"
      options << "--server" if @server_flag
      options << "--log=#{log_file}"
      options << "--media=#{media}" if media
      options << "--javascript" if @javascript_flag
      options << @style_sheets
      options
    end

    # Makes a pdf from a passed in string.
    #
    # Returns PDF as a stream, so we can use send_data to shoot
    # it down the pipe using Rails.
    #
    def pdf_from_string(string, output_file = '-')
      with_timeout do
        pdf = initialize_pdf_from_string(string, output_file, {:output_to_log_file => false})
        pdf.close_write
        result = pdf.gets(nil)
        pdf.close_read
        result.force_encoding('BINARY') if RUBY_VERSION >= "1.9"

        result
      end
    end

    def pdf_from_string_to_file(string, output_file)
      with_timeout do
        pdf = initialize_pdf_from_string(string, output_file)
        pdf.close
      end
    end

  protected

    def with_timeout(&block)
      if timeout
        Timeout.timeout(timeout, &block)
      else
        block.call
      end
    end

    def initialize_pdf_from_string(string, output_file, options = {})
      options = {:log_command => true, :output_to_log_file => true}.merge(options)
      path = exe_path
      # Don't spew errors to the standard out...and set up to take IO
      # as input and output
      path << " --media=#{media}" if media
      path << " --silent - -o #{output_file}"
      path << " >> '#{log_file}' 2>> '#{log_file}'" if options[:output_to_log_file]

      log_command path if options[:log_command]

      # Actually call the prince command, and pass the entire data stream back.
      pdf = IO.popen(path, "w+")
      pdf.puts string
      pdf
    end

    def log_command(path)
      logger.info "\n\nPRINCE XML PDF COMMAND"
      logger.info path
      logger.info ''
    end
  end
end

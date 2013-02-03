require 'princely'
require 'princely/asset_support'

class Princely
  module PdfHelper
    include AssetSupport

    def self.included(base)
      base.send :alias_method_chain, :render, :princely
    end

    def render_with_princely(options = nil, *args, &block)
      if options.is_a?(Hash) && options.has_key?(:pdf)
        options[:name] ||= options.delete(:pdf)
        make_and_send_pdf(options.delete(:name), options)
      else
        render_without_princely(options, *args, &block)
      end
    end

    private

    def make_pdf(options = {})
      options = {
        :stylesheets => [],
        :layout => false,
        :template => File.join(controller_path, action_name),
        :relative_paths => true
      }.merge(options)

      prince = Princely.new
      # Sets style sheets on PDF renderer
      prince.add_style_sheets(*options[:stylesheets].collect{|style| asset_file_path(style)})

      html_string = render_to_string(options.slice(:template, :layout))

      html_string = localize_html_string(html_string, Rails.public_path) if options[:relative_paths]

      # Send the generated PDF file from our html string.
      if filename = options[:filename] || options[:file]
        prince.pdf_from_string_to_file(html_string, filename)
      else
        prince.pdf_from_string(html_string)
      end
    end

    def asset_file_path(asset)
      stylesheet = stylesheet.to_s.gsub('.css', '')
      File.join(config.stylesheets_dir, "#{stylesheet}.css")
    end
    alias_method :stylesheet_file_path, :asset_file_path

    def make_and_send_pdf(pdf_name, options = {})
      options = {:disposition => 'attachment'}.merge(options)
      send_data(
        make_pdf(options),
        :filename => "#{pdf_name}.pdf",
        :type => 'application/pdf',
        :disposition => options[:disposition]
      )
    end
  end
end

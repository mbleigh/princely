module PdfHelper
  require 'princely'

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
    options[:stylesheets] ||= []
    options[:layout] ||= false
    options[:template] ||= File.join(controller_path, action_name)

    prince = Princely.new
    # Sets style sheets on PDF renderer
    prince.add_style_sheets(*options[:stylesheets].collect{|style| asset_file_path(style)})

    html_string = render_to_string(options.slice(:template, :layout))

    html_string = localize_html_string(html_string)

    # Send the generated PDF file from our html string.
    if filename = options[:filename] || options[:file]
      prince.pdf_from_string_to_file(html_string, filename)
    else
      prince.pdf_from_string(html_string)
    end
  end

  def localize_html_string(html_string)
    AssetSupport.localize_html_string(html_string, Rails.public_path)
  end

  def asset_file_path(asset)
    stylesheet = stylesheet.to_s.gsub(".css","")
    File.join(config.stylesheets_dir, "#{stylesheet}.css")
  end
  alias_method :stylesheet_file_path, :asset_file_path

  def make_and_send_pdf(pdf_name, options = {})
    options[:disposition] ||= 'attachment'
    send_data(
      make_pdf(options),
      :filename => pdf_name + ".pdf",
      :type => 'application/pdf',
      :disposition => options[:disposition]
    )
  end

  module AssetSupport
    def localize_html_string(html_string, asset_path = nil)
      # Make all paths relative, on disk paths...
      html_string.gsub!(".com:/",".com/") # strip out bad attachment_fu URLs
      html_string.gsub!( /src=["']+([^:]+?)["']/i ) do |m|
        asset_src = asset_path ? "#{asset_path}/#{$1}" : asset_file_path($1)
        %Q{src="#{asset_src}"} # re-route absolute paths
      end

      # Remove asset ids on images with a regex
      html_string.gsub!( /src=["'](\S+\?\d*)["']/i ) { |m| %Q{src="#{$1.split('?').first}"} }
      html_string
    end

    def asset_file_path(asset)
      # Remove /assets/ from generated names and try and find a matching asset
      Rails.application.assets.find_asset(asset.gsub(%r{/assets/}, "")).try(:pathname) || asset
    end
  end
end

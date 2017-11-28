module Princely
  module AssetSupport
    def localize_html_string(html_string, asset_path = nil)
      html_string = html_string.to_str
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
      path = asset

      if Rails.application.config.respond_to?(:assets)
        if Rails.application.config.assets.enabled
          compiled_asset = Rails.application.assets_manifest.assets[asset]

          if compiled_asset.present?
            path = File.join(Rails.public_path, 'assets', compiled_asset)
          end
        end
      end

      path
    end
  end
end

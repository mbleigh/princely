# Princely

Princely is a simple wrapper for the [Prince XML PDF generation library](http://www.princexml.com).
The plugin will also automatically register the PDF MimeType so that you can use
pdf as a format in Rails controller `respond_to` blocks.

## Example

```ruby
class Provider::EstimatesController < Provider::BaseController
  # You can render PDF templates simply by
  # using the :pdf option on render templates.
  def show
    respond_to do |format|
      format.html
      format.pdf do
        render :pdf => 'file_name',
               :template => 'controller/action',
               :handlers => %w[erb],
               :formats => %w[pdf],
               :stylesheets => %w[application prince],
               :layout => 'pdf',
               :locals => { :foo => 'bar' },
               :disposition => 'inline', # PDF will be sent inline, means you can load it inside an iFrame or Embed
               :relative_paths => true # Modify asset paths to make them relative. See [the AssetSupport module](/lib/princely/asset_support.rb)
      end
    end
  end

  # Alternatively, you can use make_and_send_pdf to render out a PDF for the
  # action without a respond_to block.
  def pdf
    make_and_send_pdf "file_name"
  end
end
```

## Render Defaults

The defaults for the render options are as follows:

    layout:          false
    template:        the template for the current controller/action
    locals:          none
    stylesheets:     none
    disposition:     attachment (created PDF file will be sent as download)
    relative_paths:  true
    server_flag:     true
    javascript_flag: false
    timeout:         none

## Contributors

* Maintainer: Jared Fraser ([modsognir](https://github.com/modsognir))
* Gemification and more: Nic Williams
* Based on code by: Seth B ([subimage](https://github.com/subimage))
* [Other Contributors](https://github.com/mbleigh/princely/contributors)

## Resources

* Copyright (c) 2007-2013 Michael Bleigh and Intridea, Inc., released under the MIT license.

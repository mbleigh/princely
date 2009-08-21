require File.dirname(__FILE__) + '/../princely'
require 'princely/pdf_helper'

Mime::Type.register 'application/pdf', :pdf

ActionController::Base.send(:include, PdfHelper)
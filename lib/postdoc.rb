require 'postdoc/postdoc_view_helper'

module Postdoc

  class PostdocRailtie < Rails::Railtie
    initializer 'postdoc.register' do |_app|
      ActionView::Base.send :include, PostdocViewHelper
    end
  end

  ActionController::Renderers.add :pdf do |filename, options|
    pdffile = Tempfile.new(['output', '.pdf'])
    htmlfile = Tempfile.new(['input', '.html'])

    htmlfile.write(render_to_string(options))
    htmlfile.flush

    if options[:debug]
      `chrome file://#{htmlfile.path}`
    end

    `chrome --headless --disable-gpu --print-to-pdf=#{pdffile.path} file://#{htmlfile.path}`

    htmlfile.close
    htmlfile.unlink

    result = pdffile.read

    pdffile.unlink
    pdffile.close

    result
  end
end

# frozen_string_literal: true

require 'action_controller'
require 'postdoc/chrome_process'
require 'postdoc/client'
require 'postdoc/html_document'

module Postdoc
  ActionController::Renderers.add :pdf do |_filename, options|
    Postdoc.render_from_string render_to_string(options), options
  end

  def self.render_from_string(content, **options)
    server = ChromeProcess.new(**options)
    html_file = HTMLDocument.new(content, **options)
    server.client
        .print_pdf_from_html(html_file.path, **options)
  ensure
    server.kill
    html_file.cleanup
  end
end

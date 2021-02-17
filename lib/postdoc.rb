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
    chrome_process = ChromeProcess.new(**options)

    # Try and connect to the chrome process a for ten second before giving up.
    10.times { chrome_process.alive? || sleep(1) }
    client = chrome_process.client
    html_file = HTMLDocument.new(content, **options)
    client.print_pdf_from_html(html_file.path, **options)
  ensure
    chrome_process.kill
    html_file.cleanup
  end
end

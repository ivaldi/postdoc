# frozen_string_literal: true

require 'postdoc/chrome_process'
require 'postdoc/client'
require 'postdoc/html_document'

module Postdoc
  ActionController::Renderers.add :pdf do |_filename, options|
    Postdoc.render_from_string render_to_string(options), options
  end

  def self.render_from_string(options)
    chrome_process = ChromeProcess.new(port: options[:chrome_debugging_port])

    # Try and connect to the chrome process a for ten second before giving up.
    10.times { chrome_process.alive? || sleep(1) }

    client = chrome_process.client
    client.print_pfd_from_html HTMLFile.new(string)
  ensure
    chrome_process.kill
    html_file.cleanup
  end
end

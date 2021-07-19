# frozen_string_literal: true

require 'action_controller'
require 'postdoc/chrome_process'
require 'postdoc/client'
require 'postdoc/html_document'
require 'postdoc/print_settings'
require 'postdoc/batch'

module Postdoc
  ActionController::Renderers.add :pdf do |_filename, options|
    Postdoc.render_from_string render_to_string(options), options
  end

  def self.render_from_string(content, **options)
    print_settings = PrintSettings.new(**options)
    server = ChromeProcess.new(**options)
    html_file = HTMLDocument.new(content)
    server.client
        .print_pdf_from_html(html_file.path,
            settings: print_settings)
  ensure
    if server.client.client.present?
      server.client.client.send_cmd 'Browser.close'
    end
    server.kill
    html_file.cleanup
  end

  # A clean and easy way to render a batch:
  # ```
  # html_string_1
  # html_string_2
  # with_footer = Postdoc::PrintSettings.new(footer_template: footer_template)

  # result = Postdoc.batch do |batch|
  #   batch.add_document doc1
  #   batch.add_document doc2, settings: with_footer
  # end
  # ```
  def self.batch(batch: Batch.new)
    yield(batch)
    begin
      server = ChromeProcess.new
      batch.result(server.client)
    ensure
      if server.client.client.present?
        server.client.client.send_cmd 'Browser.close'
      end
      server.kill
      batch.cleanup
    end
  end
end

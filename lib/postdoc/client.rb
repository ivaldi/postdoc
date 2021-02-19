# frozen_string_literal: true

require 'chrome_remote'

module Postdoc
  class Client
    attr_accessor :client

    def initialize(port)
      20.times { setup_connection_or_wait(port) && break }
    end

    def print_pdf_from_html(file_path,
        header_template: false,
        footer_template: false,
        **options)
      client.send_cmd 'Page.enable'
      client.send_cmd 'Page.navigate', url: "file://#{file_path}"
      client.wait_for 'Page.loadEventFired'

      response = client.send_cmd 'Page.printToPDF', {
        landscape: options[:landscape] || false,
        printBackground: true,
        marginTop: options[:margin_top] || 1,
        marginBottom: options[:margin_bottom] || 1,
        displayHeaderFooter: !(header_template || footer_template),
        headerTemplate: header_template || '',
        footerTemplate: footer_template || ''
      }

      Base64.decode64 response['data']
    end

    private

    def setup_connection_or_wait(port)
      @client = ChromeRemote.client(port: port)
      @client.send_cmd "Network.enable"
      true
    rescue
      sleep 0.2
    end
  end
end

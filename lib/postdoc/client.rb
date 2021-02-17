# frozen_string_literal: true

require 'chrome_remote'

module Postdoc
  class Client
    attr_accessor :client
    def initialize(port)
      @client = ChromeRemote.client(port: port)
    end

    def print_pdf_from_html(file_path,
          header_template: false,
          footer_template: false,
          **options)
      client.send_cmd "Network.enable"
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
  end
end

# frozen_string_literal: true

require 'chrome_remote'

module Postdoc

  class Client
    attr_accessor :client

    def initialize(port)
      @port = port
      100.times { setup_connection_or_wait && break }
      raise 'ChromeClient couldn\'t launch' if @client.blank?
    end

    # We should move away from passing options like this and collect them in
    # the prinbt settings.
    def print_pdf_from_html(file_path,
        settings: PrintSettings.new)

      client.send_cmd 'Page.enable'
      client.send_cmd 'Page.navigate', url: "file://#{file_path}"
      client.wait_for 'Page.loadEventFired'

      response = client.send_cmd 'Page.printToPDF', settings.to_cmd
      
      client.send_cmd 'Browser.close'

      Base64.decode64 response['data']
    end

    def print_document(file_path, settings: PrintSettings.new)
      client.send_cmd 'Page.enable'
      client.send_cmd 'Page.navigate', url: "file://#{file_path}"
      client.wait_for 'Page.loadEventFired'
      response = client.send_cmd 'Page.printToPDF', settings.to_cmd

      client.send_cmd 'Browser.close'

      Base64.decode64 response['data']
    end

    private

    def setup_connection_or_wait
      @client = ChromeRemote.client(port: @port)
      true
    rescue
      sleep(0.1)
      false
    end
  end
end

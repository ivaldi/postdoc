# frozen_string_literal: true

require 'chrome_remote'

module Postdoc
  ActionController::Renderers.add :pdf do |_filename, options|
    Postdoc.render_from_string render_to_string(options), options
  end

  def self.render_from_string(string, options)
    htmlfile = Tempfile.new ['input', '.html'], Rails.root.join('tmp')

    htmlfile.write string
    htmlfile.flush

    if options[:client].nil?
      # random port at 1025 or higher
      random_port = 1024 + Random.rand(65_535 - 1024)
      pid = Process.spawn "chrome --remote-debugging-port=#{random_port} --headless"
    end
    
    success = false
    10.times do
      begin
        TCPSocket.new('localhost', random_port)
        success = true 
        break
      rescue
      end
      sleep 1
    end
    
    return unless success

    begin
      chrome = options[:client].nil? ? ChromeRemote.client(port: random_port) : options[:client]

      chrome.send_cmd 'Page.enable'
      chrome.send_cmd 'Page.navigate', url: "file://#{htmlfile.path}"
      chrome.wait_for 'Page.loadEventFired'

      if options[:header_template].present? || options[:footer_template].present?
        displayHeaderFooter = true
      else
        displayHeaderFooter = false
      end

      response = chrome.send_cmd 'Page.printToPDF', {
        landscape: options[:landscape] || false,
        printBackground: true,
        marginTop: options[:margin_top] || 1,
        marginBottom: options[:margin_bottom] || 1,
        displayHeaderFooter: displayHeaderFooter,
        headerTemplate: options[:header_template] || '',
        footerTemplate: options[:footer_template] || ''
      }
      result = Base64.decode64 response['data']
    ensure
      if options[:client].nil?
        Process.kill 'KILL', pid
        Process.wait pid
      else
        chrome.send_cmd 'Page.close'
      end

      htmlfile.close
      htmlfile.unlink
    end

    result
  end
end

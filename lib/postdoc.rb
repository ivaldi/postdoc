require 'chrome_remote'

module Postdoc
  ActionController::Renderers.add :pdf do |filename, options|
    render_from_string_to_pdf render_to_string(options), options
  end

  def self.render_from_string(string, options)
    htmlfile = Tempfile.new ['input', '.html']

    htmlfile.write string
    htmlfile.flush

    # random port at 1025 or higher
    random_port = 1024 + Random.rand(65535 - 1024)

    pid = Process.spawn "chrome --remote-debugging-port=#{random_port} --headless"

    # FIXME
    sleep 1

    begin
      chrome = ChromeRemote.client port: random_port
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
        headerTemplate: options[:header_template],
        footerTemplate: options[:footer_template]
      }
      result = Base64.decode64 response['data']
    ensure
      Process.kill 'KILL', pid
      Process.wait pid

      htmlfile.close
      htmlfile.unlink
    end

    result
  end
end

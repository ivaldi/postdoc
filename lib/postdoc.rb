require 'postdoc/postdoc_view_helper'
require 'chrome_remote'

module Postdoc

  class PostdocRailtie < Rails::Railtie
    initializer 'postdoc.register' do |_app|
      ActionView::Base.send :include, PostdocViewHelper
    end
  end

  ActionController::Renderers.add :pdf do |filename, options|
    htmlfile = Tempfile.new ['input', '.html']

    htmlfile.write render_to_string(options)
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

      # FIXME
      sleep 2

      response = chrome.send_cmd 'Page.printToPDF', {
        landscape: options[:landscape] || false,
        printBackground: true,
        marginTop: options[:margin_top] || 1,
        marginBottom: options[:margin_bottom] || 1
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

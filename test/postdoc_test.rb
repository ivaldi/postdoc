require 'test_helper'
require 'open-uri'

class PostdocTest < ActiveSupport::TestCase
  test 'responds to #render_form_string' do
    assert_respond_to Postdoc, :render_from_string
  end

  test 'responds to #render_batch' do
    assert_respond_to Postdoc, :render_batch
  end

  class ClientTest < ActiveSupport::TestCase
    def server
      @server ||= Postdoc::ChromeProcess.new
    end

    def subject
      @subject ||= Postdoc::Client.new(server.port)
    end

    test 'can initialize' do
      assert subject
    ensure
      server.kill
    end

    test 'responds to #print_pdf_from_html' do
      assert_respond_to subject, :print_pdf_from_html
    ensure
      server.kill
    end
  end

  class ChromeProcessTest < ActiveSupport::TestCase
    def subject
      @subject ||= Postdoc::ChromeProcess.new
    end

    test 'it can initialize' do
      assert subject
    ensure
      subject.kill
    end

    test 'it creates a process' do
      assert Process.getpgid(subject.pid)
    ensure
      subject.kill
    end

    test 'kill stops the pid' do
      subject.kill
      assert_raises Errno::ESRCH do
        Process.getpgid(subject.pid)
      end
    end

    test '#client returns a client' do
      assert_instance_of Postdoc::Client, subject.client
    ensure
      subject.kill
    end

    test 'it uses a random value as default' do
      Random.expects(:rand).returns(4200)
      server = Postdoc::ChromeProcess.new
      assert_equal 4200, server.port
    ensure
      server.kill
    end
  end

  class HTMLDocumentTest < ActiveSupport::TestCase
    def subject
      @subject ||= Postdoc::HTMLDocument.new(
        URI.open('http://bettermotherfuckingwebsite.com/').read
      )
    end

    test 'it can initialize' do
      assert subject
    end

    test 'it can write a file' do
      assert File.file?(subject.file)
    end

    test 'it removed a file on cleanup' do
      file_path = subject.file.path
      subject.cleanup

      assert_not File.file?(file_path)
    end
  end

  class Job

  end
end

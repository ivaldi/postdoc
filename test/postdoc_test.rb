require 'test_helper'
require 'open-uri'

class PostdocTest < ActiveSupport::TestCase
  test 'responds to #render_form_string' do
    assert_respond_to Postdoc, :render_from_string
  end

  class ClientTest < ActiveSupport::TestCase
    def subject
      @subject ||= Postdoc::Client.new('1234')
    end

    test 'can initialize' do
      assert subject
    end

    test 'responds to #print_pdf_from_html' do
      assert_respond_to subject, :print_pdf_from_html
    end
  end

  class ChromeProcessTest < ActiveSupport::TestCase
    def subject
      @subject ||= Postdoc::ChromeProcess.new(port: 9222)
    end

    test 'it can initialize' do
      assert subject
      subject.kill
    end

    test 'it creates a process' do
      assert Process.getpgid(subject.pid)
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
      subject.kill
    end

    test 'it uses a random value as default' do
      Random.expects(:rand).returns(4200)
      assert_equal 4200, Postdoc::ChromeProcess.new.port
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
end

# frozen_string_literal: true

module Postdoc
  class HTMLDocument
    attr_accessor :file

    def initialize(content, path: '/tmp' )
      @file = Tempfile.new ['input', '.'], path

      @file.write content
      @file.flush
    end

    def cleanup
      @file.close
      @file.unlink
    end
  end
end

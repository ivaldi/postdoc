# frozen_string_literal: true

require 'rails'

module Postdoc
  class HTMLDocument
    attr_accessor :file

    delegate :path, to: :file

    def initialize(content, path: nil, **_options)
      path ||= Rails.root&.join('tmp') || '/tmp'
      @file = Tempfile.new ['input', '.html'], path

      file.write content
      file.flush
    end

    def cleanup
      file.close
      file.unlink
    end
  end
end

module Postdoc
  # A job is a single "print" in a batch and binds a document to a setting.
  class Job
    def initialize(document, settings: PrintSettings.new)
      @settings = settings
      @document = HTMLDocument.new(document)
    end

    # Return the result of the job.
    def result(client)
      client.print_document(@document.path, settings: @settings)
    end

    def cleanup
      @document.cleanup
    end
  end
end

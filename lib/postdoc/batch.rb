require 'postdoc/print_settings'
require 'postdoc/job'

module Postdoc
  # This module represents a batch. At times we want to render multiple PDF's in
  # series and batching saves a lot of overhead by not restarting chrome over
  # and over. Practical applications are  "stitching" PDF's together to get
  # around markup constraints in chrome or rendering a batch of reports all at
  # once.
  class Batch
    def initialize(jobs: [])
      @jobs = jobs
    end

    # Creates a job from a document and add to the jobs.
    def add_document(document, settings: {})
      settings = PrintSettings.new(**settings)
      @jobs << Job.new(document, settings: settings)
    end

    def add_job(job)
      @jobs << job
    end

    # returns the output of the config. Requires a {Postdoc::Client Client}
    def result(client)
      @jobs.map { |job| job.result(client) }
    end

    def cleanup
      @jobs.each(&:cleanup)
    end
  end
end

require 'sidekiq'
module CDMDEXER
  # Extract records from OAI, delete records marked for deletion
  # and send everything else to a transformation / load worker
  class ETLWorker
    include Sidekiq::Worker

    extend ::Forwardable
    def_delegators :@oai_request,
                   :deletable_ids,
                   :updatables,
                   :next_resumption_token

    attr_reader :config,
                :solr_config,
                :cdm_endpoint,
                :oai_endpoint,
                :field_mappings,
                :resumption_token,
                :batch_size,
                :is_recursive

    attr_writer :oai_request_klass,
                :etl_worker_klass,
                :load_worker_klass,
                :completed_callback_klass,
                :transform_worker_klass

    def perform(config)
      # Sidekiq stores params in JSON, so we can't inject dependencies. This
      # results in the long set of arguments that follows. Otherwise, we'd
      # simply inject the OAI request and extractor objects
      @config            = config
      @solr_config       = config.fetch('solr_config')
      @cdm_endpoint      = config.fetch('cdm_endpoint')
      @oai_endpoint      = config.fetch('oai_endpoint')
      @field_mappings    = config.fetch('field_mappings', false)
      @resumption_token  = config.fetch('resumption_token', nil)
      @batch_size        = config.fetch('batch_size', 5).to_i
      @is_recursive      = config.fetch('is_recursive', true)
      after_date         = config.fetch('after_date', false)

      @oai_request = oai_request_klass.new(
        endpoint_url: oai_endpoint,
        resumption_token: resumption_token,
        set_spec: config.fetch('set_spec', nil),
        # Optionally only select records that have been updated after a
        # certain date. You may need to manually update a parent record
        # after updating a child in order to signify to the indexer that
        # some record in the parent's children has been updated. This indexer
        # expects to only see parent records in the OAI responses.
        # The default here is to skip indexing based on date.
        # Rails example for getting a date: `after_date: 2.weeks.ago`
        after_date: after_date
      )

      run_batch!
      run_next_batch!
    end

    # Because Sidekiq serializes params to JSON, we provide custom setters
    # for dependencies (normally these would be default params in the
    # constructor) so that they may be mocked and tested
    def completed_callback_klass
      @completed_callback_klass ||= CDMDEXER::CompletedCallback
    end

    def etl_worker_klass
      @etl_worker_klass ||= ETLWorker
    end

    def oai_request_klass
      @oai_request_klass ||= OaiRequest
    end

    def load_worker_klass
      @load_worker_klass ||= LoadWorker
    end

    def transform_worker_klass
      @transform_worker_klass ||= TransformWorker
    end

    # Recurse through OAI batches one at a time
    def run_next_batch!
      if next_resumption_token && is_recursive
        etl_worker_klass.perform_async(next_config)
      else
        completed_callback_klass.call!(config)
      end
    end

    private

    # Extract an oai response, delete the deletables, transform and load the
    # updatable items
    def run_batch!
      # Delete records that OAI has marked for deletion
      delete_deletables!
      transform_and_load!
    end

    def next_config
      config.merge('resumption_token' => next_resumption_token)
    end

    def transform_and_load!
      updatables.each_slice(batch_size) do |records|
        transform_worker_klass.perform_async(records,
                                            solr_config.to_json,
                                            cdm_endpoint,
                                            oai_endpoint,
                                            field_mappings,
                                            batch_size)
      end
    end

    def delete_deletables!
      load_worker_klass.perform_async([], deletable_ids, solr_config)
    end
  end
end

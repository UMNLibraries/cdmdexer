# frozen_string_literal: true

require 'hash_at_path'
require 'json'
require 'time'

module CDMDEXER
  # Light wrapper around OAI requests
  # Enhances OAI responses with handles sets, records, etc and adds a little
  # extra value to their data with a keyed set lookup, filters for deleted
  # and non-deleted records
  class OaiRequest
    attr_reader :endpoint_url,
                :resumption_token,
                :client,
                :set_spec,
                :after_date

    def initialize(endpoint_url: '',
                   resumption_token: nil,
                   set_spec: nil,
                   client: Net::HTTP,
                   after_date: false)
      @endpoint_url     = endpoint_url
      @resumption_token = resumption_token
      @client           = client
      @set_spec         = set_spec ? "&set=#{set_spec}" : ''
      @after_date       = after_date
    end

    def records
      headers.map do |header|
        header.merge(
          'id' => header['identifier'].split(':').last.split('/').join(':')
        )
      end
    end

    def sets
      # Ensure a result of one set is still an array
      @sets ||= force_array request(sets_endpoint_url).at_path('OAI_PMH/ListSets/set')
    end

    def set_lookup
      sets.inject({}) { |memo, set| memo.merge(to_key(set)) }
    end

    def next_resumption_token
      identifier_request.at_path('OAI_PMH/ListIdentifiers/resumptionToken')
    end

    def deletable_ids
      records.select do |record|
        if record['status'] == 'deleted'
          after_date ? Time.parse(record['datestamp']) >= after_date : true
        end
      end.map { |record| record['id'] }
    end

    def updatables
      records.reject do |record|
        if record['status'] == 'deleted'
          true
        elsif after_date && Time.parse(record['datestamp']) < after_date
          true
        else
          false
        end
      end
    end

    private

    # TODO: Add some error handling if this ever turns up empty
    def headers
      force_array identifier_request.at_path('OAI_PMH/ListIdentifiers/header')
    end

    # Ensure results are a single level array
    # (single row sets, records, etc)
    def force_array(result)
      [result].flatten.compact
    end

    def to_key(set)
      {
        set['setSpec'] =>
          {
            name: set['setName'],
            description: set.at_path('setDescription/dc/description')
          }
      }
    end

    def identifier_request
      @identifier_request ||=
        resumption_token ? request(batch_endpoint_url) : request(first_batch_endpoint_url)
    end

    def first_batch_endpoint_url
      "#{endpoint_url}?verb=ListIdentifiers&metadataPrefix=oai_dc#{set_spec}"
    end

    def batch_endpoint_url
      "#{endpoint_url}?verb=ListIdentifiers&resumptionToken=#{resumption_token}"
    end

    def sets_endpoint_url
      "#{endpoint_url}?verb=ListSets"
    end

    def request(location)
      CDMDEXER::OaiNotification.call!(location)
      Hash.from_xml(client.get_response(URI(location)).body)
    end
  end
end

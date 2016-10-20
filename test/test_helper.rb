$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'cdmbl'

require 'minitest/autorun'
require 'minitest/pride'
require 'minitest/spec'
require 'vcr'
require 'sidekiq/testing'
require 'webmock/minitest'

WebMock.enable!


VCR.configure do |config|
  config.cassette_library_dir = "test/fixtures/vcr_cassettes"
  config.hook_into :webmock
  config.allow_http_connections_when_no_cassette = true
end



# Avoid testing solr itself
module CDMBL

  class TestConnection
    def add(records)
    end

    def commit
    end

    def delete_by_id(ids)
    end
  end

  class TestClient
    def self.connect(url)
      TestConnection.new
    end
  end

  class TestSolr < DefaultSolr
    def initialize(url: 'http://localhost:8983', client: TestClient)
      super(url: url, client: client)
    end
  end

  # An example callback
  class Callback
    def self.call!(solr_client)
      'blerg this is a test callback'
    end
  end
end
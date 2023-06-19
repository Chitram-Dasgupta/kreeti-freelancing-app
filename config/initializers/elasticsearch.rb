module ElasticCategories
  ELASTICSEARCH_CONFIG_FILE = 'config/elasticsearch.yml'.freeze
  Rails.configuration.elasticsearch = YAML.unsafe_load_file(ELASTICSEARCH_CONFIG_FILE)[Rails.env].deep_symbolize_keys

  Elasticsearch::Model.client = Elasticsearch::Client.new Rails.configuration.elasticsearch
end

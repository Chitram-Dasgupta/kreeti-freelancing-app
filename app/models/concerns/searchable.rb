module Searchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

    def as_indexed_json(_options = {})
      as_json(
        only: %i[id title description],
        include: { categories: { only: :name } }
      )
    end

    settings index: { max_ngram_diff: 10 }, analysis: {
      filter: {
        ngram_filter: {
          type: 'ngram',
          min_gram: 2,
          max_gram: 12
        }
      },
      analyzer: {
        index_ngram_analyzer: {
          type: 'custom',
          tokenizer: 'standard',
          filter: %w[lowercase ngram_filter]
        },
        search_ngram_analyzer: {
          type: 'custom',
          tokenizer: 'standard',
          filter: ['lowercase']
        }
      }
    } do
      mapping do
        indexes :categories, type: 'nested' do
          indexes :name, type: 'text', analyzer: 'index_ngram_analyzer', search_analyzer: 'search_ngram_analyzer'
        end
      end
    end

    def self.search_projects(category_name)
      search_definition = {
        query: {
          bool: {
            must: [
              {
                nested: {
                  path: 'categories',
                  query: {
                    match: {
                      'categories.name': category_name
                    }
                  }
                }
              }
            ]
          }
        }
      }

      __elasticsearch__.search(search_definition)
    end
  end
end

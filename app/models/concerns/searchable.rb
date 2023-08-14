# frozen_string_literal: true

module Searchable
  extend ActiveSupport::Concern

  # rubocop:disable Metrics/BlockLength
  included do
    include Elasticsearch::Model

    after_commit on: [:create] do
      __elasticsearch__.index_document
    end

    after_commit on: [:update] do
      __elasticsearch__.update_document
    end

    after_commit on: [:destroy] do
      __elasticsearch__.delete_document
    end

    # rubocop:disable Metrics/MethodLength
    def self.search_definition(category_name, filter = [])
      {
        size: 1000,
        query: {
          bool: {
            filter:,
            must: [
              {
                nested: {
                  path: 'categories',
                  query: if category_name.present?
                           {
                             match_phrase: {
                               'categories.name': category_name
                             }
                           }
                         else
                           {
                             match_all: {}
                           }
                         end
                }
              }
            ]
          }
        }
      }
    end
    # rubocop:enable Metrics/MethodLength
  end
  # rubocop:enable Metrics/BlockLength
end

# frozen_string_literal: true

module Searchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

    # settings index: { number_of_shards: 1 } do
    #   mappings dynamic: 'false' do
    #     indexes :categories, type: 'nested' do
    #       indexes :name, type: 'text'
    #     end
    #   end
    # end
  end
end

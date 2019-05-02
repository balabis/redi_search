# frozen_string_literal: true

require "redi_search/index"
require "redi_search/document/converter"

require "active_support/concern"

module RediSearch
  module Model
    extend ActiveSupport::Concern

    class_methods do
      attr_reader :redi_search_index

      def redi_search(**options) # rubocop:disable Metrics/MethodLength
        @redi_search_index = Index.new(
          options[:index_name] || "#{name.underscore}_idx",
          options[:schema],
          self
        )

        class << self
          def search(query, **options)
            redi_search_index.search(query, **options)
          end

          def reindex
            redi_search_index.reindex(all)
          end
        end
      end
    end

    def redi_search_document
      Document::Converter.new(self.class.redi_search_index, self).document
    end
  end
end

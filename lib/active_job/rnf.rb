require "active_job/rnf/engine"

module ActiveJob
  module RNF
    extend ActiveSupport::Concern

    included do
      rescue_from ActiveJob::DeserializationError do |exception|
        case exception.original_exception
        when ActiveRecord::RecordNotFound
          # NOOP
        else
          raise exception
        end
      end
    end

  end
end

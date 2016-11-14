# frozen_string_literal: true
module ActiveJob
  module RNF
    class Engine < ::Rails::Engine

      config.to_prepare do
        ActiveJob::Base.send :include, ActiveJob::RNF
      end
    end
  end
end

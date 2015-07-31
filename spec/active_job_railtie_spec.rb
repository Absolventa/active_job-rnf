require 'rails_helper'

RSpec.describe ActiveJob::RNF do
  let(:record) { ExampleRecord.create }

  before(:all) do
    ActiveRecord::Base.connection.execute <<-EOSQL
CREATE TABLE example_records (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  type VARCHAR(255)
);
EOSQL
  end

  before { ExampleRecord.clear_performance! }

  class ExampleRecord < ActiveRecord::Base
    class << self
      attr_reader :performed

      def performed?
        performed.present?
      end

      def clear_performance!
        @performed = []
      end
    end

    def action!(job_id)
      self.class.performed << job_id
    end
  end

  class ExampleRecordWithErrors < ExampleRecord
    def action!(*)
      fail RuntimeError.new('Ooops.')
    end
  end

  class ExampleJob < ActiveJob::Base
    def perform(*record)
      Array(record).each {|r| r.action!(job_id) }
    end
  end

  it 'deserializes the record normally' do
    job = ExampleJob.perform_later(record)
    expect { ExampleJob.execute job.serialize }.not_to raise_error
    expect(ExampleRecord).to be_performed
  end

  it 'rescues from AR::RecordNotFound' do
    job = ExampleJob.perform_later(record)
    record.destroy
    expect { ExampleJob.execute job.serialize }.not_to raise_error
    expect(ExampleRecord).not_to be_performed
  end

  context 'with other errors' do
    let(:record) { ExampleRecordWithErrors.create }

    let(:serialized_job) do
      ExampleJob.new.serialize.tap { |job| job['arguments'] = [Object.new] }
    end

    it 'is picky about the origin of the DeserializationError' do
      expect { ExampleJob.execute serialized_job }.
        to raise_error ActiveJob::DeserializationError
    end

    it 'raises other error' do
      job = ExampleJob.perform_later(record)
      expect { ExampleJob.execute job.serialize }.to raise_error RuntimeError
      expect(ExampleRecordWithErrors).not_to be_performed
    end
  end
end

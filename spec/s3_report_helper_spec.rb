# frozen_string_literal: true

require 'spec_helper'

RSpec.describe S3ReportHelper do
  # test class
  class DummyAwsClient
    attr_accessor :options, :target

    def get_object(options, target)
      @options = options
      @target = target
      DummyResponse.new
    end

    def bucket(bucket_name)
      DummyResponse.new
    end
  end

  # test class
  class DummyResponse
    def body
    end

    def object(filename)
      DummyObject.new
    end
  end

  # test class
  class DummyObject
    def upload_file(file)
    end
  end

  subject(:s3_report_helper) { described_class.new(path) }
  let(:path) { 'tmp' }
  let(:file) { 'TEST_REPORT_2010_NPWD_TEST_1.TST' }
  let(:bucket_name) { 'development-pwpr-reports' }
  let(:response) { DummyResponse.new }
  let(:object) { DummyObject.new }
  let(:aws_client) { DummyAwsClient.new }
  let(:report_type) { 'TEST_REPORT' }
  let(:file_location) { 'my/local/dir' }
  let(:ext) { 'TST' }
  let(:npwd) { 'NPWD_TEST_1' }
  let(:year) { '2010' }

  before do
    allow(Aws::S3::Resource).to receive(:new).and_return(aws_client)
    allow(Aws::S3::Client).to receive(:new).and_return(aws_client)
  end

  describe '#get_report' do
    it 'expects the correct path' do
      result = s3_report_helper.get_report(year, npwd, report_type, ext)
      expect(result[:target]).to eq path + '/' + file
    end

    it 'expects the correct filename' do
      s3_report_helper.get_report(year, npwd, report_type, ext)
      expect(aws_client.options[:key]).to eq file
    end

    it 'expects the correct bucket to be accessed' do
      s3_report_helper.get_report(year, npwd, report_type, ext)
      expect(aws_client.options[:bucket]).to eq bucket_name
    end
  end

  describe '#upload_to_S3' do
    it 'expects the correct bucket to be accessed' do
      allow(aws_client).to receive(:bucket).and_return(response)
      allow(response).to receive(:object).and_return(object)
      s3_report_helper.upload_to_S3(year, npwd, report_type, file_location, ext)
      expect(aws_client).to have_received(:bucket).with(bucket_name)
    end

    it 'expects the correct filename to be saved' do
      allow(aws_client).to receive(:bucket).and_return(response)
      allow(response).to receive(:object).and_return(object)
      s3_report_helper.upload_to_S3(year, npwd, report_type, file_location, ext)
      expect(response).to have_received(:object).with(file)
    end

    it 'expects the correct filename to be uploaded' do
      allow(aws_client).to receive(:bucket).and_return(response)
      allow(response).to receive(:object).and_return(object)
      allow(object).to receive(:upload_file)
      s3_report_helper.upload_to_S3(year, npwd, report_type, file_location, ext)
      expect(object).to have_received(:upload_file).with(file_location)
    end
  end

  describe '#get_default_template' do
    it 'expects the correct report name' do
      allow(object).to receive(:get_object)
      result = s3_report_helper.get_default_template(report_type, ext)
      expect(result[:target]).to eq 'tmp/default_TEST_REPORT.TST'
    end
  end
end

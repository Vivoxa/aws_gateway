# frozen_string_literal: true

# class to fetch and store report related artifacts in S3
class S3ReportHelper
  DEFAULT_FILE_EXT = 'pdf'

  attr_accessor :tmp_filepath

  def initialize(local_temp_dir)
    @tmp_filepath = local_temp_dir
  end

  def get_report(year, business_npwd, report_type, ext = DEFAULT_FILE_EXT)
    require 'pry'
    binding.pry
    s3 = Aws::S3::Client.new
    s3_filename = build_filename(year, business_npwd, report_type, ext)
    target = tmp_filepath + '/' + s3_filename
    resp = s3.get_object(bucket: report_bucket_name, key: s3_filename, target: target )
    resp
  end

  def upload_to_S3(year, business_npwd, report_type, file_location, ext = DEFAULT_FILE_EXT)
    s3 = Aws::S3::Resource.new

    # Create the object to upload
    s3_desired_filename = build_filename(year, business_npwd, report_type, ext)
    obj = s3.bucket(report_bucket_name).object(s3_desired_filename)
    # Upload it
    obj.upload_file(file_location)
  end

  def get_default_template(report_type, ext = DEFAULT_FILE_EXT)
    s3 = Aws::S3::Client.new
    target = default_template_download_location(report_type, ext)
    resp = s3.get_object({bucket: template_bucket_name, key: "default_#{report_type}.#{ext}"}, target: target)
    { response_body: resp.body, target: target }
  end

  private

  def default_template_download_location(report_type, ext = DEFAULT_FILE_EXT)
    @tmp_filepath + "/default_#{report_type}.#{ext}"
  end

  def build_filename(year, business_npwd, report_type, ext = DEFAULT_FILE_EXT)
    "#{report_type}_#{year}_#{business_npwd}.#{ext}"
  end

  def environment()
    ENV.fetch('ENV', 'development')
  end

  def report_bucket_name
    "#{environment}-pwpr-reports"
  end

  def template_bucket_name
    "#{environment}-pwpr-templates"
  end
end

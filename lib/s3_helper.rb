class S3Helper

  DEFAULT_FILE_EXT = 'pdf'.freeze

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
    resp = s3.get_object({bucket: template_bucket_name, key: "default_#{report_type}.#{ext}"}, target: TMP_FILEPATH)
    resp.body
  end

  private

  def cleanup(year, business)
    path_to_save_file = tmp_filename(year, business)
    FileUtils.rm [path_to_save_file], force: true
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

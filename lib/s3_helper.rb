class S3Helper

    DEFAULT_FILE_EXT = 'pdf'.freeze

    def upload_to_S3(year, business_npwd, report_type, file_location, ext = DEFAULT_FILE_EXT)
      s3 = Aws::S3::Resource.new

      # Create the object to upload
      s3_desired_filename = build_filename(year, business_npwd, report_type, ext)
      obj = s3.bucket(report_bucket_name).object(s3_desired_filename)
      # Upload it
      obj.upload_file(file_location)
      # cleanup(year, business, report_type)
    end

    private

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

# frozen_string_literal: true

module AwsGateway
  # class to upload agency templates to S3
  class S3AgencyTemplateHelper
    S3_FILE_AGENCY_TEMPLATE_IDENTIFIER = 'AT'

    def put(year, scheme_id, filename, path_to_file)
      s3 = Aws::S3::Resource.new

      # Create the object to upload
      s3_desired_filename = s3_build_filename(year, scheme_id, filename)
      obj = s3.bucket(bucket_name).object(s3_desired_filename)

      # Upload it
      obj.upload_file(path_to_file)
    end

    private

    def s3_build_filename(year, scheme_id, filename)
      "#{AgencyTemplateAwsHandler::S3_FILE_AGENCY_TEMPLATE_IDENTIFIER}-#{year}-#{scheme_id}-#{filename}"
    end

    def bucket_name
      "#{environment}-pwpr"
    end

    def environment
      ENV.fetch('ENV', 'development')
    end
  end
end
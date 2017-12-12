Gem::Specification.new do |s|
  s.name        = 'aws_gateway'
  s.version     = '0.0.0'
  s.date        = '12/12/2017'
  s.summary     = "Enables upload and download from AWS services"
  s.description = "A gatewqay service to AWS services and file storage"
  s.authors     = ["Nigel Surtees"]
  s.email       = 'nigelsurtees@hotmail.co.uk'
  s.files       = ["lib/aws_gateway.rb", "lib/s3_helper.rb"]
  s.homepage    = 'https://github.com/Vivoxa/aws_gateway'

  s.add_dependency 'aws-sdk', '~> 2'
  s.add_development_dependency 'pry-byebug'
  s.add_development_dependency 'renogen', '1.2.0'
end


lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "mongoid/enum_attribute/version"

Gem::Specification.new do |spec|
  spec.name          = "mongoid-enum_attribute"
  spec.version       = Mongoid::EnumAttribute::VERSION
  spec.authors       = ["Tomáš Celizna"]
  spec.email         = ["tomas.celizna@gmail.com"]

  spec.summary       = %q{Take on ActiveRecord::Enum in Mongoid}
  spec.homepage      = "https://github.com/tomasc/mongoid-enum_attribute"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'mongoid', '>= 5', '<= 7.0'

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency 'database_cleaner'
end

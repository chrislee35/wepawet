# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'wepawet/version'

Gem::Specification.new do |spec|
	spec.name          = "wepawet"
	spec.version       = Wepawet::VERSION
	spec.authors       = ["chrislee35"]
	spec.email         = ["rubygems@chrislee.dhs.org"]
	spec.description   = %q{Wepawet is a service for detecting and analyzing web-based malware. It currently handles Flash, JavaScript, and PDF files. http://wepawet.cs.ucsb.edu}
	spec.summary       = %q{provides an interface to UCSB's wepawet malicious URL analysis project}
	spec.homepage      = "http://github.com/chrislee35/wepawet"
	spec.license       = "MIT"

	spec.files         = `git ls-files`.split($/)
	spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
	spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
	spec.require_paths = ["lib"]

	spec.add_runtime_dependency "multipart-post", ">= 1.1.0"
	spec.add_runtime_dependency "libxml-ruby", ">= 1.1.4"
	spec.add_runtime_dependency "configparser", "~> 0.1.1"
	spec.add_development_dependency "bundler", "~> 1.3"
	spec.add_development_dependency "rake"

	spec.signing_key   = "#{File.dirname(__FILE__)}/../gem-private_key.pem"
	spec.cert_chain    = ["#{File.dirname(__FILE__)}/../gem-public_cert.pem"]
end

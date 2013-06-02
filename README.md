# Wepawet

This gem provides an interface to UCSB's wepawet malicious URL analysis project
Wepawet is a service for detecting and analyzing web-based malware. It currently handles Flash, JavaScript, and PDF files. http://wepawet.cs.ucsb.edu

## Installation

Add this line to your application's Gemfile:

    gem 'wepawet'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install wepawet

## Usage

	require 'wepawet'
	
	config = {
		'wepawetSubmitUrl' => 'http://wepawet.cs.ucsb.edu/services/upload.php', 
		'wepawetQueryUrl' => 'http://wepawet.cs.ucsb.edu/services/query.php',
		'wepawetDomainUrl' => 'http://wepawet.cs.ucsb.edu/services/domain.php',
		'wepawetUrlUrl' => 'http://wepawet.cs.ucsb.edu/services/url.php',
	}
	w = Wepawet::Submit.new(config)
	hash = w.submit_url("http://example.com")
	q = Wepawet::Query.new(config)
	resp = q.by_taskid(hash) 
	# => {"url"=>"http://example.com", "status"=>"queued"}
	resp = q.by_domain("example.com") 
	# => {"domain"=>"example.com", "report_url"=>"http://wepawet.cs.ucsb.edu/domain.php?hash=a6bf1757fff057f266b697df9cf176fd&type=js"}
	resp = q.by_url("http://example.com") 
	# => {"url"=>"http://example.com", "benign"=>"http://wepawet.cs.ucsb.edu/view.php?hash=a9b9f04336ce0181a08e774e01113b31&t=1303679363&type=js"}

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

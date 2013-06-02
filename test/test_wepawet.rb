unless Kernel.respond_to?(:require_relative)
  module Kernel
    def require_relative(path)
      require File.join(File.dirname(caller[0]), path.to_str)
    end
  end
end

require_relative 'helper'

class TestWepawet < Test::Unit::TestCase
	def test_submit_example_com_for_analysis
		config = {
			'wepawetSubmitUrl' => 'http://wepawet.cs.ucsb.edu/services/upload.php', 
			'wepawetQueryUrl' => 'http://wepawet.cs.ucsb.edu/services/query.php',
			'wepawetDomainUrl' => 'http://wepawet.cs.ucsb.edu/services/domain.php',
			'wepawetUrlUrl' => 'http://wepawet.cs.ucsb.edu/services/url.php',
		}
		w = Wepawet::Submit.new(config)
		hash = w.submit_url("http://example.com")
		assert_equal(32, hash.length)
		assert(hash =~ /^[a-fA-F0-9]{32}$/)
		q = Wepawet::Query.new(config)
		begin
			sleep 2
			resp = q.by_taskid(hash)
		end while resp['status'] == 'queued'
		resp = q.by_taskid(hash)
		assert("http://example.com", resp['url'])
		assert("benign", resp['result'])
		assert("processed", resp['status'])
		resp = q.by_domain("example.com")
		assert("example.com", resp['domain'])
		resp = q.by_url("http://example.com")
		assert("http://example.com", resp['url'])
	end
end

require "wepawet/version"
require 'net/http'
require 'net/https'
require 'uri'
require 'net/http/post/multipart'
require 'xml'
require 'cgi'

# The Wepawet module contains all the query and submission classes for wepawet
module Wepawet
	
	# Wepawet::Submit is used to submit new files and/or URLs into the wepawet system.
	class Submit
		def initialize(config = {
			'wepawetSubmitUrl' => 'http://wepawet.cs.ucsb.edu/services/upload.php', 
			'wepawetQueryUrl' => 'http://wepawet.cs.ucsb.edu/services/query.php',
			'wepawetDomainUrl' => 'http://wepawet.cs.ucsb.edu/services/domain.php',
			'wepawetUrlUrl' => 'http://wepawet.cs.ucsb.edu/services/url.php',
		})
			@config = config
		end
		
		def submit_file(filename, resource_type='js')
			params = {'resource_type' => resource_type}
			['user','passwd','referer'].each do |opt|
				params[opt] = @config[opt] if @config[opt]
			end
			file = File.open(filename)
			params['file'] = UploadIO.new(file, "application/octet-stream", File.basename(filename))
			uri = URI.parse(@config['wepawetSubmitUrl'])
			http = Net::HTTP.new(uri.host, uri.port)
			http.use_ssl = (uri.scheme == 'https')
			http.verify_mode = OpenSSL::SSL::VERIFY_NONE
			request = Net::HTTP::Post::Multipart.new(uri.path, params)
			request.add_field("User-Agent", "Ruby/#{RUBY_VERSION} wepawet gem v#{Wepawet::VERSION}")
			response = http.request(request)
			parse_response(response.body)
		end
		
		# Wepawet::Submit#submit_url(url) submits a new URL to the wepawet system and returns a task ID (a hash).
		def submit_url(url, resource_type='js')
			params = {'resource_type' => resource_type, 'url' => url}
			['user','passwd','referer'].each do |opt|
				params[opt] = @config[opt] if @config[opt]
			end
			uri = URI.parse(@config['wepawetSubmitUrl'])
			http = Net::HTTP.new(uri.host, uri.port)
			http.use_ssl = (uri.scheme == 'https')
			http.verify_mode = OpenSSL::SSL::VERIFY_NONE
			request = Net::HTTP::Post.new(uri.path)
			request.set_form_data(params)
			request.add_field("User-Agent", "Ruby/#{RUBY_VERSION} wepawet gem v#{Wepawet::VERSION}")
			response = http.request(request)
			parse_response(response.body)
		end
		
		def parse_response(doc)
			xml = XML::Document.string(doc)
			h = xml.find("hash")
			h[0].child.to_s
		rescue Exception
			return nil
		end
	end
	
	class Query
		def initialize(config = {
			'wepawetSubmitUrl' => 'http://wepawet.cs.ucsb.edu/services/upload.php', 
			'wepawetQueryUrl' => 'http://wepawet.cs.ucsb.edu/services/query.php',
			'wepawetDomainUrl' => 'http://wepawet.cs.ucsb.edu/services/domain.php',
			'wepawetUrlUrl' => 'http://wepawet.cs.ucsb.edu/services/url.php',
		})
			@config = config
		end
		
		def by_whatever(whatever, value)
			params = {'resource_type' => 'js', whatever => value}
			urlkey = (whatever == 'hash') ? 'wepawetQueryUrl' : (whatever == 'domain') ? 'wepawetDomainUrl' : (whatever == 'url') ? 'wepawetUrlUrl' : 'wepawetQueryUrl'
			uri = URI.parse(@config[urlkey]+"?"+params.map{|k,v| "#{k}=#{v}"}.join("&"))
			http = Net::HTTP.new(uri.host, uri.port)
			http.use_ssl = (uri.scheme == 'https')
			http.verify_mode = OpenSSL::SSL::VERIFY_NONE
			request = Net::HTTP::Get.new(uri.path+"?"+uri.query)
			request.add_field("User-Agent", "Ruby/#{RUBY_VERSION} wepawet gem v#{Wepawet::VERSION}")
			response = http.request(request)
			_parse_response(response.body)
		end
		
		def by_taskid(taskid)
			by_whatever('hash',taskid)
		end
		
		alias :by_hash :by_taskid
		
		def by_domain(domain)
			by_whatever('domain',domain)
		end
		
		def by_url(url)
			by_whatever('url', CGI.escape(url))
		end
		
		def _parse_response(doc)
			xml = XML::Document.string(doc)
			hash = {}
			xml.child.children.each do |node|
				if node.name =~ /\w/ and node.child
					hash[node.name] = node.child.content
				end
			end
			hash
		rescue Exception
			return nil
		end
	end
end
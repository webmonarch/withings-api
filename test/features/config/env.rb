require 'net/http'

module ApiCucumberHelpers
  def result_or_exception(name)
    begin
      self.instance_variable_set("@#{name}", yield)
    rescue => e
      puts e
      self.instance_variable_set("@#{name}_exception", e)
    end
  end

  def wrap_method(clazz, method_sym, &block)
    alias_method_sym = "__#{method_sym}".to_sym

    clazz.instance_exec(method_sym) do |sym|
      alias_method alias_method_sym, method_sym
      define_method(method_sym) do |*arguments|
        block.call(lambda { self.send(alias_method_sym, *arguments) }, *arguments)
      end
    end
  end

  def logger
    Cucumber.logger
  end
end

World(ApiCucumberHelpers)

def unwrap_method(clazz, method_sym)
  alias_method_sym = "__#{method_sym}".to_sym

  clazz.instance_exec do
    alias_method method_sym, alias_method_sym
    remove_method(alias_method_sym)
  end
end

# hacking all over the place!
def puts(o)
  Kernel.puts "      \33[36m#{o}\33[0m"
end

def print_http_req_resp
  before_after_method_wrap(Net::HTTP, :transport_request) do |aliased, *arguments|
    puts "HTTP Request: #{arguments.first.path}"
    res = aliased.call
    puts "HTTP Response Headers: #{res.to_hash.inspect}"
    puts "HTTP Response Body: #{res.body}"

    res
  end
end

def before_after_method_wrap(clazz, method_sym, &block)
  Before do
    wrap_method(clazz, method_sym, &block)
  end

  After do
    unwrap_method(clazz, method_sym)
  end
end

print_http_req_resp

before_after_method_wrap(Net::HTTP, :__transport_request) do |aliased, *arguments|
  stream = Net::BufferedIO.new(StringIO.new(
%Q(HTTP/1.1 200 OK
Content-Type: text/plain

oauth_token=1cc2b0710e51b86e2865b646692f80c011d7707177f37272d8d6395e483&oauth_token_secret=ed0695302f4f01c839bf2992d305e341800385df925032922d91c1356e9e8)))

  res = Net::HTTPResponse.read_new(stream)

  res.reading_body(stream, true) {
    yield res if block_given?
  }

  res
end



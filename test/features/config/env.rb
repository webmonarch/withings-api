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

  def unwrap_method(clazz, method_sym)
    alias_method_sym = "__#{method_sym}".to_sym

    clazz.instance_exec do
      alias_method method_sym, alias_method_sym
      remove_method(alias_method_sym)
    end
  end

  def logger
    Cucumber.logger
  end
end

World(ApiCucumberHelpers)

def print_http_uris
  Before do
    wrap_method(Net::HTTP, :transport_request) do |aliased, *arguments|
      puts arguments.first.path

      aliased.call
    end
  end

  After do
    unwrap_method(Net::HTTP, :transport_request)
  end
end

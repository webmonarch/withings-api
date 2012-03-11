module ApiCucumberHelpers
  def result_or_exception(name)
    begin
      self.instance_variable_set("@#{name}", yield)
    rescue => e
      puts e
      self.instance_variable_set("@#{name}_exception", e)
    end
  end
end

World(ApiCucumberHelpers)
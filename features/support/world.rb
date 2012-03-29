require 'capybara/cucumber'

module ApiCucumberHelpers
  # executes the given block, storing the return value
  # in an instance variable named "name" or the exception
  # result in "name"_exception
  def result_or_exception(name, &block)
    begin
      self.instance_variable_set("@#{name}", yield)
    rescue => e
      puts e
      self.instance_variable_set("@#{name}_exception", e)
    end
  end

  def logger
    Cucumber.logger
  end
end

World(ApiCucumberHelpers)

# Capybara Setup

Capybara.default_driver = :selenium
Capybara.default_wait_time = 5
World(Capybara::DSL)

# overwrite puts to make it's output more
# harmonious with the stylized Cucumber
# output
def puts(o)
  Kernel.puts "      \33[36m#{o}\33[0m"
end
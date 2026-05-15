require_relative "report"

module TemplateMethod
  class PlainTextReport < Report
    def output_head
      puts("**** #{@title} ****")
      puts
    end

    def output_line(line)
      puts(line)
    end
  end
end

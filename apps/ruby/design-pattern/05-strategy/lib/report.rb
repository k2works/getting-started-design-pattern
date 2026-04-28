# frozen_string_literal: true

module Strategy
  # Report class (Strategy pattern)
  #
  # Accepts a formatting strategy as a block or Proc,
  # and delegates output processing to it.
  class Report
    attr_reader :title, :text
    attr_accessor :formatter

    def initialize(&formatter)
      @title = "\u6708\u6b21\u5831\u544a"
      @text = %w[順調 最高の調子]
      @formatter = formatter
    end

    def output_report
      @formatter.call(self)
    end
  end
end

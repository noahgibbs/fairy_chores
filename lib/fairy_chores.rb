require "fairy_chores/version"

module FairyChores
  class Error < StandardError; end

  class Circle
    def initialize(howmany)
      @howmany = howmany
    end
  end
end

require "fairy_chores/version"

module FairyChores
  class Error < StandardError; end

  # how_many_fairies is how many total fairies to make (all roles combined.)
  # fairy_strategy is the method of selecting fairy roles.
  # rules is the rules of the game.
  #
  # Now that I think of it, strategy, rules and how_many_fairies are quite
  # interdependent. Hrm.
  def self.make_circle(how_many_fairies:, fairy_strategy:, rules:)
    # Future: pick a Circle subclass according to rules
    FairyChores::Circle.new fairies: make_fairies(how_many: how_many_fairies, strategy: fairy_strategy)
  end

  class Circle
    attr_reader :round_num
    attr_reader :how_many
    attr_reader :fairies

    def initialize(fairies:)
      @how_many = fairies.size
      @fairies = fairies
      @round_num = 1
    end

    def finished?
      return true if @fairies.all?(:doing_chores)
      return true if @fairies.none?(:can_assign_chores)
      false
    end

    def winner
      :none
    end
  end

  def self.make_fairies(how_many:, strategy:)
    fairies = []
    how_many.times do |i|
      fairies << make_fairy(which: i, role: :ignored)
    end
    fairies
  end

  def self.make_fairy(which:, role:)
    # Future: choose Fairy class by role
    FairyChores::Fairy.new which: which
  end

  class Fairy
    attr_reader :index # Which one is this?
    attr_reader :doing_chores

    def initialize(which:)
      @index = which
      @doing_chores = false
    end

    def assign_to_chores
      @doing_chores = true
    end

    def can_assign_chores
      false
    end
  end
end

require "fairy_chores/version"

module FairyChores
  class Error < StandardError; end

  @fairy_types = {}

  def self.add_fairy_type(sym, klass)
    @fairy_types[sym] = klass
  end

  def self.get_fairy_type(sym)
    @fairy_types[sym]
  end

  @game_types = {}

  def self.add_game_type(sym, klass)
    @game_types[sym] = klass
  end

  def self.get_game_type(sym)
    @game_types[sym]
  end

  # game_type is the type of game
  def self.make_circle(how_many_fairies:, game_type:)
    klass = get_game_type(game_type)
    raise "Unknown game type #{this_game_type.inspect}!" unless klass
    # Future: pick a Circle subclass according to game_type
    klass.new how_many: how_many_fairies
  end

  class Circle
    attr_reader :round_num
    attr_reader :how_many
    attr_reader :fairies

    def initialize(how_many:)
      @how_many = how_many
      @round_num = 1
      make_fairies
    end

    def finished?
      return true if @fairies.all?(:doing_chores)
      return true if @fairies.none?(:can_assign_chores)
      false
    end

    def winner
      :none
    end

    protected

    def make_fairies
      @fairies = []
      @how_many.times do |i|
        @fairies << make_fairy({ which: i, role: :fairy })
      end
    end

    def make_fairy(info)
      klass = FairyChores.get_fairy_type(info[:role])
      raise "Unknown fairy role: #{info[:role].inspect}!" unless klass
      klass.new info
    end
  end
  add_game_type(:nothing_happens, Circle)

  class AssignersJustWinCircle < Circle
    def make_fairies
      raise "Not enough fairies for game type!" unless @how_many > 2
      @fairies = ([ :assigner, :assigner ] +  [ :fairy ] * (@how_many - 2)).map.with_index { |t, i| make_fairy({ which: i, role: t }) }
    end

    # Define finished? and winner
  end
  add_game_type(:assigners_win, AssignersJustWinCircle)

  class Fairy
    attr_reader :index # Which one is this?
    attr_reader :doing_chores

    def initialize(info)
      @index = info[:which]
      @doing_chores = false
    end

    def assign_to_chores
      @doing_chores = true
    end

    def can_assign_chores
      false
    end
  end
  add_fairy_type(:fairy, Fairy)

  class ChoreAssignerFairy < Fairy
    def initialize(info)
      super
    end

    def can_assign_chores
      true
    end
  end
  add_fairy_type(:assigner, ChoreAssignerFairy)
end

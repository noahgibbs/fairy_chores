require "fairy_chores/version"
require "andor"

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

  def self.all_game_types
    @game_types.keys
  end

  NAMEGEN = File.read File.join(__dir__, "..", "andor", "fairy_names.txt")

  # game_type is the type of game
  def self.make_circle(how_many_fairies:, game_type:)
    klass = get_game_type(game_type)
    raise "Unknown game type #{game_type.inspect}!" unless klass
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
      winner != :none
    end

    def winner
      return :assigners if @fairies.all? { |f| f.doing_chores || f.can_assign_chores }
      return :frolickers if @fairies.none? { |f| f.can_assign_chores } && @fairies.any? { |f| !f.doing_chores }
      :none
    end

    def allowed_actions
      [ :frolic, :chores, :assign, :none ]
    end

    def get_fairy(which)
      @fairies[which]
    end

    def calculate_round
      round = Round.new(circle: self)

      fairy_actions = @fairies.map do |fairy|
        act = fairy.next_action
        raise "Got an illegal action (#{act.inspect})!" unless allowed_actions.include?(act[0])
        round.add_action fairy, act
      end

      round
    end

    def apply_round(round)
      round.actions.each do |which, act|
        fairy = get_fairy(which)
        if act[0] == :assign
          target_fairy = get_fairy(act[1])
          target_fairy.assign_to_chores(assigned_by: fairy)
        end
      end
      @round_num += 1
    end

    def generate_random_name
      circle_names = @fairies.map(&:name)
      gen = andor_generator
      20.times do
        n = gen.generate_from_name @andor_start_token
        unless circle_names.include?(n)
          return n
        end
      end
      raise "After 20 tries, couldn't get a name that wasn't already used!"
    end

    protected

    def andor_generator
      return @andor_generator if @andor_generator
      @andor_generator = Andor::NameGenerator.new
      @andor_generator.load_rules_from_andor_string FairyChores::NAMEGEN
      if @andor_generator.names.include?("start")
        @andor_start_token = "start"
      else
        @andor_start_token = @andor_generator.names.first
      end
      @andor_generator
    end

    def make_fairies
      @fairies = []
      @how_many.times do |i|
        @fairies << make_fairy({ which: i, role: :fairy, circle: self })
      end
    end

    def make_fairy(info)
      klass = FairyChores.get_fairy_type(info[:role])
      raise "Unknown fairy role: #{info[:role].inspect}!" unless klass
      klass.new info
    end
  end
  add_game_type(:nothing_happens, Circle)

  class Fairy
    attr_reader :name
    attr_reader :which
    attr_reader :doing_chores
    attr_reader :circle

    def initialize(info)
      @which = info[:which]
      @doing_chores = false
      @circle = info[:circle]
      @name = info[:name] || @circle.generate_random_name
    end

    def assign_to_chores(assigned_by:)
      @doing_chores = true
    end

    def can_assign_chores
      false
    end

    def next_action
      @doing_chores ? [:chores] : [:frolic]
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

    def next_action
      target = @circle.fairies.select { |f| !f.doing_chores && !f.can_assign_chores }.sample
      [ :assign, target.which ]
    end
  end
  add_fairy_type(:assigner, ChoreAssignerFairy)

  class Round
    attr_reader :circle
    attr_reader :actions

    def initialize(circle:)
      @circle = circle
      @actions = {}
    end

    def add_action(fairy, action)
      raise "This round already has an action for this fairy! (#{fairy.which})" if @actions[fairy.which]

      @actions[fairy.which] = action
    end

    def text_description(indent: 0)
      indent_spaces = " " * indent
      desc = ""

      fairies_by_action = {}
      @actions.each do |which, act|
        fairies_by_action[act[0]] ||= []
        fairies_by_action[act[0]] << @circle.get_fairy(which)
      end

      none_fairies = fairies_by_action[:none]
      if none_fairies
        desc.concat "#{indent_spaces}#{none_fairies.size} fairies are doing nothing (#{none_fairies.map {|f| f.name }.join(", ")}.)\n"
      end
      frolic_fairies = fairies_by_action[:frolic]
      if frolic_fairies
        desc.concat "#{indent_spaces}#{frolic_fairies.size} fairies are frolicking happily (#{frolic_fairies.map {|f| f.name }.join(", ")}.)\n"
      end
      chores_fairies = fairies_by_action[:chores]
      if chores_fairies
        desc.concat "#{indent_spaces}#{chores_fairies.size} fairies sadly do their chores (#{chores_fairies.map {|f| f.name }.join(", ")}.)\n"
      end

      assign_fairies = fairies_by_action[:assign]
      assign_fairies.each do |f|
        target_fairy = @circle.get_fairy @actions[f.which][1]
        desc.concat "#{indent_spaces}#{f.name} is assigning chores to #{target_fairy.name}\n"
      end

      desc
    end
  end

end

require "fairy_chores/simple_games"

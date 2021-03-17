require "fairy_chores"

module FairyChores
  class AssignersJustWinCircle < Circle
    def make_fairies
      raise "Not enough fairies for game type!" unless @how_many > 2
      @fairies = ([ :assigner, :assigner ] +  [ :fairy ] * (@how_many - 2)).map.with_index { |t, i| make_fairy({ which: i, role: t, circle: self }) }
    end

    def finished?
      true
    end

    def winner
      :assigners
    end
  end
  add_game_type(:assigners_win_now, AssignersJustWinCircle)

  class AssignersSlowlyWinCircle < Circle
    def make_fairies
      raise "Not enough fairies for game type!" unless @how_many > 2
      @fairies = ([ :assigner, :assigner ] +  [ :fairy ] * (@how_many - 2)).map.with_index { |t, i| make_fairy({ which: i, role: t, circle: self }) }
    end
  end
  add_game_type(:assigners_win, AssignersSlowlyWinCircle)
end

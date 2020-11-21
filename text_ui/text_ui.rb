require './core/session'
require './core/bj_exception'
require_relative 'help'

class TUIException < BJException; end

class TextUI
  COMMANDS = Game.instance_methods + Object.instance_methods - [:is_over]
  DECORATE_LENGTH = 20

  def run
    puts "Enter the player's name"
    name = gets.chomp
    @session = (name == '' ? Session.new : Session.new(name))
    @running = true

    print_state

    while @running
      begin
        handle_command
      rescue BJException => e
        puts e.message
        retry
      end
    end
  end

  def handle_command
    print '>'
    return if (command = gets.chomp) == ''

    command = command.gsub(' ', '_').to_sym
    return if tui_commands_handle(command)

    raise TUIException, "The command #{command} does not exist" unless COMMANDS.include?(command)

    @session.game.send(command)

    print_state
  end

  # takes symbol
  def tui_commands_handle(command)
    case command
    when :quit then @running = false
    when :help then puts HELP
    when :state then print_state
    when :replay
      @session.replay
      print_state
    else return false
    end
    true
  end

  def print_state
    puts '-' * DECORATE_LENGTH
    print_hand(@session.player)
    unless @session.game.is_over
      print_hidden_hand(@session.dealer)
      puts '-' * DECORATE_LENGTH
      return
    end

    print_hand(@session.dealer)
    print_winner
    %i[player dealer].each do |person|
      puts "#{@session.send(person).name}'s money: #{@session.send(person).money}"
    end
    puts '-' * DECORATE_LENGTH
    puts "To play again type 'replay', to quit - type 'quit'"
    puts '-' * DECORATE_LENGTH
  end

  def print_winner
    puts '*' * DECORATE_LENGTH
    if @session.game.winner == :nowinner
      puts 'No winner this time'
    else
      puts "The winner is #{@session.game.winner.name}"
    end
    puts '*' * DECORATE_LENGTH
  end

  def print_hand(person)
    puts '-' * DECORATE_LENGTH
    puts "#{person.name}'s hand:"
    person.hand.cards.each { |card| print card.name }
    puts
    puts "Total score: #{person.hand.value}"
    puts '-' * DECORATE_LENGTH
  end

  def print_hidden_hand(person)
    puts '-' * DECORATE_LENGTH
    puts "#{person.name}'s hand:"
    person.hand.cards.each { print '?' }
    puts
    puts 'Total score: ???'
    puts '-' * DECORATE_LENGTH
  end
end

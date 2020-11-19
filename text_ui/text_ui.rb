require './core/session'
require './core/bj_exception'

class TUIException < BJException; end

class TextUI
  COMMANDS = Session.instance_methods - Object.instance_methods - %i[player dealer] # rewrite

  def run
    puts "Enter the player's name"
    name = gets.chomp
    @session = (name == '' ? Session.new : Session.new(name))
    @running = true

    print_state(@session.state)

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
    next if (command = gets.chomp) == ''

    command = command.gsub(' ', '_').to_sym
    next if tui_commands_handle(command)

    raise TUIException, "The command #{command} does not exist" unless COMMANDS.include?(command)

    state = @session.send(command)

    print_state(state)
  end

  def tui_commands_handle(command) # takes symbol
    case command
    when :quit then @running = false
    when :help then puts HELP
    else return false
    end
    true
  end

  def print_state(state)
    print_hand(state, :player)
    print_hand(state, :dealer)

    if state.has_ended
      puts "The winner is #{state.winner.name}"
      %i[player dealer].each do |person|
        puts "#{@session.send(person).name}'s money: #{@session.send(person).money}"
      end
      puts "To play again type 'replay', to quit - type 'quit'"
    end
  end

  def print_hand(state, sym)
    puts "#{sym}'s hand:"
    state.send("#{sym}_cards").each { |card| print card.name }
    puts
    puts "Total score: #{state.send("#{sym}_score")}"
  end
end

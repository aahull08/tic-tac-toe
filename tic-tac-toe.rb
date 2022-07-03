INITIAL_MARKER = ' '
PLAYER_MARKER = 'X'
COMPUTER_MARKER = 'O'
WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # cols
                [[1, 5, 9], [3, 5, 7]]              # diagonals

def prompt(string)
  puts " --> #{string}"
end

# rubocop:disable Metrics/AbcSize
def display_board(board)
  system 'clear'
  puts "You're a #{PLAYER_MARKER} the computer is #{COMPUTER_MARKER}"
  puts ""
  puts "     |     |"
  puts "  #{board[1]}  |  #{board[2]}  |  #{board[3]}"
  puts "     |     |"
  puts "-----+-----+-----"
  puts "     |     |"
  puts "  #{board[4]}  |  #{board[5]}  |  #{board[6]}"
  puts "     |     |"
  puts "-----+-----+-----"
  puts "     |     |"
  puts "  #{board[7]}  |  #{board[8]}  |  #{board[9]}"
  puts "     |     |"
end
# rubocop:enable Metrics/AbcSize

def initialized_board
  new_board = {}
  (1..9).each { |num| new_board[num] = INITIAL_MARKER }
  new_board
end

def empty_squares(board)
  board.keys.select { |num| board[num] == INITIAL_MARKER }
end

def joinor(arr, punctuation = ', ', word_at_end = 'or')
  # My Solution
  # return array.join(" #{word_at_end} ") if array.size <= 2
  # new_array = []
  # array.each_with_index do |num, index|
  #   if index + 1 < array.size
  #     new_array << "#{num}#{punctuation}"
  #   else
  #     new_array << "#{word_at_end} #{num}"
  #   end
  # end
  # new_array.join
  case arr.size
  when 0 then ''
  when 1 then arr.first
  when 2 then arr.join(" #{word_at_end} ")
  else
    arr[-1] = "#{word_at_end} #{arr.last}"
    arr.join(punctuation)
  end
end

def player_places_piece!(board)
  square = ''
  loop do
    prompt "Choose a square (#{joinor(empty_squares(board))})"
    square = gets.chomp.to_i
    break if empty_squares(board).include?(square)
    prompt "Sorry, that is not a valid choice."
  end
  board[square] = PLAYER_MARKER
end

# rubocop:disable Metrics/CyclomaticComplexity, Metrics/MethodLength
def computer_places_piece!(board)
  square = nil
  WINNING_LINES.each do |line|
    square = find_at_risk_square(board, line, COMPUTER_MARKER)
    break if square
  end

  if !square
    WINNING_LINES.each do |line|
      square = find_at_risk_square(board, line, PLAYER_MARKER)
      break if square
    end
  end

  if !square
    square = 5 if board[5] == INITIAL_MARKER
  end

  if !square
    square = empty_squares(board).sample
  end

  board[square] = COMPUTER_MARKER
end
# rubocop:enable Metrics/CyclomaticComplexity, Metrics/MethodLength

def find_at_risk_square(board, line, marker)
  if board.values_at(line[0], line[1], line[2]).count(marker) == 2
    line.each_with_index do |ele, index|
      if board[ele] == INITIAL_MARKER
        square = line[index]
        return square
      end
    end
  end
  nil
end

def board_full?(board)
  empty_squares(board).empty?
end

def someone_won?(board)
  !!detect_winner(board)
end

def detect_winner(board)
  WINNING_LINES.each do |line|
    if board.values_at(line[0], line[1], line[2]).count(PLAYER_MARKER) == 3
      return 'Player'
    elsif board.values_at(*line).count(COMPUTER_MARKER) == 3
      return 'Computer'
    end
  end
  nil
end

def whoose_first(first_or_second)
  return 'Player' if first_or_second == 'f'
  return 'Computer' if first_or_second == 's'
  ['Player', 'Computer'].sample
end

def place_piece!(board, current_player)
  computer_places_piece!(board) if current_player == 'Computer'
  player_places_piece!(board) if current_player == 'Player'
end

def alernate_player(current_player)
  current_player == 'Computer' ? 'Player' : 'Computer'
end

loop do
  player_score = 0
  computer_score = 0

  loop do
    prompt 'Do you want to go first(f), second(s), or computer choice(any key)?'
    first_or_second = gets.chomp.downcase
    current_player = whoose_first(first_or_second)
    board = initialized_board

    loop do
      display_board(board)
      place_piece!(board, current_player)
      current_player = alernate_player(current_player)
      break if someone_won?(board) || board_full?(board)
    end

    display_board(board)

    if someone_won?(board)
      prompt "#{detect_winner(board)} won!"
      detect_winner(board) == 'Computer' ? computer_score += 1 : player_score += 1
    else
      prompt "Its a tie!"
    end
    prompt "Scoreboard"
    prompt "Player Score: #{player_score}: Computer Score: #{computer_score}"
    break if computer_score == 5 || player_score == 5
    prompt "Press any button for next round"
    gets
  end
  prompt "Do you want to play again (y or n)?"
  answer = gets.chomp
  break unless answer.downcase.start_with?('y')
end

prompt "Thanks for playing Tic-Tac-Toe!"
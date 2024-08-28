$initial_movies = {
  Interstellar: 5,
  "The Dark Knight": 5,
  "Kung-Pow: Enter The Fist": 1,
  Hangmen: 0
}
$t1 = "---------------- Movie Ratings ----------------"
$t2 = "------------------ Main Menu ------------------"
$t3 = "----------------- Add a Movie -----------------"
$t4 = "--------------- Update a Movie ----------------"
$t5 = "--------------- Delete a Movie ----------------"
$t6 = "-------------- Find Movies By... --------------"
$t7 = "---------------- Find a Movie -----------------"
$t8 = "-------------------- Error --------------------"
$t9 = "=>: "

def add(movies, title=nil)
  puts `clear`
  puts $t1
  puts $t3
  if title == nil
    title = ""
    puts "What is the title?"
    print $t9
    input = gets.chomp().split(' ')
    input.each() do |word|
      title = title + " " + word.downcase().capitalize().strip()
    end
    title.strip!()
    if movies[title.to_sym()]
      puts `clear`
      puts $t8
      puts "#{title} alredy exists and has a rating of #{movies[title.to_sym]}"
      puts "Press enter to return to the main menu."
      gets
      return main_menu(movies)
    end
  else
    puts "The movie title you entered is #{title}"
  end
  puts "What is the rating? (0 - 5)"
  print $t9
  begin
    rating = Integer(gets.chomp())
    if rating > 5
      raise
    end
  rescue
    puts `clear`
    puts $t8
    puts "I'm sorry, the rating must be a number between 0 and 5."
    puts "Please try again. Press enter to go back."
    gets
    return add(movies, title)
  end
  movies[title.to_sym] = rating
  puts `clear`
  puts "\"#{title}\" successfully added with a rating of #{rating}!"
  puts "Press enter to go back to the main menu."
  gets
  return main_menu(movies)
end

def update(movies, title=nil)
  puts `clear`
  puts $t1
  puts $t4
  if title == nil
    puts "What is the title of the movie you want to update?"
    print $t9
    title = gets.chomp().downcase().capitalize()
  else
    puts "You were in the middle of updating #{title}!"
  end
  if movies[title.to_sym()] == nil
    puts `clear`
    puts $t8
    puts "I'm sorry, that movie isn't here. Consider adding it!"  
    puts "Press enter to return to the main menu."
    gets
  else
    puts "The current rating for \"#{title}\" is #{movies[title.to_sym()]}."
    puts "What is the new rating? (0 - 5)"
    print $t9
    begin
      rating = Integer(gets.chomp())
      if rating > 5
        raise
      end
    rescue
      puts `clear`
      puts $t8
      puts "I'm sorry, the rating must be a number between 0 and 5."
      puts "Please try again. Press enter to go back."
      gets
      return update(movies, title)
    end
    puts `clear`
    movies[title.to_sym()] = rating
    puts "Successfully updated the rating for \"#{title}\" to #{rating}!"
    puts "Press enter to return to the main menu."
    gets
  end
  return main_menu(movies)
end

def delete(movies)
  puts `clear`
  puts $t1
  puts $t5
  puts "Enter the title of the movie you wish to delete."
  print $t9
  title = gets.chomp().downcase().capitalize()
  if movies[title.to_sym] == nil
    puts `clear`
    puts $t8
    puts "I'm sorry, #{title} was not found."
    puts "Check your spelling and try again, or it isn't here!"
    puts "Press enter to return to the main menu"
    gets
  else
    movies.delete(title.to_sym())
    puts `clear`
    puts "#{title} has been successfully deleted!"
    puts "press enter to return to the main menu."
    gets
  end
  return main_menu(movies)  
end

def filter(movies)
  range_choice = {}
  text_choice = nil
  rating_choice = nil
  begin
    puts `clear`
    puts $t1
    puts $t6
    puts "How would you like to filter by?"
    puts "\"Rating\""
    puts "\"Title\""
    puts "\"All\" <= Lists all the movies"
    print $t9
    filter_choice = gets.chomp().downcase()
    if filter_choice != "rating" && filter_choice != "title" && filter_choice != "all"
      raise
    elsif filter_choice == "rating"
      puts "Do you want to search with a range?"
      puts "\"Yes\" or \"No\""
      print $t9
      decision = gets.chomp().downcase()
      if decision == "yes"
        puts "From? (lowest)"
        print $t9
        low = Integer(gets.chomp())
        puts "To? (highest)"
        print $t9
        high = Integer(gets.chop())
        if low >= high
          raise
        end
        range_choice[:low] = low
        range_choice[:high] = high
      elsif decision == "no"
        puts "What rating do you want to search for?"
        print $t9
        rating_choice = Integer(gets.chomp())
      else
          raise
      end
    elsif filter_choice == "title"
      puts "Enter some characters to search by."
      print $t9
      text_choice = gets.chomp().downcase()
    elsif filter_choice != "all" && filter_choice != "title" && filter_choice != "rating"
      raise
    end
    puts "Which value would you like to sort by?"
    puts "\"Title\""
    puts "\"Rating\""
    print $t9
    sort_choice = gets.chomp().downcase()
    if sort_choice != "title" && sort_choice != "rating"
      raise
    end
    puts "Ascending or descending?"
    puts "\"asc\" for ascending."
    puts "\"desc\" for descending."
    print $t9
    asc_choice = gets.chomp().downcase
    if asc_choice != "asc" && asc_choice != "desc"
      raise
    end 
  rescue
    puts `clear`
    puts $t8
    puts "Please try again. Press enter to go back"
    gets
    retry
  end
  results = search(movies, filter_choice, sort_choice, asc_choice, range_choice, rating_choice, text_choice)
  puts `clear`
  puts $t1
  puts $t6
  puts ""
  if results.length == 0
    puts "No results!"
  else
    results.each() { |title, rating| puts "\"#{title.to_s()}\" ----- #{rating} out of 5"}
    puts ""
    puts "End of list"  
  end
  puts "Press enter to return to the main menu."
  gets
  return main_menu(movies)
end

def search(movies, select_by, sort_by=nil, asc=nil, range=nil, rating=nil, text=nil)
  results = {}
  if select_by == "rating"
    if range.length == 0
      results = movies.select() { |key, value| rating == value }
    else
      results = movies.select() { |key, value| value >= range[:low] && value <= range[:high]}
    end
  elsif select_by == "title"
    results = movies.select() { |key, value| key.to_s().downcase().include? text }
  else
    results = movies
  end
  if sort_by == "rating"
    results = results.sort_by() { |k, v| v }
  else
    results = results.sort_by() { |k, v| k }
  end
  results = results.reverse() if asc == "desc"
  return results.to_h()
end

def find(movies)
  puts `clear`
  puts $t1
  puts $t7
  puts "Enter the title of the movie you are looking for."
  print $t9
  title = gets.chomp().downcase().capitalize()
  if movies[title.to_sym()] == nil
    puts `clear`
    puts $t8
    puts "I'm sorry, #{title} was not found."
    puts "Check your spelling and try again, or consider adding it!"
    puts "Press enter to return to the main menu."
    gets
  else
    puts `clear`
    puts $t1
    puts $t7
    puts ""
    puts "\"#{title}\" has a rating of #{movies[title.to_sym()]} out of 5!"
    puts ""
    puts "Press enter to return to the main menu."
    gets
  end
  return main_menu(movies)
end


def main_menu(movies)
  puts `clear`
  puts $t1
  puts $t2
  puts "\"find\" ====> find a specific movie by title."
  puts "\"filter\" ==> show movies filtered by a value."
  puts "\"add\" =====> add a movie and it's rating."
  puts "\"update\" ==> update a movie's rating."
  puts "\"delete\" ==> delete a movie."
  puts "\"exit\" ====> exit the program"
  puts "Enter which you'd like to do:"
  print $t9
  choice = gets.chomp().downcase()
  if choice == "filter"
    return filter(movies)
  elsif choice == "find"
    return find(movies)
  elsif choice == "add"
    return add(movies)
  elsif choice == "update"
    return update(movies)
  elsif choice == "delete"
    return delete(movies)
  elsif choice == "exit"
    puts `clear`
    return
  else
    puts `clear`
    puts $t8
    puts "I'm sorry, that is not a valid menu selection."
    puts "Please try again. Press enter to go back."
    gets
    main_menu(movies)
  end
end

main_menu($initial_movies)

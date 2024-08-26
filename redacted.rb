puts "Enter in a text:"
words = gets.chomp().split(' ')
puts "Enter some words to redact:"
redacted_words = gets.chomp().downcase().split(' ')
words.each() do |word|
  if redacted_words.include?(word.downcase())
    print "REDACTED "
  else
    print "#{word} "
  end
end

puts "Give me a sentence!:"
text = gets.chomp()
words = text.split(" ")
frequencies = Hash.new(0)
words.each() { |word| frequencies[word] += 1 }
frequencies = frequencies.sort_by do |word, count|
  count
end
frequencies.reverse!()
puts "Word frequencies:"
frequencies.each() { |word, count| puts "#{word} #{count}"}
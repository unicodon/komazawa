require "csv"

data = CSV.read('hunter.csv')

data.each_with_index { |row, index|
  date, time = ARGV[index % ARGV.count].split(":")
  if time == nil
    time = 1
  end
  command = "ruby koma.rb -d #{date} -t #{time} -n #{row[0]} -p #{row[1]}"
  puts command
}

class User
  # takes an ID argument and finds the User with that ID, returns a user object w/ information on that user from the DB
  def self.find(id)
    command = `sqlite3 test.db "SELECT * FROM users WHERE id = #{id}"`;
    sql_results_parser command
  end

  # returns all users in the database as objects inside of an array
  def self.all
    command = `sqlite3 test.db "SELECT * FROM users"`;
    sql_results_parser command
  end

  # returns an object containing the last user in the database
  def self.last
    command = `sqlite3 test.db "SELECT * FROM users WHERE id = (SELECT MAX(id) FROM users)"`;
    sql_results_parser command
  end

  # returns an object containing the first user in the database
  def self.first
    command = `sqlite3 test.db "SELECT * FROM users WHERE id = (SELECT MIN(id) FROM users)"`;
    sql_results_parser command
  end

  # some code to parse what gets returned from the SQL command
  def self.sql_results_parser(reply)
    lines = reply.split('\n')

    # Probably doing .first or .last: we only got one line back.
    if lines.length == 1
      return reply.split('|')
    end

    # Multiple Lines returned, assume .all was called.
    if lines.length > 1
      ret_arr = []
      (0..lines.length).each_with_index do |_line, i|
        ret_arr.push(lines[i].split('|'))
      end
      return ret_arr
    end

    null
  end # sql_results_parser

end

def init_db
  `sqlite3 test.db "CREATE TABLE IF NOT EXISTS users (
    id integer PRIMARY KEY AUTOINCREMENT,
    fname varchar(50),
    lname varchar(50),
    dateCreated timestamp DEFAULT current_timestamp
  );"`
  `sqlite3 test.db "INSERT INTO users (fname, lname) VALUES ('Alice', 'Alison');"`
  `sqlite3 test.db "INSERT INTO users (fname, lname) VALUES ('Bob', 'Bobson');"`
  `sqlite3 test.db "INSERT INTO users (fname, lname) VALUES ('Carl', 'Carlson');"`
end

init_db()
puts "Finding ID #1:"
puts User.find(1) # Should return Alice.
puts "Finding First:"
puts User.first()
puts "Finding Last:"
puts User.last()
puts "Finding All:"
puts User.all()
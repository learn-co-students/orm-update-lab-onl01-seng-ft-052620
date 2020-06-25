require_relative "../config/environment.rb"

class Student
  attr_accessor :name, :grade
  attr_reader :id

  def initialize(name, grade, id=nil)
  self.name = name
  self.grade = grade
  @id = id
  end

  def self.create_table
  sql = <<-SQL
      CREATE TABLE students (
        id INTEGER PRIMARY KEY,
        name TEXT, 
        grade TEXT
        )
        SQL
        DB[:conn].execute(sql)
      end
      
      #   # Remember, you can access your database connection anywhere in this class
      #   #  with DB[:conn]
      

  def self.drop_table
  sql = <<-SQL
      DROP TABLE IF EXISTS students
  SQL
  DB[:conn].execute(sql)
  end

  def save
  	if self.id
  		self.update
  	else
  		sql = <<-SQL
  			INSERT INTO students (name, grade)
  			VALUES (?, ?)
  		SQL
  		DB[:conn].execute(sql,self.name, self.grade)
  		sql = <<-SQL
  			SELECT *
  			FROM students
  			WHERE name = ?
  		SQL
  		@id = DB[:conn].execute(sql,self.name)[0][0]
  	end
  end

  def update
    sql = <<-SQL 
      UPDATE students 
      SET name = ?, grade = ? 
      WHERE id = ?
    SQL
    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end


  def self.create (name, grade)
    student = self.new(name, grade)
    student.save
  end

  def self.new_from_db(row)
  	self.new(row[1],row[2],row[0])
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * 
      FROM students
      WHERE name = ?
    SQL
   self.new_from_db(DB[:conn].execute(sql,name)[0])
    

  end

end

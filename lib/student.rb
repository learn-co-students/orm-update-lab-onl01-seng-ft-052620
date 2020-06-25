require_relative "../config/environment.rb"

class Student
attr_accessor :name, :grade
attr_reader :id 
  def initialize(id = nil, name, grade)
    @name = name
    @grade = grade
    @id = id 

  end
  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
  def self.create_table
    sql = <<-sql
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade INTEGER
      )
    sql
    DB[:conn].execute(sql)
  end
  def self.drop_table
    sql = <<-sql
      DROP TABLE students

    sql
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
 
      DB[:conn].execute(sql, self.name, self.grade)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    end
  end
  def update
    sql = "UPDATE students SET name = ?, grade = ? WHERE ID = ?"
    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end
  def self.create(name,grade)
    student_val = Student.new(name, grade)
    student_val.save
    student_val
  end
  def self.new_from_db(row)
    new_student = self.new(row[0], row[1], row[2])  
    new_student  
  end
  def self.find_by_name(name)
    sql = <<-sql
    SELECT * FROM students
    WHERE name = ?
    LIMIT 1
    sql
    DB[:conn].execute(sql, name).map do|row|
      self.new_from_db(row)
    end.first

  end
end

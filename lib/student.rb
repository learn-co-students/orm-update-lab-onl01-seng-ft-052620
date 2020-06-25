require_relative "../config/environment.rb"

class Student

  attr_accessor :name, :grade
  attr_reader :id

  def initialize(id=nil,name, grade)
    @id = id
    @name = name
    @grade = grade

  end

  def self.create_table
    sql = <<-sql
    CREATE TABLE students(
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade INTEGER
    );
    sql

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end

  def update
    sql = <<-sql
    UPDATE students set name = ?,
    grade = ?
    WHERE ID =?
    sql
    DB[:conn].execute(sql,self.name,self.grade,self.id)
  end

  def self.new_from_db(row)
    new_student = self.new(row[0], row[1], row[2])  
    new_student
  end

  def save
    if self.id
      self.update
    else
      sql = <<-sql
      INSERT INTO students(name, grade)
      VALUES(?,?)
      sql
      DB[:conn].execute(sql,self.name,self.grade)
      @id = DB[:conn].execute('SELECT last_insert_rowid() FROM students')[0][0]
    end
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
    # find the student in the database given a name
    # return a new instance of the Student class
  end



  def self.create(name,grade)
    student_val = Student.new(name, grade)
    student_val.save
    student_val
  end

    


  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]


end

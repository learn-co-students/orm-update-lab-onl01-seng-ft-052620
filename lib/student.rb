require_relative "../config/environment.rb"
require 'pry'

class Student
  attr_accessor :name, :grade, :number_of_saves
  attr_reader :id
  @@all = []

  def initialize(name, grade, id = nil)
    @number_of_saves = 0
    @name = name
    @grade = grade
    @id = id
    @@all << self
  end


  def self.create_table
    sql =  <<-SQL
  CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL
    DB[:conn].execute(sql)
  end


  def self.drop_table
    sql =  <<-SQL
    DROP TABLE students;
    SQL
    DB[:conn].execute(sql)
  end

  def save

    if @id == nil
    sql =  <<-SQL
    INSERT INTO students (name, grade)
    VALUES (?,?)
    SQL
    DB[:conn].execute(sql, self.name, self.grade)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  else
    sql =  <<-SQL
    UPDATE students
    SET name = ?, grade = ?
    WHERE students.id = ?;
    SQL
    DB[:conn].execute(sql, self.name, self.grade, @id)
    end

  end

  def self.create(name, grade)

    new_student = Student.new(name, grade)
    new_student.save
    new_student

  end

  def self.new_from_db(row)

    new_id = row[0]
    new_name = row[1]
    new_grade = row[2]
    new_student = Student.new(new_name, new_grade, new_id)
    new_student

  end

  def self.find_by_name(name)

    sql = <<-SQL
    SELECT *
    FROM students
    WHERE students.name = ?;
    SQL

    row = DB[:conn].execute(sql, name).flatten
    new_id = row[0]
    new_name = row[1]
    new_grade = row[2]
    new_student = Student.new(new_name, new_grade, new_id)
    new_student

    end

  def update

    sql =  <<-SQL
    UPDATE students
    SET name = ?, grade = ?
    WHERE students.id = ?;
    SQL
    DB[:conn].execute(sql, self.name, self.grade, id)

  end


end

class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    student = self.new
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    student
  end

  def self.all
    query = <<-SQL
      SELECT * FROM students
    SQL
    query_results = DB[:conn].execute(query)
    query_results.map do |row|
      new_from_db(row)
    end

    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * FROM students WHERE name = ? LIMIT 1;
    SQL
    query_result = DB[:conn].execute(sql, name).first
    new_from_db(query_result)
    # find the student in the database given a name
    # return a new instance of the Student class
  end
  
  def self.all_students_in_grade_9
    sql_query = <<-SQL
      SELECT * FROM students WHERE grade = 9;
    SQL
    query_results = DB[:conn].execute(sql_query)
    query_results.map {|row| new_from_db(row)}
  end
  
  def self.students_below_12th_grade
    sql_query = <<-SQL
      SELECT * FROM students WHERE grade < 12;
    SQL
    query_results = DB[:conn].execute(sql_query)
    query_results.map {|row| new_from_db(row)}
  end

  def self.first_X_students_in_grade_10(num)
    sql_query = <<-SQL
      SELECT * FROM students WHERE grade = 10 LIMIT ?
    SQL
    query_results = DB[:conn].execute(sql_query, num)
    query_results.map {|row| new_from_db(row)}
  end

  def self.first_student_in_grade_10
    first_X_students_in_grade_10(1).first
  end

  def self.all_students_in_grade_X(num)
    sql_query = <<-SQL
      SELECT * FROM students WHERE grade = ?
    SQL
    query_results = DB[:conn].execute(sql_query, num)
    query_results.map {|row| new_from_db(row)}
  end
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end

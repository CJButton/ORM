
require_relative 'question_likes'
require_relative 'reply_table'
require_relative 'questions_table'
require_relative 'questions_database'
require_relative 'question_follows'

require 'byebug'
class User
  attr_accessor :fname, :lname
  attr_reader :id

  def self.find_by_name(fname, lname)

    user = QuestionsDBConnection.instance.execute(<<-SQL, fname, lname)
      SELECT
        *
      FROM
        users
      WHERE
        fname = ? AND lname = ?
    SQL

    return nil if user.empty?
    User.new(user.first)
  end

  def self.find_by_id(id)
    user = QuestionsDBConnection.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        users
      WHERE
        id = ?
    SQL
    User.new(user.first)
  end

  # how is it working?
  def authored_questions
     Question.find_by_author_id(@id)
  end

  # def average_karma
  #   karma = QuestionsDBConnection.instance.execute(<<-SQL)
  #     SELECT
  #       AVG(count_of_likes)
  #     FROM
  # 
  #       (SELECT
  #         question_id
  #       FROM
  #         users
  #       JOIN questions ON user.id = questions.user_id
  #       WHERE
  #         user.id = @id
  #     )
  #   SQL

    #select user_id, question_id, count(*) from question_follows group by question_id order by count(*) DESC;

  end

  def authored_replies
    Reply.find_by_user_id(@id)
  end

  def initialize(options)
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
  end

  def followed_questions
    QuestionFollow.followed_questions_for_user_id(@id)
  end

  def liked_questions
    QuestionLike.liked_questions_for_user_id(@id)
  end

end

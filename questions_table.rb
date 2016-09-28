
require_relative 'question_follows'
require_relative 'reply_table'
require_relative 'question_likes'
require_relative 'questions_database'

#id INTEGER PRIMARY KEY,
# title TEXT NOT NULL,
# body TEXT NOT NULL,
# user_id INTEGER NOT NULL,

class Question

  attr_accessor :title, :body, :user_id
  attr_reader :id

  def self.find_by_id(id)

    question = QuestionsDBConnection.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        questions
      WHERE
        id = ?
    SQL
    return nil if question.empty?
    # question.map { |options| Question.new(options) } technically not need
    Question.new(question.first) #.first is need to access the options hash that resides inside questions array
  end

  def self.find_by_author_id(user_id)

    question = QuestionsDBConnection.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM
        questions
      WHERE
        user_id = ?
    SQL
    return nil if question.empty?
    question.map {|question| Question.new(question)}
  end

  def self.most_followed(n)
    QuestionFollow.most_followed_questions(n)
  end

  def initialize(options)
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @user_id = options['user_id']
  end

  def author
    @user_id
    # User.find_by_id(@user_id)
  end

  def replies
    Reply.find_by_question_id(@id)
  end

  def followers
    QuestionFollow.followers_for_question_id(@id)
  end

  def likers
    QuestionLike.likers_for_question_id(@id)
  end

  def num_likes
    QuestionLike.num_likes_for_question_id(@id)
  end
end

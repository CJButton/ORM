
require_relative 'questions_database'
require_relative 'questions_table'
require_relative 'users_table'


class QuestionFollow
  attr_reader :question_id, :user_id

  def self.followers_for_question_id(question_id)
    users = QuestionsDBConnection.instance.execute(<<-SQL, question_id: question_id)
      SELECT
        users.*
      FROM
        question_follows
      JOIN
        users ON question_follows.user_id = users.id
      WHERE
        question_follows.question_id = :question_id;
    SQL

    return nil if users.empty?
    # p users
    users.map { |user| User.new(user) }
  end

  def self.followed_questions_for_user_id(person)
    questions = QuestionsDBConnection.instance.execute(<<-SQL, person)
      SELECT
        questions.*
      FROM
        question_follows
      JOIN
        users ON question_follows.user_id = users.id
      JOIN
        questions ON question_follows.question_id = questions.id
      WHERE
        question_follows.user_id = ?;
    SQL

    return "nil" if questions.empty?
    # p users
    questions.map { |question| Question.new(question) }
  end

  def self.most_followed_questions(n)
    questions = QuestionsDBConnection.instance.execute(<<-SQL, n)
      SELECT
        questions.*
      FROM
        question_follows
      JOIN
        questions
        ON questions.id = question_follows.question_id
      GROUP BY
        question_id
      ORDER BY
        count(*)
      LIMIT
        ?;
    SQL
    questions.map {|question| Questions.new(question) }

  end

  def initialize(options)
    @user_id = options['user_id']
    @question_id = options['question_id']
  end

end

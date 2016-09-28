
require_relative 'users_table'
require_relative 'questions_table'
require_relative 'questions_database'

class QuestionLike

  def self.likers_for_question_id(question_id)
    users = QuestionsDBConnection.instance.execute(<<-SQL, question_id: question_id)
      SELECT
        users.*
      FROM
        question_likes
      JOIN
        users ON question_likes.user_id = users.id
      WHERE
        question_likes.question_id = :question_id;
    SQL

    return nil if users.empty?
    # p users
    users.map { |user| User.new(user) }
  end

  def self.num_likes_for_question_id(question_id)
    likes = QuestionsDBConnection.instance.execute(<<-SQL, question_id)
      SELECT
        COUNT(*) AS Likes
      FROM
        question_likes
      JOIN
        questions
        ON questions.id = question_likes.question_id
      WHERE question_id = ?
      GROUP BY
        question_id;
    SQL


    likes
  end

  def self.liked_questions_for_user_id(user_id)
    questions = QuestionsDBConnection.instance.execute(<<-SQL, user_id)
      SELECT
        questions.*
      FROM
        question_likes
      JOIN
        users ON question_likes.user_id = users.id
      JOIN
        questions ON question_likes.question_id = questions.id
      WHERE
        question_likes.user_id = ?;
    SQL

    return "nil" if questions.empty?

    questions.map { |question| Question.new(question) }
  end

end

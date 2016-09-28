


require_relative 'questions_database'

# CREATE TABLE replies (
#   id INTEGER PRIMARY KEY,
#   body TEXT NOT NULL,
#   question_id INTEGER NOT NULL,
#   parent_id INTEGER,
#   user_id INTEGER NOT NULL,
#
#   FOREIGN KEY (question_id) REFERENCES questions()
#   FOREIGN KEY (parent_id) REFERENCES replies(id),
#   FOREIGN KEY (user_id) REFERENCES users(id)

class Reply

  attr_accessor :body, :question_id, :parent_id, :user_id
  attr_reader :id

  def self.find_by_user_id(user_id)

    reply = QuestionsDBConnection.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM
        replies
      WHERE
        user_id = ?
    SQL
    return nil if reply.empty?
    # question.map { |options| Question.new(options) } technically not need
    Reply.new(reply.first) #.first is need to access the options hash that resides inside questions array
  end

  def self.find_by_question_id(question_id)

    reply = QuestionsDBConnection.instance.execute(<<-SQL, question_id)
      SELECT
        *
      FROM
        replies
      WHERE
        question_id = ?
    SQL
    return nil if reply.empty?
    reply.map {|reply| Reply.new(reply)}
  end

  def initialize(options)
    @id = options['id']
    @body = options['body']
    @question_id = options['question_id']
    @parent_id = options['parent_id']
    @user_id = options['user_id']
  end

  def author
    @user_id
  end

  def question
    @question_id
  end

  def parent_reply
    raise "#{self} has no parent reply" unless @parent_id

    reply = QuestionsDBConnection.instance.execute(<<-SQL, @parent_id)
      SELECT
        *
      FROM
        replies
      WHERE
        id = ?
    SQL

    Reply.new(reply.first)
  end

  def child_replies

    reply = QuestionsDBConnection.instance.execute(<<-SQL, @id)
      SELECT
        *
      FROM
        replies
      WHERE
        parent_id = ?
    SQL

    raise "#{self} has no children" if reply.nil?

    reply.map { |reply| Reply.new(reply) }
  end

end

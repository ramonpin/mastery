defmodule Mastery do
  alias Mastery.Boundary.{QuizSession, QuizManager}
  alias Mastery.Boundary.{TemplateValidator, QuizValidator}
  alias Mastery.Core.Quiz

  def start_quiz_manager() do
    QuizManager.start_link()
  end

  def build_quiz(fields) do
    with :ok <- QuizValidator.errors(fields),
         :ok <- QuizManager.build_quiz(fields), 
    do: :ok, else: (error -> error)
  end

  def add_template(title, fields) do
    with :ok <- TemplateValidator.errors(fields),
         :ok <- QuizManager.add_template(title, fields),
    do: :ok, else: (error -> error)
  end

  def take_quiz(title, email) do
    with %Quiz{} = quiz <- QuizManager.lookup_quiz_by_title(title),
         {:ok, session} <- QuizSession.start_link({quiz, email}),
    do: session, else: (error -> error)
  end

  def select_question(session) do
    QuizSession.select_question(session)
  end

  def answer_question(session, answer) do
    QuizSession.answer_question(session, answer)
  end
end

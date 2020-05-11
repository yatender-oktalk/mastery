defmodule Mastery.Core.Response do
  defstruct ~w[quiz_title template_name to email answer correct timestamp]a

  def new(quiz, email, answer) do
    question = quiz.current_question
    template = question.template

    %__MODULE__{
      answer: answer,
      template_name: template.name,
      email: email,
      quiz_title: quiz.title,
      correct: template.checker.(question.substitutions, answer),
      timestamp: DateTime.utc_now(),
      to: question.asked
    }
  end
end

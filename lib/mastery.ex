defmodule Mastery do
  @moduledoc false

  alias Mastery.Boundary.{QuizSession, QuizManager}
  alias Mastery.Boundary.{TemplateValidator, QuizValidator}
  alias Mastery.Core.Quiz


  def start_quiz_manager() do
    GenServer.start_link(QuizManager, %{}, name: QuizManager)
  end

  def build_quiz(fields) do
    with :ok <- QuizValidator.errors(fields),
    :ok <- GenServer.call(QuizManager, {:build_quiz, fields}) do
      :ok
    else
      error -> error
    end
  end

  def add_template(title, fields) do
    with :ok <- TemplateValidator.errors(fields),
    :ok <- GenServer.call(QuizManager, {:add_template, title, fields}) do
      :ok
    else
      error -> error
    end
  end

  def take_quiz(title, email) do
    with %Quiz{} = quiz <- QuizManager.lookup_quiz_by_title(title),
    {:ok, session} <- GenServer.start_link(QuizSession, {quiz, email})
    do
      session
    else
      error -> error
    end
  end


end

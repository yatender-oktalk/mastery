defmodule Worker do
  @moduledoc false

  def work(n) do
    if Enum.random(1..10) == 1 do
      raise "oops"
    else
      {:result, Enum.random(1..(n * 100))}
    end
  end

  def make_safe(dangerous_work, arg) do
    try do
      apply(dangerous_work, [arg])
    rescue
      error ->
        # include any needed context here
        {:error, error, arg}
    end
  end

  def stream_work do
    Stream.iterate(1, &(&1 + 1))
    |> Stream.map(fn i -> make_safe(&work/1, i) end)
  end

  def work do
    Worker.stream_work()
    |> Enum.reduce_while([], fn
      {:error, _error, _context} = error, _results ->
        {:halt, error}

      result, results ->
        {:cont, [result | results]}
    end)
    |> case do
      {:error, _error, _context} = error ->
        error

      results ->
        Enum.reverse(results)
    end
    |> IO.inspect()
  end
end

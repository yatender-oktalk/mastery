defmodule Cache do
  @moduledoc false

  def cacheble(module, function, args) do
    case val = check_cache(module, function, args) do
      true ->
        val

      false ->
        res = apply(module, function, args)
        save_cache(module, function, args, res)
    end
  end

  defp check_cache(_m, _f, _a) do
    Enum.random([true, false])
  end

  defp save_cache(m, f, a, _res) do
    get_key(m, f, a)
    :ok
  end

  defp get_key(_m, _f, _a) do
    "return_key_from_mfa"
  end
end

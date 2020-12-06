defmodule Conduit.Support.TimeSupport do
  def to_utc_naive(%DateTime{} = dt) do
    dt
    |> DateTime.shift_zone!("Etc/UTC")
    |> DateTime.to_naive()
    |> to_utc_naive()
  end

  def to_utc_naive(%NaiveDateTime{} = ndt) do
    ndt
    |> NaiveDateTime.truncate(:second)
  end
end

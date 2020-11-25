defmodule Conduit.Factory do
  use ExMachina

  def user_factory do
    %{
      email: sequence(:email, &"jake#{&1}@jake.jake"),
      username: sequence(:username, &"jake#{&1}"),
      hashed_password: sequence(:password, &"jakejake#{&1}"),
      bio: "I like to skateboard, dude",
      image: "https://i.stack.imgur.com/xHWG8.jpg"
    }
  end
end

script_hello_world = {
  ["en"] = {
    { "Speaker1", "Hello world!" },
    { "Speaker2", "Oh, hey there!" },
    { "Speaker1", "This was a nice conversation" },
    { "Speaker2", "Choose this for me:"},
    { type = "choice", choices = {
      { "Choice 1 the best",
          branch = {
            { "Another person", "Oh this is another scene from your branches! How awesome!" },
          },
        },
      { "Choice two", action = "" },
      { "Choice three just to see", branch = {
        { "Another person", "Oh this is another scene from your branches! How awesome!" },
        },
      },
      { "Choice four that's the most", type = "", action = "" },
    }},  },
  ["br"] = {
    { "Fulano 1", "Hello world!" },
    { "Beltrano 2", "Oh, hey there!" },
    { "Fulano ", "This was a nice conversation" },
  }
}

script_choice_three = {
  ["en"] = {
    { "Another person", "Oh this is another scene from your branches! How awesome!" },
  }
}
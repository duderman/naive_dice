alias NaiveDice.Repo
alias NaiveDice.Events.Event

%Event{title: "THE BEST EVER SHOW", allocation: 5}
|> Event.changeset()
|> Repo.insert!()

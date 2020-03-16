# NaiveDice

The app is deployed to managed Kubernetes cluster on DO. Configs can be found in [`k8s`](k8s/) folder. Deploy-related commands are implemented in [`Makefile`](Makefile). Docker image lives in a private DockerHub repository.

[http://app.naivedice.site/](http://app.naivedice.site/)

# Development

To start the app:

  * Install dependencies with `mix deps.get`
  * Create, migrate and seed your database with `mix ecto.setup`
  * Install Node.js dependencies with `cd assets && yarn install`
  * Export Stripe API Keys `export STRIPE_API_KEY=youkey STRIPE_PUBLIC_KEY=youpubkey`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

To run tests: `mix test`

# TODO

There are still few things left to do or at least consider. F.e:

* If the user spends too much time on the reservation page the reservation is going to expire but the payment will still go through. Can be fixed through JS on the frontend but due to the low probability and time limit left for later
* Tickets price and currency are hardcoded because there were no requirements regarding that
* Local development ideally should be done using docker-compose but because of time limitations and nature of the project can be implemented later
* Run production migrations from distillery release hooks. At the moment done by manually calling release task inside the app pod
* Monitoring, log-collection, errors tracking e.t.c
* Scaling is going to be problematic atm. The app uses locking system that relies on some processes living on the same machine. Plus each replica is going to perform its own reservations expiration checks. In future can be sorted using separate systems, extracting required functionality into different apps e.t.c
* SSL
* Implement health checks so kubernetes will be able to properly handle deployments and pods availability
* CI/CD

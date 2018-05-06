defmodule RidesApi.Scheduler do
  # Injects the Quantum scheduler functions into the RidesApi app
  # Enable Quantum cron like functionality
  use Quantum.Scheduler, otp_app: :rides_api
end

defmodule RidesApi.Scheduler do
  # Injects the Quantum scheduler functions into the RidesApi server
  # Enable Quantum cron like functionality
  use Quantum.Scheduler, otp_app: :rides_api
end

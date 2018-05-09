#!/bin/sh
echo "About to run migrate and seed script"
$RELEASE_ROOT_DIR/bin/rides_api command "Elixir.RidesApi.ReleaseTasks" migrate_seed
echo "Finished running migrate and seed script"

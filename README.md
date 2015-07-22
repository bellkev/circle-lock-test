# circle-lock-test

This is a simple helper script to ensure that a certain action happens once at a time on a CircleCI project.
It is a higher-order command like `sudo`, so you can wrap whatever other commands you want with it.

## Dependencies

There are currently a couple of prerequisites for using the `do-exclusively` script.
`jq` must be installed (see the circle.yml in the circle-lock-test project for an example install)
`$CIRCLE_TOKEN` must be set to a CircleCI API token that can read builds for that project (either a user or project API token will work)

## Usage

`do-exclusively --branch <somebranch> --tag <sometag> echo "whatever commands I want"`
The branch and tag arguments are both optional and limit the scope of the command and its lock to a given branch
name or builds whose commit message contains a certain commit message. If neither option is used,
the wrapped command will run on every build of the project and will wait for any other builds of the
project to finish before running.

## Examples

`do-exclusively --tag smoketest echo "Run my smoke tests"`

Only run on builds with a commit message like "Do lots of stuff [smoketest]", and ensure that any
other builds tagged [smoketest] finish before this action begins.

`do-exclusively --branch staging ./deploy.sh staging`

Only run on builds on the `staging` branch, and wait for all other `staging` branch builds
to finish before running.

# circle-lock-test

## Usage

```
do-exclusively --branch <somebranch> --tag <sometag> echo My commands ...
```
The branch and tag arguments are both optional and limit the scope of the command and its lock to a given branch name or builds whose commit message contains a certain commit message. For example:

```
do-exclusively --tag smoketest echo "Run my smoke tests"
```
Would only run on builds with a commit message like "Do lots of stuff [smoketest]".

#!/usr/bin/env bats


setup() {
    source do-exclusively
}

@test "pargse_args branch" {
    parse_args --branch "crazy branchname"
    [[ "$branch" == "crazy branchname" && -z "${tag+x}" && -z "${rest[0]+x}" ]]
}

@test "pargse_args commit tag" {
    parse_args --tag "crazy tag"
    [[ -z "${branch+x}" && "$tag" == "crazy tag" && -z "${rest[0]+x}" ]]
}

@test "pargse_args branch and tag and rest" {
    parse_args --tag "crazy tag" --branch "crazy branch" foo bar
    [[ "$tag" == "crazy tag" && "$branch" == "crazy branch" && "${rest[0]}" == "foo" && "${rest[1]}" == "bar" && -z "${rest[2]+x}" ]]
}

@test "parse_args empty" {
    parse_args
    [[ -z "${branch+x}" && -z "${tag+x}" && -z "${rest[0]+x}" ]]
}

@test "skip if wrong branch" {
    branch=foo
    CIRCLE_BRANCH=bar
    should_skip
}

@test "don't skip if right branch" {
    branch=foo
    CIRCLE_BRANCH=foo
    ! should_skip
}

@test "skip if wrong tag" {
    tag=foo
    commit_message="No tag"
    should_skip
}

@test "don't skip if right tag" {
    tag=foo
    commit_message="Has [foo] tag"
    ! should_skip
}

@test "don't skip if branch/tag unset" {
    ! should_skip
}

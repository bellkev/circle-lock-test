#!/usr/bin/env bats

setup() {
    source do-exclusively
}

@test "pargse_args branch" {
    parse_args --branch "crazy branchname"
    [[ "$branch" == "crazy branchname" && -z "${tag+x}" && -z "${rest[0]+x}"]]
}

@test "pargse_args commit tag" {
    parse_args --tag "crazy tag"
    [[ -z "${branch+x}" && "$tag" == "crazy tag" && -z "${rest[0]+x}"]]
}

@test "pargse_args branch and tag and rest" {
    parse_args --tag "crazy tag" --branch "crazy branch" foo bar
    [[ "$tag" == "crazy tag" && "$branch" == "crazy branch" && "${rest[0]}" == "foo" && "${rest[1]}" == "bar" && -z "${rest[2]+x}" ]]
}

@test "parse_args empty" {
    parse_args
    [[ -z "${branch+x}" && -z "${tag+x}" == "crazy tag" && -z "${rest[0]+x}"]]
}

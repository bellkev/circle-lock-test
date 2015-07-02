#!/usr/bin/env bats


setup() {
    source do-exclusively
    test_data='[{ "build_num": 1, "status": "running", "branch": "foo", "subject": "Has [bar] tag"},
                { "build_num": 2, "status": "pending", "branch": "foo", "subject": "Has [bar] tag"},
                { "build_num": 3, "status": "queued", "branch": "foo", "subject": "Has [bar] tag"},
                { "build_num": 4, "status": "pending", "branch": "foo", "subject": "No tag"},
                { "build_num": 5, "status": "pending", "branch": "not-foo", "subject": "Has [bar] tag"},
                { "build_num": 6, "status": "pending", "branch": "foo", "subject": "Has [bar] tag"}]'
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

@test "filter on build_num" {
    CIRCLE_BUILD_NUM=6
    make_jq_prog
    result=$(echo $test_data | jq "$jq_prog")
    [[ "$result" == 1?2?3?4?5 ]]
}

@test "filter on branch" {
    CIRCLE_BUILD_NUM=6
    branch=foo
    make_jq_prog
    result=$(echo $test_data | jq "$jq_prog")
    [[ "$result" == 1?2?3?4 ]]
}

@test "filter on tag" {
    CIRCLE_BUILD_NUM=6
    tag=bar
    make_jq_prog
    result=$(echo $test_data | jq "$jq_prog")
    [[ "$result" == 1?2?3?5 ]]
}

@test "filter on tag and branch" {
    CIRCLE_BUILD_NUM=6
    tag=bar
    branch=foo
    make_jq_prog
    result=$(echo $test_data | jq "$jq_prog")
    [[ "$result" == 1?2?3 ]]
}

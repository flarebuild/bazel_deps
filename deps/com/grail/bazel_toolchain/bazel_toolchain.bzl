load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def bazel_toolchain(name, version, sha256):
    http_archive(
        name = name,
        sha256 = sha256,
        strip_prefix = "bazel-toolchain-%s" % version,
        urls = ["https://github.com/grailbio/bazel-toolchain/archive/%s.tar.gz" % version ],
        repo_mapping = {
            "@rules_cc": "@build_bazel_rules_cc",
        },
    )
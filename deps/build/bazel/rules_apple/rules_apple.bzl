load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def rules_apple(name, version, sha256):
    http_archive(
        name = "build_bazel_rules_apple",
        strip_prefix = "rules_apple-%s" % version,
        sha256 = sha256,
        urls = [ x % version for x in [
            "https://storage.googleapis.com/grpc-bazel-mirror/github.com/bazelbuild/rules_apple/archive/%s.tar.gz",
            "https://github.com/bazelbuild/rules_apple/archive/%s.tar.gz",
        ]],
    )
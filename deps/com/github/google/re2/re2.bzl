load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def re2(name, version, sha256):
    http_archive(
        name = name,
        sha256 = sha256,
        strip_prefix = "re2-%s" % version,
        urls = [ x % version for x in [
            "https://storage.googleapis.com/grpc-bazel-mirror/github.com/google/re2/archive/%s.tar.gz",
            "https://github.com/google/re2/archive/%s.tar.gz",
        ]],
    )
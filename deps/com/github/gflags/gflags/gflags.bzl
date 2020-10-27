load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def gflags(name, sha256, version):
    http_archive(
        name = name,
        sha256 = sha256,
        strip_prefix = "gflags-%s" % version,
        urls = [ x % version for x in [
            "https://storage.googleapis.com/grpc-bazel-mirror/github.com/gflags/gflags/archive/%s.tar.gz",
            "https://github.com/gflags/gflags/archive/%s.tar.gz",
        ]],
    )
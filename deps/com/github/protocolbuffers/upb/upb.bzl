load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def upb(name, version, sha256):
    http_archive(
        name = name,
        sha256 = sha256,
        strip_prefix = "upb-%s" % version,
        urls = [ x % version for x in [
            "https://storage.googleapis.com/grpc-bazel-mirror/github.com/protocolbuffers/upb/archive/%s.tar.gz",
            "https://github.com/protocolbuffers/upb/archive/%s.tar.gz",
        ]],
    )
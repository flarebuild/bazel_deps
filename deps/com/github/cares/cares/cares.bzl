load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def cares(name, version, sha256):
    http_archive(
        name = name,
        build_file = "@com_github_grpc_grpc//third_party:cares/cares.BUILD",
        sha256 = sha256,
        strip_prefix = "c-ares-%s" % version,
        urls = [ x % version for x in [
            "https://storage.googleapis.com/grpc-bazel-mirror/github.com/c-ares/c-ares/archive/%s.tar.gz",
            "https://github.com/c-ares/c-ares/archive/%s.tar.gz",
        ]],
    )
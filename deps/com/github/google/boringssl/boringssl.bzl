load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def boringssl(name, version, sha256):
    http_archive(
        name = name,
        sha256 = sha256,
        strip_prefix = "boringssl-%s" % version,
        url = "https://github.com/google/boringssl/archive/%s.tar.gz" % version,
    )
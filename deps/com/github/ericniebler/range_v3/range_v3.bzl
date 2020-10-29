load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def range_v3(name, version, sha256):
    http_archive(
        name = name,
        sha256 = sha256,
        strip_prefix = "range-v3-%s" % version,
        urls = [
            "https://github.com/ericniebler/range-v3/archive/%s.tar.gz" % version,
        ],
    )
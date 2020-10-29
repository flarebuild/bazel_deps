load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def abseil_cpp(name, version, sha256):
    http_archive(
        name = name,
        sha256 = sha256,
        strip_prefix = "abseil-cpp-%s" % version,
        urls = ["https://github.com/abseil/abseil-cpp/archive/%s.zip" % version],
    )
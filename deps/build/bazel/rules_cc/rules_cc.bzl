load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def rules_cc(name, version, sha256):
    http_archive(
        name = name,
        sha256 = sha256,
        strip_prefix = "rules_cc-%s" % version,
        urls = ["https://github.com/bazelbuild/rules_cc/archive/%s.tar.gz" % version],
    )

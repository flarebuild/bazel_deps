load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def rules_rust(name, version, sha256):
    http_archive(
        name = name,
        sha256 = sha256,
        strip_prefix = "rules_rust-%s" % version,
        urls = [ "https://github.com/bazelbuild/rules_rust/archive/%s.tar.gz" % version, ],

    )

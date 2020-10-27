load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def apple_support(name, version, sha256):
    http_archive(
        name = name,
        urls = [
            "https://github.com/bazelbuild/apple_support/releases/download/{version}/apple_support.{version}.tar.gz".format(version = version),
        ],
        sha256 = sha256,
    )
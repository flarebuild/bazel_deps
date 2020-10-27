load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def rules_swift(name, version, sha256):
    http_archive(
        name = name,
        urls = [
            "https://github.com/bazelbuild/rules_swift/releases/download/{version}/rules_swift.{version}.tar.gz".format(version = version),
        ],
        sha256 = sha256,
    )
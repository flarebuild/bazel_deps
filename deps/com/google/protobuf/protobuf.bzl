load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def protobuf(name, version, sha256):
    http_archive(
        name = name,
        sha256 = sha256,
        strip_prefix = "protobuf-%s" % version,
        urls = ["https://github.com/protocolbuffers/protobuf/archive/v%s.zip" % version],
        repo_mapping = {
            "@rules_python": "@build_bazel_rules_python",
            "@zlib": "@net_zlib",
        }
    )

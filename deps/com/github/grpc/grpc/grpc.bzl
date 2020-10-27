load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def grpc(name, version, sha256):
    http_archive(
        name = name,
        sha256 = sha256,
        strip_prefix = "grpc-%s" % version,
        urls = ["https://github.com/grpc/grpc/archive/v%s.zip" % version],
        repo_mapping = {
            "@boringssl": "@com_github_google_boringssl",
            "@rules_cc": "@build_bazel_rules_cc",
            "@rules_python": "@build_bazel_rules_python",
            "@upb": "@com_github_protocolbuffers_upb",
            "@zlib": "@net_zlib",
        },
    )
    native.bind(
        name = "protobuf_clib",
        actual = "@com_google_protobuf//:protoc_lib",
    )
    native.bind(
        name = "protobuf_headers",
        actual = "@com_google_protobuf//:protobuf_headers",
    )
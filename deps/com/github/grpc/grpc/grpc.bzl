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
            "@com_google_absl": "@com_github_abseil_abseil_cpp",
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
    native.bind(
        name = "upb_lib",
        actual = "@com_github_protocolbuffers_upb//:upb",
    )
    native.bind(
        name = "libssl",
        actual = "@com_github_google_boringssl//:ssl",
    )
    native.bind(
        name = "madler_zlib",
        actual = "@net_zlib//:zlib",
    )
    native.bind(
        name = "cares",
        actual = "@com_github_cares_cares//:ares",
    )
    native.bind(
        name = "re2",
        actual = "@com_github_google_re2//:re2",
    )

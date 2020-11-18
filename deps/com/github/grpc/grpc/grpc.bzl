load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

_PATCH = """
--- src/core/tsi/alts/crypt/gsec.h
+++ src/core/tsi/alts/crypt/gsec.h
@@ -27,10 +27,14 @@

 #include <grpc/grpc.h>

+#ifdef FLARE_MUSL
+#include <fcntl.h>
+#else
 struct iovec {
   void* iov_base;
   size_t iov_len;
 };
+#endif

 /**
  * A gsec interface for AEAD encryption schemes. The API is thread-compatible.
"""

def _grpc_impl(repository_ctx):
    version = repository_ctx.attr.version
    sha256 = repository_ctx.attr.sha256
    repository_ctx.download_and_extract(
        "https://github.com/grpc/grpc/archive/v%s.zip" % version,
        output = ".",
        sha256 = sha256,
        type = "zip",
        stripPrefix = "grpc-%s" % version,
    )
    if repository_ctx.os.name.lower().startswith("linux"):
        repository_ctx.file(
            "grpc_patch.diff",
            _PATCH,
        )
        repository_ctx.patch("grpc_patch.diff")

_grpc = repository_rule(
    implementation = _grpc_impl,
    local = True,
    attrs = {
        "version": attr.string(mandatory=True),
        "sha256": attr.string(mandatory=True),
    },
)

def grpc(name, version, sha256):
    _grpc(
        name = name,
        sha256 = sha256,
        version = version,
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
        name = "protocol_compiler",
        actual = "@com_google_protobuf//:protoc",
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

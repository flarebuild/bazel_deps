load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

BUILD_CONTENT = """
cc_library(
    name = "portable_concurrency",
    srcs = glob([
        "portable_concurrency/bits/*.cpp",
    ]),
    includes = [
        ".",
    ],
    hdrs = glob([
        "portable_concurrency/*",
        "portable_concurrency/bits/*.h",
        "portable_concurrency/bits/*.hpp",
    ]),
    copts = [ "-std=c++17" ],
    visibility = ["//visibility:public"],
)
"""

def _portable_concurrency_impl(repository_ctx):
    version = repository_ctx.attr.version
    repository_ctx.download_and_extract(
        "https://github.com/VestniK/portable_concurrency/archive/{version}.zip".format(version = version),
        output = ".",
        sha256 = repository_ctx.attr.sha256,
        type = "zip",
        stripPrefix = "portable_concurrency-{version}".format(version = version),
    )
    repository_ctx.file(
        "BUILD",
        content = BUILD_CONTENT
    )

_portable_concurrency = repository_rule(
    implementation = _portable_concurrency_impl,
    local = True,
    attrs = {
        "version": attr.string(mandatory=True),
        "sha256": attr.string(mandatory=True),
    },
)

def portable_concurrency(name, version, sha256):
    _portable_concurrency(
        name = name,
        sha256 = sha256,
        version = version,
    )

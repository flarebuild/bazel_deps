load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

_BUILD_CONTENT = """
cc_library(
    name = "chaiscript",
    includes = [
        "include",
    ],
    hdrs = glob([
        "include/**/*.hpp",
    ]),
    visibility = ["//visibility:public"],
)
"""

def chaiscript(name, version, sha256):
    http_archive(
        name = name,
        urls = [ "https://github.com/ChaiScript/ChaiScript/archive/v%s.zip" % version, ],
        strip_prefix = "ChaiScript-%s" % version,
        sha256 = sha256,
        build_file_content = _BUILD_CONTENT
    )
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

_BUILD_CONTENT = """
package(default_visibility = ["//visibility:public"])

licenses(["notice"])  # BSD/MIT-like license (for zlib)

cc_library(
    name = "zlib",
    srcs = [
        "adler32.c",
        "compress.c",
        "crc32.c",
        "crc32.h",
        "deflate.c",
        "deflate.h",
        "gzclose.c",
        "gzguts.h",
        "gzlib.c",
        "gzread.c",
        "gzwrite.c",
        "infback.c",
        "inffast.c",
        "inffast.h",
        "inffixed.h",
        "inflate.c",
        "inflate.h",
        "inftrees.c",
        "inftrees.h",
        "trees.c",
        "trees.h",
        "uncompr.c",
        "zconf.h",
        "zutil.c",
        "zutil.h",
    ],
    hdrs = ["zlib.h"],
    copts = select({
        "//:windows": [],
        "//conditions:default": [
            "-Wno-shift-negative-value",
            "-DZ_HAVE_UNISTD_H",
        ],
    }),
    includes = ["."],
)

config_setting(
    name = "windows",
    constraint_values = [
        "@bazel_tools//platforms:windows",
    ],
    visibility = ["//visibility:public"],
)

"""


def zlib(name, version, sha256):
    http_archive(
        name = name,
        sha256 = sha256,
        strip_prefix = "zlib-%s" % version,
        urls = [x % version for x in [
            "https://mirror.bazel.build/zlib.net/zlib-%s.tar.gz",
            "https://zlib.net/zlib-%s.tar.gz",
        ]],
        build_file_content = _BUILD_CONTENT
    )

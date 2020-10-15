load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

_BUILD_CONTENT = """
# Description:
#   bzip2 is a high-quality data compressor.

licenses(["notice"])  # BSD derivative

cc_library(
    name = "bz2lib",
    srcs = [
        "blocksort.c",
        "bzlib.c",
        "bzlib_private.h",
        "compress.c",
        "crctable.c",
        "decompress.c",
        "huffman.c",
        "randtable.c",
    ],
    hdrs = [
        "bzlib.h",
    ],
    includes = ["."],
    visibility = ["//visibility:public"],
)
"""

def bzip(name, version, sha256):
    http_archive(
        name = name,
        sha256 = sha256,
        strip_prefix = "bzip2-%s" % version,
        url = "https://sourceware.org/pub/bzip2/bzip2-%s.tar.gz" % version,
        build_file_content = _BUILD_CONTENT
    )
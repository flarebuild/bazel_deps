load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

_BUILD_CONTENT = """
cc_library(
    name = "zstd",
    hdrs = ["lib/zstd.h"],
    includes = ["lib"],
    visibility = ["//visibility:public"],
    deps = [
        ":common",
        ":compress",
        ":decompress",
        ":deprecated",
    ],
)

cc_library(
    name = "compress",
    srcs = glob([
        "lib/compress/zstd*.c",
        "lib/compress/hist.c",
    ]),
    hdrs = glob([
        "lib/compress/zstd*.h",
    ]),
    visibility = ["//visibility:public"],
    deps = [":common"],
)

cc_library(
    name = "decompress",
    srcs = glob(["lib/decompress/zstd*.c"]) + [
        "lib/decompress/zstd_decompress_internal.h",
        "lib/decompress/zstd_decompress_block.h",
        "lib/decompress/zstd_ddict.h",
    ],
    hdrs = glob([
        "lib/decompress/*_impl.h",
    ]),
    visibility = ["//visibility:public"],
    deps = [
        ":common",
        ":legacy",
    ],
)

cc_library(
    name = "deprecated",
    srcs = glob(["lib/deprecated/*.c"]),
    hdrs = glob([
        "lib/deprecated/*.h",
    ]),
    visibility = ["//visibility:public"],
    deps = [":common"],
)

cc_library(
    name = "legacy",
    srcs = glob(["lib/legacy/*.c"]),
    hdrs = glob([
        "lib/legacy/*.h",
    ]),
    copts =
        select({
            ":windows": [],
            "//conditions:default": ["-Wno-uninitialized"],
        }),
    defines = [
        "ZSTD_LEGACY_SUPPORT=4",
    ],
    includes = ["lib/legacy"],
    visibility = ["//visibility:public"],
    deps = [":common"],
)

cc_library(
    name = "compiler",
    hdrs = [
        "lib/common/compiler.h",
    ],
    includes = ["lib/common"],
    visibility = ["//visibility:public"],
)

cc_library(
    name = "cpu",
    hdrs = [
        "lib/common/cpu.h",
    ],
    visibility = ["//visibility:public"],
)

cc_library(
    name = "bitstream",
    hdrs = [
        "lib/common/bitstream.h",
    ],
    visibility = ["//visibility:public"],
)

cc_library(
    name = "entropy",
    srcs = [
        "lib/common/entropy_common.c",
        "lib/common/fse_decompress.c",
        "lib/compress/fse_compress.c",
        "lib/compress/hist.h",
        "lib/compress/huf_compress.c",
        "lib/decompress/huf_decompress.c",
    ],
    hdrs = [
        "lib/common/fse.h",
        "lib/common/huf.h",
    ],
    visibility = ["//visibility:public"],
    deps = [
        ":bitstream",
        ":compiler",
        ":debug",
        ":errors",
        ":mem",
    ],
)

cc_library(
    name = "errors",
    srcs = ["lib/common/error_private.c"],
    hdrs = [
        "lib/common/error_private.h",
        "lib/common/zstd_errors.h",
    ],
    visibility = ["//visibility:public"],
)

cc_library(
    name = "mem",
    hdrs = [
        "lib/common/mem.h",
    ],
    visibility = ["//visibility:public"],
)

cc_library(
    name = "pool",
    srcs = [
        "lib/common/pool.c",
    ],
    hdrs = [
        "lib/common/pool.h",
    ],
    visibility = ["//visibility:public"],
    deps = [
        ":threading",
        ":zstd_common",
    ],
)

cc_library(
    name = "threading",
    srcs = ["lib/common/threading.c"],
    hdrs = [
        "lib/common/threading.h",
    ],
    defines = [
        "ZSTD_MULTITHREAD",
    ],
    linkopts = [
        "-pthread",
    ],
    visibility = ["//visibility:public"],
    deps = [
        ":debug",
    ],
)

cc_library(
    name = "xxhash",
    srcs = ["lib/common/xxhash.c"],
    hdrs = [
        "lib/common/xxhash.h",
    ],
    defines = [
        "XXH_NAMESPACE=ZSTD_",
    ],
    visibility = ["//visibility:public"],
)

cc_library(
    name = "zstd_common",
    srcs = ["lib/common/zstd_common.c"],
    hdrs = [
        "lib/common/zstd_internal.h",
        "lib/zstd.h",
    ],
    includes = ["lib"],
    visibility = ["//visibility:public"],
    deps = [
        ":compiler",
        ":debug",
        ":entropy",
        ":errors",
        ":mem",
        ":xxhash",
    ],
)

cc_library(
    name = "debug",
    srcs = [
        "lib/common/debug.c",
    ],
    hdrs = [
        "lib/common/debug.h",
    ],
    includes = ["lib/common"],
    visibility = ["//visibility:public"],
)

cc_library(
    name = "common",
    deps = [
        ":bitstream",
        ":compiler",
        ":cpu",
        ":debug",
        ":entropy",
        ":errors",
        ":mem",
        ":pool",
        ":threading",
        ":xxhash",
        ":zstd_common",
    ],
)

config_setting(
    name = "windows",
    constraint_values = [
        "@bazel_tools//platforms:windows",
    ],
)
"""

def zstd(name, version, sha256):
    http_archive(
        name = name,
        sha256 = sha256,
        strip_prefix = "zstd-%s" % version,
        urls = [x.format(version = version) for x in [
            "https://mirror.bazel.build/github.com/facebook/zstd/releases/download/v{version}/zstd-{version}.tar.gz",
            "https://github.com/facebook/zstd/releases/download/v{version}/zstd-{version}.tar.gz",
        ]],
        build_file_content = _BUILD_CONTENT
    )

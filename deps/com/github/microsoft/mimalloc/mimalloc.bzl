BUILD_CONTENT = """
cc_library(
    name = "mimalloc",
    includes = [ "include" ],
    srcs = glob([
        "src/stats.c",
        "src/random.c",
        "src/os.c",
        "src/arena.c",
        "src/region.c",
        "src/segment.c",
        "src/page.c",
        "src/alloc.c",
        "src/alloc-aligned.c",
        "src/alloc-posix.c",
        "src/heap.c",
        "src/options.c",
        "src/init.c",
        "src/bitmap.inc.c",
    ]),
    local_defines = select({
        "@bazel_tools//src/conditions:darwin": [
            "MI_OSX_ZONE=1",
        ],
        "//conditions:default": [],
    }),
    hdrs = glob([
        "include/*.h",
        "src/bitmap.inc.c",
        "src/alloc-override.c",
        "src/alloc-override-osx.c",
        "src/page-queue.c",
        
    ]),
    visibility = ["//visibility:public"],
)

cc_library(
    name = "mimalloc_override",
    srcs = [ "src/override.cpp" ],
    deps = [ ":mimalloc" ],
    visibility = ["//visibility:public"],
    local_defines = select({
        "@bazel_tools//src/conditions:darwin": [
            "MI_OSX_ZONE=1",
        ],
        "//conditions:default": [],
    }),
)

"""

OVERRIDE_CPP = """
#include <mimalloc-new-delete.h>
#include <mimalloc-override.h>
"""


def _mimalloc_impl(repository_ctx):
    version = repository_ctx.attr.version
    repository_ctx.download_and_extract(
        "https://github.com/microsoft/mimalloc/archive/v{version}.zip".format(version = version),
        output = ".",
        sha256 = repository_ctx.attr.sha256,
        type = "zip",
        stripPrefix = "mimalloc-{version}".format(version = version),
    )
    repository_ctx.file(
        "src/override.cpp",
        content = OVERRIDE_CPP
    )
    repository_ctx.file(
        "BUILD",
        content = BUILD_CONTENT
    )

_mimalloc = repository_rule(
    implementation = _mimalloc_impl,
    local = True,
    attrs = {
        "version": attr.string(mandatory=True),
        "sha256": attr.string(mandatory=True),
    },
)

def mimalloc(name, version, sha256):
    _mimalloc(
        name = name,
        sha256 = sha256,
        version = version,
    )
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

BUILD_CONTENT = """
cc_library(
    name = "mdbx",
    srcs = glob([
        "src/alloy.c",
    ]),
    includes = [
        "src",
        ".",
    ],
    hdrs = glob([
        "mdbx.h",
        "src/*.h",
        "src/*.c",
    ]),
    local_defines = [
        "MDBX_CONFIG_H=src/config.h",
    ],
    visibility = ["//visibility:public"],
)
"""

CONFIG_H_CONTENT = """
#define LTO_ENABLED
/* #undef MDBX_USE_VALGRIND */
/* #undef ENABLE_GPROF */
/* #undef ENABLE_GCOV */
/* #undef ENABLE_ASAN */
/* #undef MDBX_FORCE_ASSERTIONS */

/* Common */
#define MDBX_HUGE_TRANSACTIONS 0
#define MDBX_TXN_CHECKOWNER 1
#define MDBX_ENV_CHECKPID_AUTO
#ifndef MDBX_ENV_CHECKPID_AUTO
#define MDBX_ENV_CHECKPID 0
#endif
#define MDBX_LOCKING_AUTO
#ifndef MDBX_LOCKING_AUTO
/* #undef MDBX_LOCKING */
#endif
#define MDBX_TRUST_RTC_AUTO
#ifndef MDBX_TRUST_RTC_AUTO
#define MDBX_TRUST_RTC 0
#endif

/* Windows */
#define MDBX_CONFIG_MANUAL_TLS_CALLBACK 0
#define MDBX_AVOID_CRT 0

/* MacOS & iOS */
#define MDBX_OSX_SPEED_INSTEADOF_DURABILITY 0

/* POSIX */
#define MDBX_DISABLE_GNU_SOURCE 0
#define MDBX_USE_OFDLOCKS_AUTO
#ifndef MDBX_USE_OFDLOCKS_AUTO
#define MDBX_USE_OFDLOCKS 0
#endif

/* Build Info */
#ifndef MDBX_BUILD_TIMESTAMP
#define MDBX_BUILD_TIMESTAMP "2020-11-06T09:36:27Z"
#endif
#ifndef MDBX_BUILD_TARGET
#define MDBX_BUILD_TARGET "x86_64"
#endif
#ifndef MDBX_BUILD_TYPE
#define MDBX_BUILD_TYPE "MinSizeRel"
#endif
#ifndef MDBX_BUILD_COMPILER
#define MDBX_BUILD_COMPILER "clang"
#endif
#ifndef MDBX_BUILD_FLAGS
#define MDBX_BUILD_FLAGS " -fexceptions -fcxx-exceptions -frtti -fno-common -ggdb -Wno-unknown-pragmas -ffunction-sections -fdata-sections -Wall -Wextra -flto=thin -Os -DNDEBUG MDBX_BUILD_SHARED_LIBRARY=0 -ffast-math -fvisibility=hidden"
#endif
#define MDBX_BUILD_SOURCERY 47492323531afee427a3de6ddaeae26eed45bfd1b52d92fd121a5a13a9747dbb_v0_9_2_0_g092ab09
"""

PATCH_CONTENT = """
--- src/internals.h
+++ src/internals.h
@@ -12,9 +12,7 @@
  * <http://www.OpenLDAP.org/license.html>. */
 
 #pragma once
-#ifdef MDBX_CONFIG_H
-#include MDBX_CONFIG_H
-#endif
+#include "src/config.h"
 
 #define LIBMDBX_INTERNALS
 #ifdef MDBX_TOOLS
"""

def _libmdbx_impl(repository_ctx):
    version = repository_ctx.attr.version
    repository_ctx.download_and_extract(
        "https://github.com/erthink/libmdbx/archive/v{version}.zip".format(version = version),
        output = ".",
        sha256 = repository_ctx.attr.sha256,
        type = "zip",
        stripPrefix = "libmdbx-{version}".format(version = version),
    )
    repository_ctx.file(
        "BUILD",
        content = BUILD_CONTENT
    )
    repository_ctx.template(
        "src/version.c",
        "src/version.c.in",
        substitutions = {
            "${MDBX_VERSION_MAJOR}" : "0",
            "${MDBX_VERSION_MINOR}" : "9",
            "${MDBX_VERSION_RELEASE}" : "2",
            "${MDBX_VERSION_REVISION}" : "0",
        },
    )
    repository_ctx.file(
        "src/config.h",
        CONFIG_H_CONTENT
    )
    repository_ctx.file(
        "libmdbx.diff",
        content = PATCH_CONTENT,
    )
    repository_ctx.patch("libmdbx.diff")

_libmdbx = repository_rule(
    implementation = _libmdbx_impl,
    local = True,
    attrs = {
        "version": attr.string(mandatory=True),
        "sha256": attr.string(mandatory=True),
    },
)

def libmdbx(name, version, sha256):
    _libmdbx(
        name = name,
        sha256 = sha256,
        version = version,
    )
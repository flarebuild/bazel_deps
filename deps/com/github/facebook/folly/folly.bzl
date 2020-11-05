CONFIG_H_CONTENT = """
/*
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#pragma once

#if !defined(FOLLY_MOBILE)
#if defined(__ANDROID__) || \
    (defined(__APPLE__) &&  \
       ((defined(TARGET_IPHONE_SIMULATOR) && TARGET_IPHONE_SIMULATOR) || \
        (defined(TARGET_OS_SIMULATOR) && TARGET_OS_SIMULATOR) || \
        (defined(TARGET_OS_IPHONE) && TARGET_OS_IPHONE)))
#define FOLLY_MOBILE 1
#else
#define FOLLY_MOBILE 0
#endif
#endif // FOLLY_MOBILE

#define FOLLY_HAVE_PTHREAD 1
#define FOLLY_HAVE_PTHREAD_ATFORK 1

#define FOLLY_HAVE_LIBGFLAGS 1
/* #undef FOLLY_UNUSUAL_GFLAGS_NAMESPACE */
#define FOLLY_GFLAGS_NAMESPACE gflags

#define FOLLY_HAVE_LIBGLOG 1

/* #undef FOLLY_USE_JEMALLOC */
/* #undef FOLLY_USE_LIBSTDCPP */

#if __has_include(<features.h>)
#include <features.h>
#endif

/* #undef FOLLY_HAVE_MEMRCHR */
/* #undef FOLLY_HAVE_ACCEPT4 */
#define FOLLY_HAVE_GETRANDOM 0
#define FOLLY_HAVE_PREADV 0
#define FOLLY_HAVE_PWRITEV 0
#define FOLLY_HAVE_CLOCK_GETTIME 1
/* #undef FOLLY_HAVE_PIPE2 */
/* #undef FOLLY_HAVE_SENDMMSG */
/* #undef FOLLY_HAVE_RECVMMSG */
/* #undef FOLLY_HAVE_OPENSSL_ASN1_TIME_DIFF */

/* #undef FOLLY_HAVE_IFUNC */
#define FOLLY_HAVE_STD__IS_TRIVIALLY_COPYABLE 1
#define FOLLY_HAVE_UNALIGNED_ACCESS 1
#define FOLLY_HAVE_VLA 1
/* #undef FOLLY_HAVE_WEAK_SYMBOLS */
/* #undef FOLLY_HAVE_LINUX_VDSO */
/* #undef FOLLY_HAVE_MALLOC_USABLE_SIZE */
#define FOLLY_HAVE_INT128_T 1
/* #undef FOLLY_SUPPLY_MISSING_INT128_TRAITS */
#define FOLLY_HAVE_WCHAR_SUPPORT 1
/* #undef FOLLY_HAVE_EXTRANDOM_SFMT19937 */
#define FOLLY_USE_LIBCPP 1
/* #undef HAVE_VSNPRINTF_ERRORS */

/* #undef FOLLY_USE_SYMBOLIZER */
#define FOLLY_DEMANGLE_MAX_SYMBOL_SIZE 1024

#undef FOLLY_HAVE_SHADOW_LOCAL_WARNINGS

#define FOLLY_HAVE_LIBLZ4 0
/* #undef FOLLY_HAVE_LIBLZMA */
#define FOLLY_HAVE_LIBSNAPPY 0
#define FOLLY_HAVE_LIBZ 1
#define FOLLY_HAVE_LIBZSTD 1
#define FOLLY_HAVE_LIBBZ2 0

#define FOLLY_LIBRARY_SANITIZE_ADDRESS 0

#define FOLLY_SUPPORT_SHARED_LIBRARY 1
#define FOLLY_HAS_COROUTINES 1
#define FOLLY_OPENSSL_IS_110 1
#define OPENSSL_NO_POLY1305 1
#define OPENSSL_NO_CHACHA 1
#define FOLLY_HAVE_BACKTRACE 1
#ifdef __linux__
#define FOLLY_HAVE_DWARF 1
#define FOLLY_HAVE_ELF 1
#endif
#define FOLLY_NO_EXPECTED_CORO
"""

def _folly_impl(repository_ctx):
    version = repository_ctx.attr.version
    repository_ctx.download_and_extract(
        "https://github.com/facebook/folly/archive/{version}.zip".format(version = version),
        output = ".",
        sha256 = repository_ctx.attr.sha256,
        type = "zip",
        stripPrefix = "folly-{version}".format(version = version),
    )
    repository_ctx.file(
        "folly/folly-config.h",
        content = CONFIG_H_CONTENT
    )

folly = repository_rule(
    implementation = _folly_impl,
    local = True,
    attrs = {
        "version": attr.string(mandatory=True),
        "sha256": attr.string(mandatory=True),
    },
)

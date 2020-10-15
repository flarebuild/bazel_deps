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
     (TARGET_IPHONE_SIMULATOR || TARGET_OS_SIMULATOR || TARGET_OS_IPHONE))
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
#define FOLLY_HAVE_LIBZSTD 0
#define FOLLY_HAVE_LIBBZ2 0

#define FOLLY_LIBRARY_SANITIZE_ADDRESS 0

#define FOLLY_SUPPORT_SHARED_LIBRARY 1
#define FOLLY_HAS_COROUTINES 1
#define FOLLY_OPENSSL_IS_110 1
#define OPENSSL_NO_POLY1305 1
#define OPENSSL_NO_CHACHA 1
"""

BUILD_CONTENT = """
cc_library(
    name = "folly",
    includes = [
        ".",
    ],
    srcs = glob([
        "folly/*.cpp",
        "folly/futures/**/*.cpp",
        "folly/container/**/*.cpp",
        "folly/executors/**/*.cpp",
        "folly/memory/**/*.cpp",
        "folly/detail/**/*.cpp",
        "folly/net/**/*.cpp",
        "folly/io/**/*.cpp",
        "folly/fibers/**/*.cpp",
        "folly/chrono/**/*.cpp",
        "folly/ssl/**/*.cpp",
        "folly/tracing/**/*.cpp",
        "folly/gen/**/*.cpp",
        "folly/hash/**/*.cpp",
        "folly/lang/**/*.cpp",
        "folly/system/**/*.cpp",
        "folly/functional/**/*.cpp",
        "folly/concurrency/**/*.cpp",
        "folly/portability/**/*.cpp",
        "folly/synchronization/**/*.cpp",
        "folly/experimental/*.cpp",
        # "folly/experimental/symbolizer/**/*.cpp",
        # "folly/experimental/io/*.cpp",
        "folly/experimental/io/HugePages.cpp",
        "folly/experimental/io/FsUtil.cpp",
        "folly/experimental/coro/**/*.cpp",
    ], exclude = [
        "**/test/**",
        "folly/experimental/TestUtil.cpp",
    ]),
    hdrs = glob([
        "folly/*.h",
        "folly/futures/**/*.h",
        "folly/container/**/*.h",
        "folly/executors/**/*.h",
        "folly/memory/**/*.h",
        "folly/detail/**/*.h",
        "folly/net/**/*.h",
        "folly/io/**/*.h",
        "folly/fibers/**/*.h",
        "folly/chrono/**/*.h",
        "folly/ssl/**/*.h",
        "folly/tracing/**/*.h",
        "folly/gen/**/*.h",
        "folly/hash/**/*.h",
        "folly/lang/**/*.h",
        "folly/system/**/*.h",
        "folly/functional/**/*.h",
        "folly/concurrency/**/*.h",
        "folly/portability/**/*.h",
        "folly/synchronization/**/*.h",
        "folly/experimental/*.h",
        # "folly/experimental/symbolizer/**/*.h",
        # "folly/experimental/io/*.h",
        "folly/experimental/io/HugePages.h",
        "folly/experimental/io/FsUtil.h",
        "folly/experimental/coro/**/*.h",
    ], exclude = [
        "**/test/**",
        "folly/experimental/TestUtil.h",
    ]),
    deps = [
        "@net_zlib//:zlib",
        "@com_github_google_glog//:glog",
        # "@com_github_gflags_gflags//:gflags",
        "@com_github_google_double_conversion//:double-conversion",
        # "@libfmt//:fmt",
        "@org_libevent//:libevent",
        "@org_boost//:config",
        "@org_boost//:operators",
        "@org_boost//:crc",
        "@org_boost//:multi_index",
        "@org_boost//:intrusive",
        "@org_boost//:variant",
        "@org_boost//:detail",
        "@org_boost//:context",
        "@org_boost//:algorithm",
        "@org_boost//:container",
        "@org_boost//:filesystem",
        "@org_boost//:program_options",
        "@org_boost//:preprocessor",
        "@org_boost//:function_types",
    ],
    copts = [ 
        "-std=c++2a",
        "-Wno-ambiguous-reversed-operator",
    ],
    visibility = ["//visibility:public"],
)
"""

_PATCH_CONTENT = """
--- folly/io/async/ssl/OpenSSLUtils.cpp
+++ folly/io/async/ssl/OpenSSLUtils.cpp
@@ -221,7 +221,7 @@ SSL_CTX* OpenSSLUtils::getSSLInitialCtx(SSL* ssl) {

 BioMethodUniquePtr OpenSSLUtils::newSocketBioMethod() {
   BIO_METHOD* newmeth = nullptr;
-#if FOLLY_OPENSSL_IS_110
+#if FOLLY_OPENSSL_IS_110 && !defined(OPENSSL_IS_BORINGSSL)
   if (!(newmeth = BIO_meth_new(BIO_TYPE_SOCKET, "socket_bio_method"))) {
     return nullptr;
   }
@@ -271,7 +271,9 @@ int OpenSSLUtils::getBioShouldRetryWrite(int r) {
 }

 void OpenSSLUtils::setBioAppData(BIO* b, void* ptr) {
-#ifdef OPENSSL_IS_BORINGSSL
+#if defined(OPENSSL_IS_BORINGSSL) && FOLLY_OPENSSL_IS_110
+  BIO_set_data(b, ptr);
+#elif defined(OPENSSL_IS_BORINGSSL)
   BIO_set_callback_arg(b, static_cast<char*>(ptr));
 #else
   BIO_set_app_data(b, ptr);
@@ -279,7 +281,9 @@ void OpenSSLUtils::setBioAppData(BIO* b, void* ptr) {
 }

 void* OpenSSLUtils::getBioAppData(BIO* b) {
-#ifdef OPENSSL_IS_BORINGSSL
+#if defined(OPENSSL_IS_BORINGSSL) && FOLLY_OPENSSL_IS_110
+  return BIO_get_data(b);
+#elif defined(OPENSSL_IS_BORINGSSL)
   return BIO_get_callback_arg(b);
 #else
   return BIO_get_app_data(b);

--- folly/portability/OpenSSL.cpp
+++ folly/portability/OpenSSL.cpp
@@ -23,7 +23,7 @@ namespace folly {
 namespace portability {
 namespace ssl {

-#ifdef OPENSSL_IS_BORINGSSL
+#if defined(OPENSSL_IS_BORINGSSL) && !FOLLY_OPENSSL_IS_110
 int SSL_CTX_set1_sigalgs_list(SSL_CTX*, const char*) {
   return 1; // 0 implies error
 }
@@ -125,6 +125,12 @@ EC_KEY* EVP_PKEY_get0_EC_KEY(EVP_PKEY* pkey) {
 }
 #endif

+#if !FOLLY_OPENSSL_IS_110 || defined(OPENSSL_IS_BORINGSSL)
+const char* SSL_SESSION_get0_hostname(const SSL_SESSION* s) {
+  return nullptr;
+}
+#endif
+
 #if !FOLLY_OPENSSL_IS_110
 BIO_METHOD* BIO_meth_new(int type, const char* name) {
   BIO_METHOD* method = (BIO_METHOD*)OPENSSL_malloc(sizeof(BIO_METHOD));

--- folly/portability/OpenSSL.h
+++ folly/portability/OpenSSL.h
@@ -118,7 +118,7 @@ namespace folly {
 namespace portability {
 namespace ssl {

-#ifdef OPENSSL_IS_BORINGSSL
+#if defined(OPENSSL_IS_BORINGSSL) && !FOLLY_OPENSSL_IS_110
 int SSL_CTX_set1_sigalgs_list(SSL_CTX* ctx, const char* sigalgs_list);
 int TLS1_get_client_version(SSL* s);
 #endif
@@ -152,6 +152,10 @@ DH* EVP_PKEY_get0_DH(EVP_PKEY* pkey);
 EC_KEY* EVP_PKEY_get0_EC_KEY(EVP_PKEY* pkey);
 #endif

+#if FOLLY_OPENSSL_IS_110 && defined(OPENSSL_IS_BORINGSSL)
+const char* SSL_SESSION_get0_hostname(const SSL_SESSION* s);
+#endif
+
 #if !FOLLY_OPENSSL_IS_110
 BIO_METHOD* BIO_meth_new(int type, const char* name);
 void BIO_meth_free(BIO_METHOD* biom);

--- folly/detail/Iterators.h
+++ folly/detail/Iterators.h
@@ -81,9 +81,9 @@ class IteratorFacade {
     return asDerivedConst().equal(rhs);
   }

-  bool operator!=(D const& rhs) const {
-    return !operator==(rhs);
-  }
+  // bool operator!=(D const& rhs) const {
+  //   return !operator==(rhs);
+  // }

   /*
    * Allow for comparisons between this and an iterator of some other class.
@@ -101,10 +101,10 @@ class IteratorFacade {
     return D2(asDerivedConst()) == rhs;
   }

-  template <class D2>
-  bool operator!=(D2 const& rhs) const {
-    return !operator==(rhs);
-  }
+  // template <class D2>
+  // bool operator!=(D2 const& rhs) const {
+  //   return !operator==(rhs);
+  // }

   V& operator*() const {
     return asDerivedConst().dereference();

--- folly/Expected.h
+++ folly/Expected.h
@@ -1459,43 +1459,43 @@ struct Promise {
   }
 };

-template <typename Value, typename Error>
-struct Awaitable {
-  Expected<Value, Error> o_;
-
-  explicit Awaitable(Expected<Value, Error> o) : o_(std::move(o)) {}
-
-  bool await_ready() const noexcept {
-    return o_.hasValue();
-  }
-  Value await_resume() {
-    return std::move(o_.value());
-  }
-
-  // Explicitly only allow suspension into a Promise
-  template <typename U>
-  void await_suspend(std::experimental::coroutine_handle<Promise<U, Error>> h) {
-    *h.promise().value_ = makeUnexpected(std::move(o_.error()));
-    // Abort the rest of the coroutine. resume() is not going to be called
-    h.destroy();
-  }
-};
+// template <typename Value, typename Error>
+// struct Awaitable {
+//   Expected<Value, Error> o_;
+
+//   explicit Awaitable(Expected<Value, Error> o) : o_(std::move(o)) {}
+
+//   bool await_ready() const noexcept {
+//     return o_.hasValue();
+//   }
+//   Value await_resume() {
+//     return std::move(o_.value());
+//   }
+
+//   // Explicitly only allow suspension into a Promise
+//   template <typename U>
+//   void await_suspend(std::experimental::coroutine_handle<Promise<U, Error>> h) {
+//     *h.promise().value_ = makeUnexpected(std::move(o_.error()));
+//     // Abort the rest of the coroutine. resume() is not going to be called
+//     h.destroy();
+//   }
+// };
 } // namespace expected_detail

-template <typename Value, typename Error>
-expected_detail::Awaitable<Value, Error>
-/* implicit */ operator co_await(Expected<Value, Error> o) {
-  return expected_detail::Awaitable<Value, Error>{std::move(o)};
-}
+// template <typename Value, typename Error>
+// expected_detail::Awaitable<Value, Error>
+// /* implicit */ operator co_await(Expected<Value, Error> o) {
+//   return expected_detail::Awaitable<Value, Error>{std::move(o)};
+// }
 } // namespace folly

 // This makes folly::Expected<Value> useable as a coroutine return type...
-namespace std {
-namespace experimental {
-template <typename Value, typename Error, typename... Args>
-struct coroutine_traits<folly::Expected<Value, Error>, Args...> {
-  using promise_type = folly::expected_detail::Promise<Value, Error>;
-};
-} // namespace experimental
-} // namespace std
+// namespace std {
+// namespace experimental {
+// template <typename Value, typename Error, typename... Args>
+// struct coroutine_traits<folly::Expected<Value, Error>, Args...> {
+//   using promise_type = folly::expected_detail::Promise<Value, Error>;
+// };
+// } // namespace experimental
+// } // namespace std
 #endif // FOLLY_HAS_COROUTINES

--- folly/container/detail/F14Policy.h
+++ folly/container/detail/F14Policy.h
@@ -488,9 +488,9 @@ class ValueContainerIterator : public ValueContainerIteratorBase<ValuePtr> {
   bool operator==(ValueContainerIterator<ValueConstPtr> const& rhs) const {
     return underlying_ == rhs.underlying_;
   }
-  bool operator!=(ValueContainerIterator<ValueConstPtr> const& rhs) const {
-    return !(*this == rhs);
-  }
+  // bool operator!=(ValueContainerIterator<ValueConstPtr> const& rhs) const {
+  //   return !(*this == rhs);
+  // }

  private:
   ItemIter underlying_;
@@ -989,9 +989,9 @@ class VectorContainerIterator : public BaseIter<ValuePtr, uint32_t> {
   bool operator==(VectorContainerIterator<ValueConstPtr> const& rhs) const {
     return current_ == rhs.current_;
   }
-  bool operator!=(VectorContainerIterator<ValueConstPtr> const& rhs) const {
-    return !(*this == rhs);
-  }
+  // bool operator!=(VectorContainerIterator<ValueConstPtr> const& rhs) const {
+  //   return !(*this == rhs);
+  // }

  private:
   ValuePtr current_;
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
    repository_ctx.file(
        "BUILD.bazel",
        content = BUILD_CONTENT
    )
    repository_ctx.file(
        "folly_patch.diff",
        content = _PATCH_CONTENT,
    )
    repository_ctx.patch("folly_patch.diff")

folly = repository_rule(
    implementation = _folly_impl,
    local = True,
    attrs = {
        "version": attr.string(mandatory=True),
        "sha256": attr.string(mandatory=True),
    },
)
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

PATCH_CONTENT = """
"""

BUILD_CONTENT = """
genrule(
    name = "gen_sh",
    outs = [
        "gen.sh",
    ],
    cmd = \"\"\"
cat > $@ <<"EOF"
#! /bin/sh
sed -e 's/@VERSION@/1.0.18/g' \
    -e 's/@SODIUM_LIBRARY_VERSION_MAJOR@/10/g' \
    -e 's/@SODIUM_LIBRARY_VERSION_MINOR@/18/g' \
    -e 's/@SODIUM_LIBRARY_MINIMAL_DEF@//g'
EOF\"\"\",
)

config_setting(
    name = "windows",
    constraint_values = [
        "@bazel_tools//platforms:windows",
    ],
    visibility = ["//visibility:public"],
)

genrule(
    name = "version_h",
    srcs = ["src/libsodium/include/sodium/version.h.in"],
    outs = ["src/libsodium/include/sodium/version.h"],
    cmd = "$(location :gen_sh) < $(<) > $(@)",
    tools = [":gen_sh"],
)

cc_library(
    name = "sodium",
    includes = [
        "src/libsodium/crypto_core/curve25519/ref10",
        "src/libsodium/crypto_generichash/blake2b/ref",
        "src/libsodium/crypto_onetimeauth/poly1305",
        "src/libsodium/crypto_onetimeauth/poly1305/donna",
        "src/libsodium/crypto_onetimeauth/poly1305/sse2",
        "src/libsodium/crypto_pwhash/argon2",
        "src/libsodium/crypto_pwhash/scryptsalsa208sha256",
        "src/libsodium/crypto_scalarmult/curve25519",
        "src/libsodium/crypto_scalarmult/curve25519/donna_c64",
        "src/libsodium/crypto_scalarmult/curve25519/ref10",
        "src/libsodium/crypto_scalarmult/curve25519/sandy2x",
        "src/libsodium/crypto_shorthash/siphash24/ref",
        "src/libsodium/crypto_sign/ed25519/ref10",
        "src/libsodium/crypto_stream/chacha20",
        "src/libsodium/crypto_stream/chacha20/dolbeau",
        "src/libsodium/crypto_stream/chacha20/ref",
        "src/libsodium/crypto_stream/salsa20",
        "src/libsodium/crypto_stream/salsa20/ref",
        "src/libsodium/crypto_stream/salsa20/xmm6",
        "src/libsodium/crypto_stream/salsa20/xmm6int",
        "src/libsodium/include",
        "src/libsodium/include/sodium",
        "src/libsodium/include/sodium/private",
    ],
    copts = ["-DCONFIGURED=1"] + select({
        ":windows": [],
        "//conditions:default": ["-DHAVE_PTHREAD"],
    }),
    srcs = glob([
        "src/libsodium/**/*.c",
        "src/libsodium/**/*.h",
    ]),
    hdrs = [":version_h"] + glob([
        "src/libsodium/include/**/*.h",
    ]),
    deps = [
    ],
    visibility = ["//visibility:public"],
)
"""

def _sodium_impl(repository_ctx):
    version = repository_ctx.attr.version
    repository_ctx.download_and_extract(
        "https://github.com/jedisct1/libsodium/archive/{version}.zip".format(version = version),
        output = ".",
        sha256 = repository_ctx.attr.sha256,
        type = "zip",
        stripPrefix = "libsodium-{version}".format(version = version),
    )
    repository_ctx.file(
        "BUILD.bazel",
        content = BUILD_CONTENT
    )
    repository_ctx.file(
        "sodium_patch.diff",
        content = PATCH_CONTENT,
    )
    repository_ctx.patch("sodium_patch.diff")

_sodium = repository_rule(
    implementation = _sodium_impl,
    local = True,
    attrs = {
        "version": attr.string(mandatory=True),
        "sha256": attr.string(mandatory=True),
    },
)

def sodium(name, version, sha256):
    _sodium(
        name = name,
        sha256 = sha256,
        version = version,
    )
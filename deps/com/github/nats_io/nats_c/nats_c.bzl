BUILD_CONTENT = """
cc_library(
    name = "nats",
    includes = [
        "src",
    ],
    srcs = glob([
        "src/*.c",
        "src/stan/*.c",
        "src/unix/*.c",
    ]),
    hdrs = glob([
        "src/*.h",
        "src/include/*.h",
        "src/stan/*.h",
        "src/unix/*.h",
    ]),
    defines = [
        "NATS_HAS_TLS",
        "NATS_HAS_STREAMING",
    ],
    deps = [
        "@com_github_jedisct1_sodium//:sodium",
        "@com_github_google_boringssl//:ssl",
        "@com_github_protobuf_c_protobuf_c//:protobuf_c",
    ],
    visibility = ["//visibility:public"],
)
"""

def _nats_impl(repository_ctx):
    version = repository_ctx.attr.version
    repository_ctx.download_and_extract(
        "https://github.com/nats-io/nats.c/archive/v{version}.zip".format(version = version),
        output = ".",
        sha256 = repository_ctx.attr.sha256,
        type = "zip",
        stripPrefix = "nats.c-{version}".format(version = version),
    )
    repository_ctx.file(
        "BUILD",
        content = BUILD_CONTENT
    )

nats_c = repository_rule(
    implementation = _nats_impl,
    local = True,
    attrs = {
        "version": attr.string(mandatory=True),
        "sha256": attr.string(mandatory=True),
    },
)
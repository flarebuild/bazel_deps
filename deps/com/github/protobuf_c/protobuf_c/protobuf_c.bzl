BUILD_CONTENT = """
cc_library(
    name = "protobuf_c",
    includes = [
        ".",
    ],
    srcs = glob([
        "protobuf-c/protobuf-c.c",
    ]),
    hdrs = glob([
        "protobuf-c/protobuf-c.h",
    ]),
    visibility = ["//visibility:public"],
)
"""

def _protobuf_c_impl(repository_ctx):
    version = repository_ctx.attr.version
    repository_ctx.download_and_extract(
        "https://github.com/protobuf-c/protobuf-c/archive/v{version}.zip".format(version = version),
        output = ".",
        sha256 = repository_ctx.attr.sha256,
        type = "zip",
        stripPrefix = "protobuf-c-{version}".format(version = version),
    )
    repository_ctx.file(
        "BUILD",
        content = BUILD_CONTENT
    )

protobuf_c = repository_rule(
    implementation = _protobuf_c_impl,
    local = True,
    attrs = {
        "version": attr.string(mandatory=True),
        "sha256": attr.string(mandatory=True),
    },
)
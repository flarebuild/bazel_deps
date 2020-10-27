BUILD_CONTENT = """
cc_library(
    name = "fmt",
    includes = [ "include" ],
    srcs = glob([
        "src/*.cc"
    ]),
    hdrs = glob([
        "include/fmt/*.h",
    ]),
    visibility = ["//visibility:public"],
)
"""

def _libfmt_impl(repository_ctx):
    version = repository_ctx.attr.version
    repository_ctx.download_and_extract(
        "https://github.com/fmtlib/fmt/archive/{version}.zip".format(version = version),
        output = ".",
        sha256 = repository_ctx.attr.sha256,
        type = "zip",
        stripPrefix = "fmt-{version}".format(version = version),
    )
    repository_ctx.file(
        "BUILD",
        content = BUILD_CONTENT
    )

_libfmt = repository_rule(
    implementation = _libfmt_impl,
    local = True,
    attrs = {
        "version": attr.string(mandatory=True),
        "sha256": attr.string(mandatory=True),
    },
)

def fmt(name, version, sha256):
    _libfmt(
        name = name,
        sha256 = sha256,
        version = version,
    )
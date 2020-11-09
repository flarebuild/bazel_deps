BUILD_CONTENT = """
cc_library(
    name = "di",
    includes = [
        "include",
        "extension/include",
    ],
    srcs = glob([
        "include/boost/**/*.hpp",
        "extension/include/boost/**/*.hpp",
    ]),
    hdrs = glob([
        "include/boost/**/*.hpp",
        "extension/include/boost/**/*.hpp",
    ]),
    copts = [
        "-Wno-return-stack-address",
    ],
    visibility = ["//visibility:public"],
)
"""

def _boost_di_impl(repository_ctx):
    version = repository_ctx.attr.version
    repository_ctx.download_and_extract(
        "https://github.com/boost-experimental/di/archive/v{version}.zip".format(version = version),
        output = ".",
        sha256 = repository_ctx.attr.sha256,
        type = "zip",
        stripPrefix = "di-{version}".format(version = version),
    )
    repository_ctx.file(
        "BUILD",
        content = BUILD_CONTENT
    )

_boost_di = repository_rule(
    implementation = _boost_di_impl,
    local = True,
    attrs = {
        "version": attr.string(mandatory=True),
        "sha256": attr.string(mandatory=True),
    },
)

def di(name, version, sha256):
    _boost_di(
        name = name,
        sha256 = sha256,
        version = version,
    )

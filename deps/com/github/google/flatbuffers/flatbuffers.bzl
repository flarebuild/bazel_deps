def _flatbuffers_impl(repository_ctx):
    version = repository_ctx.attr.version
    repository_ctx.download_and_extract(
        "https://github.com/google/flatbuffers/archive/v{version}.zip".format(version = version),
        output = ".",
        sha256 = repository_ctx.attr.sha256,
        type = "zip",
        stripPrefix = "flatbuffers-{version}".format(version = version),
    )

_flatbuffers = repository_rule(
    implementation = _flatbuffers_impl,
    local = True,
    attrs = {
        "version": attr.string(mandatory=True),
        "sha256": attr.string(mandatory=True),
    },
)

def flatbuffers(name, version, sha256):
    _flatbuffers(
        name = name,
        sha256 = sha256,
        version = version,
    )

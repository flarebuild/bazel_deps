def _catch_impl(repository_ctx):
    version = repository_ctx.attr.version
    repository_ctx.download_and_extract(
        "https://github.com/catchorg/Catch2/archive/v{version}.zip".format(version = version),
        output = ".",
        sha256 = repository_ctx.attr.sha256,
        type = "zip",
        stripPrefix = "Catch2-{version}".format(version = version),
    )

_catch = repository_rule(
    implementation = _catch_impl,
    local = True,
    attrs = {
        "version": attr.string(mandatory=True),
        "sha256": attr.string(mandatory=True),
    },
)

def catch(name, version, sha256):
    _catch(
        name = name,
        sha256 = sha256,
        version = version,
    )
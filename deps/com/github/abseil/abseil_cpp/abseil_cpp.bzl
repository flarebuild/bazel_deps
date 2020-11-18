def _abseil_impl(repository_ctx):
    version = repository_ctx.attr.version
    sha256 = repository_ctx.attr.sha256
    repository_ctx.download_and_extract(
        "https://github.com/abseil/abseil-cpp/archive/%s.zip" % version,
        output = ".",
        sha256 = sha256,
        type = "zip",
        stripPrefix = "abseil-cpp-%s" % version,
    )

_abseil = repository_rule(
    implementation = _abseil_impl,
    local = True,
    attrs = {
        "version": attr.string(mandatory=True),
        "sha256": attr.string(mandatory=True),
    },
)

def abseil_cpp(name, version, sha256):
    _abseil(
        name = name,
        sha256 = sha256,
        version = version,
    )
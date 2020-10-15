def _glog_impl(repository_ctx):
    version = repository_ctx.attr.version
    repository_ctx.download_and_extract(
        "https://github.com/google/glog/archive/v{version}.zip".format(version = version),
        output = ".",
        sha256 = repository_ctx.attr.sha256,
        type = "zip",
        stripPrefix = "glog-{version}".format(version = version),
    )

_glog = repository_rule(
    implementation = _glog_impl,
    local = True,
    attrs = {
        "version": attr.string(mandatory=True),
        "sha256": attr.string(mandatory=True),
    },
)

def glog(name, version, sha256):
    _glog(
        name = name,
        sha256 = sha256,
        version = version,
    )

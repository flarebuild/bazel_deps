PATCH_CONTENT = """
--- BUILD
+++ BUILD
@@ -6,6 +6,9 @@ exports_files(["LICENSE"])

 cc_library(
     name = "double-conversion",
+    includes = [
+        ".",
+    ],
     srcs = [
         "double-conversion/bignum.cc",
         "double-conversion/bignum-dtoa.cc",
"""


def _double_conversion_impl(repository_ctx):
    version = repository_ctx.attr.version
    repository_ctx.download_and_extract(
        "https://github.com/google/double-conversion/archive/v{version}.zip".format(version = version),
        output = ".",
        sha256 = repository_ctx.attr.sha256,
        type = "zip",
        stripPrefix = "double-conversion-{version}".format(version = version),
    )
    repository_ctx.file(
        "double_conversion.diff",
        content = PATCH_CONTENT,
    )
    repository_ctx.patch("double_conversion.diff")

_double_conversion = repository_rule(
    implementation = _double_conversion_impl,
    local = True,
    attrs = {
        "version": attr.string(mandatory=True),
        "sha256": attr.string(mandatory=True),
    },
)

def double_conversion(name, version, sha256):
    _double_conversion(
        name = name,
        sha256 = sha256,
        version = version,
    )

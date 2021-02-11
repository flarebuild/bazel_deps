load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

_BUILD_CONTENT = """
cc_library(
    name = "rxcpp",
    includes = [
        "Rx/v2/src",
    ],
    hdrs = glob([
        "Rx/v2/src/**/*.hpp",
        "Rx/v2/src/**/*.cpp",
    ]),
    visibility = ["//visibility:public"],
)
"""

def rxcpp(name, version, sha256):
    http_archive(
        name = name,
        urls = [ "https://github.com/ReactiveX/RxCpp/archive/v%s.zip" % version, ],
        strip_prefix = "RxCpp-%s" % version,
        sha256 = sha256,
        build_file_content = _BUILD_CONTENT
    )
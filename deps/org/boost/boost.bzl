load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def boost(name, rules_boost_version, rules_boost_sha256, boost_version, boost_sha256):
    http_archive(
        name = "com_github_nelhage_rules_boost",
        sha256 = rules_boost_sha256,
        strip_prefix = "rules_boost-%s" % rules_boost_version,
        urls = [ "https://github.com/nelhage/rules_boost/archive/%s.tar.gz" % rules_boost_version, ],
        repo_mapping = { 
            "@boost": "@org_boost",
        }
    )
    boost_ver_underscored = boost_version.replace(".", "_")
    http_archive(
        name = name,
        build_file = "@com_github_nelhage_rules_boost//:BUILD.boost",
        patch_cmds = ["rm -f doc/pdf/BUILD"],
        sha256 = boost_sha256,
        strip_prefix = "boost_%s" % boost_ver_underscored,
        urls = [ x % (boost_version, boost_ver_underscored) for x in [
            "https://mirror.bazel.build/dl.bintray.com/boostorg/release/%s/source/boost_%s.tar.bz2",
            "https://dl.bintray.com/boostorg/release/%s/source/boost_%s.tar.bz2",
        ]],
        repo_mapping = {
            "@net_zlib_zlib": "@net_zlib",
            "@org_bzip_bzip2": "@org_bzip",
            "@org_lzma_lzma": "@org_lzma",
            "@openssl": "@com_github_google_boringssl",
            "@boost": "@org_boost",
        },
    )
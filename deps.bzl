load("@build_flare_bazel_utility//yaml:yaml.bzl", "load_yaml")
load("@build_flare_bazel_utility//util:formatters.bzl", "f")
load("@bazel_skylib//lib:paths.bzl", "paths")

def _load_dep_info(repository_ctx, dep):
    name = paths.basename(dep)
    dir = "//deps/" + dep + ":"
    return struct(
        path = dir + name + ".bzl",
        describe = load_yaml(repository_ctx.read(Label(dir + "describe.yaml")))
    )

def _init_pattern(name, describe):
    args = { "name": name }
    if "default_args" in describe:
        args.update(describe["default_args"])

    return f.format_call(describe["rule"], args)

def _compose_deps_impl(repository_ctx):
    to_compose = load_yaml(repository_ctx.read(repository_ctx.attr.config))
    loaded = {}

    for _ in range(repository_ctx.attr.depth):
        cur_deps = to_compose
        to_compose = []
        for dep in cur_deps:
            info = _load_dep_info(repository_ctx, dep)
            loaded[dep] = info
            if "deps" in info.describe:
                for transitive_dep in info.describe["deps"]:
                    if transitive_dep not in loaded:
                        to_compose.append(transitive_dep)
        if not to_compose:
            break
                
    if len(to_compose):
        fail("not enough depth to compose transitive deps, plz increase it, current: %s" + repository_ctx.attr.depth )


    loads = []
    inits = []

    for dep, info in loaded.items():
        loads.append("load(\"@build_flare_bazel_deps%s\", \"%s\")" % (info.path, info.describe["rule"])) 
        inits.append(f.add_indent(_init_pattern(
            dep.replace("/", "_"),
            info.describe,
        ), 1))

    repository_ctx.file("BUILD.bazel", "")
    repository_ctx.file(
        "defs.bzl", 
        "\n".join(loads) + "\ndef init_deps():\n" + "\n".join(inits),
    )

compose_deps = repository_rule(
    implementation = _compose_deps_impl,
    attrs = {
        "config": attr.label(
            mandatory = True,
            allow_single_file = True,
        ),
        "depth": attr.int(
            default = 10
        ),
    },
)
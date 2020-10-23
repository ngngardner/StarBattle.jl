using StarBattle
using Documenter

makedocs(;
    modules=[StarBattle],
    authors="ngngardner <ngngardner@gmail.com> and contributors",
    repo="https://github.com/ngngardner/StarBattle.jl/blob/{commit}{path}#L{line}",
    sitename="StarBattle.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://ngngardner.github.io/StarBattle.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/ngngardner/StarBattle.jl",
)

### A Pluto.jl notebook ###
# v0.12.20

using Markdown
using InteractiveUtils

# ╔═╡ 7420c480-910c-11eb-2338-6bbd68005f0a
begin
    using Pkg
    Pkg.add("PlutoUI")
    Pkg.add("FreqTables")
    Pkg.add("RDatasets")
    Pkg.add("StatsBase")
    Pkg.add("StatsPlots")
    Pkg.add("Distributions")
    Pkg.add("Statistics")
    Pkg.add("LaTeXStrings")
	Pkg.add("VegaLite")
end

# ╔═╡ b0f0b9a4-938c-11eb-3929-331bdd555c4c
using DataFrames,JSON,HTTP,JSONTables,Dates,TableIO,CSV,VegaLite

# ╔═╡ 298ff14c-910d-11eb-1088-efa7ab843b4f
using PlutoUI,FreqTables,RDatasets,StatsBase,StatsPlots,Distributions,Statistics,LaTeXStrings,QuadGK

# ╔═╡ 4b759868-9494-11eb-1f4e-3d0ab484ec88


# ╔═╡ 131772d8-917f-11eb-1add-1f94cfb9bf63
begin
	Pkg.add("QuadGK")
	Pkg.add("JSON")
	Pkg.add("HTTP")
	Pkg.add("JSONTables")
	Pkg.add("CSV")
	Pkg.add("TableIO")
end

# ╔═╡ Cell order:
# ╠═7420c480-910c-11eb-2338-6bbd68005f0a
# ╠═4b759868-9494-11eb-1f4e-3d0ab484ec88
# ╠═131772d8-917f-11eb-1add-1f94cfb9bf63
# ╠═b0f0b9a4-938c-11eb-3929-331bdd555c4c
# ╠═298ff14c-910d-11eb-1088-efa7ab843b4f

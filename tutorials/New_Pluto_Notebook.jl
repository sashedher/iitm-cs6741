### A Pluto.jl notebook ###
# v0.12.20

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

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
end

# ╔═╡ 298ff14c-910d-11eb-1088-efa7ab843b4f
begin
    using PlutoUI
    using FreqTables
    using RDatasets
    using StatsBase
    using StatsPlots
    using Distributions
    using Statistics
    using LaTeXStrings
	using QuadGK
end


# ╔═╡ 131772d8-917f-11eb-1add-1f94cfb9bf63
Pkg.add("QuadGK")

# ╔═╡ 01cea346-9177-11eb-00a3-e3d8875dbc77
Q = Normal(0, 1)

# ╔═╡ 975d87a0-9182-11eb-0147-919853fe6da4
v = @bind v html"<input type=range min=1 max=5 step=1>"

# ╔═╡ 0c5ec226-9183-11eb-000c-c952dd92ade0
v  

# ╔═╡ dd1a76ce-9180-11eb-0ee8-9337eeb7f71a
P=TDist(v)

# ╔═╡ 89aab454-9180-11eb-320f-a5456e1db2b3
pdf(P,0)*log(pdf(P,0)/pdf(Q,0))

# ╔═╡ 2f38094c-9181-11eb-20e9-bf788b2093f0
KLDiv(x)=pdf(P,x)*log(pdf(P,x)/pdf(Q,x))

# ╔═╡ a1be90a0-9186-11eb-3c36-fff654b98d91
div(n,t)=quadgk(x->pdf(t,x)*log(pdf(t,x)/pdf(n,x)),(-37:37)...)[1]

# ╔═╡ 0ba1593a-9187-11eb-255f-478177875ea9
div(Q,P)

# ╔═╡ 63426374-9181-11eb-207c-b543757532f3
quadgk(x->KLDiv(x), (-37:37)...)[1]

# ╔═╡ 5e46ab3a-9183-11eb-0930-49b5eafb2d9b
length((-37:37))

# ╔═╡ 62a23480-9186-11eb-0216-95e465c51918
KLD(D1,D2)=quadgk(x->KLDiv(x), (-37:37)...)[1]

# ╔═╡ Cell order:
# ╠═7420c480-910c-11eb-2338-6bbd68005f0a
# ╠═131772d8-917f-11eb-1add-1f94cfb9bf63
# ╠═298ff14c-910d-11eb-1088-efa7ab843b4f
# ╠═01cea346-9177-11eb-00a3-e3d8875dbc77
# ╠═975d87a0-9182-11eb-0147-919853fe6da4
# ╠═0c5ec226-9183-11eb-000c-c952dd92ade0
# ╠═dd1a76ce-9180-11eb-0ee8-9337eeb7f71a
# ╠═89aab454-9180-11eb-320f-a5456e1db2b3
# ╠═2f38094c-9181-11eb-20e9-bf788b2093f0
# ╠═a1be90a0-9186-11eb-3c36-fff654b98d91
# ╠═0ba1593a-9187-11eb-255f-478177875ea9
# ╠═63426374-9181-11eb-207c-b543757532f3
# ╠═5e46ab3a-9183-11eb-0930-49b5eafb2d9b
# ╠═62a23480-9186-11eb-0216-95e465c51918

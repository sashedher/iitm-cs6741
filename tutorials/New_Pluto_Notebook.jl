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

# ╔═╡ 2f609232-91ff-11eb-1e50-8fb6bac96e47


# ╔═╡ 63426374-9181-11eb-207c-b543757532f3
quadgk(x->KLDiv(x), (-37:37)...)[1]

# ╔═╡ 5e46ab3a-9183-11eb-0930-49b5eafb2d9b
length((-37:37))

# ╔═╡ 62a23480-9186-11eb-0216-95e465c51918
KLD(D1,D2)=quadgk(x->KLDiv(x), (-37:37)...)[1]

# ╔═╡ c95381fa-91fb-11eb-21d3-a15225ba19d2
# begin
#     conv(x) = sum(pdf(D_n,x-k)*pdf(D_b,k) for k=-5:0.1:8)
#     # plot(-5:0.1:8, conv.(-5:0.1:8))
# end

# ╔═╡ f7ae629a-91fb-11eb-0c2d-f114013f1cf7
U1=Uniform(0,1)

# ╔═╡ f2741aea-91fb-11eb-3e3e-3f1853d4e5a0
samples=rand(U1,10^6)

# ╔═╡ 8b462602-91ff-11eb-13db-27847df88df9
length(samples)

# ╔═╡ cb0d09e4-91fb-11eb-1ff9-cd203b3dff6a
xu=fit(Uniform, samples)

# ╔═╡ 92345b5a-91ff-11eb-3652-f3b1009318c7
mean(samples),mean(U1),mean(xu)

# ╔═╡ cbed5580-91fb-11eb-37f0-494b8d6a253d
begin
	dis=[]
	for i in 2:10
		samples=rand(U1,10^6)
		xd=fit(Uniform,samples)
		push!(dis,xd)
	end
end

# ╔═╡ cd1ce894-91fb-11eb-0fed-79787ddd771f
dis

# ╔═╡ 0818f558-9208-11eb-065c-3f850b7d161c
conv(x) = sum(pdf(dis[1],x-k)*pdf(dis[2],k) for k=0.0:0.001:1.0)

# ╔═╡ 322ae216-9208-11eb-1fb9-7f7c4de8b521
conv.(-5:0.1:8)

# ╔═╡ 62686598-9208-11eb-2bbd-9713670d77f1
 plot(-1:0.01:3, conv.(-1:0.01:3))

# ╔═╡ eef7d312-9209-11eb-29ce-cf9b52413cf3
convs(ux,uy,x) = sum(pdf(ux,x-k)*pdf(uy,k) for k=0.0:0.001:1.0)

# ╔═╡ 33653a62-920a-11eb-3186-1162d17fb9fb
 plot(0.0:0.01:1.0,convs.(dis[1],dis[2],0.0:0.01:1.0))

# ╔═╡ 2e7bbe7e-920d-11eb-278f-cf23208d520e
maximum(convs.(dis[1],dis[2],-1:0.01:3))

# ╔═╡ cdff0544-91fb-11eb-259b-8772fde759c2
begin
	cns=[]
	for i in 1:8
	    for j in i:9
			convs.(dis[i],dis[j],-1:0.01:3)
		end
		push!(cns,)
	end
		
end

# ╔═╡ 10b433a4-920c-11eb-2adf-3d60a02daa0e
length(cns)

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
# ╠═2f609232-91ff-11eb-1e50-8fb6bac96e47
# ╠═63426374-9181-11eb-207c-b543757532f3
# ╠═5e46ab3a-9183-11eb-0930-49b5eafb2d9b
# ╠═62a23480-9186-11eb-0216-95e465c51918
# ╠═c95381fa-91fb-11eb-21d3-a15225ba19d2
# ╠═f7ae629a-91fb-11eb-0c2d-f114013f1cf7
# ╠═f2741aea-91fb-11eb-3e3e-3f1853d4e5a0
# ╠═8b462602-91ff-11eb-13db-27847df88df9
# ╠═cb0d09e4-91fb-11eb-1ff9-cd203b3dff6a
# ╠═92345b5a-91ff-11eb-3652-f3b1009318c7
# ╠═cbed5580-91fb-11eb-37f0-494b8d6a253d
# ╠═cd1ce894-91fb-11eb-0fed-79787ddd771f
# ╠═0818f558-9208-11eb-065c-3f850b7d161c
# ╠═322ae216-9208-11eb-1fb9-7f7c4de8b521
# ╠═62686598-9208-11eb-2bbd-9713670d77f1
# ╠═eef7d312-9209-11eb-29ce-cf9b52413cf3
# ╠═33653a62-920a-11eb-3186-1162d17fb9fb
# ╠═2e7bbe7e-920d-11eb-278f-cf23208d520e
# ╠═cdff0544-91fb-11eb-259b-8772fde759c2
# ╠═10b433a4-920c-11eb-2adf-3d60a02daa0e

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

# ╔═╡ b0f0b9a4-938c-11eb-3929-331bdd555c4c
using DataFrames,JSON,HTTP,JSONTables,Dates,TableIO,CSV

# ╔═╡ 298ff14c-910d-11eb-1088-efa7ab843b4f
using PlutoUI,FreqTables,RDatasets,StatsBase,StatsPlots,Distributions,Statistics,LaTeXStrings,QuadGK

# ╔═╡ 131772d8-917f-11eb-1add-1f94cfb9bf63
begin
	Pkg.add("QuadGK")
	Pkg.add("JSON")
	Pkg.add("HTTP")
	Pkg.add("JSONTables")
	Pkg.add("CSV")
	Pkg.add("TableIO")
end

# ╔═╡ ee48c5f4-93a6-11eb-238f-1ffd8145a1ef


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
divr(n,t)=quadgk(x->pdf(t,x)*log(pdf(t,x)/pdf(n,x)),(-37:37)...)[1]

# ╔═╡ 0ba1593a-9187-11eb-255f-478177875ea9
divr(Q,P)

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
 plot(-1.0:0.01:2.0,convs.(dis[1],dis[2],-1.0:0.01:2.0))

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

# ╔═╡ a90df21e-9394-11eb-0ff7-37cfc41afa04
md"Question-4"

# ╔═╡ a88bdb1c-9394-11eb-1e74-7bd8f5df3bd9
U4=Uniform(0,1)

# ╔═╡ c1b23bec-9394-11eb-1b67-f5c5d9399cce
s=rand(U4,30)

# ╔═╡ f5648448-9394-11eb-16d1-8bee54c6cd04
length(s)

# ╔═╡ fad25ca2-9394-11eb-2619-810171823759
maximum(s)-minimum(s)

# ╔═╡ fcb1f26c-9394-11eb-1460-4bccdabe09bc
median(s)

# ╔═╡ fc92123a-9394-11eb-3a5e-2135605e5e56
begin
	r4=[]
	for i in range(1,10000,step=1)
		rs=rand(U4,30)
		push!(r4,maximum(rs)-minimum(rs))
	end
end

# ╔═╡ 445d3a02-9397-11eb-10ce-41c6e44124b5
length(r4)

# ╔═╡ afbb4068-9395-11eb-36ef-5b96bd9928d8
default(size =(3000, 2000))

# ╔═╡ fc6e3d88-9394-11eb-2099-392f638b5de3
begin
	histogram(r4)
	d_mean = mean(r4)
	d_mode = mode(r4)
	d_median = median(r4)
	plot!([d_mean, d_mean], [600, mean(r4)], label="Mean", line=(8, :dash, :green))
	plot!([d_mode, d_mode], [600, mode(r4)], label="Mode", line=(5, :red))
	plot!([d_median, d_median], [600, median(r4)], label="Median", line=(9, :dot, :orange))
end

# ╔═╡ 794befd2-9398-11eb-1540-c1d46e036644
d_mean,d_median,d_mode

# ╔═╡ 81e22c1a-93a7-11eb-3c54-3dc5d37d1a9e
md"Question-6"

# ╔═╡ 9318d3d2-93a7-11eb-3a5b-375cc68de07e
begin
	res = HTTP.get("https://api.covid19india.org/data.json")
	dt = String(res.body)
	jsdt = JSON.Parser.parse(dt)
end

# ╔═╡ 81bf2f1c-93a7-11eb-2c6b-d759292526c4
df =DataFrame.(jsdt["cases_time_series"])

# ╔═╡ f3a6bee2-93a7-11eb-2ea5-a766f2ea8760
df41=deepcopy(df[1])

# ╔═╡ f53fd502-93a7-11eb-03bf-23879fef6d61
for i in range(1,length=length(df)-1)
	append!(df41,df[i+1])
end

# ╔═╡ 0732c1cc-93a8-11eb-160f-afcd3625d342
df41

# ╔═╡ 0ab14aa2-93a9-11eb-2d57-eb405217aeca
@bind f PlutoUI.FilePicker() # pick any supported file type

# ╔═╡ 0f5f8730-93a9-11eb-10d5-b99d6c469e22
dfcv1 = DataFrame(read_table(f); copycols=false)

# ╔═╡ c392491e-93df-11eb-3ced-7599ee6ea181
dfcv=select(dfcv1,:Date,:State,:Confirmed)

# ╔═╡ cb23ef50-93c3-11eb-03dc-b5dc6280542f
dfcv

# ╔═╡ 554caf24-93c3-11eb-28ee-4163180e7649
weekno=Dates.week.(dfcv[:,:Date])

# ╔═╡ f3036fd6-93c4-11eb-3099-e5610582221b
length(weekno)

# ╔═╡ 603ff93e-93c3-11eb-287f-4f3f92831712
insertcols!(dfcv,2,:WeekNo=>weekno)

# ╔═╡ a3402dde-93da-11eb-0780-17fb27689e57
gdat=groupby(dfcv,[:WeekNo,:State])

# ╔═╡ d49bff9c-93db-11eb-1299-6b7f94d8987c
length(gdat)

# ╔═╡ 08be43ac-93dc-11eb-2804-bd8927071733
fdf=combine(gdat,:Confirmed => sum)

# ╔═╡ b9ad8452-93dc-11eb-1011-03bbbc391430
WklyRpt=unstack(fdf, :State,:Confirmed_sum)

# ╔═╡ 5092565e-93dd-11eb-13bb-d74ece157512
cov(WklyRpt.Kerala, WklyRpt.India)

# ╔═╡ e38715a8-93dd-11eb-3949-8f37ec5b6a7b
heatmap(names(WklyRpt)[1],names(WklyRpt)[1],WklyRpt)

# ╔═╡ eb89812a-93e0-11eb-0356-cf81866baf20
ck=Int64(WklyRpt[:,:Kerala])

# ╔═╡ 72c29f72-93df-11eb-3ff2-2bf3ed8ae0be
describe(WklyRpt)

# ╔═╡ 718dc3fc-93df-11eb-0d2d-cb22195ba3c7


# ╔═╡ 246f1cf0-93de-11eb-2046-2dbf48fd3e65
typeof(WklyRpt[2,3])

# ╔═╡ 364aab9c-93de-11eb-3ddd-ab0af4f27f95
names(WklyRpt)[2]

# ╔═╡ babe8d76-93de-11eb-2025-377581321a42
heatmap(randn(10,10))

# ╔═╡ Cell order:
# ╠═7420c480-910c-11eb-2338-6bbd68005f0a
# ╠═131772d8-917f-11eb-1add-1f94cfb9bf63
# ╠═b0f0b9a4-938c-11eb-3929-331bdd555c4c
# ╠═298ff14c-910d-11eb-1088-efa7ab843b4f
# ╠═ee48c5f4-93a6-11eb-238f-1ffd8145a1ef
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
# ╟─a90df21e-9394-11eb-0ff7-37cfc41afa04
# ╠═a88bdb1c-9394-11eb-1e74-7bd8f5df3bd9
# ╠═c1b23bec-9394-11eb-1b67-f5c5d9399cce
# ╠═f5648448-9394-11eb-16d1-8bee54c6cd04
# ╠═fad25ca2-9394-11eb-2619-810171823759
# ╠═fcb1f26c-9394-11eb-1460-4bccdabe09bc
# ╠═fc92123a-9394-11eb-3a5e-2135605e5e56
# ╠═445d3a02-9397-11eb-10ce-41c6e44124b5
# ╠═afbb4068-9395-11eb-36ef-5b96bd9928d8
# ╠═fc6e3d88-9394-11eb-2099-392f638b5de3
# ╠═794befd2-9398-11eb-1540-c1d46e036644
# ╟─81e22c1a-93a7-11eb-3c54-3dc5d37d1a9e
# ╠═9318d3d2-93a7-11eb-3a5b-375cc68de07e
# ╠═81bf2f1c-93a7-11eb-2c6b-d759292526c4
# ╠═f3a6bee2-93a7-11eb-2ea5-a766f2ea8760
# ╠═f53fd502-93a7-11eb-03bf-23879fef6d61
# ╠═0732c1cc-93a8-11eb-160f-afcd3625d342
# ╠═0ab14aa2-93a9-11eb-2d57-eb405217aeca
# ╠═0f5f8730-93a9-11eb-10d5-b99d6c469e22
# ╠═c392491e-93df-11eb-3ced-7599ee6ea181
# ╠═cb23ef50-93c3-11eb-03dc-b5dc6280542f
# ╠═554caf24-93c3-11eb-28ee-4163180e7649
# ╠═f3036fd6-93c4-11eb-3099-e5610582221b
# ╠═603ff93e-93c3-11eb-287f-4f3f92831712
# ╠═a3402dde-93da-11eb-0780-17fb27689e57
# ╠═d49bff9c-93db-11eb-1299-6b7f94d8987c
# ╠═08be43ac-93dc-11eb-2804-bd8927071733
# ╠═b9ad8452-93dc-11eb-1011-03bbbc391430
# ╠═5092565e-93dd-11eb-13bb-d74ece157512
# ╠═e38715a8-93dd-11eb-3949-8f37ec5b6a7b
# ╠═eb89812a-93e0-11eb-0356-cf81866baf20
# ╠═72c29f72-93df-11eb-3ff2-2bf3ed8ae0be
# ╠═718dc3fc-93df-11eb-0d2d-cb22195ba3c7
# ╠═246f1cf0-93de-11eb-2046-2dbf48fd3e65
# ╠═364aab9c-93de-11eb-3ddd-ab0af4f27f95
# ╠═babe8d76-93de-11eb-2025-377581321a42

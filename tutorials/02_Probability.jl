### A Pluto.jl notebook ###
# v0.12.17

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

# ╔═╡ ebcb6ec6-61f9-11eb-05a3-817618350415
using PlutoUI

# ╔═╡ 2d1693e6-61fa-11eb-3cb6-9f5431449a41
begin
	using Plots
	pyplot()
end

# ╔═╡ f5d3f88c-620e-11eb-3bc8-e3e0e1598482
using Random

# ╔═╡ 6b69c792-62bd-11eb-0f1d-2d0081598dfa
using Distributions

# ╔═╡ b80b8e58-62bf-11eb-11fb-1397b06ae3e1
using QuadGK

# ╔═╡ ebd217ba-61f8-11eb-2337-9db63173ed34
md"# Module 2: _Probability Quick Refresher in Julia_
**CS6741: Statistical Foundations of Data Science**

In this module, we will quickly revise some aspects of Probability through exercises on Julia.

"

# ╔═╡ 4e0bacac-621c-11eb-17be-a968500dc6bc
md"### Dice Throws"

# ╔═╡ 48a0d2ac-6a1d-11eb-2441-897ca192e8ad
md"👉 How would you simulate a fair dice?"

# ╔═╡ 29fb09a2-61f9-11eb-0699-4dbf7daca0d7
faces = 1:6

# ╔═╡ bbae804a-61f9-11eb-03fe-89049682eae7
rand(faces)

# ╔═╡ e977219e-620d-11eb-2ca1-2141cc7c7d2a
md"What is the distribution of values obtained with throws?"

# ╔═╡ ee1bd118-61f9-11eb-1a18-df7d29a96c97
@bind throwdice Button("Throw dice")

# ╔═╡ 059c87a6-61fa-11eb-01b4-09c40af1be94
throws = []

# ╔═╡ 0a10f34e-61fa-11eb-365d-01ff16513530
begin
	throwdice
	for _ in 1:1000
		push!(throws, rand(faces))
	end
end

# ╔═╡ e00f4d02-61f9-11eb-2c5e-19ab03f4bdeb
begin
	throwdice
	histogram(throws, bins = [1, 2, 3, 4, 5, 6, 7], normalize=true, legend=false)
end

# ╔═╡ 20ea39f4-620e-11eb-05b3-716b88bcd205
md"👉 What about the distribution of throws of two dice?"

# ╔═╡ c0b6a868-61fb-11eb-2190-83d6d760ede4
begin
	N = 1000
	two_throws =  [(rand(faces), rand(faces)) for _ in 1:N]
end

# ╔═╡ 947c880a-6203-11eb-1bfe-95c8e630b395
begin
	freq_matrix = zeros(length(faces), length(faces))
	for i in faces
		for j in faces
			freq_matrix[i, j] = count(two_throws .== [(i, j)]) / N
		end
	end
end

# ╔═╡ fb898100-6204-11eb-1faf-cd75283f54d4
freq_matrix

# ╔═╡ b25c21be-6203-11eb-2f40-5db01b4beb89
heatmap(faces, faces, freq_matrix, clim=(0, 0.1))

# ╔═╡ 2b3a4f0c-620e-11eb-2021-bdaab9318fc1
md"👉 What is the probability that the sum of two dice is prime?"

# ╔═╡ c2ae2510-620a-11eb-07e0-91cf24657a55
function isPrime(x)
	if x == 1
		return false
	elseif x == 2
		return true
	end
	for i = 2:sqrt(x)
		if x%i == 0
			return false
		end
	end
	return true
end

# ╔═╡ 853a1ab6-6a1d-11eb-2e08-93e5bcc73c7c
isPrime.(2:12)

# ╔═╡ 33d3be8c-620e-11eb-3f7d-8f9a60cfdefc
md"We have 11 unique sums possible 2 through 12 out of which only 5 (2, 3, 5, 7, 11) are prime. Hence probability is:"

# ╔═╡ 6205d7aa-620d-11eb-3c75-83b491a84995
count(isPrime.(2:12)) / 11

# ╔═╡ 6f0eec76-6a1d-11eb-2585-17959367c09f
md"👉 Is the above correct? Why or why not?"

# ╔═╡ ba50d33e-6a1d-11eb-0687-47cb0b6f8242
md"👉 What visualiation would you use to help you with this?"

# ╔═╡ ec8b9cd0-6211-11eb-06fa-37880ae43e40
histogram([(rand(faces) + rand(faces)) for _ in 1:10000])

# ╔═╡ e37eefb6-6a1d-11eb-000b-89dbddabce5d
md"👉 How do we fix this?"

# ╔═╡ 5b2accf0-620e-11eb-06b9-ef354ebb3261
md"Correct theoretical approach assumes equal probability of the individual dice throws and not the sum"

# ╔═╡ 7dced6ec-6205-11eb-3e95-5f2fa0d5adf3
theorySol = sum([isPrime(i + j) for i in faces, j in faces]) / length(faces)^2

# ╔═╡ 7bbe53a6-620e-11eb-296a-dbf3eaab558d
md"Now we will compute the same thing by running lots of experiments with randomly sampled data. Usually called _Monte Carlo experiments_"

# ╔═╡ 014acff6-6206-11eb-0f3f-f17ef6edf8dd
@bind n_exp html"<input type=range min=1 max=6>"

# ╔═╡ 987d2bb2-620d-11eb-07b6-1736ac133029
n_exp

# ╔═╡ 0c205d04-6205-11eb-2d31-5f689e25a3f1
est = sum([isPrime(rand(faces) + rand(faces)) for i in 1:10^n_exp]) / 10^n_exp

# ╔═╡ beccfb34-620e-11eb-177a-711b597f5f6f
md"These random experiments give different results each time"

# ╔═╡ b0c7733e-620e-11eb-0fb6-f3a9f7631823
[sum([isPrime(rand(faces) + rand(faces)) for i in 1:10^5]) / 10^5 for j = 1: 10]

# ╔═╡ ce084cfc-620e-11eb-2881-8f30a7558bba
md"For reproducibility, we can set the seed of the random number generator"

# ╔═╡ d8b7f274-620e-11eb-13b1-3933af0f7157
begin 
	Random.seed!(0)
	sum([isPrime(rand(faces) + rand(faces)) for i in 1:10^5]) / 10^5
end

# ╔═╡ 77fb84bc-621c-11eb-2cc3-71425a74f823
md"Notice that in the above we used the probability concepts of _independence_ of two random variables and _Monte Carlo_ simulations."

# ╔═╡ 59437fd2-621c-11eb-1e31-f1973639a0e2
md"### Picking balls"

# ╔═╡ 8fbbc5a6-6212-11eb-1020-7382ef578cea
md"Selection with and without replacement"

# ╔═╡ beeacf18-6212-11eb-1929-a5c830dddbcb
md"Let us suppose a bag contains 5 balls - 3 tennis balls, 2 cricket balls"

# ╔═╡ 6aa6b4ec-6212-11eb-39ea-db9d36b22cce
bag = ["🎾", "🥎", "🎾", "🎾", "🥎"]

# ╔═╡ bc4822e0-6212-11eb-3a49-e5307fe49156
rand(bag)

# ╔═╡ d5215c20-6212-11eb-32f5-c71343b60d22
md"👉 What is the probability that if I draw two balls both are tennis balls"

# ╔═╡ e6f2b97e-6212-11eb-0ef4-6593e840b93a
md"The easier case is with replacement. It is simply $P(🎾) \times P(🎾)$"

# ╔═╡ e49d22cc-6212-11eb-2732-27ad5e863ffc
3/5 * 3/5

# ╔═╡ f462afb0-6212-11eb-1a80-239d798e25f8
md"👉 What if we do not allow replacement?"

# ╔═╡ 383c0f2e-6213-11eb-355e-5b16663f1897
md"We are looking for $P(🎾|\phi) \times P(🎾|🎾)$"

# ╔═╡ 559fea86-6213-11eb-185e-b5fc917251fe
3/5 * 2/4

# ╔═╡ 73f6494e-6213-11eb-2a42-7b58fe47d597
md"👉 How do we implement this in Julia when running for more complex examples? Which one do you think is easier to implement - with or without replacements?"

# ╔═╡ 1ad550e8-6214-11eb-108b-0d6e08518018
md"With replacement:"

# ╔═╡ e455c886-6213-11eb-01b8-5df9e2bb7ea8
sum([(rand(bag) == "🎾" && rand(bag) == "🎾") for i in 1:100000])/100000

# ╔═╡ 33bc8ece-6a1f-11eb-20c9-fd32413cc2ac
md"👉 How would you implement this without replacement?"

# ╔═╡ 17ebe7ac-6214-11eb-38f1-3b757972e958
md"Without replacement:"

# ╔═╡ 3d281fc0-6214-11eb-16ae-89900d7f437f
begin
	num = 10000
	count_ = 0
	for i = 1:num
		bag1 = copy(bag)
		ball1 = rand(bag1)
		deleteat!(bag1, findfirst(x-> x == "🎾", bag1))
		ball2 = rand(bag1)
		if ball1 == "🎾" && ball2 == "🎾"
			count_ += 1
		end
	end
	count_ / num
end

# ╔═╡ 94d49374-621c-11eb-2985-b5ee5644c67e
md"Notice that in the above example we use the idea of _conditional probability_"

# ╔═╡ 5eff3d3a-621c-11eb-0824-f76604aed501
md"### Inclusion exclusion principle"

# ╔═╡ ba16f60e-623f-11eb-190a-af4758c32068
md"You have to inform $n$ people about some important news, but you have a fancy quantum phone that randomly dials a person. If you are allowed to make $r \geq n$ calls, what is the probability that all $n$ people are informed of the important news."

# ╔═╡ 51413a62-6a1f-11eb-1400-5918c088122c
md"👉 How would you do this? Think first of the mathematical approach, and then we will look at the computational approach."

# ╔═╡ eed974c0-623f-11eb-021e-ebfc3c85b934
md"Let $A_i$ denote the event that the $i$th person is not informed. Then the probability we seek is 
```math
P(B) = 1 - P(A_1 \cup \ldots \cup A_n)
```"

# ╔═╡ 2cf52d58-6240-11eb-1e21-f3c0a71b4525
md"The probability of the union of those events is not as easy as it may seem. It requires application of the _inclusion exclusion_ principle repeatedly to obtain
```math
P(\large\cup_{i = 1}^n A_i) = \sum_{i = 1}^n P(A_i) - \sum_{\mbox{pairs}} P(A_i \cap A_j) + \sum_{\mbox{triplets}} P(A_i \cap A_j \cap A_k) + \ldots
```
"

# ╔═╡ e8c3415a-6240-11eb-328c-fd7e571ad7f9
md"So our probability becomes
```math
P(B) = 1 - \sum_{k = 1}^n (-1)^{k + 1} {n \choose k}p_k
```
where $p_k$ is the probability of at least $k$ people hearing about the news. From counting principles you can find out that 
```math
p_k = \dfrac{(n - k)^r}{n^r} = \left(1 - \dfrac{k}{n}\right)^r
```
"

# ╔═╡ 74a09470-6241-11eb-00df-cb5032e755c3
function callprobabilty(n, r)
	return sum([(-1)^k * binomial(n, k) * (1 - k/n)^r for k in 0:n])
end

# ╔═╡ 9d189772-6241-11eb-16a3-25c54c8d4148
theorycurve = [callprobabilty(big(n), big(2*n)) for n in 1:100] 

# ╔═╡ 024a8056-6242-11eb-23b6-a14e3fe68a74
plot(1:100, theorycurve)

# ╔═╡ 619109a4-6242-11eb-34eb-2527db9629bc
theorycurves = [ [callprobabilty(big(n), big(r_ratio*n)) for n in 1:200] for r_ratio in 1:3]

# ╔═╡ 85f02e2e-6242-11eb-2a27-7746c98beb47
plot(1:100, theorycurves, label=["r=n" "r=2n" "r=3n"])

# ╔═╡ ce1be85a-6242-11eb-026b-eb7215cc8c18
function simulatecalls(n, r, N)
	failed = float(0)
	for exp in 1:N
		counts = zeros(n)
		for k in 1:r
			person = rand(1:n)
			counts[person] += 1
		end
		if minimum(counts) == 0
			failed += 1
		end
	end
	return 1.0 - failed / N
end

# ╔═╡ 363c8308-6249-11eb-3580-8b721c00a424


# ╔═╡ e0efb4ea-6245-11eb-2423-b7d55a99bf0e
empiricalcurves = [[simulatecalls(n, r_ratio*n, 1000) for n in 1:100] for r_ratio in 1:3]

# ╔═╡ 1aaa0faa-6246-11eb-1f5c-69cbf277efea
begin
	scatter(1:100, empiricalcurves, label="")
	plot!(1:100, theorycurves, label=["r=n" "r=2n" "r=3n"])
end

# ╔═╡ 55b868f4-62bd-11eb-16a8-e14408e3e4bd
md"### Testing independence in random number generators"

# ╔═╡ a1c8ec8c-6a1f-11eb-0a85-fb5cac062c56
md"Randomness is a big requirement in statistical analysis and computational methods that depend on sampling."

# ╔═╡ 95bd11e8-6a1f-11eb-3287-0b32ba568406
md"👉 Do you know of any simple way to generate pseudo random numbers?"

# ╔═╡ abe1778a-6249-11eb-3b17-0de274e8e3fe
md"
A pseudo-random generator is given by the following sequence of outputs:
```math
X_{n + 1} = (a X_n + c) \mbox{ mod } m
```
"

# ╔═╡ 277b4f60-624a-11eb-2e11-9b6c5aeb3b4a
function prng(n)
	c = 7
	m = 13
	a = 5
	out = zeros(Int, n)
	out[1] = floor(rand() * m)
	for i in 2:n
		out[i] = (a * out[i - 1] + c) % m
	end
	return out
end

# ╔═╡ 9645b9a6-624a-11eb-09e9-c399cb136a5c
prng(5)

# ╔═╡ f6e2aff6-624c-11eb-16b5-318c5f230a56
n_vals = 1000

# ╔═╡ b97aa654-6a1f-11eb-11da-f91221057751
md"👉 Are two consecutive random numbers generated with `prng` independent? How would you check this computationally?"

# ╔═╡ ff30f85c-624b-11eb-3cf2-c170108d7092
vals1 = [prng(2) for i in 1:n_vals]

# ╔═╡ e59bc748-6a1f-11eb-2463-7dc3313f4b35
md"Remember that two random variables $X$ and $Y$ are indpendent if
```math
P(X, Y) = P(X) P(Y)
```"

# ╔═╡ b197bcf2-624c-11eb-3b99-efbedf0c6f3b
begin
	a = rand(1:13)
	b = rand(1:13)
	p_a = sum([vals1[i][1] == a for i in 1:n_vals]) / n_vals
	p_b = sum([vals1[i][2] == b for i in 1:n_vals]) / n_vals
	p_ap_b = p_a * p_b
	p_ab = sum([vals1[i][1] == a && vals1[i][2] == b for i in 1:n_vals]) / n_vals
	"a=$a b=$b p(x = a)=$p_a p(y = b)=$p_b p(x = a, y = b)=$p_ab p(x = a)p(y = b)=$p_ap_b"
end

# ╔═╡ 6b0245fe-624f-11eb-38f1-e702814d57c3
vals2 = [[rand(1:13), rand(1:13)] for i in 1:n_vals]

# ╔═╡ 5193bb62-62bc-11eb-1df7-1b7a7e9983ed
begin
	p_a2 = sum([vals2[i][1] == a for i in 1:n_vals]) / n_vals
	p_b2 = sum([vals2[i][2] == b for i in 1:n_vals]) / n_vals
	p_a2p_b2 = p_a2 * p_b2
	p_ab2 = sum([vals2[i][1] == a && vals2[i][2] == b for i in 1:n_vals]) / n_vals
	"a=$a b=$b p(x = a)=$p_a2 p(y = b)=$p_b2 p(x = a, y = b)=$p_ab2 p(x = a)p(y = b)=$p_a2p_b2"
end

# ╔═╡ 76fffb4e-62bd-11eb-153b-690eeaed1160
md"### Distributions and their plots"

# ╔═╡ fae8040a-62be-11eb-18a4-9fe8dee70bed
D_n = Normal(0, 1)

# ╔═╡ 0ea764ea-62bf-11eb-0e98-437744ee9fa9
plot(-5:0.1:5, [pdf(D_n, x) for x in -5:0.1:5], label="Normal PDF")

# ╔═╡ 3771b0ec-62bf-11eb-0300-6d9503c5716b
plot(-5:0.1:5, [cdf(D_n, x) for x in -5:0.1:5], label="CDF")

# ╔═╡ 66abd1d6-62c3-11eb-2e4e-1f67f89c3526
begin
	plot(-5:0.1:5, [cdf(D_n, x) for x in -5:0.1:5], label="CDF")
	plot!(-5:0.1:5, [quadgk(x -> pdf(D_n, x), (-5, y)...)[1] for y in -5:0.1:5], line = (4, :dash), label="From integration")
end

# ╔═╡ c420bab4-62c0-11eb-13c5-51ef6be81102
D_b = Binomial(5, 0.5)

# ╔═╡ ee11743a-62c0-11eb-04ef-8f30696c46ee
plot(0:5, [pdf(D_b, x) for x in 0:5], line=:stem, marker=:circle, label="Binomial")

# ╔═╡ 66a1bfe2-62bf-11eb-36d4-cfcaff920522
mean(D_n)

# ╔═╡ 93a82e9c-62cc-11eb-1b9c-cbc0e30b623e
md"### Moments of distributions"

# ╔═╡ f5b41e14-62bf-11eb-3257-6f5f5d6ceee6
md"What is the mean?
For a discrete distribution:
```math
\mathbb{E}[x]  = \sum_x xp(x)
```
For a continuous distribution:
```math
\mathbb{E}[x]  = \int_{-\infty}^{\infty} x f(x) dx,
```
where $f(x)$ is the pdf of the distribution.
"

# ╔═╡ 2be88b12-62c2-11eb-14de-6912598bc6bb
area = quadgk(x -> pdf(D_n, x), (-5, 5)...)

# ╔═╡ ec35489c-62bf-11eb-0311-2fed6b29d0c6
computed_mean = quadgk(x -> x * pdf(D_n, x), (-5, 5)...)

# ╔═╡ 5dffb66c-62c1-11eb-32f6-4b0b17d2aed1
mean(Binomial(5, 0.5))

# ╔═╡ 35406a36-62c2-11eb-347e-9b03c368119a
tot_length = sum([pdf(D_b, x) for x in 0:5])

# ╔═╡ 653515e4-62c1-11eb-25b0-930f782be996
computed_mean_binominal = sum([x * pdf(D_b, x) for x in 0:5])

# ╔═╡ 6a1d4ba4-62c2-11eb-3b71-431ee0c1fdf5
md"
```math
\mbox{Var}(X) = \mathbb{E}[X^2] - (\mathbb{E}[X])^2
```
"

# ╔═╡ 565657a8-62c2-11eb-22ad-9fbf7e7b44e0
var(D_n)

# ╔═╡ 641557fe-62c2-11eb-1ffd-0b1486231fa0
quadgk(x -> x^2 * pdf(D_n, x), (-5, 5)...)[1] - mean(D_n)^2

# ╔═╡ a46d7728-62cc-11eb-3486-d799a3d29298
md"### Sampling and sums of distributions"

# ╔═╡ 5811e2d8-62cc-11eb-266a-3d1ed4d9270b
n_samples = 1000

# ╔═╡ 2d0191b4-62c3-11eb-1479-21830ac879eb
x1 = rand(D_n, n_samples)

# ╔═╡ c845fae0-62c6-11eb-2a29-bdbc0c07d6d4
histogram(x1, normalize=true)

# ╔═╡ bd903520-62c6-11eb-1f71-49b662373de7
x2 = rand(D_b, n_samples)

# ╔═╡ 485386b2-62cc-11eb-1dd4-31857e128d7f
histogram(x2, normalize=true)

# ╔═╡ c4f908fa-62c6-11eb-259d-576dee85efb9
x = x1 + x2

# ╔═╡ 505c1658-62cc-11eb-1068-659d4286a4da
histogram(x, normalize=true)

# ╔═╡ 6e365fee-62cc-11eb-28d4-cd498c21895d
begin
	histogram(x, normalize=true)
	plot!(-5:0.1:5, [pdf(D_n, x)+pdf(D_b, x) for x in -5:0.1:5])
end

# ╔═╡ ad175b5a-62cc-11eb-2913-8741eca3d89c
md"The random variable which is the sum of two independent random variable does not necessarily have a pdf as the sum of the pdfs of the two random variables."

# ╔═╡ c19c5abc-62cc-11eb-3bcd-d9ee89e4619d
begin
	conv(x) = sum(pdf(D_n,x-k)*pdf(D_b,k) for k=-5:0.1:8)
	plot(-5:0.1:8, conv.(-5:0.1:8))
end

# ╔═╡ e6d9958c-62cd-11eb-164e-4b52aedd1584
md"The convolution operation on the individual pdfs creates the pdf of the sum of two random variables. It is defined as:
```math
h(z) = (p1 \otimes p2)(z) = \int_{-\infty}^{\infty} f(t) g(z - t) dt
```
This needs to be changed to discrete versions if distribution/s are discrete.
"

# ╔═╡ b68f9fdc-62cd-11eb-1852-0116fe475f36
begin
	histogram(x, normalize=true)
	plot!(-5:0.1:8, conv.(-5:0.1:8))
end

# ╔═╡ 7b02ff44-62ce-11eb-2c40-b5a734f869cb
md"### Inverse"

# ╔═╡ 7e5765f6-62ce-11eb-222e-9786c5fc0911
md"When we say that the $\mbox{CDF}(x) = u$, we mean that the probability of the random number being less than or equal to $x$ is $u$. We can now ask an opposite question: For what value of $x$ is the probability of the random number being less than $x$ is a given $u$. This is usually referred to as the _inverse function_."

# ╔═╡ beea6cda-62ce-11eb-0ef1-253f1a40504b
md"Though not mathematically tight, we can define the inverse function $\mbox{CDF}^{-1}$ as:
```math
\mbox{CDF}^{-1}(u) = \inf\{x\ :\ \mbox{CDF}(x) \geq u\}
```
"

# ╔═╡ 0047b980-62cf-11eb-3ca2-ad2f18f0e091
cdf_n(x) = cdf(Normal(0, 1), x)

# ╔═╡ 1676307e-62cf-11eb-39e5-bd732850ab2f
cdf_n_inv(u) = minimum(filter((x) -> (cdf_n(x) >= u), -5:0.01:5))

# ╔═╡ 343f9c62-62cf-11eb-2d09-cff6967a1d65
plot(-5:0.1:5, [cdf_n(x) for x in -5:0.1:5])

# ╔═╡ 5fab01a2-62cf-11eb-1c61-f9da64f9a75f
plot(0.1:0.01:0.9, [cdf_n_inv(u) for u in 0.1:0.01:0.9])

# ╔═╡ 9a083902-62d2-11eb-2570-bdb7ea1e1f5e
md"Let us relate the inverse function to area under the PDF curve"

# ╔═╡ c483fc1c-62d1-11eb-14b6-f50474a58fb2
cdf_n_inv(0.8)

# ╔═╡ a9a39152-62d2-11eb-3b4a-5d37f7195f3a
cdf_n_inv(0.95)

# ╔═╡ f437e702-62d1-11eb-1ac8-63c7f6ec16c4
xslider = @bind x_slider html"<input type=range min=-5 max=5 step=0.01>"

# ╔═╡ 8439e2ec-62d2-11eb-3772-d17e099debb5
x_slider

# ╔═╡ 794c86e6-62d2-11eb-3e27-ebd8a1b3d4e3
u_cdf = cdf_n(x_slider)

# ╔═╡ cb5e2858-62d1-11eb-1489-037703d411ec
begin
	plot(x->x, x->pdf(Normal(0, 1), x), -10, 10, label="")
	plot!(x->x, x->pdf(Normal(0, 1), x), x_slider, 10, fill=(0, :orange), label="")
end

# ╔═╡ 2a8682e2-62d3-11eb-119e-cbd804e1b0b2
md"### Fitting given data to distributions"

# ╔═╡ a089b976-62d3-11eb-2702-8945a47bf858
n_slider = @bind n_samples_exp html"<input type=range min=1 max=5 step=1>"

# ╔═╡ 3151c634-62d3-11eb-2698-95e4e14aab2d
samples = rand(Normal(10, 2.5), 10^n_samples_exp) + rand(Normal(0, 1), 10^n_samples_exp)

# ╔═╡ 62e55e4a-62d3-11eb-21e3-7b02354ddd02
histogram(samples)

# ╔═╡ 786f3d9c-62d3-11eb-28a7-b387242e3760
fit(Normal, samples)

# ╔═╡ 9531fffe-62d3-11eb-124c-0d2cccea92ae
md"Notice how the estimate of μ is reasonably unbiased even for small sizes of the samples, but how σ seems to be higher."

# ╔═╡ Cell order:
# ╟─ebd217ba-61f8-11eb-2337-9db63173ed34
# ╠═ebcb6ec6-61f9-11eb-05a3-817618350415
# ╠═2d1693e6-61fa-11eb-3cb6-9f5431449a41
# ╟─4e0bacac-621c-11eb-17be-a968500dc6bc
# ╟─48a0d2ac-6a1d-11eb-2441-897ca192e8ad
# ╠═29fb09a2-61f9-11eb-0699-4dbf7daca0d7
# ╠═bbae804a-61f9-11eb-03fe-89049682eae7
# ╟─e977219e-620d-11eb-2ca1-2141cc7c7d2a
# ╠═ee1bd118-61f9-11eb-1a18-df7d29a96c97
# ╠═059c87a6-61fa-11eb-01b4-09c40af1be94
# ╠═0a10f34e-61fa-11eb-365d-01ff16513530
# ╠═e00f4d02-61f9-11eb-2c5e-19ab03f4bdeb
# ╟─20ea39f4-620e-11eb-05b3-716b88bcd205
# ╠═c0b6a868-61fb-11eb-2190-83d6d760ede4
# ╠═947c880a-6203-11eb-1bfe-95c8e630b395
# ╠═fb898100-6204-11eb-1faf-cd75283f54d4
# ╠═b25c21be-6203-11eb-2f40-5db01b4beb89
# ╟─2b3a4f0c-620e-11eb-2021-bdaab9318fc1
# ╟─c2ae2510-620a-11eb-07e0-91cf24657a55
# ╠═853a1ab6-6a1d-11eb-2e08-93e5bcc73c7c
# ╟─33d3be8c-620e-11eb-3f7d-8f9a60cfdefc
# ╠═6205d7aa-620d-11eb-3c75-83b491a84995
# ╟─6f0eec76-6a1d-11eb-2585-17959367c09f
# ╟─ba50d33e-6a1d-11eb-0687-47cb0b6f8242
# ╠═ec8b9cd0-6211-11eb-06fa-37880ae43e40
# ╟─e37eefb6-6a1d-11eb-000b-89dbddabce5d
# ╟─5b2accf0-620e-11eb-06b9-ef354ebb3261
# ╠═7dced6ec-6205-11eb-3e95-5f2fa0d5adf3
# ╟─7bbe53a6-620e-11eb-296a-dbf3eaab558d
# ╠═014acff6-6206-11eb-0f3f-f17ef6edf8dd
# ╠═987d2bb2-620d-11eb-07b6-1736ac133029
# ╠═0c205d04-6205-11eb-2d31-5f689e25a3f1
# ╟─beccfb34-620e-11eb-177a-711b597f5f6f
# ╠═b0c7733e-620e-11eb-0fb6-f3a9f7631823
# ╟─ce084cfc-620e-11eb-2881-8f30a7558bba
# ╠═f5d3f88c-620e-11eb-3bc8-e3e0e1598482
# ╠═d8b7f274-620e-11eb-13b1-3933af0f7157
# ╟─77fb84bc-621c-11eb-2cc3-71425a74f823
# ╟─59437fd2-621c-11eb-1e31-f1973639a0e2
# ╟─8fbbc5a6-6212-11eb-1020-7382ef578cea
# ╟─beeacf18-6212-11eb-1929-a5c830dddbcb
# ╠═6aa6b4ec-6212-11eb-39ea-db9d36b22cce
# ╠═bc4822e0-6212-11eb-3a49-e5307fe49156
# ╟─d5215c20-6212-11eb-32f5-c71343b60d22
# ╟─e6f2b97e-6212-11eb-0ef4-6593e840b93a
# ╠═e49d22cc-6212-11eb-2732-27ad5e863ffc
# ╟─f462afb0-6212-11eb-1a80-239d798e25f8
# ╟─383c0f2e-6213-11eb-355e-5b16663f1897
# ╠═559fea86-6213-11eb-185e-b5fc917251fe
# ╟─73f6494e-6213-11eb-2a42-7b58fe47d597
# ╟─1ad550e8-6214-11eb-108b-0d6e08518018
# ╠═e455c886-6213-11eb-01b8-5df9e2bb7ea8
# ╟─33bc8ece-6a1f-11eb-20c9-fd32413cc2ac
# ╟─17ebe7ac-6214-11eb-38f1-3b757972e958
# ╠═3d281fc0-6214-11eb-16ae-89900d7f437f
# ╟─94d49374-621c-11eb-2985-b5ee5644c67e
# ╟─5eff3d3a-621c-11eb-0824-f76604aed501
# ╟─ba16f60e-623f-11eb-190a-af4758c32068
# ╟─51413a62-6a1f-11eb-1400-5918c088122c
# ╟─eed974c0-623f-11eb-021e-ebfc3c85b934
# ╟─2cf52d58-6240-11eb-1e21-f3c0a71b4525
# ╟─e8c3415a-6240-11eb-328c-fd7e571ad7f9
# ╠═74a09470-6241-11eb-00df-cb5032e755c3
# ╠═9d189772-6241-11eb-16a3-25c54c8d4148
# ╠═024a8056-6242-11eb-23b6-a14e3fe68a74
# ╠═619109a4-6242-11eb-34eb-2527db9629bc
# ╠═85f02e2e-6242-11eb-2a27-7746c98beb47
# ╠═ce1be85a-6242-11eb-026b-eb7215cc8c18
# ╠═363c8308-6249-11eb-3580-8b721c00a424
# ╠═e0efb4ea-6245-11eb-2423-b7d55a99bf0e
# ╠═1aaa0faa-6246-11eb-1f5c-69cbf277efea
# ╟─55b868f4-62bd-11eb-16a8-e14408e3e4bd
# ╟─a1c8ec8c-6a1f-11eb-0a85-fb5cac062c56
# ╟─95bd11e8-6a1f-11eb-3287-0b32ba568406
# ╟─abe1778a-6249-11eb-3b17-0de274e8e3fe
# ╠═277b4f60-624a-11eb-2e11-9b6c5aeb3b4a
# ╠═9645b9a6-624a-11eb-09e9-c399cb136a5c
# ╠═f6e2aff6-624c-11eb-16b5-318c5f230a56
# ╟─b97aa654-6a1f-11eb-11da-f91221057751
# ╠═ff30f85c-624b-11eb-3cf2-c170108d7092
# ╟─e59bc748-6a1f-11eb-2463-7dc3313f4b35
# ╠═b197bcf2-624c-11eb-3b99-efbedf0c6f3b
# ╠═6b0245fe-624f-11eb-38f1-e702814d57c3
# ╠═5193bb62-62bc-11eb-1df7-1b7a7e9983ed
# ╟─76fffb4e-62bd-11eb-153b-690eeaed1160
# ╠═6b69c792-62bd-11eb-0f1d-2d0081598dfa
# ╠═fae8040a-62be-11eb-18a4-9fe8dee70bed
# ╠═0ea764ea-62bf-11eb-0e98-437744ee9fa9
# ╠═3771b0ec-62bf-11eb-0300-6d9503c5716b
# ╠═66abd1d6-62c3-11eb-2e4e-1f67f89c3526
# ╠═c420bab4-62c0-11eb-13c5-51ef6be81102
# ╠═ee11743a-62c0-11eb-04ef-8f30696c46ee
# ╠═66a1bfe2-62bf-11eb-36d4-cfcaff920522
# ╠═b80b8e58-62bf-11eb-11fb-1397b06ae3e1
# ╟─93a82e9c-62cc-11eb-1b9c-cbc0e30b623e
# ╟─f5b41e14-62bf-11eb-3257-6f5f5d6ceee6
# ╠═2be88b12-62c2-11eb-14de-6912598bc6bb
# ╠═ec35489c-62bf-11eb-0311-2fed6b29d0c6
# ╠═5dffb66c-62c1-11eb-32f6-4b0b17d2aed1
# ╠═35406a36-62c2-11eb-347e-9b03c368119a
# ╠═653515e4-62c1-11eb-25b0-930f782be996
# ╟─6a1d4ba4-62c2-11eb-3b71-431ee0c1fdf5
# ╠═565657a8-62c2-11eb-22ad-9fbf7e7b44e0
# ╠═641557fe-62c2-11eb-1ffd-0b1486231fa0
# ╟─a46d7728-62cc-11eb-3486-d799a3d29298
# ╠═5811e2d8-62cc-11eb-266a-3d1ed4d9270b
# ╠═2d0191b4-62c3-11eb-1479-21830ac879eb
# ╠═c845fae0-62c6-11eb-2a29-bdbc0c07d6d4
# ╠═bd903520-62c6-11eb-1f71-49b662373de7
# ╠═485386b2-62cc-11eb-1dd4-31857e128d7f
# ╠═c4f908fa-62c6-11eb-259d-576dee85efb9
# ╠═505c1658-62cc-11eb-1068-659d4286a4da
# ╠═6e365fee-62cc-11eb-28d4-cd498c21895d
# ╟─ad175b5a-62cc-11eb-2913-8741eca3d89c
# ╠═c19c5abc-62cc-11eb-3bcd-d9ee89e4619d
# ╟─e6d9958c-62cd-11eb-164e-4b52aedd1584
# ╠═b68f9fdc-62cd-11eb-1852-0116fe475f36
# ╟─7b02ff44-62ce-11eb-2c40-b5a734f869cb
# ╟─7e5765f6-62ce-11eb-222e-9786c5fc0911
# ╟─beea6cda-62ce-11eb-0ef1-253f1a40504b
# ╠═0047b980-62cf-11eb-3ca2-ad2f18f0e091
# ╠═1676307e-62cf-11eb-39e5-bd732850ab2f
# ╠═343f9c62-62cf-11eb-2d09-cff6967a1d65
# ╠═5fab01a2-62cf-11eb-1c61-f9da64f9a75f
# ╟─9a083902-62d2-11eb-2570-bdb7ea1e1f5e
# ╠═c483fc1c-62d1-11eb-14b6-f50474a58fb2
# ╠═a9a39152-62d2-11eb-3b4a-5d37f7195f3a
# ╠═f437e702-62d1-11eb-1ac8-63c7f6ec16c4
# ╠═8439e2ec-62d2-11eb-3772-d17e099debb5
# ╠═794c86e6-62d2-11eb-3e27-ebd8a1b3d4e3
# ╠═cb5e2858-62d1-11eb-1489-037703d411ec
# ╟─2a8682e2-62d3-11eb-119e-cbd804e1b0b2
# ╠═a089b976-62d3-11eb-2702-8945a47bf858
# ╠═3151c634-62d3-11eb-2698-95e4e14aab2d
# ╠═62e55e4a-62d3-11eb-21e3-7b02354ddd02
# ╠═786f3d9c-62d3-11eb-28a7-b387242e3760
# ╟─9531fffe-62d3-11eb-124c-0d2cccea92ae

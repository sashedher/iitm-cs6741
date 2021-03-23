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

# ╔═╡ e9498332-3635-11eb-144e-9317d798a852
begin
	using Plots
	pyplot()
end

# ╔═╡ e46a9378-363b-11eb-2de3-392328463c96
using LaTeXStrings

# ╔═╡ 12dcd77c-36b2-11eb-2edb-23474d30667e
using PlutoUI

# ╔═╡ f53acdf2-363c-11eb-338d-eda9aae08443
using Distributions

# ╔═╡ 7fc34796-3648-11eb-244d-fbec5ad621b1
using Roots

# ╔═╡ ddee4202-3649-11eb-1198-236bf1d0d262
using Calculus

# ╔═╡ ae0486aa-36a6-11eb-30b9-8f03e178de69
using Random, LinearAlgebra

# ╔═╡ 790c383c-3647-11eb-2d7e-5d502338d789
using Combinatorics

# ╔═╡ 222e6098-36a9-11eb-12f9-dbb9552d0768
using PyCall

# ╔═╡ 1246fbea-3620-11eb-324c-1d4299044df9
md"# Module 1: _Introduction to Julia_

Welcome to **CS6741: Statistical Foundations of Data Science**

We will use Julia throughout the course. In this module, you will see some reasons why we choose Julia. Through these examples, we will also introduce you to Julia syntax. However this is by no means a complete presentation. You will have to try the language for yourself and read the official [docs](https://docs.julialang.org/en/v1/) and [tutorials](https://julialang.org/learning/tutorials/) to get more familiar with Juila.

"

# ╔═╡ b71b0e7e-3628-11eb-1713-092a8f0e6499
md"## Why Julia?

Through the course, we will work with Julia. Some lectures and all assignments will involve Julia code. So the natural question you may ask is: Why Julia? Why not Python which many of you would already know? Or why not R which is (still) widely used in Statistics? Or why not a standard performant language like C? Below we discuss several reasons for this. 
"

# ╔═╡ 13b1268a-362b-11eb-1fb0-fbd74c2c80e5
md"#### 1. The two langauge problem

An important trade-off in programming is that between the time it takes to **develop** a program and the time it takes to **execute** a program. For the broad area of data sciences, one may argue that reducing developer time is more important than execution time. Consequently, languages such as R and Python have been designed to be **easier to learn** and have specific **libraries** for data analysis, visualisation, linear algebra, statistics, etc. However, after the program is finalised, R and Python do not provide high performance for **deployment**. Usually, at this point, the program is reimplemented in languages such as C/C++ or FORTRAN or Java. This is the **two langauge problem**. 

Julia provides a very different trade-off to address this problem. Like R and Python, Julia is easy to learn, has a simple syntax, a lot of libraries for data science. And yet Julia produces high performance LLVM code which is Just-In-Time (JIT) compiled. This enables Juila to achieve performance like C."

# ╔═╡ 3826299e-3631-11eb-0602-4396f3b0375b
md"Let us illustrate this with a simple iterative function to estimate the value of the π:"

# ╔═╡ f90cf21c-3631-11eb-1db7-43e0d3eca3b6
md"```math
π = \lim_{N \to \infty} \sqrt{6 \times \sum_{x = 1}^N \frac{1}{x^2}}
```
"

# ╔═╡ 2678c03c-362d-11eb-1e35-b1a65fafe477
sqrt(6 * sum(k -> 1/k^2, 1:10^8))

# ╔═╡ 7db9d46c-362d-11eb-17de-0be78e78aafb
md"Compare this estimate against the precise value: $π"

# ╔═╡ 1c73ef50-3630-11eb-230c-2d44d12e4c64
md"The above code takes about ~ 125 ms on my machine. On the other hand, the following equivalent Python statement takes about 100x longer ~ 10 s on my machine.

`sqrt(6 * sum(1 / (x * x) for x in range(1, 10^8)))`

"

# ╔═╡ 8934782c-6956-11eb-09f4-a5fb501e3b40
md"👉 Repeat this on your device and we will discuss the results in the next class."

# ╔═╡ 1a3facd0-3631-11eb-06aa-410a6683a192
md"Results of many other micro-benchmarks are available at [this](https://julialang.org/benchmarks/) official website of Julia. The general point is that Julia seems much faster than Python - which is the default choice of many students and also courses.
"

# ╔═╡ 6f779994-36fc-11eb-1138-3d665ffea83b
md"How does Julia achieve this high performance? By JIT compiling the code into efficient, vectorized LLVM code. Indeed, you would experience a delay when you first run a piece of code (like adding a library) because Julia is compiling it.

We can inspect the implementation by looking at the source code of sqrt."

# ╔═╡ 3bdc4b1c-3644-11eb-04c8-b58a599801e0
@which sqrt(4.0)

# ╔═╡ 36b9a48a-3776-11eb-1c3c-455b531f4e81
md"Notice how the libraries in Juila are also written in Julia. This is unlike Python, where libraries like `numpy` are implemented in C for efficiency"

# ╔═╡ a639c37a-36fc-11eb-03a0-ad3ff5fbe073
md"We can also show the exact low-level code (LLVM for those who know compilers) produced by a statement. We see this for the `sum` operation for estimating π."

# ╔═╡ 83f86052-363f-11eb-23ac-6fc284636634
@code_llvm sum(k -> 1/k^2, 1:10^8)

# ╔═╡ 38cb6ee8-3640-11eb-2b0b-4b46f7a4331b
md"
```
;  @ reducedim.jl:653 within `sum'
define double @julia_sum_17200([2 x i64] addrspace(11)* nocapture nonnull readonly dereferenceable(16)) {
top:
; ┌ @ reducedim.jl:653 within `#sum#584'
; │┌ @ reducedim.jl:657 within `_sum'
; ││┌ @ reducedim.jl:307 within `mapreduce'
; │││┌ @ reducedim.jl:307 within `#mapreduce#580'
; ││││┌ @ reducedim.jl:312 within `_mapreduce_dim'
       %1 = call double @julia__mapreduce_17201([2 x i64] addrspace(11)* nocapture nonnull readonly %0)
; └└└└└
  ret double %1
}
```
"

# ╔═╡ e0d53d14-36fc-11eb-1712-312176bb50be
md"Notice how Julia is automatically doing vectorization and the code is ready to be parallelized."

# ╔═╡ 4d01b08e-3776-11eb-0f66-879f1077f72c
md"So Julia addresses the two language problem for data science - it can be used for learning and exploratory anlaysis and is fast enough for deployment."

# ╔═╡ 4e80c0d6-3633-11eb-3b70-5bba9910d0ab
md"#### 2. Reactive coolness with Pluto.jl"

# ╔═╡ f30f27a4-36fc-11eb-114f-73c46189b2a2
md"Another reason to use Julia is simply as a learning/teaching tool. We are using the `Pluto.jl` library which is a cool way to try out things as you are learning. The key concept is a `reactive document` wherein all parts of the document are re-executed when any one part changes. So when a variable is changed, all other code blocks which depend on this variable are re-executed and the output updated. Notice this is not how a Jupyter notebook for instance works. When you change a variable, it only affects the cell that is executed. You can learn about Pluto from this [video](https://www.youtube.com/watch?v=6ewFgLR1LLY). Pluto also has very helpful live docs."

# ╔═╡ 60f92516-3700-11eb-0c8e-eb6bdfa9d700
md"In the following, changing the `universe` variable automatically changes the display in the next cell"

# ╔═╡ 3375e884-36fd-11eb-05cc-61cecdc3f25a
universe = "universe"

# ╔═╡ 4838e1cc-36fd-11eb-2252-6dc30614dca7
md"hello $universe"

# ╔═╡ cede9b4e-3703-11eb-1032-3b126bef79a6
md"In the above notice the $ symbol used to interpolate or substitute a value within double quotes. This is a convenient way to print output in `Pluto`."

# ╔═╡ 27caddb4-36fd-11eb-249b-d53ac54d5bb3
md"In addition to reactive documents, `Pluto` also has very useful interactive tools using HTML widgets. See for example the following way of changing a variable with a slider."

# ╔═╡ 0cff395e-3634-11eb-038c-7382a21e61f9
@bind x html"<input type=range min=1 max=5>"

# ╔═╡ 59fdc9a0-3634-11eb-3220-e37bc5f1a21a
x

# ╔═╡ a2441cee-3700-11eb-359b-fbafc3fd80b7
md"The same variable has been used to change the number of steps in our computation of π from earlier. Reducing `x` reduces the precision of our estimate of π."

# ╔═╡ 5734e1e6-3633-11eb-3c57-d147f8440e90
sqrt(6 * sum(k -> 1/k^2, 1:10^x))

# ╔═╡ 8c85386c-3635-11eb-220d-75fc262637c9
md"This reactive approach also works for _plots_: changing a value with a slider can trigger an updated plot. This is quite powerful in building graphical intuition throughout the course."

# ╔═╡ e028d978-3700-11eb-0761-21d79fa8c3e4
md"For plotting we will use the standard `Plots` package which is included with the `using` keyword. In addition, there is the choice of different plot backends. We will use the `pyplot` backend here. Other popular backends are `gr` and `plotly`."

# ╔═╡ fd9e0792-3700-11eb-2c26-21ecd07186f4
md"Let us use this to plot sin(ωx) where ω is changed with a slider"

# ╔═╡ 5d380a9e-3635-11eb-0971-b5ab98d71d30
@bind ω html"<input type=range min=1 max=10>"

# ╔═╡ 6eaaa3ac-3635-11eb-1dd2-5bb9f61d5ec5
ω

# ╔═╡ 1c9f1b98-3703-11eb-3a07-1ff6e27dfa88
md"Notice how we use the ω symbol. Julia supports Unicode and thus we can include these symbols in variable or function names. We will take advantage of this often for mathematical notation throughout the course."

# ╔═╡ ffee87a4-3635-11eb-259a-e552b2eddb16
plot(x->x, x->sin(ω*x), 0, 2π, legend = false, line=3)

# ╔═╡ c389d9fe-363b-11eb-0f69-9bd72252bb4d
md"Julia is ``\LaTeX`` friendly. In particular, you can use latex-typesetting in plots too."

# ╔═╡ ddd34708-3776-11eb-256f-6385b9c1be4e
md"Note that Julia package names are case-sensitive!"

# ╔═╡ ee223de4-3776-11eb-3502-c9069ffb6e03
md"In the following we demonstrate a common relation from trigonometry."

# ╔═╡ df1af070-363b-11eb-11c7-21721a710d42
plot(x->x, x->sin(ω*x)*sin(ω*x) + cos(ω*x)*cos(ω*x), 0, 2π, legend = false, line=3, ylabel=L"\sin^2(\omega \theta) + \cos^2(\omega \theta)", xlabel=L"\theta")

# ╔═╡ 2e9bd7fe-3701-11eb-185d-255d69d9ca73
md"We can also use the `PlutoUI` library which creates many easy interfaces to the HTML widgets."

# ╔═╡ 3f838d3c-3701-11eb-3a47-1143a598b863
md"In the following, we have a button which can be used to trigger a function. The variable that is bound (`samplemore` below) needs to be included in every block that is expected to be re-executed when the button is pressed."

# ╔═╡ dd7b1b20-36b1-11eb-2a3c-65a767b0afa2
@bind samplemore Button("Sample more")

# ╔═╡ b919e9be-36b6-11eb-0636-6570c66ddfcc
throws = []

# ╔═╡ 1961d638-36b2-11eb-1710-854a0d4cee29
begin
	samplemore
	for _ in 1:100
		push!(throws, rand(1:6))
	end
end

# ╔═╡ 14721fb6-3702-11eb-0cf0-15d871f5fb1c
md"Everytime the button is pressed we are recording a few fair dice throws. We then plot the frequency of all the throws so far in a _histogram_. Notice how the block of code for plotting is made to re-execute every time the button is clicked." 

# ╔═╡ 3ece5f9a-36b2-11eb-1eaf-63668f42ee83
histogram(throws, bins = 1:7, normalize=true, legend=false)

# ╔═╡ 3cdbc9a0-3777-11eb-1b20-b1e23cc647de
md"What do you think the `normalize` keyword does? We will see more about this in the section on plotting."

# ╔═╡ 70b285ee-363b-11eb-15d9-5721055a405f
md"#### 3. Lots of useful packages"

# ╔═╡ 453fe312-3702-11eb-00f3-e119b46c7dae
md"Julia is designed for scientific computing (often by scientists) and thus there are many different packages which often would directly map to the chapters you see in the course."

# ╔═╡ 57b76696-3702-11eb-3824-c32de45a9755
md"The following package provides many of the distributions that you would have seen in a probability course."

# ╔═╡ 768e5d4a-3702-11eb-339b-6dff178c893f
md"In the following, the two sliders control the mean and standard deviation of one of the most common distributions: the **normal distribution**."

# ╔═╡ 224999bc-363e-11eb-3ecb-ff5e7d48e97f
begin
	μslider = @bind μ html"<input type=range min=-3 max=3 step=0.2>"
	ωslider = @bind σ html"<input type=range min=0.1 max=2 step=0.1>"
	
	md"""Configure your **normal distribution**:
	
	μ: $(μslider)

	σ: $(ωslider)"""
end

# ╔═╡ 49cb6552-363d-11eb-1c02-9552cda30cc8
plot(x->x, x->pdf(Normal(μ, σ), x), -10, 10, ylim=(0, 1), fill=(0, :orange), label=L"\mathcal{N}("*string(μ)*","*string(σ)*")")

# ╔═╡ 8daef890-3702-11eb-0ef6-67637c7004e5
md"Playing with the sliders you can clearly see how the probability distribution function changes as you change mean (that affects the horizontal position) and standard deviation (that affects the spread)."

# ╔═╡ a2c78d50-3702-11eb-17cb-bd38085cd712
md"There are many such packages. Some of them along with their usage are tabulated below."

# ╔═╡ c2893df8-3644-11eb-06ba-332f8d6ce28a
md"
Package           | Usage 
:--------------   | :---------------
Calculus.jl       | Numerical/symbolic differentiation, integration
Clustering.jl     | Clustering algorithms
Combinatorics.jl  | Combinatorics and permutation
CSV.jl            | Process csv files
DataFrames.jl     | Tabular data
Distributions.jl  | Various probability distributions
Flux.jl           | Machine learning 
GLM.jl            | Regression with generalized linear models
HypothesisTests.jl| Statistical hypothesis testing
JSON.jl           | Parse json files
KernelDensity.jl  | Estimating kernel density 
MultiVariateStats.jl | Multivariate operations - PCA, dim. reduction
Plots.jl.         | Plotting library
Random.jl         | Pseudo random number generators
Statistics.jl     | Basic statistical functions
StatsBase.jl      | Many useful functions - covariance, cdf, ...
StatsPlots.jl     | Plotting functions for statistics

"

# ╔═╡ b907691e-3702-11eb-27cc-9da4d3ba666a
md"In the following we see an example from _Algebra_ - computing roots of polynomials"

# ╔═╡ 83247b8a-3648-11eb-16a5-3f9b58acaab1
find_zeros(x->x^2 - 3x + 2, -2, 2)

# ╔═╡ c51e8688-3702-11eb-2a4f-ffed617fed4a
md"Notice how a polynomial is defined as a function with the -> notation. Also notice the notation such as `3x` without the multiplication symbol making it easy-to-read."

# ╔═╡ bc2645f8-3648-11eb-2c17-3f22b42b693b
find_zeros(x-> x^3 - 6x^2 + 11x -6, -10, 10)

# ╔═╡ ccca79e2-3648-11eb-0128-2f759f3fcfc6
begin
	plot(x->x, x-> x^3 - 6x^2 + 11x -6, 0, 4, legend=false)
	scatter!([(1, 0), (2, 0), (3, 0)],label="Some points")
end

# ╔═╡ debcc332-3704-11eb-11fd-67ed82871b22
md"Notice the ! after the function call for `scatter`. This is not a syntactic feature, but a convention. Whenever we want the arguments of a function to change, we have a trailing !. In this case, we want the same plot to be changed with the scatter point after the smooth curve is plotted."

# ╔═╡ 92f8a172-6a18-11eb-1b1d-6d7be8e043b4
md"👉 Write a function that has a slider to choose the degree of a polynomial, then pick up a random polynomial of that degree, then find the roots of the polynomial, and plot both the function and its root."

# ╔═╡ d9f5ef94-3702-11eb-309c-cd3e1717ced2
md"Below is an example from _Calculus_ of differentiating a polynomial."

# ╔═╡ e3261bf0-3649-11eb-20a7-0b03df8c2193
simplify(differentiate("x^3 - 6x^2 + 11x -6", :x))

# ╔═╡ 9d00d11e-3703-11eb-2e2e-c98ad6266c07
md"The polynomial is a symbolic expression with `:` to indicate a defined symbol."

# ╔═╡ 094fa2ea-3705-11eb-3dfb-d5ca02a0a638
md"The above is an expression which can be treated like any other object. More about this in the later section on _Metaprogramming_."

# ╔═╡ 1ab4daa0-3705-11eb-1181-fd5627d1b9cd
md"Now let us look for some examples from _Probability_. In particular, we will look at sampling which is something you will encounter frequently."

# ╔═╡ f31c52f6-6a18-11eb-042e-13bd3876752b
md"👉 Can you think of a way to estimate the value of π by sampling points in a square?"

# ╔═╡ 368c2460-3705-11eb-2b7d-d1772b239e94
md"We will estimate the value of π in a very different way - by sampling points in a square."

# ╔═╡ cd97b340-36a6-11eb-0675-7d2668297002
begin
	N = 10^4
	points = [[rand(), rand()] for _ in 1:N]
	withincircle = filter((x) -> (norm(x) <= 1), points)
	outsidecircle = filter((x) -> (norm(x) > 1), points)
	pi = 4 * length(withincircle)/N
end

# ╔═╡ 2ef6296c-36a7-11eb-35dc-0b8ea3e69423
begin
	scatter(first.(withincircle), last.(withincircle), c=:green, lenged=false)
	scatter!(first.(outsidecircle), last.(outsidecircle), c=:red, legend=false, ratio=:equal)
end

# ╔═╡ 45ca015c-3705-11eb-0fb9-1b08a3214ec4
md"In the above notice the `first` and `last` functions to extract the parts of the arrays. Also notice the . between the function name and the paranthesis. This indicates that the function will be _broadcast_ across the array."

# ╔═╡ 66eddad4-3705-11eb-1853-57b0db5ec480
md"Julia's `Random` package provides a variety of pseudo random number generators like the MersenneTwister. You can read about it [here](https://en.wikipedia.org/wiki/Mersenne_Twister)."

# ╔═╡ 4d91ccb2-36fb-11eb-17cd-e31ea660f52d
begin
	rng = MersenneTwister()
	points_ = [[rand(rng), rand(rng)] for _ in 1:N]
	withincircle_ = filter((x) -> (norm(x) <= 1), points_)
	outsidecircle_ = filter((x) -> (norm(x) > 1), points_)
	pi_mersenne = 4 * length(withincircle_)/N
end

# ╔═╡ 875efa46-3705-11eb-25dd-a17766bcfe21
md"Now let us take an example from _Combinatorics_ and _Set Theory_."

# ╔═╡ 36480462-6a19-11eb-02d9-5575357b5408
md"👉 How many unique orderings are there of 3 identical mangoes and 2 identical apples?"

# ╔═╡ 526c6f40-36aa-11eb-03e4-abfb3e08d8fd
fruits = join.(unique(permutations(["🥭", "🍎", "🥭", "🍎", "🥭"])))

# ╔═╡ 3269c696-6a19-11eb-0c2c-8b786d04a6cd
length(fruits)

# ╔═╡ 92f54d56-3705-11eb-1551-b13b297fe3cc
md"In the above we create all permutations of a set of repeating objects - 3 mangoes and 2 apples."

# ╔═╡ 5dfa7fee-6a19-11eb-2b8f-abda33ae0d5d
md"👉 How many orderings of the fruits have two consecutive fruits the same?"

# ╔═╡ b8df4a8a-3705-11eb-0364-87c24b11e381
md"Let us now try to count the number of permutations where two consecutive fruits are the same - either two mangoes or two apples. We can easily see that there is only one such combination. Let us compute this using filters and set union."

# ╔═╡ 5bb0f238-36aa-11eb-0433-139c3db1fabb
twomangoes = filter(x->occursin("🥭🥭", x), fruits)

# ╔═╡ a9389302-3705-11eb-2997-892cd90da244
md"In the above we have used the `filter` function to go through an array and created a subset based on an inline defined function."

# ╔═╡ 4351768a-36ab-11eb-0685-ada1b1de38b0
twoapples = filter(x->occursin("🍎🍎", x), fruits)

# ╔═╡ dce51590-3705-11eb-18eb-e1ac6da7de0e
md"The required number is given by the `union` function."

# ╔═╡ 57481568-36ab-11eb-03a6-d58c7fc3fbb9
length(fruits) - length(union(twomangoes, twoapples))

# ╔═╡ 492a52b8-362c-11eb-2fab-adacdfd31dfd
md"#### 4. Type system"

# ╔═╡ 82541798-4d99-11eb-1b79-6b998e8635d5
md"The supported types in Julia (from Wikipedia): ![](https://upload.wikimedia.org/wikipedia/commons/thumb/4/40/Type-hierarchy-for-julia-numbers.png/1598px-Type-hierarchy-for-julia-numbers.png)"

# ╔═╡ ae9604e2-4d9e-11eb-1b24-1d76b69c85d0
md"In the above types such as `Number` are called _abstract types_ while types such as `Int128` which can be instantiated are called _concrete types_."

# ╔═╡ 44c18aec-4d9d-11eb-1f0f-8dc399fbd105
md"You can check the type of any variable with `typeof`"

# ╔═╡ 7bd88984-6a19-11eb-1a82-2f382fb53b68
begin
	my_int = 5
	typeof(my_int)
end

# ╔═╡ 1fed9e42-4da0-11eb-21f3-614f1f643e1e
supertype(supertype(Int64))

# ╔═╡ 58b72e72-3648-11eb-157f-21eff52b0395
begin
	a = join.(unique(permutations(["🥭", "🍎", "🥭", "🍎", "🥭"])))
	typeof(a)
end

# ╔═╡ 52456f80-4d9d-11eb-0393-d3e85ab1a13d
md"You can cast a variable in different types with `::`"

# ╔═╡ a5539a80-364b-11eb-3eb9-adf898663087
p::UInt8 = 10

# ╔═╡ c8f604f8-364b-11eb-331f-b3359235a49b
q::Float32 = 10

# ╔═╡ 5dd69a90-4d9d-11eb-3249-332fc7e62703
md"Why would we ever store unsigned int over float? Because integers are more efficient to store."

# ╔═╡ dc562142-364b-11eb-08d9-390513dfba48
sizeof(p)

# ╔═╡ 59fa9b8e-364c-11eb-366d-b5321a1ef0a5
sizeof(q)

# ╔═╡ 70350de8-4d9d-11eb-305e-db2f4ba26bf6
md"Julia performs a robust type inference when variables are set based on assignments"

# ╔═╡ 78ec70ba-364c-11eb-3224-a9ca9de3e190
r = p + q

# ╔═╡ 826ed218-364c-11eb-3eac-a91824f2386d
typeof(r)

# ╔═╡ 8194604e-362c-11eb-0d28-115852d51330
md"##### Multiple Dispatch"

# ╔═╡ 9a11b3fa-4d9d-11eb-388b-d90c32a3ae60
md"One of the cores ideas in Julia is support for _multiple dispatch_. A single function can be mapped to different implementations based on the types of the arguments."

# ╔═╡ c74aad66-6a19-11eb-07eb-5b6ba01a95af
md"👉 Can you think of a function which would give different outputs for different types of its arguments?"

# ╔═╡ df1e224e-4d9d-11eb-2ae9-09dd2057e1eb
md"For instance consider the function `length`"

# ╔═╡ e74c5dd2-4d9d-11eb-1c7b-9f06f3ece8cf
length("stats")

# ╔═╡ f0feb5f0-4d9d-11eb-2879-f59586069b0b
length(["stats"])

# ╔═╡ b6fa30a2-4d9d-11eb-361d-0d77cf4f8822
md"It turns out that `length` has 214 different implementations!"

# ╔═╡ 6f6811f8-364b-11eb-3df0-e50b05fb9545
methods(length)

# ╔═╡ 0a6f8a7c-4d9f-11eb-2bf6-e37347808cd1
md"While creating arrays you can specify the type."

# ╔═╡ f767a56c-6a19-11eb-219a-632073208e39
Array{Int32}(undef, 3)

# ╔═╡ 067a1b6c-4d9f-11eb-042f-811fe0d6f626
fill!(Array{String}(undef, 3), "Julia")

# ╔═╡ 1f6014a6-4d9f-11eb-3fa1-45e25c6a046b
md"When creating a function, we can specify the type of the arguments which can then be used for multiple dispatch."

# ╔═╡ 159758c4-3706-11eb-2e64-b5ea8bb045c5
md"##### User defined types"

# ╔═╡ 7c33ca24-4da1-11eb-277b-039369fcceb1
md"Julia allows users to define types - both abstract and concrete types. Let us define an abstract class of `Shape` and then define two concrete types - `Rectangle` and `Circle` with respective fields."

# ╔═╡ 0d1beeb8-4da0-11eb-1c4c-0ffc6fd6406f
abstract type Shape end

# ╔═╡ 15725a5c-4da0-11eb-2e07-c127626a5cfd
supertype(Shape)

# ╔═╡ eb62ee20-4d9f-11eb-0962-43f235f9f35f
 mutable struct Rectangle <: Shape
    width::Float32
	height::Float32
 end

# ╔═╡ ce86782a-4da0-11eb-1343-e14d1ef20dfb
supertype(Rectangle)

# ╔═╡ 5ede89d4-4da0-11eb-3299-8ff027018541
mutable struct Circle <: Shape
	radius::Float32
end

# ╔═╡ 3abb70b2-6a1a-11eb-36a4-2f8ee483f908
md"👉 How would you write a function to compute areas for these two shapes?"

# ╔═╡ 99f852da-4da1-11eb-35a4-0509d79a84db
md"Now if we want to write a function for calculating the area, clearly depeding on the type of the object, the formula is different. This can be conveniently handled with _multiple dispatch_"

# ╔═╡ 39b3adae-4d9f-11eb-1518-bd8184027473
function Area(r::Rectangle)
	return r.width * r.height
end

# ╔═╡ 945659ea-4da0-11eb-07b2-f325478a2d44
function Area(c::Circle)
	return π * c.radius * c.radius
end

# ╔═╡ 4be539f6-6a1a-11eb-2b7f-0787e70768f5
md"👉 How would you write a function to find the bigger of two shapes?"

# ╔═╡ af17fd94-4da1-11eb-2100-491143085e3f
md"We can also define functions with the abstract type for instance when comparing the size of two shapes."

# ╔═╡ ab4c588e-4da0-11eb-0283-999e1f5d527e
function Bigger(s1::Shape, s2::Shape)
	return Area(s1) >= Area(s2)
end

# ╔═╡ c9801a40-4da0-11eb-0b3b-a9eecc3c6d54
begin
	rect = Rectangle(4, 6)
	cir  = Circle(3) 
end

# ╔═╡ 1936a208-4da1-11eb-1e3f-31dd2ee22383
Bigger(rect, cir)

# ╔═╡ 19dab5fc-36a9-11eb-1b9e-4f43678437aa
md"#### 5. Calling Python from Julia is easy"

# ╔═╡ 560a20a8-4da1-11eb-1435-25671564c45e
md"Julia allows Python and R code to be directly imported. Further it allows the objects to be shared across Python and Julia."

# ╔═╡ 705c0d40-4da1-11eb-1da5-41685ce95eb4
md"We will create an array using the popular `numpy` library"

# ╔═╡ 27817c72-36a9-11eb-0d55-fbee89a6cfc3
np = pyimport("numpy")

# ╔═╡ 615af52c-36a9-11eb-2c16-6578895d238f
I4 = np.eye(4)

# ╔═╡ 86feacba-36a9-11eb-1eb6-2bbbe94602e3
typeof(I4)

# ╔═╡ a0a2edc8-36a9-11eb-04a1-3d72944d26aa
np.size(I4)

# ╔═╡ 204cdc8c-3706-11eb-1a66-e5d6c3629f42
md"#### 6. Metaprogramming"

# ╔═╡ 3c72fe04-4da2-11eb-03e2-59439ff087a3
md"Julia supports _metaprogramming_, i.e., you can write Julia code to manipulate Julia code. You can modify other parts of the source code, and even control if and when the modified code runs. Under the hood, this works because there are two stages to a Julia program's execution - first the code is parsed and converted into an _abstract syntax tree_ and then it is executed. Metaprogramming allows to intercept between these two stages and modify the source code and control its execution."

# ╔═╡ aa2e61c0-4da2-11eb-2cf4-91d7aeab3676
md"We have already used metaprogramming in this notebook when we used the `which` macro."

# ╔═╡ c464e2b2-4da2-11eb-2ff8-6b23c23bec48
@which sqrt(4.0)

# ╔═╡ d4e41496-4da2-11eb-2a78-e160b10ae7a8
md"Here the macro intercepts the execution of the statement and instead of running it simply returns the function which was called."

# ╔═╡ fee37ea0-4da2-11eb-32b1-3bbacc4b83ff
md"We can do metaprogramming at the user end also, and for this we need to define a statement which has been parsed but is yet to be executed."

# ╔═╡ e935a7d0-4da3-11eb-37f7-bb33c6ff1fa6
begin
	myexp = "15/3"
	Meta.parse(myexp)
end

# ╔═╡ 8a20899c-4da4-11eb-07ab-977dbf341978
md"The `:` operator indicates that the following is a parsed expression which can then be modified like any string and then executed with `eval`."

# ╔═╡ 5ce74e00-4da4-11eb-04f6-ddadff53075e
eval(Meta.parse(myexp))

# ╔═╡ 946e19b8-6a1a-11eb-1e69-0546f2d9afd9
md"👉 Write a macro which can check if the expression is illegal (eg. divided by 0) and execute only if the expression is legal."

# ╔═╡ a7903784-4da4-11eb-0d04-47177d9d64d1
md"But the key point is that we could programmatically change `myexp` before evaluating it."

# ╔═╡ c2f631a4-4da4-11eb-3faa-25e956990d8a
begin
	if occursin("/0", myexp)
		md"❌ We are not allowed to divide by 0." 
	else
		eval(Meta.parse(myexp))
	end
end

# ╔═╡ 3a8684c6-4da5-11eb-03dd-1589d1285ac9
md"With this we are able to intercept and change the result without touching the underlying implementation of 0"

# ╔═╡ 571e4fb0-4da5-11eb-0625-37b5c96291ac
md"Expressions are also used natively for some packages, for instance for differentiation of symbolic expressions."

# ╔═╡ 7a8d3970-4da5-11eb-356d-511baaddd42a
formula = "x^3 - 6x^2 + 11x -6"

# ╔═╡ 63af6e94-4da5-11eb-2921-39cc7673ff45
typeof(differentiate(formula, :x))

# ╔═╡ 97f4d87e-4da5-11eb-1078-8f9a021a01d2
differentiate(formula, :x)

# ╔═╡ a203ce10-4da5-11eb-1490-c73b6fed97d2
md"The result of application of differentiation is also an expression which can then we forwarded to another function which takes an express - `simplify`."

# ╔═╡ c092a856-4da5-11eb-391a-8bc0301a2e29
simplify(differentiate(formula, :x))

# ╔═╡ d859f8ae-4da5-11eb-3e00-c79cecfb198c
md"If we want to compute the value of the expression based on the set value of `x`, then we use the `eval` command."

# ╔═╡ 760d74aa-4da5-11eb-0daa-b774ca6f3824
eval(differentiate(formula, :x))

# ╔═╡ 291915fc-6955-11eb-2590-857e9abc4c3a
hint(text, title) = Markdown.MD(Markdown.Admonition("hint", title, [text]))

# ╔═╡ 2dfe3660-6955-11eb-3856-05b77ebe047b
hint(md"
	- Serial interpretation of instructions
	- No built in methods for parallelism
	- Weak typing system
	- No advanced programming features such as metaprogramming
	", "Disadvantages of Python")

# ╔═╡ Cell order:
# ╟─1246fbea-3620-11eb-324c-1d4299044df9
# ╟─b71b0e7e-3628-11eb-1713-092a8f0e6499
# ╟─2dfe3660-6955-11eb-3856-05b77ebe047b
# ╟─13b1268a-362b-11eb-1fb0-fbd74c2c80e5
# ╟─3826299e-3631-11eb-0602-4396f3b0375b
# ╟─f90cf21c-3631-11eb-1db7-43e0d3eca3b6
# ╠═2678c03c-362d-11eb-1e35-b1a65fafe477
# ╟─7db9d46c-362d-11eb-17de-0be78e78aafb
# ╟─1c73ef50-3630-11eb-230c-2d44d12e4c64
# ╟─8934782c-6956-11eb-09f4-a5fb501e3b40
# ╟─1a3facd0-3631-11eb-06aa-410a6683a192
# ╟─6f779994-36fc-11eb-1138-3d665ffea83b
# ╠═3bdc4b1c-3644-11eb-04c8-b58a599801e0
# ╟─36b9a48a-3776-11eb-1c3c-455b531f4e81
# ╟─a639c37a-36fc-11eb-03a0-ad3ff5fbe073
# ╠═83f86052-363f-11eb-23ac-6fc284636634
# ╟─38cb6ee8-3640-11eb-2b0b-4b46f7a4331b
# ╟─e0d53d14-36fc-11eb-1712-312176bb50be
# ╟─4d01b08e-3776-11eb-0f66-879f1077f72c
# ╟─4e80c0d6-3633-11eb-3b70-5bba9910d0ab
# ╟─f30f27a4-36fc-11eb-114f-73c46189b2a2
# ╟─60f92516-3700-11eb-0c8e-eb6bdfa9d700
# ╠═3375e884-36fd-11eb-05cc-61cecdc3f25a
# ╠═4838e1cc-36fd-11eb-2252-6dc30614dca7
# ╟─cede9b4e-3703-11eb-1032-3b126bef79a6
# ╟─27caddb4-36fd-11eb-249b-d53ac54d5bb3
# ╠═0cff395e-3634-11eb-038c-7382a21e61f9
# ╠═59fdc9a0-3634-11eb-3220-e37bc5f1a21a
# ╟─a2441cee-3700-11eb-359b-fbafc3fd80b7
# ╠═5734e1e6-3633-11eb-3c57-d147f8440e90
# ╟─8c85386c-3635-11eb-220d-75fc262637c9
# ╟─e028d978-3700-11eb-0761-21d79fa8c3e4
# ╠═e9498332-3635-11eb-144e-9317d798a852
# ╟─fd9e0792-3700-11eb-2c26-21ecd07186f4
# ╠═5d380a9e-3635-11eb-0971-b5ab98d71d30
# ╠═6eaaa3ac-3635-11eb-1dd2-5bb9f61d5ec5
# ╟─1c9f1b98-3703-11eb-3a07-1ff6e27dfa88
# ╠═ffee87a4-3635-11eb-259a-e552b2eddb16
# ╟─c389d9fe-363b-11eb-0f69-9bd72252bb4d
# ╠═e46a9378-363b-11eb-2de3-392328463c96
# ╟─ddd34708-3776-11eb-256f-6385b9c1be4e
# ╟─ee223de4-3776-11eb-3502-c9069ffb6e03
# ╠═df1af070-363b-11eb-11c7-21721a710d42
# ╟─2e9bd7fe-3701-11eb-185d-255d69d9ca73
# ╠═12dcd77c-36b2-11eb-2edb-23474d30667e
# ╟─3f838d3c-3701-11eb-3a47-1143a598b863
# ╠═dd7b1b20-36b1-11eb-2a3c-65a767b0afa2
# ╠═b919e9be-36b6-11eb-0636-6570c66ddfcc
# ╠═1961d638-36b2-11eb-1710-854a0d4cee29
# ╟─14721fb6-3702-11eb-0cf0-15d871f5fb1c
# ╠═3ece5f9a-36b2-11eb-1eaf-63668f42ee83
# ╟─3cdbc9a0-3777-11eb-1b20-b1e23cc647de
# ╟─70b285ee-363b-11eb-15d9-5721055a405f
# ╟─453fe312-3702-11eb-00f3-e119b46c7dae
# ╟─57b76696-3702-11eb-3824-c32de45a9755
# ╠═f53acdf2-363c-11eb-338d-eda9aae08443
# ╟─768e5d4a-3702-11eb-339b-6dff178c893f
# ╟─224999bc-363e-11eb-3ecb-ff5e7d48e97f
# ╠═49cb6552-363d-11eb-1c02-9552cda30cc8
# ╟─8daef890-3702-11eb-0ef6-67637c7004e5
# ╟─a2c78d50-3702-11eb-17cb-bd38085cd712
# ╟─c2893df8-3644-11eb-06ba-332f8d6ce28a
# ╟─b907691e-3702-11eb-27cc-9da4d3ba666a
# ╠═7fc34796-3648-11eb-244d-fbec5ad621b1
# ╠═83247b8a-3648-11eb-16a5-3f9b58acaab1
# ╟─c51e8688-3702-11eb-2a4f-ffed617fed4a
# ╠═bc2645f8-3648-11eb-2c17-3f22b42b693b
# ╠═ccca79e2-3648-11eb-0128-2f759f3fcfc6
# ╟─debcc332-3704-11eb-11fd-67ed82871b22
# ╟─92f8a172-6a18-11eb-1b1d-6d7be8e043b4
# ╟─d9f5ef94-3702-11eb-309c-cd3e1717ced2
# ╠═ddee4202-3649-11eb-1198-236bf1d0d262
# ╠═e3261bf0-3649-11eb-20a7-0b03df8c2193
# ╟─9d00d11e-3703-11eb-2e2e-c98ad6266c07
# ╟─094fa2ea-3705-11eb-3dfb-d5ca02a0a638
# ╟─1ab4daa0-3705-11eb-1181-fd5627d1b9cd
# ╠═ae0486aa-36a6-11eb-30b9-8f03e178de69
# ╟─f31c52f6-6a18-11eb-042e-13bd3876752b
# ╟─368c2460-3705-11eb-2b7d-d1772b239e94
# ╠═cd97b340-36a6-11eb-0675-7d2668297002
# ╠═2ef6296c-36a7-11eb-35dc-0b8ea3e69423
# ╟─45ca015c-3705-11eb-0fb9-1b08a3214ec4
# ╟─66eddad4-3705-11eb-1853-57b0db5ec480
# ╠═4d91ccb2-36fb-11eb-17cd-e31ea660f52d
# ╟─875efa46-3705-11eb-25dd-a17766bcfe21
# ╠═790c383c-3647-11eb-2d7e-5d502338d789
# ╟─36480462-6a19-11eb-02d9-5575357b5408
# ╠═526c6f40-36aa-11eb-03e4-abfb3e08d8fd
# ╠═3269c696-6a19-11eb-0c2c-8b786d04a6cd
# ╟─92f54d56-3705-11eb-1551-b13b297fe3cc
# ╟─5dfa7fee-6a19-11eb-2b8f-abda33ae0d5d
# ╟─b8df4a8a-3705-11eb-0364-87c24b11e381
# ╠═5bb0f238-36aa-11eb-0433-139c3db1fabb
# ╟─a9389302-3705-11eb-2997-892cd90da244
# ╠═4351768a-36ab-11eb-0685-ada1b1de38b0
# ╟─dce51590-3705-11eb-18eb-e1ac6da7de0e
# ╠═57481568-36ab-11eb-03a6-d58c7fc3fbb9
# ╟─492a52b8-362c-11eb-2fab-adacdfd31dfd
# ╟─82541798-4d99-11eb-1b79-6b998e8635d5
# ╟─ae9604e2-4d9e-11eb-1b24-1d76b69c85d0
# ╟─44c18aec-4d9d-11eb-1f0f-8dc399fbd105
# ╠═7bd88984-6a19-11eb-1a82-2f382fb53b68
# ╠═1fed9e42-4da0-11eb-21f3-614f1f643e1e
# ╠═58b72e72-3648-11eb-157f-21eff52b0395
# ╟─52456f80-4d9d-11eb-0393-d3e85ab1a13d
# ╠═a5539a80-364b-11eb-3eb9-adf898663087
# ╠═c8f604f8-364b-11eb-331f-b3359235a49b
# ╟─5dd69a90-4d9d-11eb-3249-332fc7e62703
# ╠═dc562142-364b-11eb-08d9-390513dfba48
# ╠═59fa9b8e-364c-11eb-366d-b5321a1ef0a5
# ╟─70350de8-4d9d-11eb-305e-db2f4ba26bf6
# ╠═78ec70ba-364c-11eb-3224-a9ca9de3e190
# ╠═826ed218-364c-11eb-3eac-a91824f2386d
# ╟─8194604e-362c-11eb-0d28-115852d51330
# ╟─9a11b3fa-4d9d-11eb-388b-d90c32a3ae60
# ╟─c74aad66-6a19-11eb-07eb-5b6ba01a95af
# ╟─df1e224e-4d9d-11eb-2ae9-09dd2057e1eb
# ╠═e74c5dd2-4d9d-11eb-1c7b-9f06f3ece8cf
# ╠═f0feb5f0-4d9d-11eb-2879-f59586069b0b
# ╟─b6fa30a2-4d9d-11eb-361d-0d77cf4f8822
# ╠═6f6811f8-364b-11eb-3df0-e50b05fb9545
# ╟─0a6f8a7c-4d9f-11eb-2bf6-e37347808cd1
# ╠═f767a56c-6a19-11eb-219a-632073208e39
# ╠═067a1b6c-4d9f-11eb-042f-811fe0d6f626
# ╟─1f6014a6-4d9f-11eb-3fa1-45e25c6a046b
# ╟─159758c4-3706-11eb-2e64-b5ea8bb045c5
# ╟─7c33ca24-4da1-11eb-277b-039369fcceb1
# ╠═0d1beeb8-4da0-11eb-1c4c-0ffc6fd6406f
# ╠═15725a5c-4da0-11eb-2e07-c127626a5cfd
# ╠═eb62ee20-4d9f-11eb-0962-43f235f9f35f
# ╠═ce86782a-4da0-11eb-1343-e14d1ef20dfb
# ╠═5ede89d4-4da0-11eb-3299-8ff027018541
# ╟─3abb70b2-6a1a-11eb-36a4-2f8ee483f908
# ╟─99f852da-4da1-11eb-35a4-0509d79a84db
# ╠═39b3adae-4d9f-11eb-1518-bd8184027473
# ╠═945659ea-4da0-11eb-07b2-f325478a2d44
# ╟─4be539f6-6a1a-11eb-2b7f-0787e70768f5
# ╟─af17fd94-4da1-11eb-2100-491143085e3f
# ╠═ab4c588e-4da0-11eb-0283-999e1f5d527e
# ╠═c9801a40-4da0-11eb-0b3b-a9eecc3c6d54
# ╠═1936a208-4da1-11eb-1e3f-31dd2ee22383
# ╟─19dab5fc-36a9-11eb-1b9e-4f43678437aa
# ╟─560a20a8-4da1-11eb-1435-25671564c45e
# ╠═222e6098-36a9-11eb-12f9-dbb9552d0768
# ╟─705c0d40-4da1-11eb-1da5-41685ce95eb4
# ╠═27817c72-36a9-11eb-0d55-fbee89a6cfc3
# ╠═615af52c-36a9-11eb-2c16-6578895d238f
# ╠═86feacba-36a9-11eb-1eb6-2bbbe94602e3
# ╠═a0a2edc8-36a9-11eb-04a1-3d72944d26aa
# ╟─204cdc8c-3706-11eb-1a66-e5d6c3629f42
# ╟─3c72fe04-4da2-11eb-03e2-59439ff087a3
# ╟─aa2e61c0-4da2-11eb-2cf4-91d7aeab3676
# ╠═c464e2b2-4da2-11eb-2ff8-6b23c23bec48
# ╟─d4e41496-4da2-11eb-2a78-e160b10ae7a8
# ╟─fee37ea0-4da2-11eb-32b1-3bbacc4b83ff
# ╠═e935a7d0-4da3-11eb-37f7-bb33c6ff1fa6
# ╟─8a20899c-4da4-11eb-07ab-977dbf341978
# ╠═5ce74e00-4da4-11eb-04f6-ddadff53075e
# ╟─946e19b8-6a1a-11eb-1e69-0546f2d9afd9
# ╟─a7903784-4da4-11eb-0d04-47177d9d64d1
# ╠═c2f631a4-4da4-11eb-3faa-25e956990d8a
# ╟─3a8684c6-4da5-11eb-03dd-1589d1285ac9
# ╟─571e4fb0-4da5-11eb-0625-37b5c96291ac
# ╠═7a8d3970-4da5-11eb-356d-511baaddd42a
# ╠═63af6e94-4da5-11eb-2921-39cc7673ff45
# ╠═97f4d87e-4da5-11eb-1078-8f9a021a01d2
# ╟─a203ce10-4da5-11eb-1490-c73b6fed97d2
# ╠═c092a856-4da5-11eb-391a-8bc0301a2e29
# ╟─d859f8ae-4da5-11eb-3e00-c79cecfb198c
# ╠═760d74aa-4da5-11eb-0daa-b774ca6f3824
# ╠═291915fc-6955-11eb-2590-857e9abc4c3a

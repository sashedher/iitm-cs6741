### A Pluto.jl notebook ###
# v0.12.21

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

# ╔═╡ def88812-6b99-11eb-07fb-3f961d7ff6ae
begin
	using Plots
	plotly()
end

# ╔═╡ c3fd3b6c-6c33-11eb-3efe-57b3d5456387
using PlutoUI

# ╔═╡ 4d3dc5da-6c3f-11eb-39c5-d353a499f63e
using FreqTables

# ╔═╡ 25f0811c-6d10-11eb-371f-65bee7df5f92
using StatsBase

# ╔═╡ 707365d6-6d12-11eb-1f15-0d9e9f7d9bca
using RDatasets

# ╔═╡ 6ea9cca2-6f44-11eb-1989-8dd7210c8793
 using StatsPlots

# ╔═╡ 9721600c-6d35-11eb-3eb7-455d9dcaae62
using Distributions

# ╔═╡ 22f18e82-6b7d-11eb-16eb-31758abdb1b0
md"# Notebook 4: _Measures of Central Tendency_
"


# ╔═╡ 0b11d70c-7b42-11eb-011c-63491c857100
md"
> 📕Reference material - Chapter 3: Using statistics to summarise data (Sections 3.1 - 3.3) from Sheldon Ross.
"

# ╔═╡ 1b5aa56c-6b93-11eb-0e91-8b977b72a959
md"Recall the definitions of the following four technical terms: 
* Population
* Sample
* Parameter
* Statistic
"

# ╔═╡ 440d2000-6c30-11eb-3ab0-815035cd1461
md"Some notations: 

| Symbol      | Description |
| ----------- | ----------- |
| $X$         | Set of population elements       |
| $N$         | Size of $X$        |
| $\{X_1, X_2, \ldots, X_N\}$         | Set of elements of $X$        |
| $x$         | Set of sample elements       |
| $n$         | Size of $x$, usually $n \ll N$        |
| $\{x_1, x_2, \ldots, x_n\}$         | Set of elements of $x$        |
"

# ╔═╡ d749c66c-6c2f-11eb-3e18-331186a54c43
md"## Mean"

# ╔═╡ 225552fe-6b93-11eb-017e-d550345b26b3
md"
| Symbol      | Description |
| ----------- | ----------- |
| $\overline{x}$         | Sample mean (statistic)     |
| $\mu$         | Population mean (parameter)      |
"

# ╔═╡ 1c04e566-6c30-11eb-23b3-e70052973245
md"Sample and population mean are defined as follows
```math
\mu = \dfrac{X_1 + X_2 + \ldots + X_N}{N}
```
```math
\overline{x} = \dfrac{x_1 + x_2 + \ldots + x_n}{n}
```
"

# ╔═╡ d204c1aa-6c31-11eb-3938-7d7091a78977
x = [rand(1:10) for _ in 1:10]

# ╔═╡ df3c4280-6c31-11eb-2703-f15ce473464d
xbar = sum(x)/length(x)

# ╔═╡ 52b32ee2-6c3f-11eb-354a-7d2d1a7e5291
mean_(arr) = sum(arr)/length(arr)

# ╔═╡ 6a1be22e-6c3d-11eb-230b-e71c24f4ebd7
md"Notice that the mean need not be an element in the set, but it is always within the range defined by the minimum and maximum elements."

# ╔═╡ ebacc7c4-6c31-11eb-2565-3d57fe04886c
md"👉 What is function of the sample values and the mean which is always 0?"

# ╔═╡ f1ee68cc-6c31-11eb-05b8-95007ebd2fb6
xdiff = x .- xbar

# ╔═╡ 0196fadc-6c32-11eb-3aa2-f1f9b35307d0
sum(xdiff)

# ╔═╡ 1cca41da-6c32-11eb-199d-e78dc429b1f2
md"
```math
\dfrac{x_1 + x_2 + \ldots + x_n}{n} = \overline{x}
```
```math
\Rightarrow \dfrac{x_1 + x_2 + \ldots + x_n}{n} - \overline{x} = 0
```
```math
\Rightarrow \dfrac{(x_1 - \overline{x}) + (x_2 - \overline{x}) + \ldots + (x_n - \overline{x})}{n} = 0
```
```math
\Rightarrow (x_1 - \overline{x}) + (x_2 - \overline{x}) + \ldots + (x_n - \overline{x}) = 0
```
"

# ╔═╡ dabfee6c-6c33-11eb-3e35-f3451eeb02ee
md"👉 What function is minimized by the mean for all $x$?"

# ╔═╡ f39953a6-6c33-11eb-1b51-9bb706ca5e66
md"
```math
f(u) = \sum_{i = 1}^n (x_i - u)^2
```
Where is $f(u)$ minimised?
"

# ╔═╡ 38e30b6e-6c34-11eb-3929-0750f343eaea
md"
```math
\dfrac{df(u)}{du} = 0 \Rightarrow \sum_{i = 1}^n (x_i - u) = 0
```
We know that the above is true for $u = \overline{x}$. Is this enough?. 
"

# ╔═╡ ee4de40c-78e7-11eb-15b6-555c9f3ec939
md"Also the second derivative is positive, so $\overline{x}$ is a local minimum."

# ╔═╡ a38fa86e-6c34-11eb-24e2-1d82988794fa
f(u::Number) = sum((x .- u).^2)

# ╔═╡ 8e6197e2-6c34-11eb-1332-b362b460af4c
begin
	plot(f, -10, 20) 	
	scatter!([xbar], [f(xbar)])
end

# ╔═╡ d04c1f7a-7a96-11eb-3234-739cdb925775
xx = [3, 5, 7]

# ╔═╡ f0672f7a-7a96-11eb-37e6-1f985ab4e892
(xx .- 6).^2

# ╔═╡ 1b6f24d2-6b94-11eb-123c-ed64a991fe31
md"👉 Can you relate the statistic of mean to the idea of _center of gravity_"

# ╔═╡ b8a74462-78e8-11eb-0bb1-631a6d7d90c0
md"
Recall that
```math
(x_1 - \overline{x}) + (x_2 - \overline{x}) + \ldots + (x_n - \overline{x}) = 0
```
"

# ╔═╡ 8fcc9386-78e7-11eb-32e0-ab481d8c45d2
md"One way to think about this: If we sum of deviations to the _right_ of the mean are equal to the sum of the deviations to the _left_ of the mean."

# ╔═╡ c93f284e-78e8-11eb-2b16-f7a86f3bf208
md"This is essentially the idea of center of gravity - we try to balance the influence of the left and right sides at the center."

# ╔═╡ 77f19cd8-78e8-11eb-23dd-29e619d44b70
md"👉 Do you recall how you used center of gravity in physics?"

# ╔═╡ dbb17100-78e8-11eb-0edb-ff57255459fb
md"👉 How can we visualise this?"

# ╔═╡ 3b5ffd52-6b99-11eb-0fac-237620f8da54
my_arr = rand(1:10, 30)

# ╔═╡ 660a7e4c-6c3e-11eb-11b0-35e7a99412f8
histogram(my_arr, nbins=10)

# ╔═╡ f093012c-78e8-11eb-0d0f-a1e09c915d48
md"Let us propose a center point of our own"

# ╔═╡ 46cb5fd8-6b99-11eb-0c1e-c30c44ae96aa
center_point = 5

# ╔═╡ 672b8780-6b99-11eb-0c28-21308cce4514
begin
	left_arr = filter(x->x<center_point, my_arr)
	right_arr = filter(x->x>=center_point, my_arr)
end

# ╔═╡ ddbeb07a-6b99-11eb-31b2-85ce3bdaa4ea
begin
	histogram(left_arr, nbins=center_point-1)
	histogram!(right_arr, nbins=10-center_point+1)
end

# ╔═╡ 42da2d98-78e9-11eb-34ca-3d05f72cf17e
md"👉 What are we trying to equate on either side of the center point?"

# ╔═╡ 749b96bc-78e9-11eb-1663-ed96af6d5996
md"The following example clarifies this."

# ╔═╡ 5a251b4e-6d23-11eb-1c68-217a9476f74c
two_arrs = [[1, 2, 3, 4, 5], [1, 2, 3, 4, 5]]

# ╔═╡ 187a4d92-6d24-11eb-206e-c3a7c7c873ca
two_arrs_2 = [[6, 7, 8, 9, 10], [ 6, 10, 10, 10, 10]]

# ╔═╡ 78989108-6d23-11eb-3787-c59945578cf2
begin
	histogram(two_arrs, nbins=5, ylims = (0,5), layout=2, legend=false)
	histogram!(two_arrs_2, nbins=5, ylims = (0,5), layout=2, legend=false)
end

# ╔═╡ e9a02bf4-6d23-11eb-2c2f-6fcae7fd2aa7
md"If we set the fulcrum at the middle, the left plot would be balanced while the right one will flip over. Notice that this is the case even though the total height of the bars in both sides would be the same."

# ╔═╡ f88c4782-6c3e-11eb-3d64-4552eb6761f2
md"Homework: Formally argue why the center of gravity of the histogram is balanced at the mean."

# ╔═╡ 7b5bd854-6c3e-11eb-06e3-450d384cd600
md"👉 How would we compute the mean if we were given the histogram (or a frequency table) instead of the raw data?"

# ╔═╡ 9b533210-6c3e-11eb-289f-1d596f411218
md"
Given a sample $x$ where element $x_i$ occurs $f_i$ times, then the mean is given as 
```math
\bar{x} = \dfrac{f_1 x_1 + f_2 x_2 + \ldots + f_n x_n}{f_1 + f_2 + \ldots + f_n}
```
"

# ╔═╡ 804204b4-6c3f-11eb-377f-370255565c19
my_arr_f = freqtable(my_arr)

# ╔═╡ c68e21a0-6c3f-11eb-2a79-7d3af89d0503
my_arr_x = names(my_arr_f)

# ╔═╡ 5802e738-6c40-11eb-28fc-0bd60ce7e38b
my_arr_f[1]

# ╔═╡ 8dffa5a2-6c3f-11eb-30ce-198e6a131fad
mean_(x, f) = sum(x .* f)/sum(f)

# ╔═╡ 5b56593e-6c3f-11eb-1002-bb10adc3a3ea
mean_(xbar)

# ╔═╡ ddce578a-7a96-11eb-1fb3-0f7ca6f804a1
mean_(xx)

# ╔═╡ e492761e-7a96-11eb-0214-89cd9c65e1cf
(xx .- mean_(xx)).^2

# ╔═╡ e164f49a-6c3d-11eb-1921-f56ba8083c92
mean_(my_arr)

# ╔═╡ 29029830-6c3f-11eb-15bd-9fabf4081608
md"👉 What is the effect of shifting each element of the sample equally on its mean?"

# ╔═╡ a208f46a-6c47-11eb-133d-95c61d2c04a4
[mean_(x .+ 1), mean_(x) + 1]

# ╔═╡ b194184c-6c47-11eb-0530-a503572f5e24
md"👉 What is the effect of scaling the sample on its mean?"

# ╔═╡ c7007f02-6c47-11eb-22ab-c156f20c699d
[mean_(x .* 2), mean_(x) * 2]

# ╔═╡ 2ef26ae6-6c48-11eb-187c-c36df7ea51be
md"Thus, the mean operation is associative with linear scaling and shifting operations"

# ╔═╡ 4aec18fa-6c48-11eb-355e-83df0f5de2eb
md"👉 What is the effect of outliers on mean?"

# ╔═╡ 576bf2bc-6c48-11eb-1616-9f97094629f6
x

# ╔═╡ 62f851b6-6c48-11eb-1cb7-379ba1523bdd
[mean_(x), mean_(append!(copy(x), 1000))]

# ╔═╡ ca14eb98-6c48-11eb-1860-1bcde00a3030
md"In the above, we are losing the _information_ contained in the 10 numbers due to a single outlier."

# ╔═╡ 8eb13c4c-6f6c-11eb-2f06-53f6df491758
md"Below is the dataset showing the income of elderly men and women obtained from their pension.Due to outliers the mean is around 200 although most of the people seem to get around 100."

# ╔═╡ 1fa3e678-6f68-11eb-1c75-59d5d15fc6ed
begin
	pension = dataset("robustbase","pension")
	histogram(pension.Income, nbins=20, normalize=:pdf, label = "income")
end

# ╔═╡ f2a528a8-791c-11eb-2fda-67379adec64d
mean(pension.Income)

# ╔═╡ 0b42ae2c-6c49-11eb-341a-db2069fc5b7c
md"##### Geometric mean"

# ╔═╡ 10073b9c-6c49-11eb-0afa-158264e5a1dc
md"In some cases, we look for other kinds of mean. You may have already read about the geometric mean. 👉 When does geometric mean make sense?"

# ╔═╡ 37233ef6-6c49-11eb-3ed0-dfc5bfbb5de7
md"For example, consider I invested Rs 100 in a mutual fund for 3 years and the interest rates were varying. First year was 6%, next year was 40% and the third year was 1%. What is my _average_ rate of return?"

# ╔═╡ a6da9082-6c49-11eb-1635-bb52376c1865
md"👉 What is the final amount I can withdraw?"

# ╔═╡ b69494dc-6c49-11eb-1b13-83c128802b1a
rates = [1.06, 1.40, 1.01]

# ╔═╡ 59dbc152-6c49-11eb-3a0f-418e76abeefc
final_amount = (((100 * rates[1]) * rates[2]) * rates[3])

# ╔═╡ 310ca022-6c4c-11eb-31e5-e7428eb61d81
md"👉 This final amount is equivalent to the return with what constant rate through the three years?"

# ╔═╡ 7c156944-6c49-11eb-362f-a92094dda231
(final_amount/100)^(1/3)

# ╔═╡ b99e332a-78eb-11eb-0556-0d06b06ce695
md"We would get this one wrong if we used the arithmetic mean we saw earlier."

# ╔═╡ 862d6a76-6c49-11eb-0b22-292e0c58d1be
mean_(rates)

# ╔═╡ c402f47a-78eb-11eb-26d9-dd3651a134f8
md"Instead we use the geometric mean."

# ╔═╡ a225267e-6c49-11eb-0ec0-2d15c0ddf5b6
(rates[1] * rates[2] * rates[3])^(1/3)

# ╔═╡ b077db76-6c4a-11eb-1501-4b9b5fa8f56d
geometric_mean(arr) = prod(arr)^(1/length(arr))

# ╔═╡ ab9a00f4-6c4d-11eb-1f88-9784f40861ee
md"Geometric mean is given as
```math
\overline{x}_g = \sqrt[n]{x_1 x_2 \ldots x_n}
```
"

# ╔═╡ d7ccc4ae-6c4a-11eb-087d-43836d31ca6d
geometric_mean(rates)

# ╔═╡ 2364602a-78ec-11eb-1738-732e82767cbc
md"Here are the annual returns from NIFTY 50 for 21 years."

# ╔═╡ 0def3004-6f47-11eb-1d6c-3d34d7c4865b
nifty_50_annual_returns = [-14.65,-16.18,3.25,71.90,10.68,36.34,39.83,54.77,-51.79,75.76,17.95,-24.62,27.70,6.76,31.39,-4.06,3.01,28.65,3.15,12.02,14.17]

# ╔═╡ 2126f412-78ec-11eb-2ce3-2fd4965f5134
md"👉 How do we deal with the negative returns?"

# ╔═╡ 603666ea-6f75-11eb-23b0-2d08e15d2a72
increase_rates = (nifty_50_annual_returns .+ 100)

# ╔═╡ 40255ac6-6f75-11eb-2399-f5f5bb5ed4d1
geometric_mean(increase_rates)

# ╔═╡ 46b041ac-78ec-11eb-3912-1501e6e49430
md"We have an annual increase of 11.2% in NIFTY 50 across 21 years!"

# ╔═╡ 59adfbd6-78ed-11eb-12f6-153fe6d552bc
md"Notice an interesting thing about the geometric mean. Say we have two years and returns $r_1$ and $r_2$ for the two years."

# ╔═╡ 735cedbc-78ed-11eb-1c2e-4fcf73e7a2da
md"If the first year has a return of 5% and the second year a return of -5%, my yield is:"

# ╔═╡ 883e8e7c-78ed-11eb-0228-11e738abf8ea
out_1 = (100 * (1 + 0.05)) * (1 - 0.05)

# ╔═╡ 917dfb92-78ed-11eb-20be-1b3275defa1d
md"If the first year has a return of -5% and the second year a return of 5%, my yield is still the same:"

# ╔═╡ 9bd4d4d0-78ed-11eb-2806-5d3482ed2c80
out_2 = (100 * (1 - 0.05) * (1 + 0.05))

# ╔═╡ cfa38fd6-78ed-11eb-16a7-13626f707283
md"Though my arithmetic mean of returns is 0, my net return is negative. This is a specific instance of a more generic rule that says $AM \geq GM$"

# ╔═╡ 63b453bc-78ef-11eb-1c6a-dd2344f64cd8
md"Homework: Show this inequality for samples of size 2"

# ╔═╡ 088fa5c0-78ec-11eb-3ea1-1b8342d40e7c
md"Homework: What is the effect of scaling and offset on the geometric mean?"

# ╔═╡ d6ffe7be-6c4c-11eb-3571-9d32cf692019
md"#### Harmonic mean"

# ╔═╡ dc1a437c-6c4c-11eb-0604-9bbe5e73ed8f
md"👉 When do we use harmonic mean?"

# ╔═╡ e4580766-6c4c-11eb-1eb3-61e8e8efb7ea
md"Suppose I ran for 30 minutes. In the first 10 minutes I ran at a speed of 10 km/h, next 10 mins I ran at a speed of 8 km/h and the last 10 mins at 9km/h. What is my average speed?"

# ╔═╡ 078e1c7a-6c4d-11eb-2949-b3bf97ff3418
md"In this case, it is simply the arithmetic mean of the speeds in the three 10 min periods."

# ╔═╡ 12d04fcc-6c4d-11eb-0414-8f92c41ab299
speeds = [10, 8, 9]

# ╔═╡ 1e5415b8-6c4d-11eb-3a1c-31c66ab50739
total_distance = sum(speeds .* 10/60)

# ╔═╡ 28d2c41c-6c4d-11eb-0a2c-a3675f6c3160
average_speed = total_distance * 60/30

# ╔═╡ 8aff96fc-78ef-11eb-0557-8124a8a6979b
md"Computing the arithmetic mean captures this average speed"

# ╔═╡ 17be119a-6c4d-11eb-0089-21c620182831
mean_(speeds)

# ╔═╡ 398842f2-6c4d-11eb-172b-25bfb2d07e1d
md"Suppose I ran for 3 kms. In the first km I ran at a speed of 10 km/h, next km I ran at a speed of 8 km/h and the last km at 9km/h. What is my average speed?"

# ╔═╡ 49e847a0-6c4d-11eb-03d2-e773b4447b7a
total_time = (1/10 + 1/8 + 1/9) * 60

# ╔═╡ 5c198748-6c4d-11eb-325e-ada6287d92d1
average_speed_2 = 3 / (total_time/60)

# ╔═╡ 888a377e-78ef-11eb-352d-0bbe478a1d51
md"This average speed does not equal the arithmetic mean"

# ╔═╡ 671e533a-6c4d-11eb-0e29-cf4d8c7beb41
mean_(speeds)

# ╔═╡ a1774b58-78ef-11eb-23aa-b70730bf4600
md"Instead we use the _harmonic mean_"

# ╔═╡ 6c562508-6c4d-11eb-2182-5f5aa5a0e686
harmonic_mean(arr) = 1/mean(1 ./ arr)

# ╔═╡ 91bcd206-6c4d-11eb-10a9-83fc256cfde2
harmonic_mean(speeds)

# ╔═╡ 26a7eec8-6c4e-11eb-39aa-511c33304975
md"Harmonic mean is given as
```math
\overline{x}_h = \dfrac{n}{\dfrac{1}{x_1} + \dfrac{1}{x_2} + \ldots + \dfrac{1}{x_n}}
```
"

# ╔═╡ efab18a6-78ef-11eb-3c21-4b83daaa4e8c
md"As we saw in the example, harmonic means are common when computing averages of rates and ratios."

# ╔═╡ 506965d4-6c4e-11eb-322e-a3924a2c4321
md"How do the three means compare?"

# ╔═╡ 07ce16ac-6f45-11eb-1bf1-0fe1ee609574
begin
	random_arr = [[rand(1:100) for _ in 1:5] for _ in 1:100]
end

# ╔═╡ 485a1854-6f53-11eb-1a44-0fa0ff59bf03
begin
	plot(1:100, mean.(random_arr),label="arithmetic mean",lw = 3)
	plot!(1:100, geometric_mean.(random_arr[:,]),label = "geometric mean",lw = 3)
	plot!(1:100, harmonic_mean.(random_arr[:,]),label = "harmonic mean",lw = 3)
end

# ╔═╡ a8e4eb4e-7b41-11eb-1f92-fd4e083ba437
md"👉💡You are required to generate a set of random numbers that add up to 0, can you think of two ways of doing this and contrast them?"

# ╔═╡ 1fc82c80-6d0c-11eb-08f7-e14d5e766d4a
md"### Mode"

# ╔═╡ 24bf5aec-6d0c-11eb-290e-c10178dbf82e
md"We saw that the mean was affected by exterme values - both too small and too large. Can we have a measure of central tendency that does not get affected by extreme values?"

# ╔═╡ 350ff6f4-6d0c-11eb-149d-a7fcd8b8356c
md"Mode is the value that has the highest frequency."

# ╔═╡ 425f7bcc-6d0c-11eb-33d3-eda5b47ec6b2
md"We saw in the history lesson about how the Greeks measured heights of wall. When a sample contains elements from a small set of repeating values, then it is reasonable to look at the most frequent as representing that sample."

# ╔═╡ c60c2826-6d11-11eb-2d2d-576535948f26
md"Below is a function that counts the number of heads when tossing a fair coin $n$ times."

# ╔═╡ f0caf88c-6d0c-11eb-3152-437d84266789
heads_count(n) = sum(rand(0:1, n))

# ╔═╡ 65ffff7a-6d0c-11eb-25d0-55b3ca331d05
arr_2 = [heads_count(10) for _ in 1:1000]

# ╔═╡ 7b5b8a3c-6d0d-11eb-32d5-2f40a3fc20af
freqtable(arr_2)

# ╔═╡ 77015e72-6d0c-11eb-1dfc-63f26b6c22da
names(freqtable(arr_2))

# ╔═╡ 44c5c75a-6d10-11eb-3d06-39bcf320837f
mode(arr_2)

# ╔═╡ c3b60b58-6d22-11eb-12c1-45614b9a92e9
md"Recall that mean was about finding the center of gravity of the histogram while the mode is about finding the highest point."

# ╔═╡ 3306a02e-6d11-11eb-2b6a-79ce50a67657
histogram(arr_2)

# ╔═╡ 86909fec-6d11-11eb-267f-69d138c4736d
md"Clearly mode is not sensitive to outliers like mean was"

# ╔═╡ 93b3855e-6d11-11eb-2af6-731df5a990ca
mode(append!(copy(arr_2), [100, 200, -10]))

# ╔═╡ 2d5e67b4-6d12-11eb-0a19-0bfe445f1d9c
md"Another advantage of the mode is that it can be used for nominal variables also (categorical variables that do not have an ordering."

# ╔═╡ 6d8ac472-6d12-11eb-2f84-1990ed3b4b09
diamonds = dataset("ggplot2", "diamonds")

# ╔═╡ 7c85e77c-6d12-11eb-02bc-5b7866eed844
cut_freq = freqtable(diamonds[!, :Cut])

# ╔═╡ a92639a8-6d12-11eb-068c-8f45fc77ff58
names(cut_freq)

# ╔═╡ 5fd6d57a-78f0-11eb-2333-5d63dc3a89d1
md"The mode in the diamonds cuts is thus 'Ideal'"

# ╔═╡ 8997d6e0-6d10-11eb-20ab-f7a06da65081
md"But there are some major issues with mode. Can you think what they are?"

# ╔═╡ 76966762-78f0-11eb-0b1a-9b458f3fe9ca
md"First let us study what happens when we reduce the number of samples of counts in the earlier tosses."

# ╔═╡ 91fb797a-6d10-11eb-1b61-875039ca8e86
arr_3 = [heads_count(10) for _ in 1:10]

# ╔═╡ a95bec9e-6d10-11eb-3148-8fcdc5ce02a1
freqtable(arr_3)

# ╔═╡ 3bad0826-6d11-11eb-0d27-0174c7264c0c
histogram(arr_3, nbins=10)

# ╔═╡ 9a3e580a-6d10-11eb-200a-f17238f64d43
mode(arr_3)

# ╔═╡ bed7cff2-6d10-11eb-104e-f19683a7b29e
md"How do we decide which one is the mode when there are multiple values with the same frequency?"

# ╔═╡ feec23ac-6d10-11eb-3b2d-4d253530df44
md"Any of the values or all of the values with the highest frequency can be called the mode. Such a sample is not _uni-modal_. This is a challenge because the many modes of such a sample may be quite different from each other and thus we may have too much choice in the measure of central tendency."

# ╔═╡ d6035b44-6d13-11eb-21c5-45b28b673af7
md"There are some samples which are referred to as _bi-modal_. This does not necessarily mean two modes, but that the histogram of the sample has two local peaks."

# ╔═╡ 4319c2b8-6d14-11eb-3bf0-ad68fe94d51d
md"For example consider this synthetic data of occupancy in a restaurant at different times of the day."

# ╔═╡ 4e8012ba-6d14-11eb-3310-6fb08ce22026
arr_time = [rand([13, 19]) + randn() for _ in 1:100]

# ╔═╡ 7dce61de-6d14-11eb-18d1-4f90d5861c39
histogram(arr_time, nbins=15)

# ╔═╡ d44c9348-6d14-11eb-13b1-7f4edc10a2a2
md"👉 Can you think of other examples of bimodal distribution?"

# ╔═╡ f7716164-6d5b-11eb-3212-e767dc4c8797
iris = dataset("datasets", "iris")

# ╔═╡ 7ad172da-78fb-11eb-149f-8bbcd135b820
md"Here is the [iris](https://vincentarelbundock.github.io/Rdatasets/doc/datasets/iris.html) dataset where the petal length of  the flowers shows a bimodal distribution"

# ╔═╡ e7a50d2a-78f8-11eb-0957-cfb028cb7c4e
histogram(iris.PetalLength, label = "Petal Length", line=(4, :blue), fill=(0, :blue, 0.3), bins=20)

# ╔═╡ 1f4f89ec-6d11-11eb-2bed-81beb2414480
md"👉 There is one more problem with mode - in terms of how sensitive it is to values. Can you think what it is?"

# ╔═╡ 01f3d540-6d13-11eb-009e-878051a1a482
md"👉 Mode is also not very useful if the values are spread across a large range. Can you think of an example from cricket?"

# ╔═╡ 8c2afaf8-6f4e-11eb-004d-bbd7afea1592
md"Below are the scores of Sachin Tendulkar in ODIs "

# ╔═╡ 8fc3e1c0-6f3f-11eb-127c-ad7f4f56735a
sachin_scores = [52,114,6,39,14,22,3,15,48,2,18,85,53,2,111,27,38,120,28,24,7,200,4,8,96,43,69,10,175,40,32,4,14,8,138,27,46,163,61,20,7,5,50,11,91,117,63,2,0,5,32,30,97,29,99,4,21,72,47,79,43,16,0,30,94,71,55,8,99,17,8,93,99,4,0,57,7,1,54,100,60,0,31,55,1,2,35,1,29,35,4,65,12,141,2,0,95,42,100,30,2,2,2,39,19,11,2,67,93,9,1,123,6,2,4,47,19,16,74,18,78,82,11,18,37,7,0,141,28,27,8,3,5,86,44,63,45,102,89,14,68,100,48,4,83,15,97,98,50,152,81,36,52,1,1,0,7,16,9,7,14,113,36,19,105,49,1,65,34,12,18,87,68,45,36,17,146,37,3,38,0,122,81,9,70,12,62,139,32,35,27,62,146,8,44,5,61,4,8,101,69,39,25,25,93,36,39,10,11,5,93,122,12,21,26,3,17,18,41,93,1,12,13,0,2,1,186,32,0,40,85,120,37,14,16,45,0,22,2,140,28,5,45,23,0,124,11,18,118,3,8,141,2,29,127,77,128,17,53,65,100,18,33,134,143,38,80,40,15,1,10,0,5,8,41,1,95,67,54,6,82,1,3,91,2,21,2,51,6,25,17,39,27,6,27,53,28,21,4,2,117,1,9,65,44,13,45,32,101,41,14,1,6,0,114,67,62,28,23,3,2,20,89,7,40,110,1,6,30,57,17,118,2,1,100,28,65,31,3,137,90,70,127,1,65,7,39,30,41,112,4,48,47,37,13,108,88,54,66,62,34,115,8,0,0,0,110,6,11,24,6,73,63,82,15,11,1,18,15,3,24,2,26,25,15,21,8,34,5,3,1,82,21,23,32,21,22,10,15,39,14,84,4,81,54,11,35,69,4,57,31,21,77,48,57,36,1,1,4,62,0,49,11,22,4,30,53,31,19,20,10,36,0,0]

# ╔═╡ a6d34838-6f3f-11eb-0586-a5a177e13846
mode(sachin_scores)

# ╔═╡ 4b739ac4-6f4e-11eb-0f50-a321a8203251
mean(sachin_scores)

# ╔═╡ 50f72ad4-6d13-11eb-303d-533ad356d2cf
md"Thus while mode is not sensitive to outliers and can apply to nominal values it is mathematically not that sound a statistic."

# ╔═╡ 6d543000-6d15-11eb-1d3c-6d0b76708cda
md"#### Median"

# ╔═╡ d9024ede-6d15-11eb-2a0d-932cd592b039
md"The mean was helpful but was sensitive to outliers. The mode is not as sensitive to outliers, but has many flaws of its own. Can we have a reduced sensitivity to outliers but a more mathematically sound statistic?"

# ╔═╡ f636444c-6d15-11eb-197c-0dde7fa9192f
md"Median is the _middle_ value when we sort the sample in ascending or descending order."

# ╔═╡ 1fa7ad02-6d16-11eb-3a98-6f056232dd3c
my_arr3 = [4, 9, 2, 0, 4, 0, 8, 4, 0, 4, 1]

# ╔═╡ d556c23c-6d20-11eb-0924-c58ab1959fbd
md"👉 Can you guess what these numbers are, atleast after computing their sum?"

# ╔═╡ ad2352dc-6d1e-11eb-2a21-25548c7ad1e2
sum(my_arr3)

# ╔═╡ 840b5dd8-78f2-11eb-0e45-ff7744454ce9
md"They are the scores by Indian batsmen when they were bowled out for 36 in Adelaide."

# ╔═╡ 392499a2-6d16-11eb-05b4-29571b1bcd77
sort(my_arr3)

# ╔═╡ b8978124-6d1e-11eb-2916-7f650ff8a7aa
ceil(length(my_arr3)/2)

# ╔═╡ 683d929c-6d17-11eb-2ad5-a3e8ffecbb59
sort(my_arr3)[Integer(ceil(length(my_arr3)/2))]

# ╔═╡ 4964ac68-6d1a-11eb-37c3-d1a3d67e1c5f
md"👉 Do you see a problem here?"

# ╔═╡ dd779d44-6d1e-11eb-28f9-61ac10283db2
md"What about arrays with even number of elements?"

# ╔═╡ db409034-6d1f-11eb-1873-e14f7473e02a
my_arr4 = [4, 9, 2, 0, 4, 0, 8, 4, 0, 4, 1, 0]

# ╔═╡ 1514f606-6d20-11eb-13dd-7167f3b17f78
sort(my_arr4)

# ╔═╡ 8e2467b8-6d20-11eb-33bf-05972d90f3a6
middle_nos = [Integer(length(my_arr4)/2), Integer(length(my_arr4)/2)+1]

# ╔═╡ 4e6a2dae-6d20-11eb-033f-6daa7dc23ed0
mean_(sort(my_arr4)[middle_nos])

# ╔═╡ 1ed6ddb6-6d21-11eb-355a-09091f10e348
md"The median of sample $x$ with $n$ elements is
```math
x'_{\frac{n + 1}{2}}, \mbox{if } n \mbox{ is odd}
```
```math
\dfrac{x'_{\frac{n}{2}} + x'_{\frac{n}{2}+1}}{2}, \mbox{if } n \mbox{ is even},
```
where $x'$ is the ascending sort of $x$.
"

# ╔═╡ dd9d770a-6d21-11eb-06f8-11bf0f96c757
function median_(arr) 
	l = length(arr)
	if l%2 == 1
		return sort(arr)[Integer((l+1)/2)]
	else
		middle_nos = [Integer(l/2), Integer(l/2)+1]
		return mean_(sort(arr)[middle_nos])
	end
end

# ╔═╡ 69e68084-6d4b-11eb-34a9-ff6b46e5fb7b
md"Notice that because of the even case, the median might not be present in the sample."

# ╔═╡ 96d81170-6d21-11eb-32a7-35d96c536cf5
md"👉 Will the median be highly sensitive to outliers?"

# ╔═╡ f8f5c11a-6d21-11eb-11b0-afbba1cf99ee
my_arr5 = [rand(1:10) for _ in 1:100]

# ╔═╡ 2c0c58e8-6d22-11eb-1b57-2dca50cae4d4
[mean_(my_arr5), mean_(push!(copy(my_arr5), 1000))]

# ╔═╡ 3177b0fc-6d22-11eb-2d23-ddb4519069a6
[mode(my_arr5), mode(push!(copy(my_arr5), 1000))]

# ╔═╡ 1a173dc4-6d22-11eb-0a85-f3d85e76ca0d
[median_(my_arr5), median_(push!(copy(my_arr5), 1000))]

# ╔═╡ 18109838-6d34-11eb-279e-158fa3b88840
md"Notice that median only requires that we be able to sort the values, i.e., the values are ordinal. So, we can legitimately compute median for categorical variables that are ordinal."

# ╔═╡ c726572c-6d34-11eb-3a4d-e786a219f0be
md"👉 Remember we had computed the mode of the cut of diamonds. How would you find the median cut of diamond?"

# ╔═╡ 51afbc40-6d34-11eb-361c-3da902956317
names(cut_freq)

# ╔═╡ 4d1472ca-6d34-11eb-15bd-8d25b8349a58
cut_freq

# ╔═╡ 5b57b45a-6d34-11eb-3c3a-b33d5f1df5dd
sum(cut_freq)/2

# ╔═╡ b713d7ba-6d34-11eb-3cf8-a3923745f6b9
cumsum(cut_freq)

# ╔═╡ bf29d576-6d34-11eb-3e46-554c33986bf1
md"The median cut is thus `Premium`."

# ╔═╡ dd73eefe-6d34-11eb-3c63-2da47678cbe6
md"Median can also be computed for frequency counts on grouped data. For instance, the number of patients in each decade of their life. We will explore this as an assignment question!"

# ╔═╡ 3e532ae6-6d33-11eb-37d5-3b34910444d0
md"👉 We related mean to the center of gravity of the histogram, mode to finding the peak of the histogram. What about median?"

# ╔═╡ 616a6244-6d33-11eb-1b7c-178e5e266e88
begin
	histogram(two_arrs, nbins=5, ylims = (0,5), layout=2, legend=false)
	histogram!(two_arrs_2, nbins=5, ylims = (0,5), layout=2, legend=false)
end

# ╔═╡ 65b871ba-6d33-11eb-2c4e-c7ba3a89f118
md"In this example from before, the mean of the two cases was different. But the median in either case is the same - 5.5. It does not matter that 4 units of height in the right chart are far away from 5.5; it only matters that they are to the right of the median." 

# ╔═╡ 892cceec-6d4d-11eb-1736-2bd4ed0125d8
md"This above property implies that we do not need accurate extreme values to compute the median. Consider the example of using a wall marking from 150 to 180 cms to measure height of students in a class. Values below 150 are marked L and values above 180 are marked H."

# ╔═╡ a6bdf0d0-6d4d-11eb-3792-cb95406b52d0
heights = [150, 180, "L", 160, "H", 160, 170, "L", 180, 150, 150]

# ╔═╡ dea6ffbe-6d4d-11eb-1dc1-ebfe179d13b3
sorted_heights = ["L", "L", 150, 150, 150, 160, 160, 170, 180, 180, "H"]

# ╔═╡ f2cbf4d6-6d4d-11eb-2044-d97fbcc9046c
md"Then the median is 160cm even without knowing three values exactly."

# ╔═╡ c3bfde1c-78f3-11eb-3c85-5fc790af90d3
md"Ok, that brings us to an end of the mean, mode, median story."

# ╔═╡ 4a3e060e-6d4d-11eb-10f4-d3e18d896353
md"One way to think about the statistics we have learnt so far is to think about how you would fill missing values. For instance in a set of some 10 values if 2 of them are missing and you need to fill them up, which statistic would you use and why? We have different choices to make:"

# ╔═╡ 01792878-78f4-11eb-10d3-bb5da37a65d8
md"
* Mean - equi-distant from all values
* Mode - the most frequent
* Median - divides data into equal halves"

# ╔═╡ f05930cc-6d3b-11eb-09b6-6d81347bb79f
md"#### Percentiles"

# ╔═╡ f5aa8e40-6d3b-11eb-3a8d-2ffb4791c2dc
md"The median can be thought of a specific type of a family of statistics. We asked for the middle value(s) when sorting the sample in ascending order. But we could have asked for the middle value of the first half of the samples (or the _first quartile_) or the middle value of the second half of the samples (or the _last quartile_)."

# ╔═╡ 5d8d41e2-6d3c-11eb-285d-55a629f5421e
sort(my_arr3)

# ╔═╡ 6c1b7eea-6d3c-11eb-04b2-3b2afeb3907b
md"Median is the mid-way value at location 6 -> 4"

# ╔═╡ 8935adca-6d3c-11eb-190a-350be3eb5d2f
md"First _quartile_ is the middle value of the first half. We have two choices here. We can either include the median element in this count or not. 

If we did not include the median element, then there are 10 elements, and the first five elements are the first half whose middle element is the value at 3rd position -> 0. 

If we included the median element, then there are 11 elements, and the first six elements are the first half whose middle element is the average of values at positions 3 and 4 -> 0.5.

Usually the second one is used."

# ╔═╡ 390c2792-6d47-11eb-1fc8-81ca76a48643
md"But it is best to have a definition that works for not just quartiles and median, but for any _percentile_"

# ╔═╡ 59638f58-6d47-11eb-2459-652d4fc12d57
md"
> The $P$ percentile is that value having the property that at least $P$ percent of the data are less than or equal to it and at least $(100 − P)$ percent of the data values are greater than or equal to it. If two data values satisfy this condition, then the $P$ percentile is the arithmetic average of these values.
"

# ╔═╡ 8bf6f1a2-6d4a-11eb-1f9c-e388545d9a1b
md"For $n$ = 11, and $P$ = 100/3, we the following two requirements:
* At least $nP/100$ = 3.67 elements are less than or equal to it $\Rightarrow$ answer must be in position 4 or larger
* At least $n(100-P)/100$ = 7.33 elements are greater than or equal to it $\Rightarrow$ answer must be in position 4 or earlier
Thus the only element that satisfies this is the value at position 4 -> Answer: 1"

# ╔═╡ 5989edfe-6d4b-11eb-21e4-252bcdb04d28
sort(my_arr3)

# ╔═╡ 8ef68e78-6d4b-11eb-16d1-1d9a11ecd438
md"Now let us do the same computation for the case where there are 12 elements."

# ╔═╡ 96f822f8-6d4b-11eb-153f-7d98f4fb8c60
sort(my_arr4)

# ╔═╡ a80902f6-6d4b-11eb-1720-9d5c539cd1a5
md"For $n$ = 12, and $P$ = 100/3, we the following two requirements:
* At least $nP/100$ = 4 values are less than or equal to it $\Rightarrow$ answer must be in position 4 or larger
* At least $n(100-P)$ = 8 values are greater than equal to it $\Rightarrow$ answer must be in position 5 or earlier
Thus both values at 4 and 5 satisfy the conditions -> Answer is the average of the values at these two positions -> in this case it is the average of 0, 1 -> 0.5. "

# ╔═╡ b0186ffe-7b42-11eb-0e75-f930be78ede8
md"👉💡 Which value corresponds to the 90th-percentile if the number of elements in the sample is (a) 8, (b) 16, (c) 100?"

# ╔═╡ bda6705c-6d4c-11eb-0046-53573d4eb874
md"As it turns out this is only one of the 9 different conventions in computing the percentiles. One alternative way of computing percentiles is interpolate values between two potentially close-by values. You will explore this in the assignment."

# ╔═╡ c8346814-7ca4-11eb-092a-a93076cb8f83
md"
> **Recap questions:** 
> 1. One reason each why you may choose one statistic over the other from the list = {mean, median, mode}
> 2. What kinds of variables are supported with mean, median, mode?
> 3. What is the interpretation of mean, median, mode with frequency table / histogram? -> Extension to continuous probabilty density function.
> 4. What are examples when mean, median, mode are good statitics to fill out missing values in data
> 5. What is the subjective choice in computation of percentiles?
> 6. Why do we only estimate population parameters from probability distributions?
"

# ╔═╡ 3134eafc-6d35-11eb-32dd-d994a817b83a
md"##### Continous density plot"

# ╔═╡ 05e29afc-6d35-11eb-0f60-b7cbd3ebb949
md"We have been seeing the histogram throughout. A natural extension of a discrete histogram is to a continuous density plot. 

One way to imagine this is to think of a very very large sample where the histogram bar have become very thin. 

Another way of think of it is that we are empirically fitting a density distribution on some sample, and then reasoning about the statitics on the fit density."

# ╔═╡ 5ee21950-6d35-11eb-32b8-f90108d573c2
md"To study such densities, we will simply consider the popular probability distributions and their `pdf`."

# ╔═╡ ce281c42-6d35-11eb-1095-ad187772f316
D_n = Normal(0, 1)

# ╔═╡ a46f1502-6d37-11eb-2931-c58f73442918
plot(-5:0.1:5, [pdf(D_n, x) for x in -5:0.1:5], label=false, line=3)

# ╔═╡ b90b32e0-6d37-11eb-1d3b-d57bb537ab03
md"👉 What are the mean, median, and mode?"

# ╔═╡ c2a45c3c-6d37-11eb-1559-f13b16c97be7
[mean(D_n), mode(D_n), median(D_n)]

# ╔═╡ c83b00ca-7b4b-11eb-2db7-6b48bcab739b
md"👉What are the formal defintions of mean, median, mode given a pdf $f$"

# ╔═╡ b46cbb7a-7b4d-11eb-28f9-c1f264fe308b
md"👉💡 For the standard normal distribution with the pdf given as 
```math
f(x) = \dfrac{1}{\sqrt{2\pi}} e^{\frac{-x^2}{2}}
```
compute the mean, median, and mode. 

Hint: Don't use the cool fact that $\int_{-\infty}^{\infty} e^{-x^2} dx = \sqrt{\pi}$
"

# ╔═╡ 6520f052-7b4c-11eb-197c-bb72e266dbfb
md"Let us visualise these relationships. We are using the standard functions for mean, mode, median from the `StatsBase` package."

# ╔═╡ 7f847014-6d38-11eb-0323-73fd8e4badc7
function dist_plot(density, xlim)
	plot(xlim[1]:(xlim[2]-xlim[1])/100:xlim[2], [pdf(density, x) for x in xlim[1]:(xlim[2]-xlim[1])/100:xlim[2]], label=false, line=3)
	d_mean = mean(density)
	d_mode = mode(density)
	d_median = median(density)
	plot!([d_mean, d_mean], [0, pdf(density, d_mean)], label="Mean", line=(4, :dash, :green))
	plot!([d_mode, d_mode], [0, pdf(density, d_mode)], label="Mode", line=(1, :red))
	plot!([d_median, d_median], [0, pdf(density, d_median)], label="Median", line=(3, :dot, :orange))
end

# ╔═╡ d6b1192e-6d38-11eb-3ae0-71251be05120
dist_plot(D_n, [-5, 5])

# ╔═╡ dc0e12cc-7b50-11eb-1485-6b84b5476baa
md"👉💡 For the normal distribution with a $\mu \neq 0$, calculate mean, median, mode."

# ╔═╡ 0bdf7f68-7b51-11eb-320d-0def800eb904
md"
The pdf for a normal distribution with parameter $\mu$ is given as
```math
f(x) = \dfrac{1}{\sqrt{2\pi}} e^{\frac{-(x - \mu)^2}{2}}
```
"

# ╔═╡ 7cd351d8-7e6f-11eb-1d94-b584db3d48ec
md"###### Symmetric distribution"

# ╔═╡ 725f5268-7b51-11eb-27e0-f550e6d7b7dc
dist_plot(Normal(1, 1), [-5,5])

# ╔═╡ 85bf5c56-7e6f-11eb-1b67-f35c5adf354b
md"###### Right skewed distribution"

# ╔═╡ 175f8f0e-6d3a-11eb-3262-73f25183226f
dist_plot(Beta(2, 5), [0, 1])

# ╔═╡ 9097fe4e-7e6f-11eb-1b1d-0569996bcaeb
md"###### Left skewed distribution"

# ╔═╡ cca33e12-6d3a-11eb-2d4f-e771f998e942
dist_plot(Beta(5, 2), [0, 1])

# ╔═╡ a0a8ae36-6d3b-11eb-346a-210f2034cb4c
md"Notice the interesting relationship between the three statistics for the above cases. In the first one we had mode < median < mean. And in the second one mean < median < mode."

# ╔═╡ b85465ca-6d3b-11eb-2910-071bdaa855b4
md"The first plot characterises a _right skewed distribution_ (the long tail is towards the right) and the second plot characterises a _left skewed distribution_ (the long tail is towards the left)."

# ╔═╡ 905416f2-7cd0-11eb-21cf-5566c5623444
md"💡 Be careful: The nomenclature is often a confusion because we visually tend to focus on the heavy part of the distribution, whereas the name characterises the long-tail."

# ╔═╡ 60857f9c-7cd0-11eb-318c-158a2f5bdf4b
md"👉 Can you think of some examples of left and right skewed data in the real world."

# ╔═╡ 70fcf436-7cd0-11eb-1e11-e1659beb77eb
md"Lets look at some datasets which have skew"

# ╔═╡ bc43750e-78fd-11eb-28e2-2f8f46205b04
exam_scores_dataset = dataset("mlmRev","Gcsemv" )

# ╔═╡ 050432c8-7918-11eb-114f-c12052a13fd8
md"the marks of the students in the below dataset is left skewed"

# ╔═╡ aac8ce14-78fd-11eb-2a41-b7d9a62b6d79
begin
	exam_scores = dropmissing(exam_scores_dataset, :Course)
	density(exam_scores.Course, label = "Course marks", line=(4, :blue), fill=(0, :blue, 0.3))
end

# ╔═╡ 5058fb44-7918-11eb-265c-732e99428793
housing = dataset("Ecdat","Housing")

# ╔═╡ cac82adc-7918-11eb-24c9-7785ab517435
md"The price of the houses in the below dataset is right skewed"

# ╔═╡ 71166b8e-7918-11eb-1f5f-bb6685c23def
density(housing.Price/1000, label = "Price of house", line=(4, :blue), fill=(0, :blue, 0.3))

# ╔═╡ f6085392-7ca7-11eb-2dbc-532c98f0ac1d
md"Back to the beta distribution"

# ╔═╡ 6097122c-7ca6-11eb-281d-eb600e5d9b94
dist_plot(Beta(2, 10), [0, 1])

# ╔═╡ 98692734-7ca7-11eb-15b2-8d40e5adbd50
md"For the beta distribution with parameters $\alpha$ and $\beta$, the mean is given by $\dfrac{\alpha}{\alpha + \beta}$, median is approximately equal to $\dfrac{\alpha - 1/3}{\alpha + \beta + 2/3}$, and mode is $\dfrac{\alpha - 1}{\alpha + \beta - 2}$"

# ╔═╡ 62719680-7ca6-11eb-2a86-eb2b8eddba7f
md"👉 When would mode be less than median?"

# ╔═╡ 890bac2c-7ca6-11eb-1a32-75d3737d32bc
dist_plot(Beta(1.2, 5), [0, 1])

# ╔═╡ 671de650-7b40-11eb-08f8-5d4b774ec321
md"👉💡 Can you think of a left skewed data where mode is less than mean? (OR) Median is less than mean"

# ╔═╡ 84d8a222-7b40-11eb-304b-1b241bf55ace
md"👉💡 Can you think of a right skewed data where mode is greater than mean? (OR) Median is greater than mean"

# ╔═╡ 9b0884c2-7b40-11eb-15c7-93985d1380f7
md"👉💡Can you think of a non-symmetric distribution where the mean, median, and mode coincide?"

# ╔═╡ 7d88c6ba-7caf-11eb-2b5e-15b07182929a
md"### Dataframes and statistics"

# ╔═╡ 98944d94-7caf-11eb-117c-97c5c984a3f2
iris

# ╔═╡ 9b5ac3a2-7caf-11eb-0984-a7c1fe534dcb
mean(iris.SepalWidth)

# ╔═╡ a4562c24-7caf-11eb-234d-d9dc520979ac
mode(iris.Species)

# ╔═╡ b1924a94-7caf-11eb-3d7d-8b9da01f7580
median(iris.PetalWidth)

# ╔═╡ 571b47c2-7cb0-11eb-2656-b19e4fce7e80
combine(groupby(iris, :Species), :PetalLength => mode)

# ╔═╡ e5ac96a8-7cb0-11eb-23c0-9564b2c9fac2
df = DataFrame(
	marks     = [85, 72, 81, missing], 
	roll      = ["10", "21", "19", "13"], 
)

# ╔═╡ 90967b0c-7cb0-11eb-1342-2593940920d5
mean(df.marks)

# ╔═╡ 7d054492-7cb0-11eb-3b14-a50b017724e2
m = mean(skipmissing(df.marks))

# ╔═╡ b4640536-7cb0-11eb-2a7a-818382acb0d8
replace!(x -> ismissing(x) ? 0 : x, copy(df.marks))

# ╔═╡ 38096106-7cb1-11eb-0da3-3d9cf70daa67
replace!(x -> ismissing(x) ? floor(m) : x, copy(df.marks))

# ╔═╡ c43f5540-7ccc-11eb-0367-65954c29aace
md"### Pending content"

# ╔═╡ 94c96e8e-7ca9-11eb-3d6f-5f59fb241e16
md"### Demonstration of convolution"

# ╔═╡ 323d75c2-7cad-11eb-21ac-fd16435972a8
md"Try out Uniform, Normal, SymTriangularDist"

# ╔═╡ f4408cda-7ca9-11eb-2051-e57adcc91212
D_1 = Normal(0, 2)

# ╔═╡ fe853a92-7ca9-11eb-1823-6fac44a406df
D_2 = Normal(0, 2)

# ╔═╡ 9b9371a6-7ca9-11eb-3ce4-61d7005d70f0
conv(x) = sum(pdf(D_1,x-k)*pdf(D_2,k) for k=-10:0.001:10)

# ╔═╡ a2afb396-7cac-11eb-1f6a-a9a9bb91b094
conv_arr = [conv.(-10:.01:10)]

# ╔═╡ 89a2308a-7caa-11eb-1911-d9144c9c9434
xslider = @bind X_val html"<input type=range min=-7 max=7 step=0.01>"

# ╔═╡ 4cd80b66-7caa-11eb-1f7b-4f3e4c1703ba
begin
	plot(-10:0.01:10, [pdf(D_1, x) for x in -10:0.01:10], fill=(0, :blue), fillalpha=0.5, line=0, label="D1")
	plot!(-10:0.01:10, [pdf(D_2, X_val - x) for x in -10:0.01:10], fill=(0, :red), fillalpha=0.5, line=0, label="D2")
end

# ╔═╡ 03dd64c2-7caa-11eb-19e5-df8a60dd08a1
begin
	plot([-10:.01:10], conv_arr, line=3, label="D1 convolution D2")
	scatter!([X_val, X_val], [0, conv(X_val)], line=(1, :red), label="Value at Xval")
end

# ╔═╡ c69828e8-7cad-11eb-0f15-7763c4bd59f5
md"Things to see:
1. How convolution actually works
2. How the convolution of two square distributions is a triangular one
3. How the convolution of two triangular distributions is a bell shaped one (asymptotic behavior is to converge to a normal distribution)
4. How the convolution of two normal distributions is a normal distribution
"

# ╔═╡ c1b6755e-7ccc-11eb-3e27-57defc4c8c04
md"### Groupby multiple columns"

# ╔═╡ 0715c5a0-7ccd-11eb-3e85-61f41a8925a3
diamonds

# ╔═╡ ef96e6e8-7ccc-11eb-3a9b-c599abe8954c
unique(diamonds.Clarity)

# ╔═╡ 031cbfb4-7ccd-11eb-0974-e500ab69d861
unique(diamonds.Cut)

# ╔═╡ 181c7524-7ccd-11eb-26da-e7badd0b6acd
d_g = groupby(diamonds, [:Clarity, :Cut])

# ╔═╡ 2c37566e-7ccd-11eb-2e64-5b1bc4457ae5
length(d_g)

# ╔═╡ 0d123cd6-7ccd-11eb-0560-3d74436d7389
d_c = combine(d_g, :Price => mean)

# ╔═╡ e4564054-7ccd-11eb-1358-63bcba4daca5
md"👉💡How would you convert this into a 5 x 8 table with the cells containing only the numerical values?"

# ╔═╡ 60773d3a-7cce-11eb-2c66-b9461dc87933
md"👉💡 Would mean of price in d_c equal to the mean of price in diamonds?"

# ╔═╡ 6c67faf8-7cce-11eb-2386-1db61ed56d17
[mean(d_c.Price_mean) mean(diamonds.Price)]

# ╔═╡ 9f1e1318-796f-11eb-1f86-5b3260b12eee
hint(text, title) = Markdown.MD(Markdown.Admonition("hint", title, [text]))

# ╔═╡ f2a9b1b6-6c47-11eb-3014-ff475d7c3796
hint(md"The sum of the differences of each sample element from the mean is always 0.", "What is 0?")

# ╔═╡ e5d32bde-6c33-11eb-26fe-ab7b016b711e
hint(md"The sum of square distances of all elements from a point is minimized when the point coincides with the mean.", "What is minimized")

# ╔═╡ 8341cf90-78e8-11eb-3516-edc45b2ce426
hint(md"The center of gravity is the average location of the weight of an object. We can completely describe the motion of any object through space in terms of the translation of the center of gravity of the object from one place to another, and the rotation of the object about its center of gravity if it is free to rotate.", "Physics - recall center of gravity")

# ╔═╡ d5c2d5be-6c47-11eb-06eb-1b8b0701dceb
hint(md"This requires us to visualise the data using the histogram. Then the center of gravity provides the point where a fulcrum placed would lead to balancing the two sides of the histogram.", "Visualising center of gravity")

# ╔═╡ 4fc84c06-78e9-11eb-11e2-3f407544155e
hint(md"We are not equating the sum of the heights of red and blue bars. We are equating for the two colours the product of the height of a bar and its distance from center point.", "Equating on either side")

# ╔═╡ 8a0ef758-6c3e-11eb-0f77-4194e7ed47e8
hint(md"Take a _weighted average_ where the weights are the number of times each value occurs.", "Mean with frequencies")

# ╔═╡ 3baa6094-6c3f-11eb-09bd-d9f048ad329a
hint(md"If each element of the sample is increased by $c$, then the sample mean increases by $c$.", "Effect of shift on mean")

# ╔═╡ b83e6300-6c47-11eb-3895-91b2f8ad5f37
hint(md"If each element of the sample is scaled by $m$, then the sample mean is also scaled by $m$.", "Effect of scaling on mean")

# ╔═╡ 275497a4-6c49-11eb-2364-9b75a9f81ede
hint(md"When we are dealing with ratios which multiply together rather than add up", "When is Geometric Mean useful?")

# ╔═╡ 92eb2396-6c4b-11eb-1269-77ff5f9a1c20
hint(md"The geometric mean of two numbers $x_1$ and $x_2$ can be rephrased as: A square of what length has the same area as a rectangle of side lengths $x_1$ and $x_2$? We can then extend this to higher dimensions.", "Why is it called geometric?")

# ╔═╡ e39f0ae0-6d14-11eb-1629-4daf5645d725
hint(md"
* Price of e-commerce product (with and without discount)
* Heights mapped across both genders $^*$
* Biological markers with and without ailment (eg. diabetes)", "Bimodal distribution examples")

# ╔═╡ f9de7e42-6d11-11eb-00ea-3ff1075cf032
hint(md"Consider the sample $x = \{1, 1, 5, 2, 2, 5, 1, 4\}$. Changing just the last value from 4 to 5, can change model from 1 (smallest value) to 5 (largest value)", "Sensitivity of mode")

# ╔═╡ 1955cb76-6d13-11eb-00a2-1f9e181d4a95
hint(md"What do you think is the mode of all scores by Sachin in ODIs?", "Cricket mode")

# ╔═╡ 6bce5970-6d22-11eb-3df2-7b3337532e1a
hint(md"An outlier has no power to affect the ordering of the other values and thus limited power to affect the middle element. On the other hand, if we sum the values the contribution of an outlier is higher and thus the outlier has an out-sized impact on the mean.", "Why is median less sensitive to outliers than mean?") 

# ╔═╡ 4cfa02d8-6d33-11eb-1a6f-91d6d1722073
hint(md"Median is the point that divides the histogram into two parts of equal area (or total heights of the bars)", "Median and histogram")

# ╔═╡ cf9ba864-7b42-11eb-1593-b9b987ee0ea6
hint(md"(a) 8th smallest, (b) 15th smallest, (c) average of 90th and 91st smallest", "Answer - check after trying")

# ╔═╡ dee4b5b4-7b4b-11eb-2f8d-07d6e2c69363
hint(md"
* Mean = $\int_{-\infty}^\infty x f(x) dx$
* Median is the point $u$ such that $\int_{-\infty}^u f(x) dx = \int_{u}^{\infty} f(x) dx$ = 0.5
* Mode = $\arg\max f(x)$", "Measures in terms of pdf")

# ╔═╡ 2ce270c2-7b50-11eb-398e-d52464bfd0ab
hint(md"For mean, we need to compute $\int_{-\infty}^\infty xf(x) dx$. Notice that $g(x) = xf(x)$ is an odd function, i.e., $g(x) = -g(-x)$. Hence, its integral over the entire real number line is 0", "Mean")

# ╔═╡ 7dc68fbe-7b50-11eb-0c50-bfdb15f6f7ca
hint(md"For median, we want to find the point $u$ such that $\int_{-\infty}^u f(x) dx = \int_u^\infty f(x) dx$. But we know that $f(x)$ is an even function, i.e., $f(x) = f(-x)$. Hence, $u = 0$ satisifies the condition", "Median")

# ╔═╡ c011aa98-7b50-11eb-063f-6fd9023665d4
hint(md"For mode, we want the maxima of the $f$. Differentiating $x$ we see that the only point it vanishes is at $x = 0$.", "Mode")

# ╔═╡ 36ab569a-7b51-11eb-09a4-27ccdb8dc873
hint(md"Consider the variable substitution $y = x - \mu$. These new variables $y$ have a constant offset from the original variables. We already know that constant offsets are passed on to mean, median, and mode. Hence, all three values, which were earlier 0, are now $\mu$.", "Solution")

# ╔═╡ f12a343e-7ccd-11eb-33e8-9f820c3b6d76
hint(md"Groupby the clarity column -> unstack each part group (will be row vectors of 5 elements) -> vertically stack the rows for ecah of the groups (into 8 rows). Notice that unlike Python, the index is not a named index. If that is really important, for which one could use IndexedTables.jl.", "Compact table")

# ╔═╡ Cell order:
# ╟─22f18e82-6b7d-11eb-16eb-31758abdb1b0
# ╟─0b11d70c-7b42-11eb-011c-63491c857100
# ╠═def88812-6b99-11eb-07fb-3f961d7ff6ae
# ╠═c3fd3b6c-6c33-11eb-3efe-57b3d5456387
# ╟─1b5aa56c-6b93-11eb-0e91-8b977b72a959
# ╟─440d2000-6c30-11eb-3ab0-815035cd1461
# ╟─d749c66c-6c2f-11eb-3e18-331186a54c43
# ╟─225552fe-6b93-11eb-017e-d550345b26b3
# ╟─1c04e566-6c30-11eb-23b3-e70052973245
# ╠═d204c1aa-6c31-11eb-3938-7d7091a78977
# ╠═df3c4280-6c31-11eb-2703-f15ce473464d
# ╠═52b32ee2-6c3f-11eb-354a-7d2d1a7e5291
# ╠═5b56593e-6c3f-11eb-1002-bb10adc3a3ea
# ╟─6a1be22e-6c3d-11eb-230b-e71c24f4ebd7
# ╟─ebacc7c4-6c31-11eb-2565-3d57fe04886c
# ╟─f2a9b1b6-6c47-11eb-3014-ff475d7c3796
# ╠═f1ee68cc-6c31-11eb-05b8-95007ebd2fb6
# ╠═0196fadc-6c32-11eb-3aa2-f1f9b35307d0
# ╟─1cca41da-6c32-11eb-199d-e78dc429b1f2
# ╟─dabfee6c-6c33-11eb-3e35-f3451eeb02ee
# ╟─e5d32bde-6c33-11eb-26fe-ab7b016b711e
# ╟─f39953a6-6c33-11eb-1b51-9bb706ca5e66
# ╟─38e30b6e-6c34-11eb-3929-0750f343eaea
# ╟─ee4de40c-78e7-11eb-15b6-555c9f3ec939
# ╠═a38fa86e-6c34-11eb-24e2-1d82988794fa
# ╠═8e6197e2-6c34-11eb-1332-b362b460af4c
# ╠═d04c1f7a-7a96-11eb-3234-739cdb925775
# ╠═ddce578a-7a96-11eb-1fb3-0f7ca6f804a1
# ╠═e492761e-7a96-11eb-0214-89cd9c65e1cf
# ╠═f0672f7a-7a96-11eb-37e6-1f985ab4e892
# ╟─1b6f24d2-6b94-11eb-123c-ed64a991fe31
# ╟─b8a74462-78e8-11eb-0bb1-631a6d7d90c0
# ╟─8fcc9386-78e7-11eb-32e0-ab481d8c45d2
# ╟─c93f284e-78e8-11eb-2b16-f7a86f3bf208
# ╟─77f19cd8-78e8-11eb-23dd-29e619d44b70
# ╟─8341cf90-78e8-11eb-3516-edc45b2ce426
# ╟─dbb17100-78e8-11eb-0edb-ff57255459fb
# ╟─d5c2d5be-6c47-11eb-06eb-1b8b0701dceb
# ╠═3b5ffd52-6b99-11eb-0fac-237620f8da54
# ╠═660a7e4c-6c3e-11eb-11b0-35e7a99412f8
# ╠═e164f49a-6c3d-11eb-1921-f56ba8083c92
# ╟─f093012c-78e8-11eb-0d0f-a1e09c915d48
# ╠═46cb5fd8-6b99-11eb-0c1e-c30c44ae96aa
# ╠═672b8780-6b99-11eb-0c28-21308cce4514
# ╠═ddbeb07a-6b99-11eb-31b2-85ce3bdaa4ea
# ╟─42da2d98-78e9-11eb-34ca-3d05f72cf17e
# ╟─4fc84c06-78e9-11eb-11e2-3f407544155e
# ╟─749b96bc-78e9-11eb-1663-ed96af6d5996
# ╠═5a251b4e-6d23-11eb-1c68-217a9476f74c
# ╠═187a4d92-6d24-11eb-206e-c3a7c7c873ca
# ╠═78989108-6d23-11eb-3787-c59945578cf2
# ╟─e9a02bf4-6d23-11eb-2c2f-6fcae7fd2aa7
# ╟─f88c4782-6c3e-11eb-3d64-4552eb6761f2
# ╟─7b5bd854-6c3e-11eb-06e3-450d384cd600
# ╟─8a0ef758-6c3e-11eb-0f77-4194e7ed47e8
# ╟─9b533210-6c3e-11eb-289f-1d596f411218
# ╠═4d3dc5da-6c3f-11eb-39c5-d353a499f63e
# ╠═804204b4-6c3f-11eb-377f-370255565c19
# ╠═c68e21a0-6c3f-11eb-2a79-7d3af89d0503
# ╠═5802e738-6c40-11eb-28fc-0bd60ce7e38b
# ╠═8dffa5a2-6c3f-11eb-30ce-198e6a131fad
# ╟─29029830-6c3f-11eb-15bd-9fabf4081608
# ╟─3baa6094-6c3f-11eb-09bd-d9f048ad329a
# ╠═a208f46a-6c47-11eb-133d-95c61d2c04a4
# ╟─b194184c-6c47-11eb-0530-a503572f5e24
# ╟─b83e6300-6c47-11eb-3895-91b2f8ad5f37
# ╠═c7007f02-6c47-11eb-22ab-c156f20c699d
# ╟─2ef26ae6-6c48-11eb-187c-c36df7ea51be
# ╟─4aec18fa-6c48-11eb-355e-83df0f5de2eb
# ╠═576bf2bc-6c48-11eb-1616-9f97094629f6
# ╠═62f851b6-6c48-11eb-1cb7-379ba1523bdd
# ╟─ca14eb98-6c48-11eb-1860-1bcde00a3030
# ╟─8eb13c4c-6f6c-11eb-2f06-53f6df491758
# ╠═1fa3e678-6f68-11eb-1c75-59d5d15fc6ed
# ╠═f2a528a8-791c-11eb-2fda-67379adec64d
# ╟─0b42ae2c-6c49-11eb-341a-db2069fc5b7c
# ╟─10073b9c-6c49-11eb-0afa-158264e5a1dc
# ╟─275497a4-6c49-11eb-2364-9b75a9f81ede
# ╟─37233ef6-6c49-11eb-3ed0-dfc5bfbb5de7
# ╟─a6da9082-6c49-11eb-1635-bb52376c1865
# ╠═b69494dc-6c49-11eb-1b13-83c128802b1a
# ╠═59dbc152-6c49-11eb-3a0f-418e76abeefc
# ╟─310ca022-6c4c-11eb-31e5-e7428eb61d81
# ╠═7c156944-6c49-11eb-362f-a92094dda231
# ╟─b99e332a-78eb-11eb-0556-0d06b06ce695
# ╠═862d6a76-6c49-11eb-0b22-292e0c58d1be
# ╟─c402f47a-78eb-11eb-26d9-dd3651a134f8
# ╠═a225267e-6c49-11eb-0ec0-2d15c0ddf5b6
# ╠═b077db76-6c4a-11eb-1501-4b9b5fa8f56d
# ╟─ab9a00f4-6c4d-11eb-1f88-9784f40861ee
# ╠═d7ccc4ae-6c4a-11eb-087d-43836d31ca6d
# ╟─92eb2396-6c4b-11eb-1269-77ff5f9a1c20
# ╟─2364602a-78ec-11eb-1738-732e82767cbc
# ╠═0def3004-6f47-11eb-1d6c-3d34d7c4865b
# ╟─2126f412-78ec-11eb-2ce3-2fd4965f5134
# ╠═603666ea-6f75-11eb-23b0-2d08e15d2a72
# ╠═40255ac6-6f75-11eb-2399-f5f5bb5ed4d1
# ╟─46b041ac-78ec-11eb-3912-1501e6e49430
# ╟─59adfbd6-78ed-11eb-12f6-153fe6d552bc
# ╟─735cedbc-78ed-11eb-1c2e-4fcf73e7a2da
# ╠═883e8e7c-78ed-11eb-0228-11e738abf8ea
# ╟─917dfb92-78ed-11eb-20be-1b3275defa1d
# ╠═9bd4d4d0-78ed-11eb-2806-5d3482ed2c80
# ╟─cfa38fd6-78ed-11eb-16a7-13626f707283
# ╟─63b453bc-78ef-11eb-1c6a-dd2344f64cd8
# ╟─088fa5c0-78ec-11eb-3ea1-1b8342d40e7c
# ╟─d6ffe7be-6c4c-11eb-3571-9d32cf692019
# ╟─dc1a437c-6c4c-11eb-0604-9bbe5e73ed8f
# ╟─e4580766-6c4c-11eb-1eb3-61e8e8efb7ea
# ╟─078e1c7a-6c4d-11eb-2949-b3bf97ff3418
# ╠═12d04fcc-6c4d-11eb-0414-8f92c41ab299
# ╠═1e5415b8-6c4d-11eb-3a1c-31c66ab50739
# ╠═28d2c41c-6c4d-11eb-0a2c-a3675f6c3160
# ╟─8aff96fc-78ef-11eb-0557-8124a8a6979b
# ╠═17be119a-6c4d-11eb-0089-21c620182831
# ╟─398842f2-6c4d-11eb-172b-25bfb2d07e1d
# ╠═49e847a0-6c4d-11eb-03d2-e773b4447b7a
# ╠═5c198748-6c4d-11eb-325e-ada6287d92d1
# ╟─888a377e-78ef-11eb-352d-0bbe478a1d51
# ╠═671e533a-6c4d-11eb-0e29-cf4d8c7beb41
# ╟─a1774b58-78ef-11eb-23aa-b70730bf4600
# ╠═6c562508-6c4d-11eb-2182-5f5aa5a0e686
# ╠═91bcd206-6c4d-11eb-10a9-83fc256cfde2
# ╟─26a7eec8-6c4e-11eb-39aa-511c33304975
# ╟─efab18a6-78ef-11eb-3c21-4b83daaa4e8c
# ╟─506965d4-6c4e-11eb-322e-a3924a2c4321
# ╠═07ce16ac-6f45-11eb-1bf1-0fe1ee609574
# ╠═485a1854-6f53-11eb-1a44-0fa0ff59bf03
# ╟─a8e4eb4e-7b41-11eb-1f92-fd4e083ba437
# ╟─1fc82c80-6d0c-11eb-08f7-e14d5e766d4a
# ╟─24bf5aec-6d0c-11eb-290e-c10178dbf82e
# ╟─350ff6f4-6d0c-11eb-149d-a7fcd8b8356c
# ╟─425f7bcc-6d0c-11eb-33d3-eda5b47ec6b2
# ╟─c60c2826-6d11-11eb-2d2d-576535948f26
# ╠═f0caf88c-6d0c-11eb-3152-437d84266789
# ╠═65ffff7a-6d0c-11eb-25d0-55b3ca331d05
# ╠═7b5b8a3c-6d0d-11eb-32d5-2f40a3fc20af
# ╠═77015e72-6d0c-11eb-1dfc-63f26b6c22da
# ╠═25f0811c-6d10-11eb-371f-65bee7df5f92
# ╠═44c5c75a-6d10-11eb-3d06-39bcf320837f
# ╟─c3b60b58-6d22-11eb-12c1-45614b9a92e9
# ╠═3306a02e-6d11-11eb-2b6a-79ce50a67657
# ╟─86909fec-6d11-11eb-267f-69d138c4736d
# ╠═93b3855e-6d11-11eb-2af6-731df5a990ca
# ╟─2d5e67b4-6d12-11eb-0a19-0bfe445f1d9c
# ╠═707365d6-6d12-11eb-1f15-0d9e9f7d9bca
# ╠═6d8ac472-6d12-11eb-2f84-1990ed3b4b09
# ╠═7c85e77c-6d12-11eb-02bc-5b7866eed844
# ╠═a92639a8-6d12-11eb-068c-8f45fc77ff58
# ╟─5fd6d57a-78f0-11eb-2333-5d63dc3a89d1
# ╟─8997d6e0-6d10-11eb-20ab-f7a06da65081
# ╟─76966762-78f0-11eb-0b1a-9b458f3fe9ca
# ╠═91fb797a-6d10-11eb-1b61-875039ca8e86
# ╠═a95bec9e-6d10-11eb-3148-8fcdc5ce02a1
# ╠═3bad0826-6d11-11eb-0d27-0174c7264c0c
# ╠═9a3e580a-6d10-11eb-200a-f17238f64d43
# ╟─bed7cff2-6d10-11eb-104e-f19683a7b29e
# ╟─feec23ac-6d10-11eb-3b2d-4d253530df44
# ╟─d6035b44-6d13-11eb-21c5-45b28b673af7
# ╟─4319c2b8-6d14-11eb-3bf0-ad68fe94d51d
# ╠═4e8012ba-6d14-11eb-3310-6fb08ce22026
# ╠═7dce61de-6d14-11eb-18d1-4f90d5861c39
# ╟─d44c9348-6d14-11eb-13b1-7f4edc10a2a2
# ╟─e39f0ae0-6d14-11eb-1629-4daf5645d725
# ╠═6ea9cca2-6f44-11eb-1989-8dd7210c8793
# ╠═f7716164-6d5b-11eb-3212-e767dc4c8797
# ╟─7ad172da-78fb-11eb-149f-8bbcd135b820
# ╠═e7a50d2a-78f8-11eb-0957-cfb028cb7c4e
# ╟─1f4f89ec-6d11-11eb-2bed-81beb2414480
# ╟─f9de7e42-6d11-11eb-00ea-3ff1075cf032
# ╟─01f3d540-6d13-11eb-009e-878051a1a482
# ╟─1955cb76-6d13-11eb-00a2-1f9e181d4a95
# ╟─8c2afaf8-6f4e-11eb-004d-bbd7afea1592
# ╟─8fc3e1c0-6f3f-11eb-127c-ad7f4f56735a
# ╠═a6d34838-6f3f-11eb-0586-a5a177e13846
# ╠═4b739ac4-6f4e-11eb-0f50-a321a8203251
# ╟─50f72ad4-6d13-11eb-303d-533ad356d2cf
# ╟─6d543000-6d15-11eb-1d3c-6d0b76708cda
# ╟─d9024ede-6d15-11eb-2a0d-932cd592b039
# ╟─f636444c-6d15-11eb-197c-0dde7fa9192f
# ╠═1fa7ad02-6d16-11eb-3a98-6f056232dd3c
# ╟─d556c23c-6d20-11eb-0924-c58ab1959fbd
# ╠═ad2352dc-6d1e-11eb-2a21-25548c7ad1e2
# ╟─840b5dd8-78f2-11eb-0e45-ff7744454ce9
# ╠═392499a2-6d16-11eb-05b4-29571b1bcd77
# ╠═b8978124-6d1e-11eb-2916-7f650ff8a7aa
# ╠═683d929c-6d17-11eb-2ad5-a3e8ffecbb59
# ╟─4964ac68-6d1a-11eb-37c3-d1a3d67e1c5f
# ╟─dd779d44-6d1e-11eb-28f9-61ac10283db2
# ╠═db409034-6d1f-11eb-1873-e14f7473e02a
# ╠═1514f606-6d20-11eb-13dd-7167f3b17f78
# ╠═8e2467b8-6d20-11eb-33bf-05972d90f3a6
# ╠═4e6a2dae-6d20-11eb-033f-6daa7dc23ed0
# ╟─1ed6ddb6-6d21-11eb-355a-09091f10e348
# ╠═dd9d770a-6d21-11eb-06f8-11bf0f96c757
# ╟─69e68084-6d4b-11eb-34a9-ff6b46e5fb7b
# ╟─96d81170-6d21-11eb-32a7-35d96c536cf5
# ╠═f8f5c11a-6d21-11eb-11b0-afbba1cf99ee
# ╠═2c0c58e8-6d22-11eb-1b57-2dca50cae4d4
# ╠═3177b0fc-6d22-11eb-2d23-ddb4519069a6
# ╠═1a173dc4-6d22-11eb-0a85-f3d85e76ca0d
# ╟─6bce5970-6d22-11eb-3df2-7b3337532e1a
# ╟─18109838-6d34-11eb-279e-158fa3b88840
# ╟─c726572c-6d34-11eb-3a4d-e786a219f0be
# ╠═51afbc40-6d34-11eb-361c-3da902956317
# ╠═4d1472ca-6d34-11eb-15bd-8d25b8349a58
# ╠═5b57b45a-6d34-11eb-3c3a-b33d5f1df5dd
# ╠═b713d7ba-6d34-11eb-3cf8-a3923745f6b9
# ╟─bf29d576-6d34-11eb-3e46-554c33986bf1
# ╟─dd73eefe-6d34-11eb-3c63-2da47678cbe6
# ╟─3e532ae6-6d33-11eb-37d5-3b34910444d0
# ╟─4cfa02d8-6d33-11eb-1a6f-91d6d1722073
# ╠═616a6244-6d33-11eb-1b7c-178e5e266e88
# ╟─65b871ba-6d33-11eb-2c4e-c7ba3a89f118
# ╟─892cceec-6d4d-11eb-1736-2bd4ed0125d8
# ╠═a6bdf0d0-6d4d-11eb-3792-cb95406b52d0
# ╠═dea6ffbe-6d4d-11eb-1dc1-ebfe179d13b3
# ╟─f2cbf4d6-6d4d-11eb-2044-d97fbcc9046c
# ╟─c3bfde1c-78f3-11eb-3c85-5fc790af90d3
# ╟─4a3e060e-6d4d-11eb-10f4-d3e18d896353
# ╟─01792878-78f4-11eb-10d3-bb5da37a65d8
# ╟─f05930cc-6d3b-11eb-09b6-6d81347bb79f
# ╟─f5aa8e40-6d3b-11eb-3a8d-2ffb4791c2dc
# ╠═5d8d41e2-6d3c-11eb-285d-55a629f5421e
# ╟─6c1b7eea-6d3c-11eb-04b2-3b2afeb3907b
# ╟─8935adca-6d3c-11eb-190a-350be3eb5d2f
# ╟─390c2792-6d47-11eb-1fc8-81ca76a48643
# ╟─59638f58-6d47-11eb-2459-652d4fc12d57
# ╟─8bf6f1a2-6d4a-11eb-1f9c-e388545d9a1b
# ╠═5989edfe-6d4b-11eb-21e4-252bcdb04d28
# ╟─8ef68e78-6d4b-11eb-16d1-1d9a11ecd438
# ╠═96f822f8-6d4b-11eb-153f-7d98f4fb8c60
# ╟─a80902f6-6d4b-11eb-1720-9d5c539cd1a5
# ╟─b0186ffe-7b42-11eb-0e75-f930be78ede8
# ╟─cf9ba864-7b42-11eb-1593-b9b987ee0ea6
# ╟─bda6705c-6d4c-11eb-0046-53573d4eb874
# ╟─c8346814-7ca4-11eb-092a-a93076cb8f83
# ╟─3134eafc-6d35-11eb-32dd-d994a817b83a
# ╟─05e29afc-6d35-11eb-0f60-b7cbd3ebb949
# ╟─5ee21950-6d35-11eb-32b8-f90108d573c2
# ╠═9721600c-6d35-11eb-3eb7-455d9dcaae62
# ╠═ce281c42-6d35-11eb-1095-ad187772f316
# ╠═a46f1502-6d37-11eb-2931-c58f73442918
# ╟─b90b32e0-6d37-11eb-1d3b-d57bb537ab03
# ╠═c2a45c3c-6d37-11eb-1559-f13b16c97be7
# ╟─c83b00ca-7b4b-11eb-2db7-6b48bcab739b
# ╟─dee4b5b4-7b4b-11eb-2f8d-07d6e2c69363
# ╟─b46cbb7a-7b4d-11eb-28f9-c1f264fe308b
# ╟─2ce270c2-7b50-11eb-398e-d52464bfd0ab
# ╟─7dc68fbe-7b50-11eb-0c50-bfdb15f6f7ca
# ╟─c011aa98-7b50-11eb-063f-6fd9023665d4
# ╟─6520f052-7b4c-11eb-197c-bb72e266dbfb
# ╠═7f847014-6d38-11eb-0323-73fd8e4badc7
# ╠═d6b1192e-6d38-11eb-3ae0-71251be05120
# ╟─dc0e12cc-7b50-11eb-1485-6b84b5476baa
# ╟─0bdf7f68-7b51-11eb-320d-0def800eb904
# ╟─36ab569a-7b51-11eb-09a4-27ccdb8dc873
# ╟─7cd351d8-7e6f-11eb-1d94-b584db3d48ec
# ╠═725f5268-7b51-11eb-27e0-f550e6d7b7dc
# ╟─85bf5c56-7e6f-11eb-1b67-f35c5adf354b
# ╠═175f8f0e-6d3a-11eb-3262-73f25183226f
# ╟─9097fe4e-7e6f-11eb-1b1d-0569996bcaeb
# ╠═cca33e12-6d3a-11eb-2d4f-e771f998e942
# ╟─a0a8ae36-6d3b-11eb-346a-210f2034cb4c
# ╟─b85465ca-6d3b-11eb-2910-071bdaa855b4
# ╟─905416f2-7cd0-11eb-21cf-5566c5623444
# ╟─60857f9c-7cd0-11eb-318c-158a2f5bdf4b
# ╟─70fcf436-7cd0-11eb-1e11-e1659beb77eb
# ╠═bc43750e-78fd-11eb-28e2-2f8f46205b04
# ╟─050432c8-7918-11eb-114f-c12052a13fd8
# ╠═aac8ce14-78fd-11eb-2a41-b7d9a62b6d79
# ╠═5058fb44-7918-11eb-265c-732e99428793
# ╠═cac82adc-7918-11eb-24c9-7785ab517435
# ╠═71166b8e-7918-11eb-1f5f-bb6685c23def
# ╟─f6085392-7ca7-11eb-2dbc-532c98f0ac1d
# ╠═6097122c-7ca6-11eb-281d-eb600e5d9b94
# ╟─98692734-7ca7-11eb-15b2-8d40e5adbd50
# ╟─62719680-7ca6-11eb-2a86-eb2b8eddba7f
# ╠═890bac2c-7ca6-11eb-1a32-75d3737d32bc
# ╟─671de650-7b40-11eb-08f8-5d4b774ec321
# ╟─84d8a222-7b40-11eb-304b-1b241bf55ace
# ╟─9b0884c2-7b40-11eb-15c7-93985d1380f7
# ╟─7d88c6ba-7caf-11eb-2b5e-15b07182929a
# ╠═98944d94-7caf-11eb-117c-97c5c984a3f2
# ╠═9b5ac3a2-7caf-11eb-0984-a7c1fe534dcb
# ╠═a4562c24-7caf-11eb-234d-d9dc520979ac
# ╠═b1924a94-7caf-11eb-3d7d-8b9da01f7580
# ╠═571b47c2-7cb0-11eb-2656-b19e4fce7e80
# ╠═e5ac96a8-7cb0-11eb-23c0-9564b2c9fac2
# ╠═90967b0c-7cb0-11eb-1342-2593940920d5
# ╠═7d054492-7cb0-11eb-3b14-a50b017724e2
# ╠═b4640536-7cb0-11eb-2a7a-818382acb0d8
# ╠═38096106-7cb1-11eb-0da3-3d9cf70daa67
# ╟─c43f5540-7ccc-11eb-0367-65954c29aace
# ╟─94c96e8e-7ca9-11eb-3d6f-5f59fb241e16
# ╠═9b9371a6-7ca9-11eb-3ce4-61d7005d70f0
# ╟─323d75c2-7cad-11eb-21ac-fd16435972a8
# ╠═f4408cda-7ca9-11eb-2051-e57adcc91212
# ╠═fe853a92-7ca9-11eb-1823-6fac44a406df
# ╠═a2afb396-7cac-11eb-1f6a-a9a9bb91b094
# ╠═89a2308a-7caa-11eb-1911-d9144c9c9434
# ╟─4cd80b66-7caa-11eb-1f7b-4f3e4c1703ba
# ╟─03dd64c2-7caa-11eb-19e5-df8a60dd08a1
# ╟─c69828e8-7cad-11eb-0f15-7763c4bd59f5
# ╟─c1b6755e-7ccc-11eb-3e27-57defc4c8c04
# ╠═0715c5a0-7ccd-11eb-3e85-61f41a8925a3
# ╠═ef96e6e8-7ccc-11eb-3a9b-c599abe8954c
# ╠═031cbfb4-7ccd-11eb-0974-e500ab69d861
# ╠═181c7524-7ccd-11eb-26da-e7badd0b6acd
# ╠═2c37566e-7ccd-11eb-2e64-5b1bc4457ae5
# ╠═0d123cd6-7ccd-11eb-0560-3d74436d7389
# ╟─e4564054-7ccd-11eb-1358-63bcba4daca5
# ╟─f12a343e-7ccd-11eb-33e8-9f820c3b6d76
# ╟─60773d3a-7cce-11eb-2c66-b9461dc87933
# ╠═6c67faf8-7cce-11eb-2386-1db61ed56d17
# ╠═9f1e1318-796f-11eb-1f86-5b3260b12eee

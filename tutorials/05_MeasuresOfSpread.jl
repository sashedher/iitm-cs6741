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

# ╔═╡ e67f8692-799c-11eb-31bb-09a7f37da454
using StatsPlots

# ╔═╡ 9642a69e-7988-11eb-069e-157feefb4eed
using RDatasets

# ╔═╡ 88d2e984-7984-11eb-3f4c-5115712ac1a2
using Distributions

# ╔═╡ 1457d8d0-7b4b-11eb-3b05-fdea9ad03b02
using StatsBase

# ╔═╡ f054b9aa-7e63-11eb-36dd-3bf1932030ac
using QuadGK

# ╔═╡ 22f18e82-6b7d-11eb-16eb-31758abdb1b0
md"# Notebook 5: _Measures of Spread_
"


# ╔═╡ 59607216-7b43-11eb-2cf7-3f74231a1839
md"
> 📕Reference material - Chapter 3: Using statistics to summarise data (Sections 3.5 and 3.6) from Sheldon Ross. 
"

# ╔═╡ 29c96178-7981-11eb-332f-95d53eceb696
md"So far we have been looking at statistics which capture central tendency. Now we will move on to statistics that capture spread of data."

# ╔═╡ 052cbe72-7984-11eb-0b02-1dd45dc17b3b
md"👉Why are measures of spread important?"

# ╔═╡ baa51422-6b93-11eb-16b7-bf0872dc2bea
md"## Range"

# ╔═╡ 449528c8-7983-11eb-1148-4fdaa380dcfd
md"The first natural statistic for spread of data is the difference between two sets of statistics"

# ╔═╡ 4d443e46-7983-11eb-33e3-316d616ad44b
md"The simplest type of range is the difference between maximum and minimum values."

# ╔═╡ 9119e782-7984-11eb-25cb-471cefe4e7d5
range_(x) = maximum(x) - minimum(x)

# ╔═╡ 9a2fe03e-7988-11eb-09ea-b709a8cbd77c
iris = dataset("datasets", "iris")

# ╔═╡ d781854e-7988-11eb-385e-e3dedbaae06e
range_(iris.PetalLength)

# ╔═╡ a70ee822-7988-11eb-112e-5be62d6310c4
range_(iris.PetalWidth)

# ╔═╡ ba3e633c-7988-11eb-2550-4b645fb2439d
range_(iris.SepalWidth)

# ╔═╡ dde99fd6-7988-11eb-061a-15e9399613b6
md"Let us look at range calculations for random variates sampled from uniform distribution"

# ╔═╡ a7f67e52-7984-11eb-22b1-69c114b468fb
uniform_sample = rand(Uniform(0, 1), 10)

# ╔═╡ bd098168-7986-11eb-110c-c5d17c258584
md"
```math
x_i \sim U(0, 1),\ i = 1, 2, \ldots, n
```
"

# ╔═╡ cf8e1c18-7984-11eb-20f9-3ff941f8b457
range_(uniform_sample)

# ╔═╡ 04a88244-7985-11eb-328d-6f3878193236
md"Notice that in the case of a uniform distribution, we know the range of the _population_ which is the *upper bound* on the range of the _sample_. The two values would get closer as we increase the sample size."

# ╔═╡ aba0e4f6-7985-11eb-0713-172db02e7224
md"👉 Probability exercise: Given that we are drawing $n$ random numbers from the uniform random distribution [0, 1], what is the probability that the maximum value is more than some $v \in (0, 1)$."

# ╔═╡ d961ff42-7985-11eb-37d2-35af70b59310
md"
```math
\mathrm{Pr}\large(\max(x_1, x_2, \ldots, x_n) > v\large) =  1 - \prod_{i = 1}^n \mathrm{Pr}(x_i \leq v) = 1 - v^n
```
"

# ╔═╡ 6636f208-7987-11eb-16a3-17e36a925c97
md"Since $v < 1$, the above probability tends to 1 as we increase $n$, i.e., as we increase the sample size, the maximum value gets closer to 1."

# ╔═╡ 1b6955c0-7986-11eb-180f-6fabd0e6cf36
md"👉 Another probability exercise: Given that we are drawing $n$ random numbers from the uniform random distribution [0, 1], what is the probability of the minimum being lesser than $u \in (0, 1)$."

# ╔═╡ e7e6e6de-7987-11eb-2fc7-37fab2d3c05b
md"
```math
\mathrm{Pr}\large(\min(x_1, x_2, \ldots, x_n) < u\large) =  1 - \prod_{i = 1}^n \mathrm{Pr}(x_i \geq u) = 1 - (1 - u)^n
```
"

# ╔═╡ eba873f4-7988-11eb-0c30-372c31f4cad8
md"Heads up -> You will see in the assignment a question that asks you to compute the probability of range of a sample being less than $d$."

# ╔═╡ 0697dcea-7989-11eb-0ead-8d17b8f4b6cd
md"We can do the same for other distributions like the normal distribution."

# ╔═╡ 47ae6534-7984-11eb-3be1-3501475c06f9
normal_sample = rand(Normal(), 100)

# ╔═╡ 98f6a88c-7984-11eb-3882-d121f8488565
range_(normal_sample)

# ╔═╡ f6fa502e-7cce-11eb-028e-c790c42e9bc2
md"👉💡 Compute the probability of bounds on maximum and minimum values in a set of $n$ random variates from the standard normal distribution"

# ╔═╡ 554abfc4-7ccf-11eb-25fb-df246eee94a0
md"👉 The range in terms of extrema values is susceptible to outliers, how would you fix this?"

# ╔═╡ 4a80d04c-7989-11eb-109b-4789a2c1480a
md"## Interquartile Range"

# ╔═╡ 87d63e9a-798a-11eb-393f-e59d4eb48bea
md"As we have seen, outliers affect the quality of statistics and the range statistic which depends on maximum and minimum values is highly susceptible."

# ╔═╡ 98bc8d9a-798a-11eb-1fc3-0bd77bb3fe8c
md"One easy way of fixing this is to discard a part of the extreme values and then take an effective range in the remaining values. Or differently stated, we can find the difference between two percentiles."

# ╔═╡ bc770cc6-798a-11eb-0333-c746ba22dc7f
md"A common choice is the **interquartile range**, that computes the difference between the first quartile (25-percentile) and third quartile (75-percentile). This is usually denoted as $\mathrm{IQR} = Q_3 - Q_1$"

# ╔═╡ 08692f0e-798b-11eb-2b02-9548f1a59426
x = rand(1:10, 11)

# ╔═╡ b0ea2b14-798c-11eb-0a6c-6f06820a0fa1
sort(x)

# ╔═╡ 15a6fa1e-798d-11eb-187e-b93de64da00b
md"Median is at position 6 -> $(sort(x)[6])"

# ╔═╡ 1aa85896-798d-11eb-15ff-7f64835af8c8
md"Q1 is average of values as positions 3, 4 -> $((sort(x)[3] + sort(x)[4])/2)"

# ╔═╡ 24b05384-798d-11eb-346a-77856d43c699
md"Q3 is average of values as positions 8, 9 -> $((sort(x)[8] + sort(x)[9])/2)"

# ╔═╡ 70ef989a-798d-11eb-1899-f51410a810eb
md"IQR = Q3 - Q1 = $((sort(x)[8] + sort(x)[9])/2 - (sort(x)[3] + sort(x)[4])/2)"

# ╔═╡ 970787c2-798d-11eb-12c7-bfd48299c383
boxplot(x)

# ╔═╡ 4b5fb2f4-798b-11eb-1af8-33890aaf0ed4
md"The highlighted box captures the middle 50 percentile of data and its height gives the IQR"

# ╔═╡ 242401ba-798b-11eb-31ed-07d5767cf6f2
boxplot(iris.PetalWidth)

# ╔═╡ 8071095e-798b-11eb-3e86-0b137ae8360f
boxplot(iris.SepalWidth)

# ╔═╡ 8842e8aa-798b-11eb-1746-f36c13e7c8ba
md"Note how the range for sepal and petal widths were the same, but IQR for sepal width is lesser indicating a very different data distribution. Also notice how there are _outliers_ shows as individual points beyond the _whiskers_ of the box plot."

# ╔═╡ 5d79259e-798b-11eb-298a-b58a6288162e
md"👉 How would you decide on the classification of outliers?"

# ╔═╡ 2f1b4990-798e-11eb-31fb-dbc8934ccdfb
md"The usual choice for the lower whisker (also called a fence) is $\max(P_0, Q_1 - 1.5 \times \mathrm{IQR})$ where $P_0$ is the minimum value in the sample."

# ╔═╡ 42b201a8-799d-11eb-00ce-27483756dce2
md"Similarly, the usual choice for the upper whisker is $\min(P_{100}, Q_3 + 1.5 \times IQR)$, where $P_{100}$ is the maximum value in the sample."

# ╔═╡ 673294b4-799d-11eb-07ac-9dbd30c54541
md"This value 1.5 is usually a parameter that can be specified:"

# ╔═╡ 6fce44da-799d-11eb-1be4-8b0d2097ce9a
boxplot(iris.SepalWidth, range = 1) # default value is 1.5

# ╔═╡ 92d81aa8-799d-11eb-25e3-7b2d722ba0c2
md"So the boxplot shows us the IQR range as a highlighted box and the whiskers as a more elongated range that also depends on the IQR."

# ╔═╡ 1082bef2-7989-11eb-0137-f36a82244d4f
md"## Variance and Standard Deviation"

# ╔═╡ 81db5570-79b2-11eb-2dcb-5b908ad62b3f
md"
| Symbol      | Description |
| ----------- | ----------- |
| $\overline{x}$         | Sample mean (statistic)     |
| $\mu$         | Population mean (parameter)      |
| $s^2$      | Sample variance (statistic) | 
| $\sigma^2$ | Population variance (parameter) |
| $s$ | Sample standard deviation (statistic) | 
| $\sigma$ | Population standard deviation (parameter) |
| 
"

# ╔═╡ 0c4ac2ae-79b3-11eb-09be-b385fd8dd389
md"Let us start with variance. We want to get some notion of spread of data."

# ╔═╡ 5ae7f7e6-79b4-11eb-1609-470cf5246eb7
arr = rand(7)

# ╔═╡ 95d0b9b0-79b4-11eb-2120-978ee85a75a3
begin
	scatter(arr, zeros(7))
	scatter!([mean(arr)], [0.1])
end

# ╔═╡ 40841800-79b7-11eb-2667-25b9a152246d
md"We can think of spread as how far are the points from the mean. We already know that $\sum_{i=1}^n (x_i - \bar{x}) = 0$."

# ╔═╡ 5aec1d14-79b7-11eb-0342-997f50dbe294
md"One way to avoid the cancelling is to take a square, i.e., $\sum_{i = 1}^n (x_i - \bar{x})^2$."

# ╔═╡ b420b066-79b7-11eb-16f6-9fa333021ea9
md"But since these are positive summands, this sum will depend on $n$. Instead we may want an average value that does not depend on $n$."

# ╔═╡ c8fa957e-79b7-11eb-355c-db21c14bccdc
md"Hence we have the following formula"

# ╔═╡ f84b2414-79b3-11eb-29d0-a3da4a9d41be
md"
```math
\sigma^2 = \dfrac{\sum_{i = 1}^N(X_i - \mu)^2}{N}
```
"

# ╔═╡ 5be6eb56-79b0-11eb-10a2-2bd5979f3a63
md"
```math
s^2 = \dfrac{\sum_{i = 1}^n(x_i - \overline{x})^2}{n - 1}
```
"

# ╔═╡ 1b53b1cc-79bb-11eb-16c2-a799ed6bafbd
md"The variance is an average of the square distance of elements from the mean."

# ╔═╡ 1056b4f2-79b3-11eb-09a6-9f7ffaf3b5e3
md"Notice the $n - 1$ in the formula for the sample variance. We will later see why it is $n - 1$ and not $n$. Quick trailer: Are the $n$ summands in the computation of $s^2$ independent?"

# ╔═╡ b4645be0-7b49-11eb-1f50-9328aece496b
md"👉💡 What happens to the sample variance if all sample values are offset by a constant?"

# ╔═╡ 07703e92-7b4a-11eb-0aa6-7180b261728c
md"👉💡 What happens to the sample variance if all sample values are scaled by a constant?"

# ╔═╡ 7e72da22-7cd2-11eb-3de0-93e1435b1987
md"👉Reall that the function $\sum_i (x_i - u)^2$ is minimized at $u = \overline{x}$. Variance is the ratio of that minimum value to the size of the population."

# ╔═╡ a0b559f6-79bb-11eb-0bb5-eb2b8e341b3c
mean(arr)

# ╔═╡ 842b718a-79bb-11eb-15e3-fd52f3ed3be4
[arr (arr .- mean(arr)).^2]

# ╔═╡ 1d2029b0-7b44-11eb-2df3-cf8c03c6c009
variance_(arr) = sum((arr .- mean(arr)).^2)/(length(arr) - 1)

# ╔═╡ 369e4a72-7b44-11eb-2947-d198ea29598e
variance_(arr)

# ╔═╡ 549ce572-7b44-11eb-3ea9-3334c962ca90
mean_(arr) = sum(arr)/length(arr)

# ╔═╡ cc201ce0-7b44-11eb-37fc-358d02e2d8ed
md"The variance is a measure of the spread of the data while the mean is a central tendency. It is easy to construct two arrays with roughly the same mean but different variance."

# ╔═╡ 5a33dad6-7b44-11eb-36cb-034dc4851a01
arr_narrow = rand(-10:10, 10000)

# ╔═╡ 671c8c5a-7b44-11eb-0302-53101084c5a6
arr_wide = rand(-100:100, 10000)

# ╔═╡ 7195a696-7b44-11eb-1073-91f2060f0fd5
[mean_(arr_narrow) mean_(arr_wide)]

# ╔═╡ 2e18943a-7ff1-11eb-1d35-7f2019c6c06e
[variance_(arr_narrow) variance_(arr_wide)]

# ╔═╡ d4f04180-7b45-11eb-210a-75f898949c20
md"The following formula will come handy in many theorems later and is also useful if you are estimating variance by hand."

# ╔═╡ afde9040-801a-11eb-3907-4f9f38b66893
md"
```math
\sigma^2 = \dfrac{\sum_{i = 1}^N(X_i - \mu)^2}{N}
```
"

# ╔═╡ edf6aaae-7b45-11eb-3e5c-ff386f3ca855
md"
```math
\sigma^2 = \overline{X^2} - \mu^2
```
"

# ╔═╡ 9ebeb81e-7cd2-11eb-3842-67d666de0d56
md"👉 In class exercise. Try to work out the proof for this."

# ╔═╡ 176b9300-7b47-11eb-34f5-e9f401587fbb
md"Notice that these are population parameters and not sample statistics"

# ╔═╡ 10813aba-7b46-11eb-15ae-9d34277557aa
md"
```math
\sigma^2 = \dfrac{1}{N}\sum_{i = 1}^N (X_i - \mu)^2 = \dfrac{1}{N} \left(\sum_{i = 1}^N X_i^2+ N\mu^2 - 2\sum_{i = 1}^N X_i \mu\right)
```
```math
= \overline{X^2} + \mu^2 - \dfrac{2\mu}{N}\sum_{i = 1}^NX_i = \overline{X^2} - \mu^2
```
"

# ╔═╡ 522289b6-7b47-11eb-2e36-f1fcaad71e46
md"This is also written as $\sigma^2 = \mathbb{E}[X^2] - {\mathbb{E}[X]}^2$."

# ╔═╡ 09b45022-7b49-11eb-3a09-25e2c5f15d5a
md"Let us build some visual intuition for this formula"

# ╔═╡ dfaca6b8-7b47-11eb-3232-c395a968eab0
arr1 = [1, 3, 5]

# ╔═╡ ce181838-7b47-11eb-09fb-21ae2437e92f
begin
	scatter(arr1, zeros(length(arr1)), xlims = (0,27), label="Original elements")
	scatter!([mean(arr1)], [0.01], label="Mean")
	scatter!(arr1.^2, zeros(length(arr1)) .+ 0.1, label="Squares of elements")
	scatter!([mean(arr1)^2], [0.2], label="Square of mean")
	scatter!([mean(arr1.^2)], [0.2], label="Mean of squares")
end

# ╔═╡ c3f0eb9c-7e5c-11eb-11ab-b39896644d0e
md"Squaring followed by mean is larger than mean followed by squaring. The difference captures the variance in data."

# ╔═╡ 1cf14bf8-7b4a-11eb-057c-cd6c391812d7
md"The formula $\sigma^2 = \overline{X^2} - \mu^2$ can be written for the sample variance also as 
```math
s^2 = \dfrac{n}{n - 1} \left(\overline{x^2} - \overline{x}^2\right)
```
"

# ╔═╡ 8fe26172-7b4a-11eb-3fec-25a023ad0c21
md"Notice that the difference between dividing by $n$ and $n- 1$ in the formula for the standard deviation is significant for small values of $n$. For large samples (say $n = 10,000$), the difference is negligible."

# ╔═╡ 413e485c-7b4b-11eb-212e-81acd087a606
md"The variance function is typically denoted as `var` and is available from the `StatsBase` package.)"

# ╔═╡ 17a48a4c-7b4b-11eb-0935-c78e3fbe8875
[var(arr) variance_(arr)]

# ╔═╡ 5f6eae0c-7b4b-11eb-1f34-891b85a352b3
md"Notice that by default, `var` is the sample variance (with the $n-1$ denominator). If you are computing population variance, then you can set the `corrected` argument to false."

# ╔═╡ 843168c4-7b4b-11eb-2d50-f50df5c611b5
var(arr, corrected=false)

# ╔═╡ 93ba3102-7b4b-11eb-1e40-4d22cef75d41
md"Most numerical packages have some way of specifying whether it is a sample statistic or population parameter. It is crucial that you see what the default setting is. This is a common gotcha."

# ╔═╡ 5508697c-7e5d-11eb-18c8-0f27ee5cb6be
md"Now a further complication arises when we compute variance of a sample given that we know the population mean."

# ╔═╡ 754bdb0e-7e5d-11eb-24ea-a15f33748d49
md"
If we did not know $\mu$:
```math
s^2 = \dfrac{\sum_{i = 1}^n(x_i - \overline{x})^2}{n - 1}
```
If we knew $\mu$:
```math
s^2 = \dfrac{\sum_{i = 1}^n(x_i - \mu)^2}{n}
```
"

# ╔═╡ a39d3d72-7e5d-11eb-3fa8-b57f67497390
md"So, if we are using the _noisy_ estimate of $\mu$ in the form of $\overline{x}$, then we have the _corrected_ denominator $n - 1$. But if we knew $\mu$, we use the standard denominator $n$. We will build more formalism to understand this later."

# ╔═╡ 8f75f92a-7ff1-11eb-07db-07a8b1ee8fd3
md"👉 Can you think of situations where we know $\mu$ and want to estimate $s^2$?"

# ╔═╡ c16cb486-7e5d-11eb-3931-616157e00d6d
md"👉 Can you devise a way to build computational intuition of the above formulae."

# ╔═╡ cb9c1654-7e5d-11eb-12a4-b1b814fb894a
arr_n = rand(Normal(), 10)

# ╔═╡ 222b0534-7e5e-11eb-07ee-599111a5a85e
mu = 0

# ╔═╡ 3c7d66e8-7e5e-11eb-156b-bf16ab97429b
σ2 = 1

# ╔═╡ 1ba1e9a6-7e5e-11eb-26c0-c3259ca71dfa
x_bar = sum(arr_n)/length(arr_n)

# ╔═╡ 5802e8a2-7e5e-11eb-0e69-2d5da350e203
s2_wo_σ2 = sum((arr_n .- x_bar).^2)/(length(arr_n) - 1)

# ╔═╡ 72d949fa-7e5e-11eb-3661-8f14b46a3336
s2_with_σ2 = sum((arr_n .- mu).^2)/(length(arr_n))

# ╔═╡ a1d2283a-7e5e-11eb-0c22-a91232575d2e
md"
**In summary**

For population parameter:
```math
\sigma^2 = \dfrac{\sum_{i = 1}^N(X_i - \mu)^2}{N}
```
For sample statistic if we did not know $\mu$:
```math
s^2 = \dfrac{\sum_{i = 1}^n(x_i - \overline{x})^2}{n - 1}
```
For sample statistic if we knew $\mu$:
```math
s^2 = \dfrac{\sum_{i = 1}^n(x_i - \mu)^2}{n}
```
"


# ╔═╡ 01c7f2d0-7e5d-11eb-0134-b527c31615cd
md"👉 How would you compute variance with frequency tables?"

# ╔═╡ eff8182c-7b4c-11eb-3608-077859fd9405
md"Instead of individual values, if we are given a frequency table where element $x_i$ occurs $f_i$ number of times, then the sample variance is given as
```math
s^2 = \dfrac{\sum_{i = 1}^n \left(f_i \times (x_i - \overline{x}^2)\right)}{\sum_{i = 1}^n f_i - 1}
```
"

# ╔═╡ 3795afc2-7e5f-11eb-04dd-650633462059
md"👉How would you compute variance from probability distribution functions"

# ╔═╡ 2f9ccf56-7b4d-11eb-0620-85cc73e63986
md"We can extend this to a probability distribution with a given pdf $f$. Notice that probability distribution characterises a population and not a sample"

# ╔═╡ 5723264a-7b4d-11eb-3d80-d728e4e125ea
md"
```math
\sigma^2 = \int_{-\infty}^{\infty} (x - \mu)^2 f(x) dx
```
where $\mu$ as we know is
```math
\mu = \int_{-\infty}^{\infty} xf(x) dx
```
"

# ╔═╡ 393eab66-7e60-11eb-138b-b7b5d7578b9e
md"The above formulation is related to the idea of moments of functions. 

The $n$th moment of a function $f$ for a given constant $c$ is:
```math
M_n = \int_{-\infty}^{\infty} (x - c)^n f(x) dx
```
"

# ╔═╡ 50be8e64-7e60-11eb-0bde-770db17176c5
md"Mean is the first moment ($n = 1$) of the pdf for $c = 0$." 

# ╔═╡ 8af58b82-7e60-11eb-345b-f5497a167d14
md"Variance is the second moment $(n = 2)$ of the pdf for $c = \mu$. This is usually called the corrected or central moment."

# ╔═╡ 5d793888-7b4d-11eb-1760-7d6e5a06d299
 md"👉 For the standard normal distribution, what is $\sigma^2$"

# ╔═╡ 45d7729e-7b4e-11eb-16b8-9fe470c4422a
md"
```math
\sigma^2 = \int_{-\infty}^\infty x^2 \dfrac{1}{\sqrt{2\pi}} e^{\frac{-x^2}{2}} dx
```
We will invoke _integration by parts_.
"

# ╔═╡ 8f23a268-7b52-11eb-14d3-a19f581d662e
md"
Let us set $u$ and $v$ as: $u = x, dv = x e^{\frac{-x^2}{2}} dx$. 
We may set $v = - e^{\frac{-x^2}{2}}$. 
```math
\dfrac{1}{\sqrt{2\pi}} \left(\int_{-\infty}^{\infty} x^2 e^{\frac{-x^2}{2}} dx\right) = \dfrac{1}{\sqrt{2\pi}}  \left(-xe^{\frac{-x^2}{2}} \Biggr|_{-\infty}^{\infty} + \int_{-\infty}^{\infty} - e^{\frac{-x^2}{2}} dx\right)
```
```math
= 0 + 1 = 1
```
For the first part, note that the $e^{-x^2/2}$ decays much faster than $x$ grows. So both limits are 0. For the second part note the famous integral $\int_{-\infty}^{\infty} e^{-x^2} dx = \sqrt{\pi}$. 
"

# ╔═╡ e62703f0-7e60-11eb-061b-05e2ebbae775
md"👉Homework: Compute variance analytically for $\mathcal{N}(\mu, \sigma)$."

# ╔═╡ d06cb7e4-7b45-11eb-0ecb-3fb5bd004188
md"## Standard deviation"

# ╔═╡ e7ee031a-7b44-11eb-1109-6d05b4ddca2e
md"Notice the variance is the sum of square of deivations. It's unit is thus the square of the unit of the values in the sample. If we want a measure of spread as the same unit as the sample data, then we can use the standard deviation which is simply the square-root of the variance."

# ╔═╡ 2806eb6a-7b45-11eb-227a-93964c77e93b
std_(arr) = sqrt(variance_(arr))

# ╔═╡ 89e42a9c-7b44-11eb-315d-7974de3531d9
[std_(arr_narrow) std_(arr_wide)]

# ╔═╡ 4c62ba78-7e62-11eb-080e-9f49bb8a60fb
md"
For population parameter:
```math
\sigma = \sqrt{\dfrac{\sum_{i = 1}^n(X_i - \mu)^2}{N}}
```
For sample statistic if we did not know $\mu$:
```math
s = \sqrt{\dfrac{\sum_{i = 1}^n(x_i - \overline{x})^2}{n - 1}}
```
For sample statistic if we knew $\mu$:
```math
s = \sqrt{\dfrac{\sum_{i = 1}^n(x_i - \mu)^2}{n}}
```
"


# ╔═╡ 7953f36c-7e62-11eb-318c-c30dc4038629
md"Notice that it the standard deviation is **not** the average of the square-root of sum of squares. It is the square-root of the avearge of the sum of squares."

# ╔═╡ fc298e8e-7e62-11eb-1275-bfaaba9e6d13
md"Because the standard deviation is the same unit as the data, we use it for analysis more often than variance. We can compute it for the petal lengths from before."

# ╔═╡ 35da102c-7e61-11eb-3068-3f8961843a9f
var(iris.PetalLength)

# ╔═╡ 5d6f375c-7e61-11eb-28ab-4561d1cabdb9
mean(iris.SepalLength)

# ╔═╡ 501021f2-7e61-11eb-3205-03823f96e0ba
std(iris.PetalWidth)

# ╔═╡ 14bf236c-7e63-11eb-31c0-1b57f03ae4ff
md"Since the standard deviation is of the same unit as the values of the sample, we can use it to define intervals of values. For instance $[\mu - \sigma, \mu + \sigma]$ defines an interval of size $2\sigma$ centered at the mean."

# ╔═╡ 711c29be-7e65-11eb-0aad-8f82e60e2ece
md"👉 A good question to ask is how many points are within this interval. Notice that counting points is the forte of another statistic - inter-quartile range, but we would like to see if we can use mean and standard deviation for this."

# ╔═╡ 5ceecd68-7e63-11eb-20a2-cf9cdf7e1758
md"Let us consider the normal distribution and identify the percentage of values than lie in the range $[\mu - k\times \sigma, \mu + k\times \sigma]$ for different values of $k$"

# ╔═╡ fab8dd52-7e65-11eb-3456-8708ccd8cd4f
md"👉How would you do this computationally?"

# ╔═╡ 9c434dd6-7e63-11eb-3bba-736c1f794722
D_ = Beta(2, 5)

# ╔═╡ 7b34bb66-7e63-11eb-2e44-1b00e23874cb
xslider = @bind x_slider html"<input type=range min=1 max=5 step=1>"

# ╔═╡ 660f6682-7e63-11eb-396d-77ef6e6f1de2
begin
	plot(x->x, x->pdf(D_, x), mean(D_) - x_slider*std(D_), mean(D_) + x_slider*std(D_), fill=(0, :orange),fillalpha=0.5, label="", title="Within [μ - " * string(x_slider) * "σ, μ +" * string(x_slider) * "σ]: " * string(floor(quadgk(x -> pdf(D_, x), (mean(D_) - x_slider*std(D_), mean(D_) + x_slider*std(D_))...)[1] * 10000)/100) * "%")
	plot!(x->x, x->pdf(D_, x), mean(D_) - 5 * std(D_), mean(D_) + 5 * std(D_), label="", line=4)
end

# ╔═╡ 624943a8-7e66-11eb-12b0-6f9a43405d16
md"There are two major implications of this: 

1. If we have a window of size $2\sigma$ around $\mu$, more than 95% of the samples would lie within this. 
2. If we have a sample value that is greater than $\mu + 2\sigma$, we can conclude that it has a low probability of being sampled.
"

# ╔═╡ 8848bee0-7e6a-11eb-0cb3-63001bba774d
md"👉 Examples?"

# ╔═╡ 91787884-7e6a-11eb-3821-a11457bb4bfa
md"
1. If I am a shoe retailer, then I would stock shoe sizes in the range $[\mu - 2\sigma, \mu + 2\sigma]$. 
2. If I see a student scoring significantly less than $\mu - 2\sigma$, I could infer that there was some specific issue which may rquire me to support the student with."

# ╔═╡ db73f682-7e6a-11eb-2890-adea119688ab
md"👉How do we compare the standard deviations of different variables?"

# ╔═╡ d4666004-7e6a-11eb-1502-41d2bdf3df30
std(iris.PetalLength)

# ╔═╡ fec9f55c-7e6a-11eb-337c-13273fff4450
std(iris.PetalWidth)

# ╔═╡ 01e8107c-7e6b-11eb-1e0b-fd862028439a
md"👉Can we conclude that petal length has a higher *spread* than petal width?"

# ╔═╡ 258692fe-7e6b-11eb-3401-e9e8d96483fe
md"No, the mean values themselves may be different."

# ╔═╡ 2b9af64e-7e6b-11eb-11be-714f382922dc
md"A common approach is to compute the ratio of standard deviation to mean. This is called the **coefficient of variation**."

# ╔═╡ 0fc0b998-7e6b-11eb-34be-8be4f0e4fe08
std(iris.PetalLength)/mean(iris.PetalLength)

# ╔═╡ 190b6e28-7e6b-11eb-069c-dbaa847caa19
std(iris.PetalWidth)/mean(iris.PetalWidth)

# ╔═╡ 3e31d85c-7e6b-11eb-0cb8-6d171248d19d
md"So it turns out that coefficient of variation is higher for petal width, contrary to our earlier guess."

# ╔═╡ 2cc216d4-7e6c-11eb-09c8-ddaa8b9b05b5
md"👉What happens to the standard deviation if we have a constant shift of all values and a constant scaling of all values?"

# ╔═╡ 99172a5c-7e6c-11eb-39db-b76d5eb6403f
md"👉Do you see a relation between the median/IQR and mean/standard-deviation?"

# ╔═╡ e700935c-7e6c-11eb-3c5f-79ee52818f27
md"👉 When will you use which?"

# ╔═╡ ec198862-7e6c-11eb-2368-cb1d288a537a
md"If the data is skewed, better to use median and IQR. This is usually the case with economic data like house prices and income. For more symmetric data, mean and standard deviation are used. This is usually the case with experimental data."

# ╔═╡ 0121fce4-7e6d-11eb-00a3-77cef143d4e0
md"Notice: Measure of central tendency required computation of spread to check if it was accurate enough. But now, we seem to also depend on **skew**. How is that measured? Is it a measure of spread?"

# ╔═╡ 272137ca-7e6d-11eb-1ccb-491acdf93e80
md"## Skew"

# ╔═╡ 5d67d74a-6b93-11eb-0df5-01899af4b4ab
md"Let us revisit our earlier plots on how the mean, median, and mode are ordered."

# ╔═╡ a53d2cd8-7e6e-11eb-1265-c3df598243b6
function dist_plot(density, xlim)
	plot(xlim[1]:(xlim[2]-xlim[1])/100:xlim[2], [pdf(density, x) for x in xlim[1]:(xlim[2]-xlim[1])/100:xlim[2]], label=false, line=3)
	d_mean = mean(density)
	d_mode = mode(density)
	d_median = median(density)
	plot!([d_mean, d_mean], [0, pdf(density, d_mean)], label="Mean", line=(4, :dash, :green))
	plot!([d_mode, d_mode], [0, pdf(density, d_mode)], label="Mode", line=(1, :red))
	plot!([d_median, d_median], [0, pdf(density, d_median)], label="Median", line=(3, :dot, :orange))
end

# ╔═╡ add3881e-7e74-11eb-24d0-c3909978a450
md"👉Think of two distributions with the same mean, but different standard deviation"

# ╔═╡ bbf9ee7a-7e6e-11eb-06d9-21df405b04a2
dist_plot(Normal(0, 1), [-5, 5])

# ╔═╡ ba25c50c-7e74-11eb-248f-95e03691af90
dist_plot(Normal(0, 2), [-5, 5])

# ╔═╡ c2e4c756-7e74-11eb-330c-db0b6ea51886
md"👉Think of two distributions with the same mean and standard deviation, but clearly different characteristics"

# ╔═╡ c8c0d22e-7e6e-11eb-1e6d-37acc66bdadb
dist_plot(Beta(2, 5), [0, 1])

# ╔═╡ ca2cce42-7e6e-11eb-1b9a-8958575b107e
dist_plot(Beta(5, 2), [0, 1])

# ╔═╡ 1024a3ec-7e70-11eb-3b96-391f330cfb32
[std(Beta(2, 5)) std(Beta(5,2))]

# ╔═╡ 0e46c762-7e70-11eb-2650-135cff7436b8
md"Notice that the standard deviation for the two distributions is the same. The mean can be made the same by simply adding an offset to all values. Then, how are the two distributions to be distinguished?"

# ╔═╡ 30f7ecf0-7e70-11eb-13d5-75ace1ff42cd
md"We need a metric for skew"

# ╔═╡ 371558a2-7e70-11eb-1661-430f14e76302
md"Pearson's coefficient of skew: (recall that it was Pearson who proposed the definition of standard deviation too)
```math
\mathrm{Skew} = \dfrac{\mathrm{Mean} - \mathrm{Mode}}{\mathrm{Standard\  deviation}}
```
He also proposed 
```math
\mathrm{Skew} = \dfrac{3(\mathrm{Mean} - \mathrm{Median})}{\mathrm{Standard\  deviation}}
```
The constant $3$ occurs because of sufficiently skewed data, mode $\approx$ $3 \times $ Median - $2 \times$ Mean
"

# ╔═╡ 907116e8-7e70-11eb-333f-290f0a7d80e8
skew1(d_) = (mean(d_) - mode(d_))/std(d_)

# ╔═╡ 4766721c-7e71-11eb-0dd7-69fdac58cc30
skew1.([Beta(2, 5) Beta(5, 2)])

# ╔═╡ 661feb52-7e71-11eb-1bf0-5b4a4f4e1c02
skew2(d_) = 3*(mean(d_) - median(d_))/std(d_)

# ╔═╡ 719b971a-7e71-11eb-1a2d-e1b67112c405
skew2.([Beta(2, 5) Beta(5, 2)])

# ╔═╡ 56e6b8f2-7e71-11eb-1203-75faf28f79e0
md"Now we have a measure to distinguish between these two distributions"

# ╔═╡ b3419d86-7e71-11eb-1a63-87efbffc5d90
md"If we change the two parameters of the Beta distribution, we can get different skews. Having greater difference between the parameters leads to higher absolute values of skewness."

# ╔═╡ c7d99398-7e71-11eb-2a80-e1ee835a675d
skew1.([Beta(1.1, 5) Beta(5, 1.1)])

# ╔═╡ cc00e586-7e71-11eb-05b9-c92bdd03dc26
dist_plot(Beta(1.1, 2), [0, 1])

# ╔═╡ e3b93278-7e71-11eb-01fb-c1fb19c1af97
md"Symmetric distributions have 0 skew"

# ╔═╡ 8c02ca6a-7e71-11eb-0533-f56d312294ac
skew1.([Normal() Uniform() SymTriangularDist()])

# ╔═╡ d9d0162a-7e72-11eb-143c-a7a0fdaa02e4
md"We can also calculate the skew using a moment-based approach."

# ╔═╡ 629dae04-7e73-11eb-1075-69cffc768b82
md"
For continuous pdf $f$:
```math
M_3 = \dfrac{1}{\sigma^3}\int_{-\infty}^{\infty} (x - \mu)^3 f(x) dx
```
And for finite sums:
```math
M_3 = \dfrac{\sum_{i = 1}^N (X_i - \mu)^3}{N\sigma^3}
```
"

# ╔═╡ 6e49f3b0-7ff3-11eb-00b5-2157914eb9ed
md"Notice that we are scaling the moment by $\sigma^3$."

# ╔═╡ da31badc-7e73-11eb-34a0-75d05bc41291
md"For samples when we do not know the population mean and standard deviation, we again need a *correction*:
```math
\mathrm{Skew} = \dfrac{n}{(n - 1)(n - 2)}\dfrac{\sum_{i = 1}^n (x_i - \overline{x})^3}{s^3}
```
"

# ╔═╡ 0d7fbfbe-7e91-11eb-14eb-ed9b68f7b02e
md"👉 What is the intuition of sign of skew?"

# ╔═╡ 6be14370-7e70-11eb-36c1-97d6b5ab2e2a
md"![](https://www.oreilly.com/library/view/clojure-for-data/9781784397180/graphics/7180OS_01_180.jpg)"

# ╔═╡ 377f3020-7e74-11eb-22d1-3bf79ca13e7a
skew_moment(x) = length(x)/((length(x) - 1) * (length(x) - 2)) * sum((x .- mean(x)).^3) / std(x)^3

# ╔═╡ 649cd9e0-7e74-11eb-0997-4f7390f13936
skew_moment(iris.PetalWidth)

# ╔═╡ 89350110-7e74-11eb-0cb1-6bb00c61e12b
histogram(iris.PetalWidth, bins=20)

# ╔═╡ b39bb5ac-7e81-11eb-3da9-fb2f6ece1f8a
diamonds = dataset("ggplot2", "diamonds");

# ╔═╡ b5d346f4-7e81-11eb-15a4-657b672f23a5
skew_moment(diamonds.Price)

# ╔═╡ bf5aaed6-7e81-11eb-3036-cbe315f2a59a
density(diamonds.Price, line=4)

# ╔═╡ fa35967e-7e81-11eb-05bc-ab321c3635c0
md"Building an intuition for skew - What values are moderately and what are highly skewed?"

# ╔═╡ 2c5cdce8-7e82-11eb-3f31-eb1c12783dad
betaslider = @bind beta_slider html"<input type=range min=1 max=10 step=0.1>"

# ╔═╡ 7f9a4eb2-7e83-11eb-2667-7d3c451bfc09
D_skew = Weibull(beta_slider, 1)

# ╔═╡ 70a7f836-7e82-11eb-367d-4125cd359a72
skewness(D_skew)

# ╔═╡ 40d3b36a-7e82-11eb-140c-9757638394e7
dist_plot(D_skew, [0, 3])

# ╔═╡ c080c712-7e83-11eb-1143-158e83f386e2
md"Rule of thumb: 
$0 \leq |\mathrm{skewness}| < 0.5$ is approximately symmetric. 
$0.5 \leq |\mathrm{skewness}| < 1$ is moderatedly skewed. 
$|\mathrm{skewness}| > 1$ is highly skewed. 
"

# ╔═╡ 2b426de4-7e84-11eb-277f-41bf0b1ea003
md"#### Kurtosis"

# ╔═╡ 330784ce-7e84-11eb-3513-374b23f1c836
md"👉Can you think of two distributions with the same mean, standard deviation, and skew, but still being different?"

# ╔═╡ 42f59704-7e84-11eb-1410-e3edb4a255ad
dist_plot(Normal(0, sqrt(5/3)), [-6, 6])

# ╔═╡ 22147248-7e85-11eb-1f56-17469bc96208
dist_plot(TDist(5), [-6, 6])

# ╔═╡ 4b9a1c3a-7e85-11eb-36b8-9b92628a80eb
mean.([Normal(0, sqrt(5/3)) TDist(5)])

# ╔═╡ 5bb290de-7e85-11eb-16a9-45daa0302e09
std.([Normal(0, sqrt(5/3)) TDist(5)])

# ╔═╡ 6023d310-7e85-11eb-0a26-9d85c0398e18
skewness.([Normal(0, sqrt(5/3)) TDist(5)])

# ╔═╡ 97d9cc9c-7e85-11eb-1e65-6d5d3fb245a7
md"👉What is different about the two distributions?"

# ╔═╡ 9f460e70-7e85-11eb-2c83-776eb9a8a401
begin
	plot(-6:0.1:6, [pdf(Normal(0, sqrt(5/3)), x) for x in -6:0.1:6], label="Normal", line=3)
	plot!(-6:0.1:6, [pdf(TDist(5), x) for x in -6:0.1:6], label="T Distribution", line=3)
end

# ╔═╡ edb98cd0-7e85-11eb-0c7a-57d0fef4c7b3
md"We have taken some area from the _shoulders_ of the normal distribution and added it to the center. We have made the distribution more **peaky** from the normal distribution to the student distribution."

# ╔═╡ dee27332-7e8c-11eb-3896-2566e284cbcd
md"Though the peaky middle is visually arresting, note that the tails of the student distribution are heavier than the tails of the normal distribution."

# ╔═╡ fafcb580-7e93-11eb-139c-5574a72195f1
begin
	plot(5:0.1:10, [pdf(Normal(0, sqrt(5/3)), x) for x in 5:0.1:10], label="Normal", line=3)
	plot!(5:0.1:10, [pdf(TDist(5), x) for x in 5:0.1:10], label="T Distribution", line=3)
end

# ╔═╡ 1328a088-7e94-11eb-1893-8307ec0a0354
md"It is this **heavy tail** behavior that we are trying to capture with kurtosis. More on this shortly."

# ╔═╡ 272b2e92-7e86-11eb-1905-b3c59f94c4b8
md"This heavy tail behavior can be quantified with the fourth centralised and scaled moment."

# ╔═╡ 67d8500a-7e86-11eb-0cfb-916b7df799eb
md"
For continuous pdf $f$:
```math
M_4 = \dfrac{1}{\sigma^4}\int_{-\infty}^{\infty} (x - \mu)^4 f(x) dx
```
And for finite sums:
```math
M_4 = \dfrac{\sum_{i = 1}^N (X_i - \mu)^4}{N\sigma^4}
```
"

# ╔═╡ 06c81c4a-7e87-11eb-2b8b-49c3e2185e5d
md"This measure is called **Kurtosis** which comes for the Greek root for arched or bulging." 

# ╔═╡ 699f856c-7e94-11eb-017f-b57a7bddc047
md"👉 Why does the kurtosis capture tails better than the values close to mean?"

# ╔═╡ 44f4d7ac-7e95-11eb-0bd1-d3eb98605f56
md"This has been a confusion in general and is well documented in [this](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4321753/#:~:text=The%20incorrect%20notion%20that%20kurtosis,rest%20once%20and%20for%20all.) paper helpfully titled _Kurtosis as Peakedness, 1905 – 2014. R.I.P._"

# ╔═╡ f08b0aae-7e87-11eb-2044-f59130ffc70a
kurtosis_(d) = round(quadgk(x -> (x - mean(d))^4 * pdf(d, x), -100, 100)[1] / var(d)^2 * 1000)/1000

# ╔═╡ 7aa15fca-7e8c-11eb-3fd3-93d2e6eef233
kurtosis_.([Normal(0, sqrt(5/3)) TDist(5)])

# ╔═╡ d98262b2-7e8c-11eb-3bf3-5fbf2fa3aaae
md"The higher value of kurtosis, the greater the concentration in the middle and at the tails."

# ╔═╡ 2385d402-7e8d-11eb-07bf-17752bfcc9b6
md"👉 For the skew we had 0 denoting symmetric distribution. How would you define a simliar benchmark for kurtosis?"

# ╔═╡ 5b8f4b08-7e8d-11eb-0039-f5a7fa194ba1
md"Use the kurtosis of the standard normal distribution as a baseline."

# ╔═╡ a615ea5c-7e8c-11eb-2346-a9a9b35a584a
kurtosis_(Normal())

# ╔═╡ 86d649e2-7e8d-11eb-3b53-47bb7f2c6a57
md"Since 3 is an artibrary number, it is a convention to subtract it from the computation of kurtosis so that the **excess kurtosis** for the standard normal distribution is 0. Positive values of excess kurtosis denote heavier tails while negative values denote lighter tails."

# ╔═╡ ce4c4f58-7e8d-11eb-3332-ab9b8d8148b9
md"The `kurtosis` function from `StatsBase.jl` computes the excess kurtosis by default"

# ╔═╡ c9b9ebe2-7e8d-11eb-0890-b3e23ceb3a83
kurtosis(Normal(0, sqrt(5/3)))

# ╔═╡ adc658c8-7e90-11eb-32d9-eb4c98405392
md"For samples when we do not know the population mean and standard deviation, we again need a *correction*:
```math
\mathrm{Kurtosis} = \dfrac{n(n+1)}{(n - 1)(n - 2)(n-3)}\dfrac{\sum_{i = 1}^n (x_i - \overline{x})^4}{s^4} - \dfrac{3(n - 1)^2}{(n - 2)(n - 3)}
```
"

# ╔═╡ 469a8e50-7e93-11eb-21b0-d1df5dfb4b0e
md"The second term is to ensure that we are computing the excess kurtosis"

# ╔═╡ 68e0762c-6c33-11eb-3d59-37d618e5c795
hint(text, title) = Markdown.MD(Markdown.Admonition("hint", title, [text]))

# ╔═╡ 1167a94a-7984-11eb-3af5-c1290bd2781c
hint(md"Measures of spread describe data. They also tell us how useful measures of central tendency are. For instance if a distribution of a data is very wide, then the mean may not be a useful representation of all values in the sample.", "Measures of spread in relation to measures of central tendency")

# ╔═╡ c2f6ff4e-7fef-11eb-0d7e-bd34ab2132af
hint(md"The probability that the maximum of $n$ variates is more than $v$ is given by $(1 - (\mathrm{cdf}(v))^n)$", "Bound on maxima")

# ╔═╡ 502ef336-7b4e-11eb-1984-4fb3fc2696a9
hint(md"$\int u dv = uv - \int v du$", "What is integration by parts")

# ╔═╡ 3b9ea1c0-7e6c-11eb-1cbf-dfe3d0fbc9c1
hint(md"
* Constant offset -> No change in standard deviation.
* Constant scaling by $c$ -> standard deviation scales by $c$.
", "Effect of transformations on standard deviation")

# ╔═╡ a641d362-7e6c-11eb-3a34-e727f9afbaa7
hint(md"The IQR is the measure of spread when the measure of central tendency is median. The IQR gives the interval around the median which contains exactly 50% of the values.", "Median and IQR")

# ╔═╡ bb96eaa6-7e6c-11eb-3251-7dfe84995533
hint(md"The standard deviation is the measure of spread when the measure of central tendency is the mean. For the normal distribution, an interval of length twice the standard deviation around the mean contains about 68% of the values.", "Mean and Standard deviation")

# ╔═╡ 0970b240-7e73-11eb-2ee9-f391e64d584b
hint(md"So far: $M_0$ is 1. $M_1$ is $\mu$. $M_2$ about $\mu$ is $\sigma^2$.", "The story of moments so far")

# ╔═╡ 3fe26ca6-7e91-11eb-1382-dd95809c4187
hint(md"Break up $\sum (X_i - \mu)^3$ into two parts: values $X_i$ that are less than $\mu$ and contribute a negative term and the values $X_i$ that are larger than $\mu$ and contribute a positive term. Negative skew implies that the former outweigh the latter.", "Sign of skew")

# ╔═╡ 7c0b35ac-7e94-11eb-19b8-3fa36803e662
hint(md"
```math
M_4 = \dfrac{\sum_{i = 1}^N (X_i - \mu)^4}{N\sigma^4} = \dfrac{N\sum_{i = 1}^N (X_i - \mu)^4}{\left(\sum_{i = 1}^N (X_i - \mu)^2\right)^2}
```
The outliers have an outsided role in the numerator and outweight the denominator (recall our difference between $\mathbb{E}[X^2]$ and $\mathbb{E}[X]^2$). Hence, the Kurtosis is decided by heavy tails and not by peaky centers.", "Kurtosis and peaks")

# ╔═╡ Cell order:
# ╟─22f18e82-6b7d-11eb-16eb-31758abdb1b0
# ╟─59607216-7b43-11eb-2cf7-3f74231a1839
# ╠═def88812-6b99-11eb-07fb-3f961d7ff6ae
# ╠═c3fd3b6c-6c33-11eb-3efe-57b3d5456387
# ╠═e67f8692-799c-11eb-31bb-09a7f37da454
# ╟─29c96178-7981-11eb-332f-95d53eceb696
# ╟─052cbe72-7984-11eb-0b02-1dd45dc17b3b
# ╟─1167a94a-7984-11eb-3af5-c1290bd2781c
# ╟─baa51422-6b93-11eb-16b7-bf0872dc2bea
# ╟─449528c8-7983-11eb-1148-4fdaa380dcfd
# ╟─4d443e46-7983-11eb-33e3-316d616ad44b
# ╠═9119e782-7984-11eb-25cb-471cefe4e7d5
# ╠═9642a69e-7988-11eb-069e-157feefb4eed
# ╠═9a2fe03e-7988-11eb-09ea-b709a8cbd77c
# ╠═d781854e-7988-11eb-385e-e3dedbaae06e
# ╠═a70ee822-7988-11eb-112e-5be62d6310c4
# ╠═ba3e633c-7988-11eb-2550-4b645fb2439d
# ╟─dde99fd6-7988-11eb-061a-15e9399613b6
# ╠═88d2e984-7984-11eb-3f4c-5115712ac1a2
# ╠═a7f67e52-7984-11eb-22b1-69c114b468fb
# ╟─bd098168-7986-11eb-110c-c5d17c258584
# ╠═cf8e1c18-7984-11eb-20f9-3ff941f8b457
# ╟─04a88244-7985-11eb-328d-6f3878193236
# ╟─aba0e4f6-7985-11eb-0713-172db02e7224
# ╟─d961ff42-7985-11eb-37d2-35af70b59310
# ╟─6636f208-7987-11eb-16a3-17e36a925c97
# ╟─1b6955c0-7986-11eb-180f-6fabd0e6cf36
# ╟─e7e6e6de-7987-11eb-2fc7-37fab2d3c05b
# ╟─eba873f4-7988-11eb-0c30-372c31f4cad8
# ╟─0697dcea-7989-11eb-0ead-8d17b8f4b6cd
# ╠═47ae6534-7984-11eb-3be1-3501475c06f9
# ╠═98f6a88c-7984-11eb-3882-d121f8488565
# ╟─f6fa502e-7cce-11eb-028e-c790c42e9bc2
# ╟─c2f6ff4e-7fef-11eb-0d7e-bd34ab2132af
# ╟─554abfc4-7ccf-11eb-25fb-df246eee94a0
# ╟─4a80d04c-7989-11eb-109b-4789a2c1480a
# ╟─87d63e9a-798a-11eb-393f-e59d4eb48bea
# ╟─98bc8d9a-798a-11eb-1fc3-0bd77bb3fe8c
# ╟─bc770cc6-798a-11eb-0333-c746ba22dc7f
# ╠═08692f0e-798b-11eb-2b02-9548f1a59426
# ╠═b0ea2b14-798c-11eb-0a6c-6f06820a0fa1
# ╟─15a6fa1e-798d-11eb-187e-b93de64da00b
# ╟─1aa85896-798d-11eb-15ff-7f64835af8c8
# ╟─24b05384-798d-11eb-346a-77856d43c699
# ╟─70ef989a-798d-11eb-1899-f51410a810eb
# ╠═970787c2-798d-11eb-12c7-bfd48299c383
# ╟─4b5fb2f4-798b-11eb-1af8-33890aaf0ed4
# ╠═242401ba-798b-11eb-31ed-07d5767cf6f2
# ╠═8071095e-798b-11eb-3e86-0b137ae8360f
# ╟─8842e8aa-798b-11eb-1746-f36c13e7c8ba
# ╟─5d79259e-798b-11eb-298a-b58a6288162e
# ╟─2f1b4990-798e-11eb-31fb-dbc8934ccdfb
# ╟─42b201a8-799d-11eb-00ce-27483756dce2
# ╟─673294b4-799d-11eb-07ac-9dbd30c54541
# ╠═6fce44da-799d-11eb-1be4-8b0d2097ce9a
# ╟─92d81aa8-799d-11eb-25e3-7b2d722ba0c2
# ╟─1082bef2-7989-11eb-0137-f36a82244d4f
# ╟─81db5570-79b2-11eb-2dcb-5b908ad62b3f
# ╟─0c4ac2ae-79b3-11eb-09be-b385fd8dd389
# ╠═5ae7f7e6-79b4-11eb-1609-470cf5246eb7
# ╠═95d0b9b0-79b4-11eb-2120-978ee85a75a3
# ╟─40841800-79b7-11eb-2667-25b9a152246d
# ╟─5aec1d14-79b7-11eb-0342-997f50dbe294
# ╟─b420b066-79b7-11eb-16f6-9fa333021ea9
# ╟─c8fa957e-79b7-11eb-355c-db21c14bccdc
# ╟─f84b2414-79b3-11eb-29d0-a3da4a9d41be
# ╟─5be6eb56-79b0-11eb-10a2-2bd5979f3a63
# ╟─1b53b1cc-79bb-11eb-16c2-a799ed6bafbd
# ╟─1056b4f2-79b3-11eb-09a6-9f7ffaf3b5e3
# ╟─b4645be0-7b49-11eb-1f50-9328aece496b
# ╟─07703e92-7b4a-11eb-0aa6-7180b261728c
# ╟─7e72da22-7cd2-11eb-3de0-93e1435b1987
# ╠═a0b559f6-79bb-11eb-0bb5-eb2b8e341b3c
# ╠═842b718a-79bb-11eb-15e3-fd52f3ed3be4
# ╠═1d2029b0-7b44-11eb-2df3-cf8c03c6c009
# ╠═369e4a72-7b44-11eb-2947-d198ea29598e
# ╠═549ce572-7b44-11eb-3ea9-3334c962ca90
# ╟─cc201ce0-7b44-11eb-37fc-358d02e2d8ed
# ╠═5a33dad6-7b44-11eb-36cb-034dc4851a01
# ╠═671c8c5a-7b44-11eb-0302-53101084c5a6
# ╠═7195a696-7b44-11eb-1073-91f2060f0fd5
# ╠═2e18943a-7ff1-11eb-1d35-7f2019c6c06e
# ╟─d4f04180-7b45-11eb-210a-75f898949c20
# ╟─afde9040-801a-11eb-3907-4f9f38b66893
# ╟─edf6aaae-7b45-11eb-3e5c-ff386f3ca855
# ╟─9ebeb81e-7cd2-11eb-3842-67d666de0d56
# ╟─176b9300-7b47-11eb-34f5-e9f401587fbb
# ╟─10813aba-7b46-11eb-15ae-9d34277557aa
# ╟─522289b6-7b47-11eb-2e36-f1fcaad71e46
# ╟─09b45022-7b49-11eb-3a09-25e2c5f15d5a
# ╠═dfaca6b8-7b47-11eb-3232-c395a968eab0
# ╠═ce181838-7b47-11eb-09fb-21ae2437e92f
# ╟─c3f0eb9c-7e5c-11eb-11ab-b39896644d0e
# ╟─1cf14bf8-7b4a-11eb-057c-cd6c391812d7
# ╟─8fe26172-7b4a-11eb-3fec-25a023ad0c21
# ╟─413e485c-7b4b-11eb-212e-81acd087a606
# ╠═1457d8d0-7b4b-11eb-3b05-fdea9ad03b02
# ╠═17a48a4c-7b4b-11eb-0935-c78e3fbe8875
# ╟─5f6eae0c-7b4b-11eb-1f34-891b85a352b3
# ╠═843168c4-7b4b-11eb-2d50-f50df5c611b5
# ╟─93ba3102-7b4b-11eb-1e40-4d22cef75d41
# ╟─5508697c-7e5d-11eb-18c8-0f27ee5cb6be
# ╟─754bdb0e-7e5d-11eb-24ea-a15f33748d49
# ╟─a39d3d72-7e5d-11eb-3fa8-b57f67497390
# ╟─8f75f92a-7ff1-11eb-07db-07a8b1ee8fd3
# ╟─c16cb486-7e5d-11eb-3931-616157e00d6d
# ╠═cb9c1654-7e5d-11eb-12a4-b1b814fb894a
# ╠═222b0534-7e5e-11eb-07ee-599111a5a85e
# ╠═3c7d66e8-7e5e-11eb-156b-bf16ab97429b
# ╠═1ba1e9a6-7e5e-11eb-26c0-c3259ca71dfa
# ╠═5802e8a2-7e5e-11eb-0e69-2d5da350e203
# ╠═72d949fa-7e5e-11eb-3661-8f14b46a3336
# ╟─a1d2283a-7e5e-11eb-0c22-a91232575d2e
# ╟─01c7f2d0-7e5d-11eb-0134-b527c31615cd
# ╟─eff8182c-7b4c-11eb-3608-077859fd9405
# ╟─3795afc2-7e5f-11eb-04dd-650633462059
# ╟─2f9ccf56-7b4d-11eb-0620-85cc73e63986
# ╟─5723264a-7b4d-11eb-3d80-d728e4e125ea
# ╟─393eab66-7e60-11eb-138b-b7b5d7578b9e
# ╟─50be8e64-7e60-11eb-0bde-770db17176c5
# ╟─8af58b82-7e60-11eb-345b-f5497a167d14
# ╟─5d793888-7b4d-11eb-1760-7d6e5a06d299
# ╟─45d7729e-7b4e-11eb-16b8-9fe470c4422a
# ╟─502ef336-7b4e-11eb-1984-4fb3fc2696a9
# ╟─8f23a268-7b52-11eb-14d3-a19f581d662e
# ╟─e62703f0-7e60-11eb-061b-05e2ebbae775
# ╟─d06cb7e4-7b45-11eb-0ecb-3fb5bd004188
# ╟─e7ee031a-7b44-11eb-1109-6d05b4ddca2e
# ╠═2806eb6a-7b45-11eb-227a-93964c77e93b
# ╠═89e42a9c-7b44-11eb-315d-7974de3531d9
# ╟─4c62ba78-7e62-11eb-080e-9f49bb8a60fb
# ╟─7953f36c-7e62-11eb-318c-c30dc4038629
# ╟─fc298e8e-7e62-11eb-1275-bfaaba9e6d13
# ╠═35da102c-7e61-11eb-3068-3f8961843a9f
# ╠═5d6f375c-7e61-11eb-28ab-4561d1cabdb9
# ╠═501021f2-7e61-11eb-3205-03823f96e0ba
# ╟─14bf236c-7e63-11eb-31c0-1b57f03ae4ff
# ╟─711c29be-7e65-11eb-0aad-8f82e60e2ece
# ╟─5ceecd68-7e63-11eb-20a2-cf9cdf7e1758
# ╟─fab8dd52-7e65-11eb-3456-8708ccd8cd4f
# ╠═f054b9aa-7e63-11eb-36dd-3bf1932030ac
# ╠═9c434dd6-7e63-11eb-3bba-736c1f794722
# ╠═7b34bb66-7e63-11eb-2e44-1b00e23874cb
# ╠═660f6682-7e63-11eb-396d-77ef6e6f1de2
# ╟─624943a8-7e66-11eb-12b0-6f9a43405d16
# ╟─8848bee0-7e6a-11eb-0cb3-63001bba774d
# ╟─91787884-7e6a-11eb-3821-a11457bb4bfa
# ╟─db73f682-7e6a-11eb-2890-adea119688ab
# ╠═d4666004-7e6a-11eb-1502-41d2bdf3df30
# ╠═fec9f55c-7e6a-11eb-337c-13273fff4450
# ╟─01e8107c-7e6b-11eb-1e0b-fd862028439a
# ╟─258692fe-7e6b-11eb-3401-e9e8d96483fe
# ╟─2b9af64e-7e6b-11eb-11be-714f382922dc
# ╠═0fc0b998-7e6b-11eb-34be-8be4f0e4fe08
# ╠═190b6e28-7e6b-11eb-069c-dbaa847caa19
# ╟─3e31d85c-7e6b-11eb-0cb8-6d171248d19d
# ╟─2cc216d4-7e6c-11eb-09c8-ddaa8b9b05b5
# ╟─3b9ea1c0-7e6c-11eb-1cbf-dfe3d0fbc9c1
# ╟─99172a5c-7e6c-11eb-39db-b76d5eb6403f
# ╟─a641d362-7e6c-11eb-3a34-e727f9afbaa7
# ╟─bb96eaa6-7e6c-11eb-3251-7dfe84995533
# ╟─e700935c-7e6c-11eb-3c5f-79ee52818f27
# ╟─ec198862-7e6c-11eb-2368-cb1d288a537a
# ╟─0121fce4-7e6d-11eb-00a3-77cef143d4e0
# ╟─272137ca-7e6d-11eb-1ccb-491acdf93e80
# ╟─5d67d74a-6b93-11eb-0df5-01899af4b4ab
# ╠═a53d2cd8-7e6e-11eb-1265-c3df598243b6
# ╟─add3881e-7e74-11eb-24d0-c3909978a450
# ╠═bbf9ee7a-7e6e-11eb-06d9-21df405b04a2
# ╠═ba25c50c-7e74-11eb-248f-95e03691af90
# ╟─c2e4c756-7e74-11eb-330c-db0b6ea51886
# ╠═c8c0d22e-7e6e-11eb-1e6d-37acc66bdadb
# ╠═ca2cce42-7e6e-11eb-1b9a-8958575b107e
# ╠═1024a3ec-7e70-11eb-3b96-391f330cfb32
# ╟─0e46c762-7e70-11eb-2650-135cff7436b8
# ╟─30f7ecf0-7e70-11eb-13d5-75ace1ff42cd
# ╟─371558a2-7e70-11eb-1661-430f14e76302
# ╠═907116e8-7e70-11eb-333f-290f0a7d80e8
# ╠═4766721c-7e71-11eb-0dd7-69fdac58cc30
# ╠═661feb52-7e71-11eb-1bf0-5b4a4f4e1c02
# ╠═719b971a-7e71-11eb-1a2d-e1b67112c405
# ╟─56e6b8f2-7e71-11eb-1203-75faf28f79e0
# ╟─b3419d86-7e71-11eb-1a63-87efbffc5d90
# ╠═c7d99398-7e71-11eb-2a80-e1ee835a675d
# ╠═cc00e586-7e71-11eb-05b9-c92bdd03dc26
# ╟─e3b93278-7e71-11eb-01fb-c1fb19c1af97
# ╠═8c02ca6a-7e71-11eb-0533-f56d312294ac
# ╟─d9d0162a-7e72-11eb-143c-a7a0fdaa02e4
# ╟─0970b240-7e73-11eb-2ee9-f391e64d584b
# ╟─629dae04-7e73-11eb-1075-69cffc768b82
# ╟─6e49f3b0-7ff3-11eb-00b5-2157914eb9ed
# ╟─da31badc-7e73-11eb-34a0-75d05bc41291
# ╟─0d7fbfbe-7e91-11eb-14eb-ed9b68f7b02e
# ╟─3fe26ca6-7e91-11eb-1382-dd95809c4187
# ╟─6be14370-7e70-11eb-36c1-97d6b5ab2e2a
# ╠═377f3020-7e74-11eb-22d1-3bf79ca13e7a
# ╠═649cd9e0-7e74-11eb-0997-4f7390f13936
# ╠═89350110-7e74-11eb-0cb1-6bb00c61e12b
# ╠═b39bb5ac-7e81-11eb-3da9-fb2f6ece1f8a
# ╠═b5d346f4-7e81-11eb-15a4-657b672f23a5
# ╠═bf5aaed6-7e81-11eb-3036-cbe315f2a59a
# ╟─fa35967e-7e81-11eb-05bc-ab321c3635c0
# ╠═2c5cdce8-7e82-11eb-3f31-eb1c12783dad
# ╠═7f9a4eb2-7e83-11eb-2667-7d3c451bfc09
# ╠═70a7f836-7e82-11eb-367d-4125cd359a72
# ╠═40d3b36a-7e82-11eb-140c-9757638394e7
# ╟─c080c712-7e83-11eb-1143-158e83f386e2
# ╟─2b426de4-7e84-11eb-277f-41bf0b1ea003
# ╟─330784ce-7e84-11eb-3513-374b23f1c836
# ╠═42f59704-7e84-11eb-1410-e3edb4a255ad
# ╠═22147248-7e85-11eb-1f56-17469bc96208
# ╠═4b9a1c3a-7e85-11eb-36b8-9b92628a80eb
# ╠═5bb290de-7e85-11eb-16a9-45daa0302e09
# ╠═6023d310-7e85-11eb-0a26-9d85c0398e18
# ╟─97d9cc9c-7e85-11eb-1e65-6d5d3fb245a7
# ╠═9f460e70-7e85-11eb-2c83-776eb9a8a401
# ╟─edb98cd0-7e85-11eb-0c7a-57d0fef4c7b3
# ╟─dee27332-7e8c-11eb-3896-2566e284cbcd
# ╠═fafcb580-7e93-11eb-139c-5574a72195f1
# ╟─1328a088-7e94-11eb-1893-8307ec0a0354
# ╟─272b2e92-7e86-11eb-1905-b3c59f94c4b8
# ╟─67d8500a-7e86-11eb-0cfb-916b7df799eb
# ╟─06c81c4a-7e87-11eb-2b8b-49c3e2185e5d
# ╟─699f856c-7e94-11eb-017f-b57a7bddc047
# ╟─7c0b35ac-7e94-11eb-19b8-3fa36803e662
# ╟─44f4d7ac-7e95-11eb-0bd1-d3eb98605f56
# ╠═f08b0aae-7e87-11eb-2044-f59130ffc70a
# ╠═7aa15fca-7e8c-11eb-3fd3-93d2e6eef233
# ╟─d98262b2-7e8c-11eb-3bf3-5fbf2fa3aaae
# ╟─2385d402-7e8d-11eb-07bf-17752bfcc9b6
# ╟─5b8f4b08-7e8d-11eb-0039-f5a7fa194ba1
# ╠═a615ea5c-7e8c-11eb-2346-a9a9b35a584a
# ╟─86d649e2-7e8d-11eb-3b53-47bb7f2c6a57
# ╟─ce4c4f58-7e8d-11eb-3332-ab9b8d8148b9
# ╠═c9b9ebe2-7e8d-11eb-0890-b3e23ceb3a83
# ╟─adc658c8-7e90-11eb-32d9-eb4c98405392
# ╟─469a8e50-7e93-11eb-21b0-d1df5dfb4b0e
# ╠═68e0762c-6c33-11eb-3d59-37d618e5c795

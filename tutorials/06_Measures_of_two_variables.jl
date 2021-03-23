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

# ╔═╡ 67bd1b94-7f32-11eb-2869-5f075fca7fbc
begin
	using PlutoUI
	using StatsPlots
	using RDatasets
	using StatsBase
	using Distributions
	using LaTeXStrings
end

# ╔═╡ 253ad4f4-8253-11eb-03d8-d358d6075910
md"A mid-sem sample question:

Write a Julia snippet to sample 100 random variates denoted $\{x_1, x_2, \ldots, x_{100}\}$ from the standard normal distribution. Then compute $\dfrac{\sum_{i = 1}^{100} \sum_{j = 1}^{100} (x_i - x_j)^2}{100 \times 100}$."

# ╔═╡ 237d9290-8254-11eb-233a-4d362783d684
begin
	sample_ = rand(Normal(), 100)
	val_ = sum(sum([[(sample_[i] - sample_[j])^2 for i in 1:100] for j in 1:100]))/(100 * 100)
end

# ╔═╡ 8ce2cb16-8253-11eb-21a5-c59e5785950e
md"Run the above a few dozen times and build an intuition for what the value is for different samples in relation to $\sigma^2$ of the underlying distribution. Then deriva analytically $\mathbb{E}[(X - Y)^2]$, where $X$ and $Y$ are two independent random variables sampled from the same distribution with pdf $f$."

# ╔═╡ 22f18e82-6b7d-11eb-16eb-31758abdb1b0
md"# Notebook 6: _Measures of Two Variables_
"


# ╔═╡ 59607216-7b43-11eb-2cf7-3f74231a1839
md"
> 📕Reference material - Chapter 3: Using statistics to summarise data (Section 3.7) from Sheldon Ross.
"

# ╔═╡ 5f510e34-7f32-11eb-158a-afdded4ae4f7
iris = dataset("datasets", "iris");

# ╔═╡ 65c3f4a2-7f32-11eb-0eb4-97a2455d1ac7
diamonds = dataset("ggplot2", "diamonds");

# ╔═╡ b1716986-7e95-11eb-383d-39edf8743454
md"#### Statistics of two variables - Covariance"

# ╔═╡ 67e698c8-7e99-11eb-01c9-eb2703970ea4
md"So far we have been seeing the statistics of one variable. When there are two variables, we are interested in how they are related."

# ╔═╡ c6dc30e0-7e99-11eb-1781-7dba5912b724
md"Basic intuition is to check if increase in one of the variables also leads to an increase or decrase in another. _Do the two variables move together? Do they co-vary?_"

# ╔═╡ b79f4c20-7e99-11eb-3eba-492dc528735d
md"👉 Can you formulate a statistic that may help identify how two variables are related?"

# ╔═╡ 7b13d1a8-7e9a-11eb-39f2-5d3e9a95c811
iris_sample = select!(iris[sample(axes(iris, 1), 5; replace = false, ordered = true), :], Not(:Species))

# ╔═╡ a136b75a-7f04-11eb-1324-c9ea26353914
md"By just working with the petal length and width values, we cannot conclude if they are covarying. Notice how they are both of different scales as well."

# ╔═╡ ff01b9c2-7f02-11eb-2edd-5131a142f119
[mean(iris_sample.PetalLength) mean(iris_sample.PetalWidth)]

# ╔═╡ bbe2eec0-7f04-11eb-3f7f-594d57f134ec
md"Now that we know the mean values of the two columns are different, we can use it to compute offsets for individual values."

# ╔═╡ fc068802-7f03-11eb-36a0-f3764ac250ab
iris_offset = select(iris_sample, :PetalWidth, :PetalLength, :PetalWidth => (x -> x .- mean(x)) => :PW_offset, :PetalLength => (x -> x .- mean(x)) => :PL_offset)

# ╔═╡ eb742c80-7f04-11eb-0435-4f58142bcdc9
md"These offset values are now clearer: If two variables are to co-vary they must do so for these offset values."

# ╔═╡ 2f64101e-7f04-11eb-148b-d1c781173d4c
iris_covar = select(iris_offset, :PetalWidth, :PetalLength, :PW_offset, :PL_offset, [:PW_offset, :PL_offset] => ((x, y) -> x .* y) => :Covariance)

# ╔═╡ 98fcccfc-7f04-11eb-0b2d-6b1feaadfae4
md"All the values in the last column being positive shows that the two values actually co-vary (either both negative or both positive). A natural next step is to simply compute the average of these products."

# ╔═╡ 12e7d1a4-7f05-11eb-19d5-2b072cbafa05
mean(iris_covar.Covariance)

# ╔═╡ 2c8776c8-7f05-11eb-0226-bf1ef7542efd
md"Covariance of two sets of population values $\{X_1, X_2, \ldots, X_N\}$ and $\{Y_1, Y_2, \ldots, Y_N\}$ is given as
```math
\mathrm{COV}(X, Y) = \dfrac{\sum_{i = 1}^N (X_i - \mu_X)(Y_i - \mu_Y)}{N}
```
"

# ╔═╡ 9da0add4-7f05-11eb-1391-0f87db7d41c4
md"We can define this in terms of expectation as 
```math
\mathrm{COV}(X, Y) = \mathbb{E}\left[(X - \mathbb{E}[X])(Y - \mathbb{E}[Y])\right]
```
"

# ╔═╡ a86b8dc4-7f05-11eb-3ca7-e5460fc15b96
md"Notice the parallels to the definition of $\sigma^2$ as $\mathbb{E}[(X - \mathbb{E}[X])^2]$"

# ╔═╡ 2e4af178-7f06-11eb-1247-3501f18174cc
md"👉Class exercise: Just like we rewrote $\sigma^2$ as $\mathbb{E}[X^2] - \mathbb{E}[X]^2$, can you rewrite $\mathrm{COV}(X, Y)$?"

# ╔═╡ e79a0a24-7f06-11eb-3c63-91d44fe78d49
md"Thus, we have $\mathrm{COV}(X, Y) = \mathbb{E}[XY] - \mathbb{E}[X]\mathbb{E}[Y]$"

# ╔═╡ 2be9abbe-824d-11eb-3b1d-2b1ddf16c195
md"👉 What is the covariance of two indpendent random variables $X$ and $Y$?"

# ╔═╡ 483778b4-824d-11eb-196c-2925d31dd603
md"👉 What is $\mathrm{COV}(aX, Y)$?"

# ╔═╡ b818699a-7f37-11eb-088c-a51bed3cbdc0
md"Here is a collection of some basic rules of covariance:

a) $\mathrm{COV}(X, X) = \sigma^2(X)$

b) If $X$ and $Y$ are independent then $\mathrm{COV}(X, Y) = 0$

c) $\mathrm{COV}(X, Y) = \mathrm{COV}(Y, X)$

d) $\mathrm{COV}(aX, Y) = a\mathrm{COV}(X, Y)$

e) $\mathrm{COV}(X + c, Y) = \mathrm{COV}(X, Y)$
"

# ╔═╡ 41664208-7f38-11eb-01f5-c32a33253f15
md"👉Homework exercise to prove these. All of these can be directly provded from the relation $\mathrm{COV}(X, Y) = \mathbb{E}[XY] - \mathbb{E}[X]\mathbb{E}[Y]$"

# ╔═╡ 6dfb60e6-7f38-11eb-070d-b99afff5f5a1
md"👉Class exercise: Show that $\mathrm{COV}(X + Y, Z) = \mathrm{COV}(X, Z) + \mathrm{COV}(Y, Z)$"

# ╔═╡ 2e32a1e2-7f39-11eb-0df0-812f689e1d1f
md"This rule can be generalised to the following
```math
\mathrm{COV}\left(\sum_i^m a_i X_i, \sum_j^n b_j Y_j\right) = \sum_i^m \sum_j^n a_i b_j \mathrm{COV}(X_i, Y_j)
```
"

# ╔═╡ c4d2c9d0-7f39-11eb-2ac9-373ed723a3f4
md"A neat application of the above is when we compute the variance of the sum of two random variables."

# ╔═╡ ce6afe4a-7f39-11eb-19f1-7157457700cd
md"
```math
\sigma^2(X + Y) = \mathrm{COV}(X+Y, X+Y)
```
```math
= \mathrm{COV}(X, X) + \mathrm{COV}(X, Y) + \mathrm{COV}(X, Y) + \mathrm{COV}(Y, Y)
```
```math
= \sigma^2(X) + 2\mathrm{COV}(X, Y) + \sigma^2(Y)
```
"

# ╔═╡ 175b1608-7f3a-11eb-0dfb-dd2ee73b9bac
md"Thus, we can interpret the covariance as half the value by which the variance of the sum increases from the sum of the variances for any two random variables."

# ╔═╡ fe62b640-8251-11eb-25fe-2b8aa69000ce
md"So we have seen three ways of computing covariance"

# ╔═╡ 27d06de0-7f07-11eb-23ce-4d6547ce31f6
mean(iris_covar.Covariance)

# ╔═╡ 0359bc70-7f07-11eb-2daa-d1f2a258d9e0
mean(iris_covar.PetalWidth .* iris_covar.PetalLength) - mean(iris_covar.PetalWidth) * mean(iris_covar.PetalLength)

# ╔═╡ a8c20bc6-8251-11eb-0d06-819a786e2b05
(var(iris_covar.PetalWidth .+ iris_covar.PetalLength, corrected=false) - var(iris_covar.PetalWidth, corrected=false) - var(iris_covar.PetalLength, corrected=false))/2

# ╔═╡ 9c42421a-7f0d-11eb-0172-f34b4adfa5f0
md"Notice that the covariance (like variance) has units that are product of the units of the individual variables. In the case of the iris dataset, the covariance we computed has the unit of length-squared."

# ╔═╡ 502bc23a-7f07-11eb-0b40-97e7e2a8a9ca
md"We can also directly use the `cov` function from `StatsBase`"

# ╔═╡ 2938c2ac-7f07-11eb-279c-ab02e04ac679
cov(iris_covar.PetalWidth, iris_covar.PetalLength, corrected=false)

# ╔═╡ 59828c88-7f07-11eb-1462-73e3850659fd
md"Notice we have used the `corrected = false` argument. This is because we are treating the dataset as a population. But in reality it is a sample and hence we need our correction." 

# ╔═╡ a48951d0-7f07-11eb-0052-7d06cf26028c
md"Covariance of two sets of sample values $\{x_1, x_2, \ldots, x_n\}$ and $\{y_1, y_2, \ldots, y_n\}$ is given as
```math
\mathrm{COV}(x, y) = \dfrac{\sum_{i = 1}^n (x_i - \overline{x})(y_i - \overline{y})}{n - 1}
```
"

# ╔═╡ e0d54d10-7f07-11eb-214a-bd24b8accb1a
md"With this correction, the covariance is larger"

# ╔═╡ ec51f080-7f07-11eb-2559-5b4cf71a2d0e
cov(iris_covar.PetalWidth, iris_covar.PetalLength)

# ╔═╡ ef48b742-7f07-11eb-18e0-f1bcc96c86e0
md"We can then compute it for the entire dataframe instead of the small sample we were studying"

# ╔═╡ dc4d1258-7e99-11eb-25e2-ffcd05171460
cov(iris.PetalLength, iris.PetalWidth)

# ╔═╡ fa8d1044-7f07-11eb-247e-a18ecff0f4f3
md"Notice again that the large positive value of the covariance indicates that the two variable covary, This is easy to see in the following scatter plot."

# ╔═╡ 182c2ca2-7e9a-11eb-040a-21429d245b4f
scatter(iris.PetalLength, iris.PetalWidth)

# ╔═╡ 2348b81e-7f08-11eb-3070-25becdb70c5a
md"The shapes of the scatter plots reveals the covariance values."

# ╔═╡ 85e8d916-7f08-11eb-094c-17dbb38c5048
begin
	x1_ = rand(Normal(5, 2), 1000);
	y1_ = x1_ + rand(Normal(5, 1), 1000);
end

# ╔═╡ ed8c0606-7f08-11eb-13ec-d166c29a4d67
scatter(x1_, y1_, title="Covariance = " * string(cov(x1_, y1_)))

# ╔═╡ 175b39a2-7f09-11eb-02d7-c91ba9204c3c
begin
	x2_ = rand(Normal(5, 2), 1000);
	y2_ = rand(Normal(5, 2), 1000);
end

# ╔═╡ 1d4a9088-7f09-11eb-3754-07c4947ecad7
scatter(x2_, y2_, title="Covariance = " * string(cov(x2_, y2_)))

# ╔═╡ 27426ea6-7f09-11eb-3c2f-c9d5d5ed33b8
begin
	x3_ = rand(Normal(5, 2), 1000);
	y3_ = -x3_ + rand(Normal(5, 1), 1000);
end

# ╔═╡ 307bf5dc-7f09-11eb-3e23-8908558e17ca
scatter(x3_, y3_, title="Covariance = " * string(cov(x3_, y3_)))

# ╔═╡ 5a6fb146-7f09-11eb-02b3-0b2bc301eb95
md"So absolute value of covariance denotes the strength of the relationship while the sign denotes the direction (aligned is positive and oppositely aligned is negative). Two variables with 0 covariance are unrelated to each other."

# ╔═╡ 882610e4-7f09-11eb-142b-9d8ed5e88fcc
md"In real world data, we need to be careful about mixing data from different groups. For instance consider the covariance between petal length and sepal width acrsoss all flowers."

# ╔═╡ 0019040c-7e9a-11eb-3ab3-698eb0f98231
cov(iris.PetalLength, iris.SepalWidth)

# ╔═╡ 241c6342-7e9a-11eb-2053-c1984c19a023
scatter(iris.PetalLength, iris.SepalWidth)

# ╔═╡ 54ccb922-7f0a-11eb-3ba6-230b0489d928
md"The covariance value for all data together is negative. But the graph does show a positive slope."

# ╔═╡ 6273fb94-7f0a-11eb-3c1a-4dfa9d925400
md"We can gropuby the species column and compute covariance for each group separately"

# ╔═╡ b9d98800-7f09-11eb-3671-ed27dbde1c3a
combine(groupby(iris, :Species), [:PetalLength, :SepalLength] => ((x, y) -> cov(x, y))  => :Covariance)

# ╔═╡ 711d46a0-7f0a-11eb-15d7-b5b17afdeeaa
md"Each of the groups have a positive covariance (though not high) between the two variables."

# ╔═╡ 80fc7f8c-7f0a-11eb-3afd-4796a222b202
md"👉Repeat this exercise for sepal length and width variables"

# ╔═╡ 09b71b5a-7e9a-11eb-07dd-e7eabcdb50ef
cov(iris.SepalLength, iris.SepalWidth)

# ╔═╡ 2aaca4f6-7e9a-11eb-3071-fdd5483fb812
scatter(iris.SepalLength, iris.SepalWidth)

# ╔═╡ fb4be732-7f0a-11eb-2b25-b3b18d6cba8a
md"👉So far, the covariance seems like a good measure to relate two variables. Do you see a downside? Hint: When is covariance high?"

# ╔═╡ 031f2f2c-7f0c-11eb-25b7-eb7530aa62af
md"As an example consider the following two sets of covariance computations and then see the corresponding scatter plots."

# ╔═╡ 146d1aaa-7f0c-11eb-00ae-fb7ed270927b
begin
	x4_ = rand(Normal(5, 5), 1000);
	y4_ = 0.1 * x4_ + rand(Normal(5, 5), 1000);
	cov(x4_, y4_)
end

# ╔═╡ 331c74be-7f0c-11eb-1195-cf4e817f61d3
begin
	x5_ = rand(Normal(5, 0.5), 1000);
	y5_ = 1 * x5_ + rand(Normal(5, 0.5), 1000);
	cov(x5_, y5_)
end

# ╔═╡ 3cb5b896-7f0c-11eb-324d-6d745f9c3796
scatter(x4_, y4_, title="Covariance = " * string(cov(x4_, y4_)))

# ╔═╡ 4f001262-7f0c-11eb-2422-1ff23f6065a1
scatter(x5_, y5_, title="Covariance = " * string(cov(x5_, y5_)))

# ╔═╡ 6acc6cfc-7f0c-11eb-3522-174161cba17b
md"Clearly by comparing the covariance between these two sets we come to the wrong conclusion that the relationship is stronger for the first set. We thus need to **normalize** the covariance"

# ╔═╡ a8744e0a-7e95-11eb-1931-b1cdda813e0f
md"#### Statistics of two variables - Correlation"

# ╔═╡ 716cb26e-6b94-11eb-1cb0-b9c2f5608b5f
md"Correlation essentially fixes the problem we discovered - of normalizing covariance . 👉 Can you guess how?"

# ╔═╡ aff1b65e-7f0c-11eb-30de-45877373262c
md"The correlation between two sets of populations $X$ and $Y$ is given as
```math
\rho_{X, Y} = \dfrac{\mathrm{COV}(X, Y)}{\sigma_X \sigma_Y}
```
where $\sigma_X$ and $\sigma_Y$ are the standard deviations of $X$ and $Y$, respectively. 
"

# ╔═╡ 3117ff70-7f0d-11eb-1c0a-95af44530f05
md"The corresponding equation for two samples $x$ and $y$ is given as
```math
\rho_{x, y} = \dfrac{\mathrm{COV}(x, y)}{s_x s_y}
```
where $s_x$ and $s_y$ are the standard deviations of $x$ and $y$, respectively. 
"

# ╔═╡ a4933666-7f16-11eb-34fa-295373733b14
md"The above definition of correlation is called the _Pearson correlation coefficient_."

# ╔═╡ 5510b24e-7f0d-11eb-15a2-6714879d78f4
md"👉What is the unit of correlation?"

# ╔═╡ 93baa848-7f0e-11eb-2700-bfc3181e0f21
md"👉Class exercise: What are the minimum and maximum possible values of $\rho_{x, y}$?"

# ╔═╡ 9115a164-7f0f-11eb-3946-453ad1a450a0
md"Let us algebraically manipulate the formula of the correlation. Note that for simplicity I am dropping the limits of the summation. In all cases, they are going from $i = 1$ to $i = n$."

# ╔═╡ a731ef30-7f0e-11eb-24f0-5d102ea4a13a
md"
```math
\rho_{x, y} = \dfrac{\mathrm{COV}(x, y)}{s_x s_y} = \dfrac{\left(\sum((x_i - \overline{x})(y_i - \overline{y})\right)/(n - 1)}{\sqrt{\sum(x_i - \overline{x})^2} \sqrt{\sum(y_i - \overline{y})^2}/(n - 1)}
```
```math
\rho_{x, y}^2 = \dfrac{\left(\sum((x_i - \overline{x})(y_i - \overline{y})\right)^2}{\sum(x_i - \overline{x})^2 \sum(y_i - \overline{y})^2} = \dfrac{(\sum a_ib_i)^2}{\sum a_i^2 \sum b_i^2}
```
"

# ╔═╡ 6d579f98-7f0f-11eb-26ea-c381d36153f3
md"The Cauchy Schwarz inequality provides a bound on the RHS. It states:
```math
\left(\sum a_i b_i\right)^2 \leq \left(\sum a_i^2\right) \left(\sum b_i^2\right)
```
For a proof see [this article](https://mathworld.wolfram.com/CauchysInequality.html). 
"

# ╔═╡ cdbe10ce-7f0f-11eb-303e-8f9f3527ce25
md"Applying this back, we have $\rho^2_{x, y} \leq 1$ and thus $\rho_{x, y} \in [-1, 1]$"

# ╔═╡ e33ba8e4-7f0f-11eb-36b2-039693234b96
md"👉When are the limits obtained?"

# ╔═╡ ebaeb804-7f0f-11eb-1621-216682cc1e62
md"The equality holds when $a_i = cb_i + \delta$ for all $i$ for some constant $c$. So the extreme values of correlation occur when $\rho_{x, y} = \mathrm{Sign}(c)$ if $\dfrac{(x_i - \overline{x})}{(y_i - \overline{y})} = c$ for all values in the sample"

# ╔═╡ 5adeedd8-7f11-11eb-185e-eb4b7521074b
cslider = @bind c_slider html"<input type=range min=-50 max=45 step=1>"

# ╔═╡ f1b4a228-7f10-11eb-3149-8f86ab1fd053
begin
	x6_ = rand(Normal(), 1000)
	y6_ = x6_ .* c_slider
	cor(x6_, y6_)
end

# ╔═╡ b633765a-7f10-11eb-2c80-f3cd7302ab5a
md"So, $\rho$ is unitless and has maximum and minimum values which allow us to compare across data fields or sets. We can check this with our two datasets from before."

# ╔═╡ e8bdb338-7f10-11eb-0b2d-47d7f358334f
scatter(x4_, y4_, title="Covariance = " * string(round(cov(x4_, y4_) * 1000)/1000) * ". Correlation = " * string(round(cor(x4_, y4_) * 1000)/1000), label=false)

# ╔═╡ e3cf7068-7f11-11eb-0645-1d988c17ea0f
scatter(x5_, y5_, title="Covariance = " * string(round(cov(x5_, y5_) * 1000)/1000) * ". Correlation = " * string(round(cor(x5_, y5_) * 1000)/1000), label=false)

# ╔═╡ 0e4169dc-7f12-11eb-1f09-695a9cbff347
md"The bottom case has now much higher correlation because we have scaled for the low standard deviation of the two individual variables."

# ╔═╡ 6d5a3c1e-7f12-11eb-244f-2787db2ff86b
md"We can use the `cor` function for dataframe columns also."

# ╔═╡ 4f405416-7f12-11eb-072f-b5ebf6ecdb89
cor(iris.PetalLength, iris.PetalWidth)

# ╔═╡ f678bd9a-7f12-11eb-3b82-0748786b4b75
md"For dataframes, it is usually helpful to compute pair-wise covariance and correlation between a set of quantitative variables. There is no built-in method for this, so we will use this one from [this forum](https://discourse.julialang.org/t/covariance-from-dataframe-or-timearray/48375/2)."

# ╔═╡ fd483aba-8584-11eb-1af1-fd7ba22276ba
md"👉What do you expect in the diagonals of such a matrix/"

# ╔═╡ 6c2b36ea-7f12-11eb-3b91-5f6186dd5ce3
function covmat(df)
   nc = ncol(df)
   t = zeros(nc, nc)
   for (i, c1) in enumerate(eachcol(df))
	   for (j, c2) in enumerate(eachcol(df))
		   sx, sy = skipmissings(c1, c2)
		   t[i, j] = cov(collect(sx), collect(sy))
	   end
   end
   return t
   end;

# ╔═╡ 3ae44970-7f13-11eb-3222-25121d19dfa0
covmat(select(iris, Not(:Species)))

# ╔═╡ 1387ed38-7f14-11eb-0f7b-c3deea1d8d76
md"Notice that the matrix is symmetric and the values on the diagonal are all positive"

# ╔═╡ 67b909b0-7f13-11eb-36ca-f74db0715854
propertynames(iris)

# ╔═╡ 11ef7960-8585-11eb-2dc3-7fa091595dbb
md"Now let us do the same with correlation. 👉What do you expect in the diagonals of such a matrix/"

# ╔═╡ 0376056a-7f14-11eb-0af4-45c83b91ff94
function cormat(df)
   nc = ncol(df)
   t = zeros(nc, nc)
   for (i, c1) in enumerate(eachcol(df))
	   for (j, c2) in enumerate(eachcol(df))
		   sx, sy = skipmissings(c1, c2)
		   t[i, j] = cor(collect(sx), collect(sy))
	   end
   end
   return t
   end;

# ╔═╡ 07f0fc76-7f14-11eb-14ef-ed4a723c9f39
cormat(select(iris, Not(:Species)))

# ╔═╡ 1cf0720a-7f14-11eb-28af-c73c1f94fa63
md"Notice that the values on the diagonal are now all 1. The sign of covariance and correlation is the same, but they have all been scaled up. It is easier to conclude on relatedness of variables with the correlation."

# ╔═╡ 681cbce8-7f14-11eb-30d6-17d3f7f5f116
cormat(select(diamonds, [:X, :Y, :Z, :Price]))

# ╔═╡ 5ce49422-7f14-11eb-3959-4fb5d18d1f38
md"The dimensions of the diamonds along different axes are highly correlated. Naturally the price also is correlated with the dimensions."

# ╔═╡ 76ff24b4-7f15-11eb-33c1-6118de89b12f
md"Rule of thumb: If $|\rho| > 0.5$, then we say the two samples are highly correlated. For $0.3 < |\rho| < 0.5$, we say there is moderate correlation. And for $|\rho| < 0.3$, the variables are uncorrelated or weakly correlated."

# ╔═╡ 62023c38-7f15-11eb-039c-e5020554a66f
md"👉What does a high absolute value of the correlation coefficient actually mean?"

# ╔═╡ 71394f5c-7f15-11eb-156d-27290791641f
md"If $|\rho|$ is high then we are confident of a **linear** relationship between the two samples."

# ╔═╡ 1fc41aca-7f16-11eb-331d-072d0e72cf16
md"This means that even if there is an exact _non-linear_ relationship between two variables, the correlation coefficient can be close to 0."

# ╔═╡ 35f0324a-7f16-11eb-159b-1f6056dad3f9
md"Consider the following case where there is a quadratic relationship between the two variables, but the correlation close to 0."

# ╔═╡ 577ceeb8-7f15-11eb-3700-cd396e2622b1
scatter(x5_, (x5_ .- mean(x5_)).^2, title="Correlation = " * string(cor(x5_, (x5_ .- mean(x5_)).^2)))

# ╔═╡ 59545e4e-7f16-11eb-03ae-a796f324110d
md"Thus the correlation coefficient is only a way to check a linear relatedness between variables. Often this itself is very useful in practice. For instance, does adminstering a vaccine reduce the spread of a disease? Or does adding a new modification to the engine increase range of an electric car?"

# ╔═╡ 9f311f58-7f16-11eb-2909-cb836b098441
md"But we must recognise that in most of machine learning today, we are interested in complex non-linear relationships. In such cases, the correlation coefficient may not be of much significance."

# ╔═╡ 3e702d8e-7f33-11eb-271d-5956d16a7e7d
md"👉 Can you think of a linear relationship that you would study in most ML problems?"

# ╔═╡ ed9d08b4-7f32-11eb-04b1-ef5a467dabea
md"👉Do you see a major limitation with this measure?"

# ╔═╡ 09a0093e-7f34-11eb-2210-ff1d72e9637a
md"We know that the mean (and hence offset from mean) and the standard deviation of any sample is adversely affected by outliers. So, it is likely that the Pearson correlation coefficient is also sensitive to outliers. 

Notice that the argument that we are dividing the covariance by the two standard deviations is to only allow comparison across variables, not counter any potential effect of outliers."

# ╔═╡ 3fdc0494-7f34-11eb-139d-ad7fa8c098e2
begin
	x7_ = rand(Normal(5, 1), 20);
	y7_ = 1 * x7_ + rand(Normal(5, 0.3), 20);
	
	x8_ = append!(copy(x7_), 10)
	y8_ = append!(copy(y7_), 9)
end

# ╔═╡ 1eb842ea-7f35-11eb-3e5b-753535a8bfea
md"Click on the checkbox to add outliers"

# ╔═╡ 8608e458-7f34-11eb-3b92-290fea88ac18
scatter(x7_, y7_, title="Correlation = " * string(cor(x7_, y7_)))

# ╔═╡ bc17e118-7f34-11eb-1189-95315fab5ce6
scatter(x8_, y8_, title="Correlation = " * string(cor(x8_, y8_)))

# ╔═╡ 176b14f8-7f36-11eb-1dde-2f1ca7c9af38
md"Correlation drops significantly due to a single outlier"

# ╔═╡ 79d21678-7f36-11eb-3e14-9568a7781ebe
md"👉Can you think of a way in which correlation coefficient increases due to outliers?"

# ╔═╡ 1e02e264-7f36-11eb-12f1-81411831a1b3
begin
	x9_ = rand(Normal(5, 1), 20);
	y9_ = 0.5 * x7_ + rand(Normal(5, 2), 20);
	
	x10_ = append!(copy(x9_), [20])
	y10_ = append!(copy(y9_), [20])
end

# ╔═╡ a109437e-7f36-11eb-0bdf-ab2bf0b8130a
scatter(x9_, y9_, title="Correlation = " * string(cor(x9_, y9_)))

# ╔═╡ a9195216-7f36-11eb-25cf-ab7eee4ca256
scatter(x10_, y10_, title="Correlation = " * string(cor(x10_, y10_)))

# ╔═╡ ee876554-7f36-11eb-1e02-b98451ccf26f
md"👉OK so we have a problem with outliers. What would your defence be?"

# ╔═╡ 769f6de6-8585-11eb-3a9f-450df3ab75a0
md"💡Hint: What did we do in the case of mean?"

# ╔═╡ 6cd8b81a-7f17-11eb-1346-270ab26a1df4
md"#### Spearman Correlation"

# ╔═╡ e3b09fdc-7f32-11eb-3b6d-2bca422fd7f3
md"Our solution with the outlier sensitivity of mean was to use median which uses the ranking of variables rather than their values."

# ╔═╡ 14ee007e-7f37-11eb-20b4-1df87a90f48d
md"👉 Can you think of correlating two variables with ranks?"

# ╔═╡ 515ed8d2-7f3d-11eb-1f0e-f920f7799263
md"The basic idea is to compute the ranks of two set of samples and then compute the Pearson's correlation coefficient of the ranks."

# ╔═╡ 60057c6a-7f3d-11eb-0f32-595b689315a3
x12_ = rand(Normal(5, 1), 5)

# ╔═╡ afff7064-7f50-11eb-05b1-d392d177ace5
y12_ = 0.5 * x12_ + rand(Normal(5, 2), 5)

# ╔═╡ bc51fde0-7f3d-11eb-02a5-9331000ad2ff
cor(x12_, y12_)

# ╔═╡ ced6f668-7f50-11eb-2fa2-755dc4b48e74
sort(x12_)

# ╔═╡ 5aac63e2-7f50-11eb-1888-a5b1980fea98
[indexin(x12_[i], sort(x12_))[1] for i in 1:length(x12_)]

# ╔═╡ 10f3be2a-7f51-11eb-1d4f-ff3943118e1f
md"The following function replaces each value in an input array by its rank in the sorted version of the array"

# ╔═╡ d8afc632-7f50-11eb-08a5-83914cf962d0
findpos(arr) = [indexin(arr[i], sort(arr))[1] for i in 1:length(arr)]

# ╔═╡ e6cad106-7f50-11eb-1069-8520b81a05fd
x12_rank = findpos(x12_)

# ╔═╡ ed174580-7f50-11eb-29ac-e925387f1779
y12_rank = findpos(y12_)

# ╔═╡ 2222b07a-7f51-11eb-11f9-3f8c191c620e
md"Once we have the ranks for both the vectors, we can compute the Spearman correlation coefficient as the Pearson correlation coefficient on the ranks."

# ╔═╡ fcf549a2-7f50-11eb-05d3-11fbdf7f3984
cor(x12_rank, y12_rank)

# ╔═╡ 4fa95fbc-7f51-11eb-3f79-05e2c0408808
md"We can put all this together in a single function"

# ╔═╡ 3fc8a3a0-7f51-11eb-2a6c-6385c55d2d2d
cor_s(x, y) = cor(findpos(x), findpos(y))

# ╔═╡ 4ec8c7f4-7f51-11eb-133e-bbc12393f533
cor_s(x12_, y12_)

# ╔═╡ 8fbc0f54-7f52-11eb-0ab8-fb60067b43e0
md"Let us now revisit the examples where outliers sensitively affected the Pearson correlation coefficient"

# ╔═╡ a97b5ff8-7f52-11eb-220e-55f4aceb21de
md"Case 1: ρ-Pearson sharply reduced by a single outlier."

# ╔═╡ b2052776-7f52-11eb-3790-ff5c917d9da7
md"Case 2: ρ-Pearson sharply increased by an outlier"

# ╔═╡ ddad5ac6-7f52-11eb-148b-91e5b7a5df8f
md"In both cases the Spearman correlation coefficient remains more robust in the face of the outliers. This is clear why - the outliers have only limited effect on the rank of the values which are then used to compute correlation."

# ╔═╡ c17e66ac-8585-11eb-2cc8-3fd3501f33ce
md"👉Do you see one other advantage of Spearman correlation coefficient over the Pearson correlation coefficient?"

# ╔═╡ 0959a256-7f53-11eb-2afe-c90157d032f3
md"Since the Spearman correlation depends only on the rank ordering it can also detect correlations with non-linear _monotonic_ functions."

# ╔═╡ 73f12006-7f53-11eb-23e9-47e725e79336
begin
	x16_ = rand(Uniform(-10, 10), 100)
	y16_ = sinh.(x16_)
end

# ╔═╡ 5684ace4-7f54-11eb-197a-bd770705eced
md"👉Where is this particularly important?"

# ╔═╡ 0868668c-7f53-11eb-0025-eb7e12f385dc
hint(text, title) = Markdown.MD(Markdown.Admonition("hint", title, [text]))

# ╔═╡ c6efb902-8255-11eb-16f0-6ffc51cf9224
hint(md"
```julia
begin
	sample_ = rand(Normal(), 100)
	val_ = sum(sum([[(sample_[i] - sample_[j])^2 for i in 1:100] for j in 1:100]))/(100 * 100)
end
```", "Solution")

# ╔═╡ 1dc8ee70-8255-11eb-3d0e-53dda549c76b
hint(md"$\mathbb{E}[(X - Y)^2] = \mathbb{E}[X^2] + \mathbb{E}[Y^2] - 2\mathbb{E}[XY]$ But we know that $X$ and $Y$ are independent and so $\mathbb{E}[XY] = \mathbb{E}[X]\mathbb{E}[Y] = \mu^2$. We also know that $\mathbb{E}[X^2] = {E}[Y^2] = \mu^2 + \sigma^2$. Hence, the above expectation is equal to $2\sigma^2$. Hence, it makes sense to get values around 2 for the previous code.", "Solution")

# ╔═╡ 5acfe6ae-7f06-11eb-182b-9b83107e0c4c
hint(md"
```math
\mathbb{E}[(X - \mathbb{E}[X])(Y - \mathbb{E}[Y])] = \mathbb{E}[XY - X\mathbb{E}[Y] - Y\mathbb{E}[X] + \mathbb{E}[X]\mathbb{E}[Y]] 
```
```math
= \mathbb{E}[XY] - \mathbb{E}[X]\mathbb{E}[Y] - \mathbb{E}[Y]\mathbb{E}[X] + \mathbb{E}[X]\mathbb{E}[Y] =  \mathbb{E}[XY] - \mathbb{E}[X]\mathbb{E}[Y]
```", "Rewriting covariance")

# ╔═╡ ac68800c-7f38-11eb-0c1b-79e8d2ab8ecf
hint(md"
```math
\mathrm{COV}(X + Y, Z) = \mathbb{E}[(X + Y)Z] - \mathbb{E}[X+Y]\mathbb{E}[Z]
```
```math
= \mathbb{E}[XZ] + \mathbb{E}[YZ] - \mathbb{E}[X]\mathbb{E}[Z] - \mathbb{E}[Y]\mathbb{E}[Z]
```
```math
= (\mathbb{E}[XZ] - \mathbb{E}[X]\mathbb{E}[Z]) + (\mathbb{E}[YZ]  - \mathbb{E}[Y]\mathbb{E}[Z])
```
```math
= \mathrm{COV}(X, Z) + \mathrm{COV}(Y, Z)
```", "Covariance sum")

# ╔═╡ baa84258-7f0b-11eb-03d4-c5e0d9547508
hint(md"Covariance is high when the signs of the offsets of the two variable match often (good part), but also when the two variables have large variances individually (bad part)", "Issue with covariance")

# ╔═╡ c6bd6268-7f0d-11eb-2094-0fdc2a8fbd88
hint(md"Correlation is unit-less as we have scaled the product of offsets from mean by the product of two standard deviations.", "Unit of covariance")

# ╔═╡ 48065f1c-7f33-11eb-1888-13ba63eea532
hint(md"Usually whenever we do regression, we have the actual value and the estimate. And we do expect an identity relation between them. In such cases we use the coefficient of determination $R^2$ as a goodness of fit. But in some cases we are fine with a high correlation between the actual and estimated value.", "Use of correlation in ML")

# ╔═╡ 5ff7afb0-7f54-11eb-0f8c-bb7af9a0de90
hint(md"Let us say we are building a ML estimator for efficacy of different manufacturing parameters for yield. Even if this function is non-linear but monotonic in the design parameters, then we can use the Spearman correlation coefficient to set the parameters for increasing the yield..", "Spearman correlation - usage")

# ╔═╡ 14eca90a-7f52-11eb-1257-c3eb50212780
disp(number) = string(round(number*1000)/1000)

# ╔═╡ 58917ca4-7f51-11eb-2399-53cc4269ba1b
scatter(x7_, y7_, title="ρ-Pearson = " * disp(cor(x7_, y7_)) * " ρ-Spearman = " * disp(cor_s(x7_, y7_)))

# ╔═╡ 37d45bea-7f52-11eb-2302-2da751a91c33
scatter(x8_, y8_, title="ρ-Pearson = " * disp(cor(x8_, y8_)) * " ρ-Spearman = " * disp(cor_s(x8_, y8_)))

# ╔═╡ c1ab36ca-7f52-11eb-2965-8914dacd089b
scatter(x9_, y9_, title="ρ-Pearson = " * disp(cor(x9_, y9_)) * " ρ-Spearman = " * disp(cor_s(x9_, y9_)))

# ╔═╡ cc35a918-7f52-11eb-1bc5-db77f47abf9f
scatter(x10_, y10_, title="ρ-Pearson = " * disp(cor(x10_, y10_)) * " ρ-Spearman = " * disp(cor_s(x10_, y10_)))

# ╔═╡ 8494b7a6-7f53-11eb-0554-e3f7afb68fc5
scatter(x16_, y16_, title="ρ-Pearson = " * disp(cor(x16_, y16_)) * " ρ-Spearman = " * disp(cor_s(x16_, y16_)), legend=false)

# ╔═╡ Cell order:
# ╟─253ad4f4-8253-11eb-03d8-d358d6075910
# ╟─c6efb902-8255-11eb-16f0-6ffc51cf9224
# ╠═237d9290-8254-11eb-233a-4d362783d684
# ╟─8ce2cb16-8253-11eb-21a5-c59e5785950e
# ╟─1dc8ee70-8255-11eb-3d0e-53dda549c76b
# ╟─22f18e82-6b7d-11eb-16eb-31758abdb1b0
# ╟─59607216-7b43-11eb-2cf7-3f74231a1839
# ╠═def88812-6b99-11eb-07fb-3f961d7ff6ae
# ╠═67bd1b94-7f32-11eb-2869-5f075fca7fbc
# ╠═5f510e34-7f32-11eb-158a-afdded4ae4f7
# ╠═65c3f4a2-7f32-11eb-0eb4-97a2455d1ac7
# ╟─b1716986-7e95-11eb-383d-39edf8743454
# ╟─67e698c8-7e99-11eb-01c9-eb2703970ea4
# ╟─c6dc30e0-7e99-11eb-1781-7dba5912b724
# ╟─b79f4c20-7e99-11eb-3eba-492dc528735d
# ╠═7b13d1a8-7e9a-11eb-39f2-5d3e9a95c811
# ╟─a136b75a-7f04-11eb-1324-c9ea26353914
# ╠═ff01b9c2-7f02-11eb-2edd-5131a142f119
# ╟─bbe2eec0-7f04-11eb-3f7f-594d57f134ec
# ╠═fc068802-7f03-11eb-36a0-f3764ac250ab
# ╟─eb742c80-7f04-11eb-0435-4f58142bcdc9
# ╠═2f64101e-7f04-11eb-148b-d1c781173d4c
# ╟─98fcccfc-7f04-11eb-0b2d-6b1feaadfae4
# ╠═12e7d1a4-7f05-11eb-19d5-2b072cbafa05
# ╟─2c8776c8-7f05-11eb-0226-bf1ef7542efd
# ╟─9da0add4-7f05-11eb-1391-0f87db7d41c4
# ╟─a86b8dc4-7f05-11eb-3ca7-e5460fc15b96
# ╟─2e4af178-7f06-11eb-1247-3501f18174cc
# ╟─5acfe6ae-7f06-11eb-182b-9b83107e0c4c
# ╟─e79a0a24-7f06-11eb-3c63-91d44fe78d49
# ╟─2be9abbe-824d-11eb-3b1d-2b1ddf16c195
# ╟─483778b4-824d-11eb-196c-2925d31dd603
# ╟─b818699a-7f37-11eb-088c-a51bed3cbdc0
# ╟─41664208-7f38-11eb-01f5-c32a33253f15
# ╟─6dfb60e6-7f38-11eb-070d-b99afff5f5a1
# ╟─ac68800c-7f38-11eb-0c1b-79e8d2ab8ecf
# ╟─2e32a1e2-7f39-11eb-0df0-812f689e1d1f
# ╟─c4d2c9d0-7f39-11eb-2ac9-373ed723a3f4
# ╟─ce6afe4a-7f39-11eb-19f1-7157457700cd
# ╟─175b1608-7f3a-11eb-0dfb-dd2ee73b9bac
# ╟─fe62b640-8251-11eb-25fe-2b8aa69000ce
# ╠═27d06de0-7f07-11eb-23ce-4d6547ce31f6
# ╠═0359bc70-7f07-11eb-2daa-d1f2a258d9e0
# ╠═a8c20bc6-8251-11eb-0d06-819a786e2b05
# ╟─9c42421a-7f0d-11eb-0172-f34b4adfa5f0
# ╟─502bc23a-7f07-11eb-0b40-97e7e2a8a9ca
# ╠═2938c2ac-7f07-11eb-279c-ab02e04ac679
# ╟─59828c88-7f07-11eb-1462-73e3850659fd
# ╟─a48951d0-7f07-11eb-0052-7d06cf26028c
# ╟─e0d54d10-7f07-11eb-214a-bd24b8accb1a
# ╠═ec51f080-7f07-11eb-2559-5b4cf71a2d0e
# ╟─ef48b742-7f07-11eb-18e0-f1bcc96c86e0
# ╠═dc4d1258-7e99-11eb-25e2-ffcd05171460
# ╟─fa8d1044-7f07-11eb-247e-a18ecff0f4f3
# ╠═182c2ca2-7e9a-11eb-040a-21429d245b4f
# ╟─2348b81e-7f08-11eb-3070-25becdb70c5a
# ╠═85e8d916-7f08-11eb-094c-17dbb38c5048
# ╠═ed8c0606-7f08-11eb-13ec-d166c29a4d67
# ╠═175b39a2-7f09-11eb-02d7-c91ba9204c3c
# ╠═1d4a9088-7f09-11eb-3754-07c4947ecad7
# ╠═27426ea6-7f09-11eb-3c2f-c9d5d5ed33b8
# ╠═307bf5dc-7f09-11eb-3e23-8908558e17ca
# ╟─5a6fb146-7f09-11eb-02b3-0b2bc301eb95
# ╟─882610e4-7f09-11eb-142b-9d8ed5e88fcc
# ╠═0019040c-7e9a-11eb-3ab3-698eb0f98231
# ╠═241c6342-7e9a-11eb-2053-c1984c19a023
# ╟─54ccb922-7f0a-11eb-3ba6-230b0489d928
# ╟─6273fb94-7f0a-11eb-3c1a-4dfa9d925400
# ╠═b9d98800-7f09-11eb-3671-ed27dbde1c3a
# ╟─711d46a0-7f0a-11eb-15d7-b5b17afdeeaa
# ╟─80fc7f8c-7f0a-11eb-3afd-4796a222b202
# ╠═09b71b5a-7e9a-11eb-07dd-e7eabcdb50ef
# ╠═2aaca4f6-7e9a-11eb-3071-fdd5483fb812
# ╟─fb4be732-7f0a-11eb-2b25-b3b18d6cba8a
# ╟─baa84258-7f0b-11eb-03d4-c5e0d9547508
# ╟─031f2f2c-7f0c-11eb-25b7-eb7530aa62af
# ╠═146d1aaa-7f0c-11eb-00ae-fb7ed270927b
# ╠═331c74be-7f0c-11eb-1195-cf4e817f61d3
# ╠═3cb5b896-7f0c-11eb-324d-6d745f9c3796
# ╠═4f001262-7f0c-11eb-2422-1ff23f6065a1
# ╟─6acc6cfc-7f0c-11eb-3522-174161cba17b
# ╟─a8744e0a-7e95-11eb-1931-b1cdda813e0f
# ╟─716cb26e-6b94-11eb-1cb0-b9c2f5608b5f
# ╟─aff1b65e-7f0c-11eb-30de-45877373262c
# ╟─3117ff70-7f0d-11eb-1c0a-95af44530f05
# ╟─a4933666-7f16-11eb-34fa-295373733b14
# ╟─5510b24e-7f0d-11eb-15a2-6714879d78f4
# ╟─c6bd6268-7f0d-11eb-2094-0fdc2a8fbd88
# ╟─93baa848-7f0e-11eb-2700-bfc3181e0f21
# ╟─9115a164-7f0f-11eb-3946-453ad1a450a0
# ╟─a731ef30-7f0e-11eb-24f0-5d102ea4a13a
# ╟─6d579f98-7f0f-11eb-26ea-c381d36153f3
# ╟─cdbe10ce-7f0f-11eb-303e-8f9f3527ce25
# ╟─e33ba8e4-7f0f-11eb-36b2-039693234b96
# ╟─ebaeb804-7f0f-11eb-1621-216682cc1e62
# ╠═5adeedd8-7f11-11eb-185e-eb4b7521074b
# ╠═f1b4a228-7f10-11eb-3149-8f86ab1fd053
# ╟─b633765a-7f10-11eb-2c80-f3cd7302ab5a
# ╟─e8bdb338-7f10-11eb-0b2d-47d7f358334f
# ╟─e3cf7068-7f11-11eb-0645-1d988c17ea0f
# ╟─0e4169dc-7f12-11eb-1f09-695a9cbff347
# ╟─6d5a3c1e-7f12-11eb-244f-2787db2ff86b
# ╠═4f405416-7f12-11eb-072f-b5ebf6ecdb89
# ╟─f678bd9a-7f12-11eb-3b82-0748786b4b75
# ╟─fd483aba-8584-11eb-1af1-fd7ba22276ba
# ╠═6c2b36ea-7f12-11eb-3b91-5f6186dd5ce3
# ╠═3ae44970-7f13-11eb-3222-25121d19dfa0
# ╟─1387ed38-7f14-11eb-0f7b-c3deea1d8d76
# ╠═67b909b0-7f13-11eb-36ca-f74db0715854
# ╟─11ef7960-8585-11eb-2dc3-7fa091595dbb
# ╠═0376056a-7f14-11eb-0af4-45c83b91ff94
# ╠═07f0fc76-7f14-11eb-14ef-ed4a723c9f39
# ╟─1cf0720a-7f14-11eb-28af-c73c1f94fa63
# ╠═681cbce8-7f14-11eb-30d6-17d3f7f5f116
# ╟─5ce49422-7f14-11eb-3959-4fb5d18d1f38
# ╟─76ff24b4-7f15-11eb-33c1-6118de89b12f
# ╟─62023c38-7f15-11eb-039c-e5020554a66f
# ╟─71394f5c-7f15-11eb-156d-27290791641f
# ╟─1fc41aca-7f16-11eb-331d-072d0e72cf16
# ╟─35f0324a-7f16-11eb-159b-1f6056dad3f9
# ╠═577ceeb8-7f15-11eb-3700-cd396e2622b1
# ╟─59545e4e-7f16-11eb-03ae-a796f324110d
# ╟─9f311f58-7f16-11eb-2909-cb836b098441
# ╟─3e702d8e-7f33-11eb-271d-5956d16a7e7d
# ╟─48065f1c-7f33-11eb-1888-13ba63eea532
# ╟─ed9d08b4-7f32-11eb-04b1-ef5a467dabea
# ╟─09a0093e-7f34-11eb-2210-ff1d72e9637a
# ╠═3fdc0494-7f34-11eb-139d-ad7fa8c098e2
# ╟─1eb842ea-7f35-11eb-3e5b-753535a8bfea
# ╠═8608e458-7f34-11eb-3b92-290fea88ac18
# ╠═bc17e118-7f34-11eb-1189-95315fab5ce6
# ╟─176b14f8-7f36-11eb-1dde-2f1ca7c9af38
# ╟─79d21678-7f36-11eb-3e14-9568a7781ebe
# ╠═1e02e264-7f36-11eb-12f1-81411831a1b3
# ╠═a109437e-7f36-11eb-0bdf-ab2bf0b8130a
# ╠═a9195216-7f36-11eb-25cf-ab7eee4ca256
# ╟─ee876554-7f36-11eb-1e02-b98451ccf26f
# ╟─769f6de6-8585-11eb-3a9f-450df3ab75a0
# ╟─6cd8b81a-7f17-11eb-1346-270ab26a1df4
# ╟─e3b09fdc-7f32-11eb-3b6d-2bca422fd7f3
# ╟─14ee007e-7f37-11eb-20b4-1df87a90f48d
# ╟─515ed8d2-7f3d-11eb-1f0e-f920f7799263
# ╠═60057c6a-7f3d-11eb-0f32-595b689315a3
# ╠═afff7064-7f50-11eb-05b1-d392d177ace5
# ╠═bc51fde0-7f3d-11eb-02a5-9331000ad2ff
# ╠═ced6f668-7f50-11eb-2fa2-755dc4b48e74
# ╠═5aac63e2-7f50-11eb-1888-a5b1980fea98
# ╟─10f3be2a-7f51-11eb-1d4f-ff3943118e1f
# ╠═d8afc632-7f50-11eb-08a5-83914cf962d0
# ╠═e6cad106-7f50-11eb-1069-8520b81a05fd
# ╠═ed174580-7f50-11eb-29ac-e925387f1779
# ╟─2222b07a-7f51-11eb-11f9-3f8c191c620e
# ╠═fcf549a2-7f50-11eb-05d3-11fbdf7f3984
# ╟─4fa95fbc-7f51-11eb-3f79-05e2c0408808
# ╠═3fc8a3a0-7f51-11eb-2a6c-6385c55d2d2d
# ╠═4ec8c7f4-7f51-11eb-133e-bbc12393f533
# ╟─8fbc0f54-7f52-11eb-0ab8-fb60067b43e0
# ╟─a97b5ff8-7f52-11eb-220e-55f4aceb21de
# ╟─58917ca4-7f51-11eb-2399-53cc4269ba1b
# ╟─37d45bea-7f52-11eb-2302-2da751a91c33
# ╟─b2052776-7f52-11eb-3790-ff5c917d9da7
# ╟─c1ab36ca-7f52-11eb-2965-8914dacd089b
# ╟─cc35a918-7f52-11eb-1bc5-db77f47abf9f
# ╟─ddad5ac6-7f52-11eb-148b-91e5b7a5df8f
# ╟─c17e66ac-8585-11eb-2cc8-3fd3501f33ce
# ╟─0959a256-7f53-11eb-2afe-c90157d032f3
# ╠═73f12006-7f53-11eb-23e9-47e725e79336
# ╠═8494b7a6-7f53-11eb-0554-e3f7afb68fc5
# ╟─5684ace4-7f54-11eb-197a-bd770705eced
# ╟─5ff7afb0-7f54-11eb-0f8c-bb7af9a0de90
# ╠═0868668c-7f53-11eb-0025-eb7e12f385dc
# ╠═14eca90a-7f52-11eb-1257-c3eb50212780

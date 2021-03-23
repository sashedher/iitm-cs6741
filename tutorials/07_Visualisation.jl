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

# ╔═╡ 5b22ecc2-68fc-11eb-0e6e-f38d2f761d95
using DataFrames

# ╔═╡ f2c54404-50dd-11eb-05cd-a94912f14d1e
using RDatasets

# ╔═╡ 60e6fd0e-50d8-11eb-37d9-add4c3dfcb1b
using Plots

# ╔═╡ 43774790-50da-11eb-05f3-4f635e934d6a
using StatsPlots

# ╔═╡ 6bf51fa8-50f3-11eb-378f-bf3ff7156539
using PlutoUI

# ╔═╡ 78c7ae98-50f7-11eb-3bc9-e30d06686614
using Distributions

# ╔═╡ 4187e3de-50ff-11eb-18c0-93284cb3ad44
using FreqTables

# ╔═╡ 12e89740-6b89-11eb-27fd-e7d7c4b81637
begin
	using HTTP, JSON
	resp = HTTP.get("https://api.covid19india.org/data.json")
	str = String(resp.body)
	jobj = JSON.Parser.parse(str)
end

# ╔═╡ 5ed5beba-6b8b-11eb-38d6-b1542bff022c
using Dates

# ╔═╡ 717e19a6-50d6-11eb-011b-ddf29b2946c8
md"# Notebook 7: _Data Visualisation in Julia_

In this section, we will learn the basics of data visualisation. It is best to think of this chapter as consisting of three broad ideas: 
1. How do we decide _what plot type to use_ for a specific data visualisation task?
2. What are the _constituents of a plot_?
3. How do we _implement the plotting with Julia_?"


# ╔═╡ d12d4384-50dd-11eb-0ecc-65623c8febfe
md"## Types of variables"

# ╔═╡ d9b48c24-50dd-11eb-2253-e1f0eeb004f2
md"The columns of data we usually study belong to the following data-types:
* Numerical data - Data in numbers (think `reals`)
  * Continuous
  * Discrete
* Categorical data - Data in groups / categories (think `enum`)
  * Nominal - No clear ordering between categories
  * Ordinal - Categories can be ordered
"

# ╔═╡ b8c7b436-6b7d-11eb-0817-eb3fb7f09f95
md"👉 Give examples of each type of variable"

# ╔═╡ 52540bba-68fc-11eb-1ecc-03ad619fe826
md"Let us see some examples of these datatypes in a toy dataset from an apparel retailer."

# ╔═╡ a6239d94-68fc-11eb-0162-d5707c186fd4
shirt_database = DataFrame(ItemNo = ["A193s1", "A2013a", "B19sd9", "C2131x"], Color = ["White", "Black", "Black", "Blue"], Sleeves = ["Half", "Full", "Half", "Half"], Pattern = ["Solid", "Striped", "Solid", "Checked"], SurveyRating = ["Good", "Poor", "Very poor", "Good"], WebsiteRating = [3, 2, 1, 4], Price = [299, 1349, 599, 729])

# ╔═╡ 59f0a50c-690d-11eb-3a6d-f50e01402f32
md"👉 What are the types for the each of the columns?"

# ╔═╡ 02ca2edc-50de-11eb-2cc5-2772d7d92fe6
md"Let us see some examples of these variable types. For creating interesting plots, we will use datasets available from the `RDatasets` package in the format of DataFrames."

# ╔═╡ 434cf43c-50de-11eb-2733-71ddf1bb8b49
RDatasets.datasets()

# ╔═╡ 85f580d0-6dfb-11eb-2dbf-db79082b85b7
md"Given below is the [iris](https://vincentarelbundock.github.io/Rdatasets/doc/datasets/iris.html) dataset."

# ╔═╡ 7d2d18ee-50de-11eb-38a1-cd402e4674b2
iris = dataset("datasets", "iris")

# ╔═╡ ea181dc0-6dfb-11eb-0ed6-2d29558cd012
md"We'll also make use of the [diabetes](https://vincentarelbundock.github.io/Rdatasets/doc/MASS/Pima.te.html) dataset."

# ╔═╡ bcdc7076-50ef-11eb-09d4-47ab5436e1d9
diabetes = dataset("MASS", "Pima.te")

# ╔═╡ a867dcec-50f0-11eb-07f2-7d34e62cd42e
md"## Types of plots"

# ╔═╡ adda9d42-50f0-11eb-266d-75d0464b2f23
md"
The following _taxonomy_ of plots at the top level is based on _what we are plotting_ and in the inner level on the _data type_ of the variables.
* Distribution
    * Single variable
        * Continuous variable - Histogram, Density plot (+ faceting)
        * Discrete / categorical variable - Bar plot
        * Box plot
        * Violin plot (+ paired)
    * Two variables
        * Both continous variables - Scatter plot, marginal density plots
        * One continuous variable, one categorical variable - 
        * Two discrete variables - Heatmap
* Composition
    * Pie chart
    * Stacked bar plot
    * Stacked line plot
* Relationship
    * Line plot
    * Correlation plot
"

# ╔═╡ 336536b0-50f2-11eb-1dbd-836f130731ac
md"Lets begin plotting. We will use the `gr` backend, but you can use any of the other backends as well."

# ╔═╡ 3fb759e6-50d9-11eb-36a4-31ed7766c5b3
gr()

# ╔═╡ ad6fa5de-5102-11eb-0329-8b5d52ba864f
default(size =(600, 300))

# ╔═╡ 4e488752-50f2-11eb-06c2-83cad3489775
md"We will also use the `StatsPlots` library for some interesting plot types."

# ╔═╡ 433bba92-50d8-11eb-05f0-d31772d405e0
md"## Distribution of data"

# ╔═╡ 9155c80e-50f0-11eb-2c14-13fce7a14b9d
md"One of the most important aspects in this course will be to study the distribution of data. So, we begin with looking at the distribution of one and two variables."

# ╔═╡ 48e55444-50d8-11eb-3861-73237803775c
md"##### Distribution of a single variable"

# ╔═╡ 068c716c-50f2-11eb-35f1-cf749745b296
md"###### Histogram"

# ╔═╡ 2df8b140-50f0-11eb-1882-2964dd07d1b3
histogram(diabetes.Glu)

# ╔═╡ 802ae7a6-50f2-11eb-1e52-2d4f62abf0e7
md"This helps us see that the data is _right skewed_ with a large fraction of values in the range of 80 - 130. We can change the number of bins and also normalize this into a density function."

# ╔═╡ 2683019c-6b81-11eb-36a2-69467c7ee7d6
md"👉 How do we choose the number bins? What effect does this have?"

# ╔═╡ 4d06a470-50f0-11eb-1369-2f743c3cbfc9
histogram(diabetes.Glu, bins=1000)

# ╔═╡ da9c31d6-8644-11eb-237a-8f711cbf2963
histogram(diabetes.Glu, bins=3)

# ╔═╡ 5a55d03c-6b81-11eb-007e-bde94e3eb46a
md"👉 When should we normalize the bin heights?"

# ╔═╡ 6577ec58-50f0-11eb-0277-6b791ab01895
histogram(diabetes.Glu, bins=25, normalize=:pdf)

# ╔═╡ feaf8b4a-8644-11eb-2817-4bc99b6790b7
md"👉What else can a histogram help visualise?"

# ╔═╡ b76d303e-50f2-11eb-0830-1bf573e84375
md"_Outliers_. In the Glucose field, there seem not to be many outliers. Let us use an interactive plot to visualise the histogram of all other fields."

# ╔═╡ 4c2714ba-50f3-11eb-0aff-679d40f27bf4
names(diabetes)

# ╔═╡ 283cb0be-50f3-11eb-35a8-4dc20e9a05f1
@bind sel_col Select(names(diabetes))

# ╔═╡ 2d0c32be-50f2-11eb-1825-9b9648ccfcdc
histogram(diabetes[:, sel_col], nbins=20, normalize=:pdf, label = sel_col)

# ╔═╡ 2a7f2460-8645-11eb-37f5-89cd05d1af48
md"In summary, histograms can help visualise the skew of data, outliers, and if there are regions of discontinuinty."

# ╔═╡ 574527c4-8645-11eb-0b26-c16a97b9ec2d
md"👉 What if we wanted a continuous approximation of the histogram?"

# ╔═╡ 98153fa4-50f4-11eb-0123-d7f01007697b
md"###### Density plot"

# ╔═╡ 264cba2a-50f5-11eb-1e9b-178bfbb7e7ab
md"Histograms show frequency counts for individual bins. If we are more interested in the abstract _shape of the distribution_ then a continuous density plot is more useful."

# ╔═╡ 9dc8fb8e-50f4-11eb-1489-6f4d3dd8802a
@bind sel_col2 Select(names(diabetes))

# ╔═╡ f3b3f4d8-50f4-11eb-05b2-d1c9164b21a3
density(diabetes[:, sel_col2], label = sel_col2, line=(4, :blue), fill=(0, :blue, 0.3))

# ╔═╡ 5440fd68-50f6-11eb-284b-5f5b65ade5b5
md"The `density` function plots the _kernel density function_. Specifically, it estimates a distribution such that area under the curve is 1 and the shape of the distribution matches the frequency counts of the variable."

# ╔═╡ 813a253e-8645-11eb-1663-03625a5483db
md"👉Which measure of central tendency is easiest to spot from the density plot?"

# ╔═╡ 908b3186-8645-11eb-1309-71bc7ab6be00
md"_Mode_. This is clear in the unimodal distribution, but also for multiple modes for multimodal distributions."

# ╔═╡ fd01f110-6bce-11eb-376d-71e7e338caf9
md"In the [ships](https://vincentarelbundock.github.io/Rdatasets/doc/MASS/ships.html) dataset, the column 'Period'(indicating period of operation) is multimodal as can be seen from the density plot."

# ╔═╡ 6336faa0-6bcc-11eb-0dec-7db99fe0d31b
shipsDataset = dataset("MASS", "ships")

# ╔═╡ 8ab2bf50-6bcd-11eb-01ff-2d884f36fb5c
@bind sel_ships Select(names(shipsDataset)[2:5])

# ╔═╡ 9309c1d0-6bcd-11eb-1f82-a5076b557033
density(shipsDataset[:, sel_ships], label = sel_ships, line=(4, :blue), fill=(0, :blue, 0.3))

# ╔═╡ b9ead7b0-6bcf-11eb-2573-d1a2cb1efe8a
md"In the ships dataset, the columns 'service' (after 10,000) and 'incidents' (after 30) show outliers in the density plot. Hence, similar to the histogram, the density plot can also be used for the identification of _outliers_."

# ╔═╡ b4121ff8-8646-11eb-330f-c792896a1577
md"The Glucose levels of patients with diabetes has a bimodal distribution."

# ╔═╡ ab2c6f18-8646-11eb-347c-47954af99437
density(diabetes[diabetes.Type .== "Yes", :Glu], label = "Yes", line=(4, :blue), fill=(0, :blue, 0.3))

# ╔═╡ 7b917128-50f8-11eb-04c0-7bee72532509
md"Density plots are very common in studying probability distributions. For commonly used distributions, we will use the `Distributions` package."

# ╔═╡ 75fd8092-50f7-11eb-385b-df20f0b26649
plot(Normal(0,1), line=(4, :blue), fill=(0, :blue, 0.3), label="Normal")

# ╔═╡ 8e7dbf8a-50f8-11eb-0cd5-9b1caa04ae2f
md"Many of the distributions are parameterized. Let us look at some of the common distributions with their parameters interactively."

# ╔═╡ 9dfbf86e-50f8-11eb-2347-4742df778537
begin
	μslider = @bind μ html"<input type=range min=-5 max=5 step=0.2>"
	ωslider = @bind σ html"<input type=range min=0.1 max=2 step=0.1>"
	md"""**Normal Distribution**
	
	μ: $(μslider)
	σ: $(ωslider)"""
end

# ╔═╡ be9b6320-50f8-11eb-3031-eb88eb81c05f
plot(Normal(μ,σ), line=(4, :blue), fill=(0, :blue, 0.3), label="Normal", -10, 10, ylim=(0, 1))

# ╔═╡ 301441fc-50f9-11eb-1c29-9f4f1acfd93c
begin
	αslider = @bind α html"<input type=range min=0.5 max=5 step=0.5>"
	βslider = @bind β html"<input type=range min=0.5 max=5 step=0.5>"
	md"""**Beta Distribution**
	
	α: $(αslider)
	β: $(βslider)"""
end

# ╔═╡ 564d14ca-50f9-11eb-18a0-4d977b316e31
plot(Beta(α,β), line=(4, :blue), fill=(0, :blue, 0.3), label="Beta", 0, 1, ylim=(0, 5))

# ╔═╡ bbe402b2-50f9-11eb-3366-573d0cdaea70
begin
	kslider = @bind k html"<input type=range min=1 max=10 step=1>"
	md"""**Chi-square Distribution**
	
	k: $(kslider)"""
end

# ╔═╡ dc80ce26-50f9-11eb-1dc4-efb97abc75f3
plot(Chi(k), line=(4, :blue), fill=(0, :blue, 0.3), label="Beta", 0, 5, ylim=(0, 1))

# ╔═╡ f8b79cf0-50fc-11eb-2d1d-31489e04471f
begin
	kgslider = @bind kg html"<input type=range min=1 max=5 step=1>"
	θslider = @bind θ html"<input type=range min=0.5 max=2 step=0.1>"
	md"""**Gamma Distribution**
	
	k: $(kgslider)
	θ: $(θslider)"""
end

# ╔═╡ 1c809a38-50fd-11eb-281a-e3cc8d990d6d
plot(Gamma(kg, θ), line=(4, :blue), fill=(0, :blue, 0.3), label="Gamma", 0, 20, ylim=(0, 1))

# ╔═╡ 2f3ed2ba-8646-11eb-0de1-1d04e888fc2d
md"Thus while density plots are the default mode to study continuous probability distribution, they are also useful for empirical data to identify mode, skew, outliers, and the general shape of the data."

# ╔═╡ a36e3a72-50f4-11eb-311a-e10e997b2d9d
md"###### Bar plot"

# ╔═╡ a8580752-50f4-11eb-14c4-93eab7aa6ecb
md"We saw that both histogram and density plots don't work for categorical data. But it is useful to visualise the frequencies of categorical data. For this we use the _bar plot_. Notice that the bar plot is different from the histogram."

# ╔═╡ 5303f760-50ff-11eb-2641-d397037dd163
freqtable(diabetes.Type)

# ╔═╡ 74959a7e-6e07-11eb-0ff2-cf4b49a62e8c
md"Given below is a bar plot for diabetic people(Yes/No) from the diabetes dataset."

# ╔═╡ 6d6b50e4-50ff-11eb-002a-8d46e701af83
bar(freqtable(diabetes.Type),label="Type")

# ╔═╡ f6f1f2d0-6e07-11eb-021b-9dbaf45f1e3f
md"Another bar plot from the iris dataset for different kinds of species."

# ╔═╡ 8a3911ca-50ff-11eb-362c-6f5ea92d27aa
bar(freqtable(iris.Species),label="Species")

# ╔═╡ 5b66ce72-6e08-11eb-2fbe-bf4fb21a18f7
md"Let us take a look at a bar plot from the diamonds dataset."

# ╔═╡ a89b96b0-50ff-11eb-12fd-19463d92b20d
diamonds = dataset("ggplot2", "diamonds");

# ╔═╡ d2dbffa0-50ff-11eb-068c-47e957435cce
@bind diamond_column Select(["Cut", "Color", "Clarity"])

# ╔═╡ c12d9840-50ff-11eb-3604-ddc6cc76e839
bar(freqtable(diamonds[:, diamond_column]), label=diamond_column)

# ╔═╡ 1f35feaa-5100-11eb-2024-ab35ba3e9fe8
md"Notice that bar plots are more generic than histograms and density plots. They can be used to plot other aspects beyond the distribution of data, as we will see later."

# ╔═╡ 4125dfd0-5100-11eb-223a-55b94f998466
md"#### Distribution of single variable in multiple slices"

# ╔═╡ 497f2132-5100-11eb-2ed0-2512baedf8b1
md"In the above we saw the distribution of a single variable. But often we would like to contrast the distributions of two or more slices of the data. Let us take an example of the Diabetes data."

# ╔═╡ 5bb4a3ee-5101-11eb-2456-39821acd0bb0
@bind sel_col3 Select(names(diabetes))

# ╔═╡ 8df80d74-5100-11eb-207c-53d522115b08
begin
	density(diabetes[diabetes.Type .== "Yes", sel_col3], label = "Yes", line=(4, :red), fill=(0, :red, 0.3))
	density!(diabetes[diabetes.Type .== "No", sel_col3], label = "No", line=(4, :green), fill=(0, :green, 0.3))
end

# ╔═╡ 367f5b64-5104-11eb-1d59-416bdbd0fbf3
md"We do not have to do these two plots manually. We can use the idea of _groups_  instead."

# ╔═╡ 30eb4c8a-5179-11eb-10bd-23d662061237
@bind sel_col4 Select(names(diabetes))

# ╔═╡ 0e15b664-5179-11eb-03cf-fdd03e1fa960
density(diabetes[:, sel_col4], group = diabetes.Type, line=(4) , fill=(0), fillalpha=0.3)

# ╔═╡ 4c0b2814-5179-11eb-3afc-6b96b70c4017
md"One more handy trick: Since the dataframe keeps repeating multiple times in the following, we can use a short-hand with the `@` construction."

# ╔═╡ 47669692-5104-11eb-0321-efacd2ee6083
@df diabetes density(:Glu, group = :Type, line=(4) , fill=(0), fillalpha=0.3)

# ╔═╡ b361ed4a-5101-11eb-3e24-67e474420a96
md"Stacking multiple density plots for different groups together works well due to the fill transparency. But for histograms, we have to do something different."

# ╔═╡ d58b795a-5103-11eb-1a5a-cd932ad9ea5f
@df diabetes histogram(:Glu, group = :Type, bins=25, normalize=:pdf)

# ╔═╡ a3b1651e-5102-11eb-2b7c-7506f3ec1042
md"We can have multiple plots laid out separately with the `layout` argument."

# ╔═╡ 4584d1c6-5105-11eb-24a4-0d471533d62c
@df diabetes histogram(:Glu, group=:Type, bins=25, normalize=:pdf, layout=2)

# ╔═╡ 9799cb84-5177-11eb-0631-7beed264b449
@df diamonds histogram(:Price, group=:Cut, bins=25, normalize=:pdf, layout=5, legend=:topright)

# ╔═╡ afc41804-8647-11eb-0245-655660d79948
md"We can also change the layout if we wanted more horizontal spacing. More complex layouts are showin [here](https://docs.juliaplots.org/latest/layouts/)."

# ╔═╡ ab34502e-8647-11eb-1cf0-4ba59ec56871
@df diamonds histogram(:Price, group=:Cut, bins=25, normalize=:pdf, layout=(3, 2), legend=:topright)

# ╔═╡ 6f801c82-6e09-11eb-0a00-b5f75adab724
md"For bar plots, we do the grouping in a slighlty different way. We extract the frequencies for each 'Type' and use it for the plot." 

# ╔═╡ f972e120-6d32-11eb-3237-a74316b8171f
begin
	bar_plots=[]
	types=unique(diabetes.Type)
	for i in 1:2
		push!(bar_plots,bar(freqtable(diabetes[diabetes.Type .== types[i],:NPreg]),label=types[i]))
	end
	plot(bar_plots[1], bar_plots[2], layout = 2)
end

# ╔═╡ fdd1d920-6e1c-11eb-13d9-29574511937e
md"From the bar plots, observe that the number of pregnancies for diabetic patients is more spread out whereas for those who are not diabetic, the distribution is right skewed."

# ╔═╡ 9321675e-5179-11eb-2df6-e54ed50b6a17
md"#### Box plot"

# ╔═╡ 965e8668-5179-11eb-0718-eb096753ad66
md"In the case of histograms and density plots, a lot of the information about the distribution of a variable is visible. If we wanted to instead look at only a subset of information, then we can use a `box plot`."

# ╔═╡ 117fe8a0-517a-11eb-132f-eb3211dde0c4
md"Notice the _abstraction of information_ as we move from histogram/density plots to the box plot."

# ╔═╡ b6e26fde-517a-11eb-34ba-b94752f8f4f1
@bind sel_col5 Select(names(diabetes))

# ╔═╡ 1dca2170-517a-11eb-0be4-c1cc0e228971
boxplot(diabetes[:, sel_col5])

# ╔═╡ 86cca6f4-517d-11eb-0104-65589fdd58a4
md"We have already discussed the plot elements of a box plot - median, IQR, whiskers, outliers."

# ╔═╡ 98c9a594-517a-11eb-1fe4-d5221eda3dd1
md"![](https://mk0codingwithmaxskac.kinstacdn.com/wp-content/uploads/2019/11/box-plot-vertical-horizontal-1.png)"

# ╔═╡ 931e2c52-517d-11eb-2ed6-1fc344727571
md"It is important to build good intuition about how things are related across plot types. For instance, if we have a heavily right skewed dataset with a long tail, then it would show up in the box plot as being bottom heavy and having many outliers on the top, like in the following case of prices of diamonds."

# ╔═╡ bccce282-517d-11eb-1894-070fa44f4134
density(diamonds[:, :Price], fill=(0, :blue, 0.3), line=(3, :blue))

# ╔═╡ 6fe12a28-517d-11eb-2a2d-7f9a4c420d89
boxplot(diamonds[:, :Price]) 

# ╔═╡ 00fdae4c-517d-11eb-1a34-650725b08271
md"Like before, we can plot the boxplots for different groups, such as the diabetes condition."

# ╔═╡ efb334e2-517a-11eb-274e-29cd6b00216c
@bind sel_col6 Select(names(diabetes))

# ╔═╡ b270a6ec-5179-11eb-2860-95fe1f7e20a6
boxplot(String.(diabetes[:, :Type]), diabetes[:, sel_col6], fillalpha=0.5, linewidth=2, label=sel_col6, legend=:topleft)

# ╔═╡ 0ea5516c-517d-11eb-042a-8dbd4acba7b0
md"Let us do the same for the iris dataset from earlier where we had three species of flowers."

# ╔═╡ 1288c71a-517c-11eb-2b60-79c4abf10e06
boxplot(String.(iris[:, :Species]), iris[:, 1], fillalpha=0.5, linewidth=2, label=names(iris)[1], legend=:topleft)

# ╔═╡ f8cca5fc-517c-11eb-332e-0d89d4691ac8
md"We can combine such boxplots across the different fields in the data to get a complete picture of the dataset. Notice how we are using a for loop to create the plots and then plotting them separately with a layout argument."

# ╔═╡ 767041dc-517b-11eb-2e15-83bfa870df15
begin
	iris_plots = []
	for iris_i in 1:4
		push!(iris_plots, boxplot(String.(iris[:, :Species]), iris[:, iris_i], fillalpha=0.5, linewidth=2, title=names(iris)[iris_i], label=""))
	end
	plot(iris_plots[1], iris_plots[2], iris_plots[3], iris_plots[4], layout = 4)
end

# ╔═╡ 379cbe3e-517d-11eb-346e-195d12bf8ae0
md"A plot like the one above can help identify the discriminative features. For instance the `setosa` species can be easily called out based on the petal length and width. While `versicolor` and `virgnia` are harder to tell apart, though we have a better chance with the petal features than with sepal features."

# ╔═╡ 5ed991c2-6b84-11eb-10c7-e5d34f7302c0
md"You can also plot good looking grouped boxplots if you use `Plotly`."

# ╔═╡ 05c7911c-517e-11eb-2a7a-3777272d76fd
md"#### Violin plot"

# ╔═╡ 0a8a070c-517e-11eb-0201-99f2f6b4f89c
md"The density plot showed us the shape of the distribution and the box plot showed us some important statistics. Can we combine these in a single plot? Yes, this is what the violin plot does."

# ╔═╡ 2a1c10f6-517e-11eb-3c00-0161244ad098
@bind sel_col7 Select(names(diabetes))

# ╔═╡ 5034b84e-517e-11eb-126f-c7a48c074a5f
violin(diabetes[:, sel_col7])

# ╔═╡ dafeda92-517f-11eb-2c15-d70012e98d61
md"We can overlay the boxplot on top of the violin plot."

# ╔═╡ 72d70e92-517e-11eb-1b0c-29015c7b91b9
begin
	violin(String.(diabetes[:, :Type]), diabetes[:, sel_col7], fillalpha=0.8, linewidth=2, label="")
	boxplot!(String.(diabetes[:, :Type]), diabetes[:, sel_col7], fillalpha=0.3, linewidth=2, label="", title=sel_col7)
end

# ╔═╡ 10a2c44c-5180-11eb-2a9e-8ffd22114b3f
@bind sel_col8 Select(names(iris))

# ╔═╡ eec70900-517f-11eb-0a5a-0b97ab4f572e
begin
	violin(String.(iris[:, :Species]), iris[:, sel_col8], fillalpha=0.8, linewidth=2, label="")
	boxplot!(String.(iris[:, :Species]), iris[:, sel_col8], fillalpha=0.3, linewidth=2, label="", title=sel_col8)
end

# ╔═╡ df9fc7d4-5182-11eb-2314-7d91be2355e6
md"The violin plots in the GR backend do not look particularly good. You can try other backends such as Plotly and Gadfly to obtain better looking plots. Python's Seaborn is also a good option: ![](https://datavizcatalogue.com/methods/images/top_images/SVG/violin_plot.svg)"

# ╔═╡ 1fec4acc-5180-11eb-0328-bfa2a9f84994
md"If we have just two classes to compare (like in the diabetes case), then we have a special way of doing that - using the two sides of the violin."

# ╔═╡ d5cd9782-5181-11eb-0965-411867c9a03a
@bind sel_col9 Select(names(diabetes))

# ╔═╡ 26f2c5fc-5181-11eb-2b8a-1f2edee76a9e
begin
	violin([1], diabetes[diabetes.Type .== "Yes", sel_col9], side=:left, label="Yes", fill=(0, :red, 0.3), linewidth=0)
	violin!([1], diabetes[diabetes.Type .== "No", sel_col9], side=:right, label="No", fill=(0, :green, 0.3), linewidth=0, title=sel_col9)
end

# ╔═╡ 16622b78-5182-11eb-24bf-cdf3500cd2f3
md"We may also want to see the individual points, especially in domains like healthcare. This can be done by overlaying a `dotplot` on top of the paired violin plots."

# ╔═╡ 7f865bec-5182-11eb-3880-e10b9c4a685d
@bind sel_col10 Select(names(diabetes))

# ╔═╡ 2a18a110-5182-11eb-1769-ed392bb4284d
begin
	violin([1], diabetes[diabetes.Type .== "Yes", sel_col10], side=:left, label="Yes", fill=(0, :red, 0.3), linewidth=0)
	dotplot!([1], diabetes[diabetes.Type .== "Yes", sel_col10], side=:left, label="Yes", marker=(:red, stroke(0), 0.3))
	violin!([1], diabetes[diabetes.Type .== "No", sel_col10], side=:right, label="No", fill=(0, :green, 0.3), linewidth=0, title=sel_col10)
	dotplot!([1], diabetes[diabetes.Type .== "No", sel_col10], side=:right, label="No", marker=(:green, stroke(0), 0.3))
end

# ╔═╡ 0dc19ee6-5184-11eb-0d29-113e921b264a
md"### Distribution of two variables"

# ╔═╡ 9f7ee908-5184-11eb-23bc-a9fe1c3749ce
md"So far we have been looking at ways to plot the distribution of a single variable. Now we move on to two variables by considering different combinations of the data types of the two variables."

# ╔═╡ 15835914-5184-11eb-336d-b3de2228abfb
md"#### Two continuous variables"

# ╔═╡ 1def7b32-5184-11eb-06d4-7b15b0607708
md"##### Scatter plot"

# ╔═╡ b57bc3c0-5184-11eb-1d1a-6763c47721a0
md"The simplest plot to imagine is a scatter plot of thet wo variables. Since they are both continuous, we expect the points to be distributed irregularly on a 2d plot."

# ╔═╡ 36831b52-5184-11eb-0244-e9fbcbaafef3
@df diabetes scatter(:Glu, :BP, xlabel="Glu", ylabel="BP", label="")

# ╔═╡ c7498fec-5184-11eb-2235-11fe7203feed
md"The scatter plot makes sense if we have few points to plot which can be visualised to obtain a sense of density of the distribution of the points. For instance in the following we clearly see that there are two broad clusters of the points."

# ╔═╡ 612b5e5c-5184-11eb-3538-edff43e08d7e
@df iris scatter(:SepalWidth, :PetalWidth, xlabel="SepalWidth", ylabel="PetalWidth", label="")

# ╔═╡ f2dc3286-5184-11eb-1ee1-9fcabc42c007
md"But scatter plots do not work if we have a large number of points to plot like in the diamonds dataframe. In this case, we can take random samples from the data and use them for a scatter plot."

# ╔═╡ c95cc3b6-5185-11eb-2102-7bc6b10a9b0a
md"Though the scatter plot shows the distribution on the 2-d plane, it is useful to also see how the data is distributed along the two axes. Such projects are technically called marginals and can be used as shown."

# ╔═╡ f8a1eae8-5185-11eb-21b0-35381169101a
@df iris marginalscatter(:SepalWidth, :PetalWidth, xlabel="SepalWidth", ylabel="PetalWidth", label="")

# ╔═╡ 509f0e74-5186-11eb-24ca-154900f666aa
md"##### Maginal KDEs"

# ╔═╡ 89a98942-519a-11eb-16d9-630f9a769d63
@df iris marginalkde(:SepalWidth, :PetalWidth, xlabel="SepalWidth", ylabel="PetalWidth", label="")

# ╔═╡ 17bc0fa4-51bf-11eb-14bb-0976b8c6a92a
@df diabetes marginalkde(:Glu, :BMI, xlabel="Glu", ylabel="BMI", label="")

# ╔═╡ 63c05f88-51bf-11eb-065b-7d352b5170cb
@df diamonds[rand(1:nrow(diamonds), 500), :] marginalkde(:X, :Y, xlabel="X", ylabel="Y", label="")

# ╔═╡ 1f67ee8a-6b7f-11eb-3296-190862654a02
md"#### One categorical and one continuous variable"

# ╔═╡ 39aa4b94-6b7f-11eb-1763-7b5731db0201
md"##### Sliced set of plots"

# ╔═╡ 76884c96-6b7f-11eb-12ab-95f92a9983d7
md"Plot multiple plots for each value of the categorical variable. Use any of the plots seen for distribution of continuous variables."

# ╔═╡ 4a217812-6b7f-11eb-24b4-074c956d5577
@df diamonds[rand(1:nrow(diamonds), 500), :] density(:Price, group=:Cut, layout=5, legend=:topright)

# ╔═╡ 3bf1b230-6c6e-11eb-2023-6176f077cdf5
md"Below is a sliced box plot from the iris dataset."

# ╔═╡ ce243800-6c6c-11eb-1863-e12032c778d2
@df iris[rand(1:nrow(iris), 200), :] boxplot(String.(:Species), :SepalLength, fillalpha=0.5, linewidth=2, label="SepalLength", legend=:topleft)

# ╔═╡ 5a6e9110-6c6e-11eb-0aaa-67f45bb7423d
md"Another boxplot from the ships dataset"

# ╔═╡ ad2c3510-6c6e-11eb-0f9b-bbe03d4e05c0
@df shipsDataset[rand(1:nrow(shipsDataset), 1000), :] boxplot(String.(:Type), :Incidents, fillalpha=0.5, linewidth=2, label="Incidents")

# ╔═╡ c71a83d0-6e1e-11eb-20db-65f12fe727d8
md"From the box plot, we can see that the groups C and D contains outliers when considering the number of damage incidents as the feature of interest."

# ╔═╡ 0d209c30-6c70-11eb-2cf0-73a491799c73
md"The below illustration is of a violin plot from the iris dataset"

# ╔═╡ 5670ebb0-6c70-11eb-0efc-f93bd094bc14
begin
	irisSlice=iris[rand(1:nrow(iris), 500), :]
	@df  irisSlice violin(String.(:Species), :SepalWidth, fillalpha=0.5, linewidth=2, label="")
	@df irisSlice boxplot!(String.(:Species), :SepalWidth, fillalpha=0.5, linewidth=2, label="SepalWidth")
end

# ╔═╡ 08bdf380-6e1f-11eb-3176-e13a76bad6ef
md"This is an illustration of a box plot overlayed on a violin plot, for a sliced set of data. Notice that we are using the same slice to draw the violin and boxplots."

# ╔═╡ d707654a-51bf-11eb-3eb2-7fed48a711ee
md"#### Two discrete variables

##### Marginal Histogram"

# ╔═╡ 588566fc-51c1-11eb-018f-95a038ccbbc2
@df diamonds[rand(1:nrow(diamonds), 1000), :] marginalhist(:X, :Y, xlabel="X", ylabel="Y", label="", bins=30)

# ╔═╡ 7261d362-51c1-11eb-3110-7bd061ebabba
@df iris marginalhist(:PetalLength, :PetalWidth, bins=30)

# ╔═╡ e1e84b26-51c1-11eb-2acc-bf44a69a41e5
@df diabetes marginalhist(:Glu, :BMI, xlabel="Glu", ylabel="BMI", label="", bins=30)

# ╔═╡ ce379972-51c3-11eb-3fe0-ed1fa76288db
md"##### Heatmap"

# ╔═╡ 96f72440-6e20-11eb-10f1-4dfe2d368817
md"Firstly, we sample a random number of rows and convert the 'Cut' and 'Clarity' features to String type."

# ╔═╡ ec9fc67c-51bf-11eb-0802-35368653faa9
begin
	diamonds_short = diamonds[rand(1:nrow(diamonds), 5000), [:Cut, :Clarity]];	
	diamonds_short = transform!(diamonds_short, :Cut => (x -> String.(x)) => :Cut, :Clarity => (x -> String.(x)) => :Clarity);
end

# ╔═╡ b29c03f0-6e20-11eb-35c5-53d584f71426
md"We build a frequency table using Cut and Clarity as the categorical features."

# ╔═╡ 5fe3f886-51c2-11eb-2a37-b3d52ef5fd08
f_table = freqtable(diamonds_short.Cut, diamonds_short.Clarity)

# ╔═╡ 8290d584-51c2-11eb-3d27-f726e21512d2
heatmap(names(f_table)[2], names(f_table)[1], f_table)

# ╔═╡ df5e4c40-6e20-11eb-38e6-ed76c461a1cf
md"The color coding from the scale on the right indicates the intensity of the values, for each pair of feature values being considered."

# ╔═╡ 7f2c8750-6d09-11eb-07b4-af47ed3c4003
md"Consider the dataset on carbon dioxide uptake in grass plants."

# ╔═╡ 0b9e3ab0-6d5c-11eb-04cc-8d9f0bb46fb3
plants=dataset("datasets","CO2")

# ╔═╡ 3ba3caf0-6d0b-11eb-2696-29db4b882fd8
begin
	plants_short = plants[rand(1:nrow(plants), 50), [:Type, :Treatment]]	
	plants_short = transform!(plants_short, :Type => (x -> String.(x)) => :Type, :Treatment => (x -> String.(x)) => :Treatment)
end

# ╔═╡ 8a1b12b2-6d0b-11eb-290c-6798b5c8f64e
f_table_plants = freqtable(plants_short.Type, plants_short.Treatment)

# ╔═╡ a965eff2-6d0b-11eb-26bb-23a3e632570f
heatmap(names(f_table_plants)[2], names(f_table_plants)[1], f_table_plants)

# ╔═╡ c49ab754-6b82-11eb-097a-e9b6ebae0c6f
md"### Composition of data"

# ╔═╡ d0175272-6b82-11eb-068e-e76e36973914
md"##### Pie Chart"

# ╔═╡ f222c498-6b82-11eb-1008-ed1fed165c64
pie(["Assignments","Midsem","Endsem"], [40,30,30], title="CS6741 Evaluation")

# ╔═╡ cc01d6c0-6c78-11eb-2e06-eb859e7eaa91
md"A pie chart from the diamonds dataset"

# ╔═╡ e5e7c530-6c74-11eb-07cf-a9dff5b62b8a
begin
	freqCuts=freqtable(diamonds.Cut)
	pie(String.(names(freqCuts)[1]),freqCuts,title="Diamonds of different cuts")
end

# ╔═╡ f35f8190-6c78-11eb-204a-21b9d6c13e2d
md"A pie chart from the ships dataset"

# ╔═╡ fd0990f0-6c78-11eb-2c19-bf8cf669cfbc
begin
	freqTypes=freqtable(shipsDataset.Type)
	pie(String.(names(freqTypes)[1]),freqTypes,title="Ship damages by type")
end

# ╔═╡ 9d3c1a2e-6e21-11eb-0a4c-ad31b64a0663
md"The pie chart indicates that there are equal number of ship damages for each type."

# ╔═╡ e1f6e600-6b83-11eb-37a7-e169b81ba790
md"We can also have stacked pie charts such as this one ![](https://i0.wp.com/vizartpandey.com/wp-content/uploads/2019/06/Nested-Pie-Charts-in-Tableau.png?resize=696%2C490&ssl=1)"

# ╔═╡ 2749759e-6b87-11eb-13b8-0390abfd0682
md"##### Stacked bar plot"

# ╔═╡ e88efa40-864d-11eb-1ae0-6b5b81782c65
md"We had seen bar plots to denote the frequency of categorical variables. We can use stacked bar plots to capture composition."

# ╔═╡ 1dc71cce-6b87-11eb-0cd1-3179162a8f91
groupedbar(rand(10,3), bar_position = :stack, bar_width=0.7)

# ╔═╡ fa44a096-864d-11eb-36e5-83f1777ed417
md"For the diamonds datsaet, we can visualise the composition of each cut based on the clarity."

# ╔═╡ 47cb6a70-6c7c-11eb-2d97-297689c50d71
begin
	frequency=freqtable(diamonds_short.Cut, diamonds_short.Clarity)
	groupedbar(names(frequency)[1],frequency, bar_position = :stack, bar_width=0.7,xlabel="Cut",ylabel="Clarity", legend=:topleft)
end

# ╔═╡ ed5b0af0-6e83-11eb-2a0f-2fbf72bfd4af
md"From the above stacked bar plot, observe that the frequency is highest for the ideal cut and lowest for the fair cut. The bar lengths are the counts for diamonds of each type of clarity."

# ╔═╡ 851f7c02-6b86-11eb-1f53-adc35eba6146
md"##### Stacked line plots"

# ╔═╡ 8aa43b5c-6b86-11eb-0e87-ebea1e7c9e79
md"To model time varying compositions, we can use stacked line plot. But there is no default plot for this. But we can build it using `userplots`."

# ╔═╡ a1d47864-6b86-11eb-14be-d9cc09db1e18
begin
	@userplot StackedArea
	
	# a simple "recipe" for Plots.jl to get stacked area plots
	# usage: stackedarea(xvector, datamatrix, plotsoptions)
	@recipe function f(pc::StackedArea)
		x, y = pc.args
		n = length(x)
		y = cumsum(y, dims=2)
		seriestype := :shape

		# create a filled polygon for each item
		for c=1:size(y,2)
			sx = vcat(x, reverse(x))
			sy = vcat(y[:,c], c==1 ? zeros(n) : reverse(y[:,c-1]))
			@series (sx, sy)
		end
	end
end

# ╔═╡ ba21b4c2-6b86-11eb-34ea-d36a5f02192a
begin
	a = [1,1,1,1.5,2,3]
	b = [0.5,0.6,0.4,0.3,0.3,0.2]
	c = [2,1.8,2.2,3.3,2.5,1.8]
	sNames = ["a","b","c"]
	x = [2001,2002,2003,2004,2005,2006]

	stackedarea(x, [a b c], labels=reshape(sNames, (1,3)))
end

# ╔═╡ 5eb5b28e-6d1c-11eb-135a-e39ca2886a7e
md"Consider the US economic time series data."

# ╔═╡ 6c93ceb0-6d1c-11eb-27c5-19a0d1bfb20e
timeSeries=dataset("ggplot2","economics")

# ╔═╡ 49a53dd0-6d1c-11eb-0c86-951498741f02
begin
	colNames = ["UEmpMed","PSavert"]
	@df timeSeries[1:5,:] stackedarea(:Date, [:UEmpMed :PSavert],labels=reshape(colNames, (1,2)))
end

# ╔═╡ a3ad4740-6e85-11eb-2fa8-493c076784c6
md"The plot shows the time series variation of median unemployment duration and personal savings rate for the first 5 months." 

# ╔═╡ ddeb6b64-6b86-11eb-315e-03a33e00803a
md"👉 Write a custom user plot for normalized stacked area plot."

# ╔═╡ ffb31c0a-6b87-11eb-0d32-d5caf1f4d3c0
md"### Relationship between variables"

# ╔═╡ 03ee3af2-6b88-11eb-1db2-29ef9e3309bf
md"##### Scatter plot"

# ╔═╡ 16ec2c52-6b88-11eb-11d9-a77dbcca747a
@df diamonds[rand(1:nrow(diamonds), 500), :] scatter(:Carat,:Price, xlabel="Carat", ylabel="Price", label="")

# ╔═╡ 2568aa80-6d5b-11eb-3641-55000a09724a
md"After manually fitting a quadratic curve:"

# ╔═╡ 050e8020-6d5b-11eb-07ca-7dd8100d7ea7
begin
	@df diamonds[rand(1:nrow(diamonds), 500), :] scatter(:Carat,:Price, xlabel="Carat", ylabel="Price", label="")
	f(x) = 10^3*x^2 + 4*10^3*x
	plot!(f, 0,2.5,lw=3,label="Manually fitted curve") 
end

# ╔═╡ f6e06960-6e85-11eb-3cc4-73a72b4ceed9
md"As can be seen after fitting the quadratic curve, there is a clear relationship between the two variables, Carat and Price." 

# ╔═╡ fd71a7b0-6d1f-11eb-22cf-79bfd98e22e0
@df diamonds[rand(1:nrow(diamonds), 500), :] scatter(:X,:Price, xlabel="X", ylabel="Price", label="")

# ╔═╡ b8a6b572-6b89-11eb-3f5d-bde166c607c9
jobj

# ╔═╡ 937a3e88-6b8c-11eb-227b-fff79274c07a
md"##### Time series line plot"

# ╔═╡ ea58b956-6b89-11eb-3ea1-cb07b1b94e67
covid_df = reduce(vcat, DataFrame.(jobj["cases_time_series"]))

# ╔═╡ 1d39aa0c-6b8b-11eb-0f5f-4badfee59bbe
begin
	covid_df[!, :dailyconfirmed] = parse.(Int,covid_df[!, :dailyconfirmed])
	covid_df[!, :dailydeceased] = parse.(Int,covid_df[!, :dailydeceased])
	covid_df[!, :dailyrecovered] = parse.(Int,covid_df[!, :dailyrecovered])
end

# ╔═╡ 6101d32e-6b8b-11eb-111c-bfe9b1ccfa7f
covid_df[!, :dateymd] = Date.(covid_df.dateymd, "yyyy-mm-dd")

# ╔═╡ d9dbc6fe-6b8b-11eb-2248-29d7553b87eb
@df covid_df plot(:dateymd, :dailydeceased, line=2, label="Deceased")

# ╔═╡ 9dc3942e-6b8a-11eb-1349-a78a72d26992
begin
	@df covid_df plot(:dateymd, :dailydeceased, line=2, label="Deceased", color=:red)
	@df covid_df plot!(:dateymd, :dailyrecovered, line=2, label="Recovered", color=:green)
	@df covid_df plot!(:dateymd, :dailyconfirmed, line=2, label="Confirmed", color=:orange)
end

# ╔═╡ 3808e72c-6b88-11eb-2ed7-f76c352a67bc
md"##### Correlation plot"

# ╔═╡ ca585eee-864e-11eb-0513-d79a3422d031
default(size = (600, 500))

# ╔═╡ c4c6f8be-864e-11eb-0d25-a30adea37da6
@df iris corrplot(cols(1:4), grid = false)

# ╔═╡ c7b3711a-864e-11eb-12f2-f17247ba833c
default(size =(600, 300))

# ╔═╡ 8cff75ee-87cc-11eb-3939-395e970a8ed1
md"![](https://www.mymarketresearchmethods.com/wp-content/uploads/2013/01/chart-types-choosing-the-right-one.png) Source: https://www.mymarketresearchmethods.com/wp-content/uploads/2013/01/chart-types-choosing-the-right-one.png"

# ╔═╡ 6bf3c854-87e6-11eb-06df-3d0f67979710
md"Checkout `gapminder` plot in Plotly."

# ╔═╡ 09d3b222-6902-11eb-0571-f7cfbaa3c0db
hint(text, title) = Markdown.MD(Markdown.Admonition("hint", title, [text]))

# ╔═╡ 248ce07a-68ff-11eb-0e88-87c99225f41a
hint(md"Unique string id - wouldn't call it categorical as values are unique", "ItemNo")

# ╔═╡ 9df0e186-690d-11eb-208d-3d17e689fc83
hint(md"Categorical and Nominal as there is no obvious ordering between the colours, though you can have a distance metric between two colours", "Color")

# ╔═╡ 319b0bb2-690e-11eb-1ddd-73e27aefdeb6
hint(md"Categorical - not very useful to differentiate between Ordinal and Nominal variables in case of just two values", "Sleeves")

# ╔═╡ 6b16b95a-693a-11eb-1812-0d5d5e80728c
hint(md"Categorical and ordinal - can be ordered (though distance between ratings is not clear)", "SurveyRating")

# ╔═╡ b62f69a2-693a-11eb-3372-93062a618960
hint(md"Numerical - Discrete since it is between 1 and 5. There is the confusion with Categorical (ordinal), but if we are going to take averages of stars etc., thinking of discrete numerical is more appropriate.", "WebsiteRating")

# ╔═╡ de361acc-693a-11eb-110b-4d7c760d3cb6
hint(md"Numerical - Continuous. Usually quantised to rupees or paise, but best to think of them as continuous values within this range. Discrete is used when we expect a large number of values to have the same value (eg. shoe size).", "Price")

# ╔═╡ Cell order:
# ╟─717e19a6-50d6-11eb-011b-ddf29b2946c8
# ╟─d12d4384-50dd-11eb-0ecc-65623c8febfe
# ╟─d9b48c24-50dd-11eb-2253-e1f0eeb004f2
# ╟─b8c7b436-6b7d-11eb-0817-eb3fb7f09f95
# ╟─52540bba-68fc-11eb-1ecc-03ad619fe826
# ╠═5b22ecc2-68fc-11eb-0e6e-f38d2f761d95
# ╟─a6239d94-68fc-11eb-0162-d5707c186fd4
# ╟─59f0a50c-690d-11eb-3a6d-f50e01402f32
# ╟─248ce07a-68ff-11eb-0e88-87c99225f41a
# ╟─9df0e186-690d-11eb-208d-3d17e689fc83
# ╟─319b0bb2-690e-11eb-1ddd-73e27aefdeb6
# ╟─6b16b95a-693a-11eb-1812-0d5d5e80728c
# ╟─b62f69a2-693a-11eb-3372-93062a618960
# ╟─de361acc-693a-11eb-110b-4d7c760d3cb6
# ╟─02ca2edc-50de-11eb-2cc5-2772d7d92fe6
# ╠═f2c54404-50dd-11eb-05cd-a94912f14d1e
# ╠═434cf43c-50de-11eb-2733-71ddf1bb8b49
# ╟─85f580d0-6dfb-11eb-2dbf-db79082b85b7
# ╠═7d2d18ee-50de-11eb-38a1-cd402e4674b2
# ╟─ea181dc0-6dfb-11eb-0ed6-2d29558cd012
# ╠═bcdc7076-50ef-11eb-09d4-47ab5436e1d9
# ╟─a867dcec-50f0-11eb-07f2-7d34e62cd42e
# ╟─adda9d42-50f0-11eb-266d-75d0464b2f23
# ╟─336536b0-50f2-11eb-1dbd-836f130731ac
# ╠═60e6fd0e-50d8-11eb-37d9-add4c3dfcb1b
# ╠═3fb759e6-50d9-11eb-36a4-31ed7766c5b3
# ╠═ad6fa5de-5102-11eb-0329-8b5d52ba864f
# ╟─4e488752-50f2-11eb-06c2-83cad3489775
# ╠═43774790-50da-11eb-05f3-4f635e934d6a
# ╟─433bba92-50d8-11eb-05f0-d31772d405e0
# ╟─9155c80e-50f0-11eb-2c14-13fce7a14b9d
# ╟─48e55444-50d8-11eb-3861-73237803775c
# ╟─068c716c-50f2-11eb-35f1-cf749745b296
# ╠═2df8b140-50f0-11eb-1882-2964dd07d1b3
# ╟─802ae7a6-50f2-11eb-1e52-2d4f62abf0e7
# ╟─2683019c-6b81-11eb-36a2-69467c7ee7d6
# ╠═4d06a470-50f0-11eb-1369-2f743c3cbfc9
# ╠═da9c31d6-8644-11eb-237a-8f711cbf2963
# ╟─5a55d03c-6b81-11eb-007e-bde94e3eb46a
# ╠═6577ec58-50f0-11eb-0277-6b791ab01895
# ╟─feaf8b4a-8644-11eb-2817-4bc99b6790b7
# ╟─b76d303e-50f2-11eb-0830-1bf573e84375
# ╠═4c2714ba-50f3-11eb-0aff-679d40f27bf4
# ╠═6bf51fa8-50f3-11eb-378f-bf3ff7156539
# ╟─283cb0be-50f3-11eb-35a8-4dc20e9a05f1
# ╠═2d0c32be-50f2-11eb-1825-9b9648ccfcdc
# ╟─2a7f2460-8645-11eb-37f5-89cd05d1af48
# ╟─574527c4-8645-11eb-0b26-c16a97b9ec2d
# ╟─98153fa4-50f4-11eb-0123-d7f01007697b
# ╟─264cba2a-50f5-11eb-1e9b-178bfbb7e7ab
# ╟─9dc8fb8e-50f4-11eb-1489-6f4d3dd8802a
# ╠═f3b3f4d8-50f4-11eb-05b2-d1c9164b21a3
# ╟─5440fd68-50f6-11eb-284b-5f5b65ade5b5
# ╟─813a253e-8645-11eb-1663-03625a5483db
# ╟─908b3186-8645-11eb-1309-71bc7ab6be00
# ╟─fd01f110-6bce-11eb-376d-71e7e338caf9
# ╠═6336faa0-6bcc-11eb-0dec-7db99fe0d31b
# ╠═8ab2bf50-6bcd-11eb-01ff-2d884f36fb5c
# ╠═9309c1d0-6bcd-11eb-1f82-a5076b557033
# ╟─b9ead7b0-6bcf-11eb-2573-d1a2cb1efe8a
# ╟─b4121ff8-8646-11eb-330f-c792896a1577
# ╠═ab2c6f18-8646-11eb-347c-47954af99437
# ╟─7b917128-50f8-11eb-04c0-7bee72532509
# ╠═78c7ae98-50f7-11eb-3bc9-e30d06686614
# ╠═75fd8092-50f7-11eb-385b-df20f0b26649
# ╟─8e7dbf8a-50f8-11eb-0cd5-9b1caa04ae2f
# ╟─9dfbf86e-50f8-11eb-2347-4742df778537
# ╟─be9b6320-50f8-11eb-3031-eb88eb81c05f
# ╟─301441fc-50f9-11eb-1c29-9f4f1acfd93c
# ╟─564d14ca-50f9-11eb-18a0-4d977b316e31
# ╟─bbe402b2-50f9-11eb-3366-573d0cdaea70
# ╟─dc80ce26-50f9-11eb-1dc4-efb97abc75f3
# ╟─f8b79cf0-50fc-11eb-2d1d-31489e04471f
# ╟─1c809a38-50fd-11eb-281a-e3cc8d990d6d
# ╟─2f3ed2ba-8646-11eb-0de1-1d04e888fc2d
# ╟─a36e3a72-50f4-11eb-311a-e10e997b2d9d
# ╟─a8580752-50f4-11eb-14c4-93eab7aa6ecb
# ╠═4187e3de-50ff-11eb-18c0-93284cb3ad44
# ╠═5303f760-50ff-11eb-2641-d397037dd163
# ╟─74959a7e-6e07-11eb-0ff2-cf4b49a62e8c
# ╠═6d6b50e4-50ff-11eb-002a-8d46e701af83
# ╟─f6f1f2d0-6e07-11eb-021b-9dbaf45f1e3f
# ╠═8a3911ca-50ff-11eb-362c-6f5ea92d27aa
# ╟─5b66ce72-6e08-11eb-2fbe-bf4fb21a18f7
# ╠═a89b96b0-50ff-11eb-12fd-19463d92b20d
# ╟─d2dbffa0-50ff-11eb-068c-47e957435cce
# ╠═c12d9840-50ff-11eb-3604-ddc6cc76e839
# ╟─1f35feaa-5100-11eb-2024-ab35ba3e9fe8
# ╟─4125dfd0-5100-11eb-223a-55b94f998466
# ╟─497f2132-5100-11eb-2ed0-2512baedf8b1
# ╟─5bb4a3ee-5101-11eb-2456-39821acd0bb0
# ╠═8df80d74-5100-11eb-207c-53d522115b08
# ╟─367f5b64-5104-11eb-1d59-416bdbd0fbf3
# ╟─30eb4c8a-5179-11eb-10bd-23d662061237
# ╠═0e15b664-5179-11eb-03cf-fdd03e1fa960
# ╟─4c0b2814-5179-11eb-3afc-6b96b70c4017
# ╠═47669692-5104-11eb-0321-efacd2ee6083
# ╟─b361ed4a-5101-11eb-3e24-67e474420a96
# ╠═d58b795a-5103-11eb-1a5a-cd932ad9ea5f
# ╟─a3b1651e-5102-11eb-2b7c-7506f3ec1042
# ╠═4584d1c6-5105-11eb-24a4-0d471533d62c
# ╠═9799cb84-5177-11eb-0631-7beed264b449
# ╟─afc41804-8647-11eb-0245-655660d79948
# ╠═ab34502e-8647-11eb-1cf0-4ba59ec56871
# ╟─6f801c82-6e09-11eb-0a00-b5f75adab724
# ╠═f972e120-6d32-11eb-3237-a74316b8171f
# ╟─fdd1d920-6e1c-11eb-13d9-29574511937e
# ╟─9321675e-5179-11eb-2df6-e54ed50b6a17
# ╟─965e8668-5179-11eb-0718-eb096753ad66
# ╟─117fe8a0-517a-11eb-132f-eb3211dde0c4
# ╟─b6e26fde-517a-11eb-34ba-b94752f8f4f1
# ╠═1dca2170-517a-11eb-0be4-c1cc0e228971
# ╟─86cca6f4-517d-11eb-0104-65589fdd58a4
# ╟─98c9a594-517a-11eb-1fe4-d5221eda3dd1
# ╟─931e2c52-517d-11eb-2ed6-1fc344727571
# ╠═bccce282-517d-11eb-1894-070fa44f4134
# ╠═6fe12a28-517d-11eb-2a2d-7f9a4c420d89
# ╟─00fdae4c-517d-11eb-1a34-650725b08271
# ╟─efb334e2-517a-11eb-274e-29cd6b00216c
# ╠═b270a6ec-5179-11eb-2860-95fe1f7e20a6
# ╟─0ea5516c-517d-11eb-042a-8dbd4acba7b0
# ╠═1288c71a-517c-11eb-2b60-79c4abf10e06
# ╟─f8cca5fc-517c-11eb-332e-0d89d4691ac8
# ╠═767041dc-517b-11eb-2e15-83bfa870df15
# ╟─379cbe3e-517d-11eb-346e-195d12bf8ae0
# ╟─5ed991c2-6b84-11eb-10c7-e5d34f7302c0
# ╟─05c7911c-517e-11eb-2a7a-3777272d76fd
# ╟─0a8a070c-517e-11eb-0201-99f2f6b4f89c
# ╟─2a1c10f6-517e-11eb-3c00-0161244ad098
# ╠═5034b84e-517e-11eb-126f-c7a48c074a5f
# ╟─dafeda92-517f-11eb-2c15-d70012e98d61
# ╠═72d70e92-517e-11eb-1b0c-29015c7b91b9
# ╟─10a2c44c-5180-11eb-2a9e-8ffd22114b3f
# ╠═eec70900-517f-11eb-0a5a-0b97ab4f572e
# ╟─df9fc7d4-5182-11eb-2314-7d91be2355e6
# ╟─1fec4acc-5180-11eb-0328-bfa2a9f84994
# ╟─d5cd9782-5181-11eb-0965-411867c9a03a
# ╠═26f2c5fc-5181-11eb-2b8a-1f2edee76a9e
# ╟─16622b78-5182-11eb-24bf-cdf3500cd2f3
# ╟─7f865bec-5182-11eb-3880-e10b9c4a685d
# ╠═2a18a110-5182-11eb-1769-ed392bb4284d
# ╟─0dc19ee6-5184-11eb-0d29-113e921b264a
# ╟─9f7ee908-5184-11eb-23bc-a9fe1c3749ce
# ╟─15835914-5184-11eb-336d-b3de2228abfb
# ╟─1def7b32-5184-11eb-06d4-7b15b0607708
# ╟─b57bc3c0-5184-11eb-1d1a-6763c47721a0
# ╠═36831b52-5184-11eb-0244-e9fbcbaafef3
# ╟─c7498fec-5184-11eb-2235-11fe7203feed
# ╠═612b5e5c-5184-11eb-3538-edff43e08d7e
# ╟─f2dc3286-5184-11eb-1ee1-9fcabc42c007
# ╟─c95cc3b6-5185-11eb-2102-7bc6b10a9b0a
# ╠═f8a1eae8-5185-11eb-21b0-35381169101a
# ╟─509f0e74-5186-11eb-24ca-154900f666aa
# ╠═89a98942-519a-11eb-16d9-630f9a769d63
# ╠═17bc0fa4-51bf-11eb-14bb-0976b8c6a92a
# ╠═63c05f88-51bf-11eb-065b-7d352b5170cb
# ╟─1f67ee8a-6b7f-11eb-3296-190862654a02
# ╟─39aa4b94-6b7f-11eb-1763-7b5731db0201
# ╟─76884c96-6b7f-11eb-12ab-95f92a9983d7
# ╠═4a217812-6b7f-11eb-24b4-074c956d5577
# ╟─3bf1b230-6c6e-11eb-2023-6176f077cdf5
# ╠═ce243800-6c6c-11eb-1863-e12032c778d2
# ╟─5a6e9110-6c6e-11eb-0aaa-67f45bb7423d
# ╠═ad2c3510-6c6e-11eb-0f9b-bbe03d4e05c0
# ╟─c71a83d0-6e1e-11eb-20db-65f12fe727d8
# ╟─0d209c30-6c70-11eb-2cf0-73a491799c73
# ╠═5670ebb0-6c70-11eb-0efc-f93bd094bc14
# ╟─08bdf380-6e1f-11eb-3176-e13a76bad6ef
# ╟─d707654a-51bf-11eb-3eb2-7fed48a711ee
# ╠═588566fc-51c1-11eb-018f-95a038ccbbc2
# ╠═7261d362-51c1-11eb-3110-7bd061ebabba
# ╠═e1e84b26-51c1-11eb-2acc-bf44a69a41e5
# ╟─ce379972-51c3-11eb-3fe0-ed1fa76288db
# ╟─96f72440-6e20-11eb-10f1-4dfe2d368817
# ╠═ec9fc67c-51bf-11eb-0802-35368653faa9
# ╟─b29c03f0-6e20-11eb-35c5-53d584f71426
# ╠═5fe3f886-51c2-11eb-2a37-b3d52ef5fd08
# ╠═8290d584-51c2-11eb-3d27-f726e21512d2
# ╟─df5e4c40-6e20-11eb-38e6-ed76c461a1cf
# ╟─7f2c8750-6d09-11eb-07b4-af47ed3c4003
# ╠═0b9e3ab0-6d5c-11eb-04cc-8d9f0bb46fb3
# ╠═3ba3caf0-6d0b-11eb-2696-29db4b882fd8
# ╠═8a1b12b2-6d0b-11eb-290c-6798b5c8f64e
# ╠═a965eff2-6d0b-11eb-26bb-23a3e632570f
# ╟─c49ab754-6b82-11eb-097a-e9b6ebae0c6f
# ╟─d0175272-6b82-11eb-068e-e76e36973914
# ╠═f222c498-6b82-11eb-1008-ed1fed165c64
# ╟─cc01d6c0-6c78-11eb-2e06-eb859e7eaa91
# ╠═e5e7c530-6c74-11eb-07cf-a9dff5b62b8a
# ╟─f35f8190-6c78-11eb-204a-21b9d6c13e2d
# ╠═fd0990f0-6c78-11eb-2c19-bf8cf669cfbc
# ╟─9d3c1a2e-6e21-11eb-0a4c-ad31b64a0663
# ╟─e1f6e600-6b83-11eb-37a7-e169b81ba790
# ╟─2749759e-6b87-11eb-13b8-0390abfd0682
# ╟─e88efa40-864d-11eb-1ae0-6b5b81782c65
# ╠═1dc71cce-6b87-11eb-0cd1-3179162a8f91
# ╟─fa44a096-864d-11eb-36e5-83f1777ed417
# ╠═47cb6a70-6c7c-11eb-2d97-297689c50d71
# ╟─ed5b0af0-6e83-11eb-2a0f-2fbf72bfd4af
# ╟─851f7c02-6b86-11eb-1f53-adc35eba6146
# ╟─8aa43b5c-6b86-11eb-0e87-ebea1e7c9e79
# ╠═a1d47864-6b86-11eb-14be-d9cc09db1e18
# ╠═ba21b4c2-6b86-11eb-34ea-d36a5f02192a
# ╟─5eb5b28e-6d1c-11eb-135a-e39ca2886a7e
# ╠═6c93ceb0-6d1c-11eb-27c5-19a0d1bfb20e
# ╠═49a53dd0-6d1c-11eb-0c86-951498741f02
# ╟─a3ad4740-6e85-11eb-2fa8-493c076784c6
# ╟─ddeb6b64-6b86-11eb-315e-03a33e00803a
# ╟─ffb31c0a-6b87-11eb-0d32-d5caf1f4d3c0
# ╟─03ee3af2-6b88-11eb-1db2-29ef9e3309bf
# ╠═16ec2c52-6b88-11eb-11d9-a77dbcca747a
# ╟─2568aa80-6d5b-11eb-3641-55000a09724a
# ╠═050e8020-6d5b-11eb-07ca-7dd8100d7ea7
# ╟─f6e06960-6e85-11eb-3cc4-73a72b4ceed9
# ╠═fd71a7b0-6d1f-11eb-22cf-79bfd98e22e0
# ╠═12e89740-6b89-11eb-27fd-e7d7c4b81637
# ╠═b8a6b572-6b89-11eb-3f5d-bde166c607c9
# ╟─937a3e88-6b8c-11eb-227b-fff79274c07a
# ╠═ea58b956-6b89-11eb-3ea1-cb07b1b94e67
# ╠═1d39aa0c-6b8b-11eb-0f5f-4badfee59bbe
# ╠═5ed5beba-6b8b-11eb-38d6-b1542bff022c
# ╠═6101d32e-6b8b-11eb-111c-bfe9b1ccfa7f
# ╠═d9dbc6fe-6b8b-11eb-2248-29d7553b87eb
# ╠═9dc3942e-6b8a-11eb-1349-a78a72d26992
# ╟─3808e72c-6b88-11eb-2ed7-f76c352a67bc
# ╠═ca585eee-864e-11eb-0513-d79a3422d031
# ╠═c4c6f8be-864e-11eb-0d25-a30adea37da6
# ╠═c7b3711a-864e-11eb-12f2-f17247ba833c
# ╟─8cff75ee-87cc-11eb-3939-395e970a8ed1
# ╟─6bf3c854-87e6-11eb-06df-3d0f67979710
# ╠═09d3b222-6902-11eb-0571-f7cfbaa3c0db

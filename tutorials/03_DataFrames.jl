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

# ╔═╡ 0532232e-5017-11eb-2ee5-bd82db649d1c
using DataFrames

# ╔═╡ ab5fe00a-74cb-11eb-1b63-8358d1a19718
using RDatasets

# ╔═╡ 02e69f0a-5030-11eb-376c-2909777b59ef
using Random

# ╔═╡ 5e0be22e-5031-11eb-02b1-679548ac5754
begin
	using Plots
	pyplot()
end

# ╔═╡ 346e3170-5035-11eb-1d53-f3717ff82404
using PlutoUI

# ╔═╡ 878ae3d0-50ab-11eb-265d-d52ac266e8a4
using TableIO

# ╔═╡ ea900542-50ac-11eb-2869-e5694b94f504
using FreqTables

# ╔═╡ 15f6a92c-50ae-11eb-0a64-4de1f7bb490a
using Statistics

# ╔═╡ f30185a6-5015-11eb-1a8d-25603607e724
md"# Module 3: _Dataframes in Julia_

**CS6741: Statistical Foundations of Data Science**

In this module, you will get to learn one of the important packages required to process structured data - `dataframes`. We will use this throughout the course to input data, perform basic data cleaning operations, and then run statistical operations. Thus, it forms an important base for the rest of the course.

"

# ╔═╡ b66b26ee-5016-11eb-01e6-694b2e39bf5d
md"
#### Installing and using Dataframes.jl
"

# ╔═╡ 4ae89f8e-5016-11eb-16df-13d654d299d5
md"We will be using the `Dataframes.jl` package. To install this package in your local Julia instance do the following:"

# ╔═╡ 5f4fdd02-5016-11eb-201d-1d9426646956
md"
```
using Pkg
Pkg.add(\"DataFrames\")
```
"

# ╔═╡ 16b7eac0-5017-11eb-15e5-b9f201470cbc
md"Notice that you do not have to quit a Pluto session to install a package. You can do it in another terminal and once the package is installed it would be available to the active Pluto session."

# ╔═╡ c8529ea0-5016-11eb-38d9-c1ecc5550d2d
md"Like any other package, we need to add it to the current Julia runtime:"

# ╔═╡ b3d48e04-5016-11eb-28f2-c71e4540a0dc
md"#### Creating dataframes"

# ╔═╡ 35fabd48-5017-11eb-1a67-e90302279f9e
md"Throughout this course and in most practical applications too, you will encounter relational data which can be laid out in a table where each row is a data item and columns represent different fields or attributes of a data item."

# ╔═╡ 4efdd714-5017-11eb-05d3-6dcec7617db1
md"This can be represented in the `DataFrame` data type. We create below our first dataframe."

# ╔═╡ 5ec1b85a-5017-11eb-1652-877f43479ca0
df = DataFrame(Number = 1:9, IsPrime = ["F", "T", "T", "F", "T", "F", "T", "F", "F"])

# ╔═╡ b31b85fe-5017-11eb-22fa-13762810aa85
md"There are many other ways of creating a dataframe. The following does it column wise."

# ╔═╡ c0d7126a-5017-11eb-2af4-89db7d01e57a
begin
	df2 = DataFrame()
	df2.Number = 1:9
	df2.IsPrime = ["F", "T", "T", "F", "T", "F", "T", "F", "F"]
	df2
end

# ╔═╡ 083152f2-74cc-11eb-3882-8b79170cd7aa
md"👉 Create a dataframe of the details of the planets in the solar system such as size, weight, and periods of rotation and revolution."

# ╔═╡ ec081484-5017-11eb-05a9-75fdf117f284
md"The following does it row-wise."

# ╔═╡ f2cdcade-5017-11eb-3ecf-59e0476e76e7
begin
	df3 = DataFrame(Number = Int[], IsPrime = String[])
	push!(df3, (1, "F")) # as a tuple
	push!(df3, [2, "T"]) # as a vector
	push!(df3, Dict(:Number => 3, :IsPrime => "T")) # as a dictionary
	push!(df3, (4, "F"))
	push!(df3, (5, "T"))
	push!(df3, (6, "F"))
	push!(df3, (7, "T"))
	push!(df3, (8, "F"))
	push!(df3, (9, "F"))
	df3
end

# ╔═╡ 1feb0404-5019-11eb-17c6-cdf37432a2b0
md"Certain cells may have missing data. These can be explicitly stated."

# ╔═╡ 2dcaacca-5019-11eb-3691-b99785b2dce9
df4 = DataFrame(
	RollNo     = [6, 28, 496], 
	Name       = ["Arun", "Arunima", "Jacob"], 
	FavNo      = [π, exp(1), missing], 
	State      = ["TN", "J&K", "TN"], 
	Attendance = [missing, 18/21, 14/24]
)

# ╔═╡ a43be892-5017-11eb-1962-d30a900d1bae
md"We have so far seen the usual data types - integers, floats, strings, boolean. But often in statistics we are also interested in _categorical data_, i.e., data which belongs on one of a countable number of categories. An example of a categorical data is the `State` field in the above table."

# ╔═╡ c42539c2-5019-11eb-2521-f978d2dc23a6
df5 = DataFrame(
	RollNo     = [6, 28, 496], 
	Name       = ["Arun", "Arunima", "Jacob"], 
	FavNo      = [π, exp(1), missing], 
	State      = categorical(["TN", "J&K", "TN"]),
	Attendance = [missing, 18/21, 14/24]
)

# ╔═╡ 5f569306-74cc-11eb-1efe-671de09ad499
md"👉 Many datasets are available in the [RDatasets package](https://github.com/JuliaStats/RDatasets.jl). Use it to read the [diamonds data](https://bookdown.org/yih_huynh/Guide-to-R-Book/diamonds.html) into a dataframe. Which of these columns are categorical?" 

# ╔═╡ 1bd6c8c0-7969-11eb-3f1c-17cbe159a26d
diamonds = dataset("ggplot2", "diamonds")

# ╔═╡ fd412c90-797a-11eb-1f71-075ec205a39f
describe(diamonds)

# ╔═╡ f005c3d0-501a-11eb-20e4-1f42902ba037
md"#### Selecting parts of a dataframe"

# ╔═╡ f9b80a8c-501a-11eb-2b51-8b7ca90b99fc
md"One of the basic functions on a dataframe is to select a subset of rows and columns based on specific selection criteria."

# ╔═╡ 13bac0d6-501c-11eb-0c0e-1d91358a121b
md"In the following we discuss simple row and column range selectors."

# ╔═╡ 15885816-501b-11eb-3070-ff59092748e8
df[1:3, :]

# ╔═╡ 75939448-501b-11eb-2a93-b1679d178b36
df[[1, 3, 5, 7], :]

# ╔═╡ 7c44c238-501b-11eb-2ce0-81e458713d63
df[:, [:IsPrime]]

# ╔═╡ 8be7f980-501b-11eb-3f71-879d6490e0a6
df[1:4, [:IsPrime]]

# ╔═╡ bd25434a-501b-11eb-2251-b92ecfd1e7b7
df[!, :IsPrime]

# ╔═╡ d84c0596-501b-11eb-0a10-a768b0538384
df[4, :IsPrime]

# ╔═╡ 1c6ed2bc-501c-11eb-37a0-b7cecc35c6fe
md"We can also use a _regular expressions_ to select columns. For instance to select all columns with `No` in them."

# ╔═╡ 53458446-501c-11eb-10df-85efdd2c8e78
df5

# ╔═╡ 25de35c2-501c-11eb-2666-5f73b1e2b004
df5[!, r"te"]

# ╔═╡ a02b1e7e-74cc-11eb-1400-7f702301e663
md"👉 In the diamonds dataset, filter the diamonds based on regular expressions on the cut."

# ╔═╡ aefc5360-7962-11eb-3e23-fbb46cdf92dd
diamonds[!,r"Cut"]

# ╔═╡ add1dd20-7962-11eb-1e18-7d4de9e5f0c7


# ╔═╡ 78f9d638-5028-11eb-0378-f52a1d091d11
md"We can also select rows based on conditions on the data fields"

# ╔═╡ a2cfe2ce-5028-11eb-1341-892384a89e52
df[df.Number .> 4, :] 

# ╔═╡ 5d86370e-501c-11eb-15bb-5f0095fc5e41
df5[df5.State .== "TN", :]

# ╔═╡ be611380-5028-11eb-2e4e-a956b61e501f
df5[(df5.State .== "TN") .& (df5.RollNo .> 100), :]

# ╔═╡ bae24224-74cc-11eb-1235-29eec31f5fe0
md"👉 In the diamonds dataset, filter the diamonds based on a certain size lower bound and certain price upper-bound."

# ╔═╡ 41e0254e-7ab5-11eb-1794-0f11687dc655
describe(diamonds)

# ╔═╡ 41376230-7ab5-11eb-3a37-19897d26a0e8
diamonds[(diamonds.Price.<3993) .& (diamonds.Price.>3991),:]

# ╔═╡ 0dc5a0f2-502f-11eb-23b0-89669cb10fc5
md"If we want to create a _new_ data frame from a part of it, then we can use the `select` keyword (think of `select` statements in SQL). Syntax is quite similar."

# ╔═╡ 36703c42-502f-11eb-01fe-d1b6e32454db
select(df5, r"No")

# ╔═╡ 58cfd450-502f-11eb-01e9-e77d7d31dcf5
md"We can transform different aspects including column names with the `select` statement."

# ╔═╡ a6416e74-502f-11eb-3763-d71db19aa35d
df

# ╔═╡ 6819c894-502f-11eb-1502-0b8abafed9a5
select(df, :Number, :IsPrime => (x -> x .== "T"))

# ╔═╡ d36bfbaa-74cc-11eb-370d-f387239ee7ca
md"👉 In the diamonds dataset, convert the price column to a categorical variable depending with three categories: Low, Medium, High, based on your chosen thresholds of price."

# ╔═╡ 61945f60-7b3c-11eb-1574-7da8ce075837
select(diamonds,:Price,:Price=>(x->(x.<1000) .& (x.>500)) =>:Threshold)

# ╔═╡ 53a82460-7b3a-11eb-3461-c90925f5a6be


# ╔═╡ 4c025570-7ab6-11eb-193a-99c726f6eac9
md"select(diamonds,:Price,categorical!(diamonds,:Price=>(x-> x.<1000 ? Low : x.>3000 ? High : Medium)=>:Range))"

# ╔═╡ 37970c30-7b78-11eb-2783-b7e60a8dc32a
begin
	a = [2,4,10,4,8,8]
	b = [5,9,7,2,8,7]
	c = [2,9,7,6,8,1]
	
	dfd = DataFrame(A = a, B = b, C = c)
end

# ╔═╡ 4516dbb0-7b78-11eb-052f-0d0582e70faa
select(dfd,:A,:B,:C,AsTable(:) => ByRow(extrema)=> [:MaxElem,:MinElem])

# ╔═╡ f85c27da-502f-11eb-3628-d9e4fba3a36a
md"More complex transformations are also possible and are often used."

# ╔═╡ 09dacec6-5030-11eb-1420-2fa4b4384a7b
Random.seed!(1)

# ╔═╡ 0e9da3e8-5030-11eb-2595-09e52e9dc5bb
df7 = DataFrame(rand(5, 3), [:a, :b, :c])

# ╔═╡ 6dd0ed84-5030-11eb-28ec-416ed6ef4e00
select(df7, :a, :b, :c => (x -> x .- mean(x)) => :c_offset)

# ╔═╡ 92673a22-5030-11eb-0657-7583d5dfda62
md"Doing the same thing with the `transform` keyword retains the existing columns"

# ╔═╡ f701ade2-74cc-11eb-27cf-cfeb48f63662
md"👉 For the diamonds dataset, the price column is in US dollars, convert them into INR."

# ╔═╡ d3fdf860-7ab8-11eb-3bc0-f1e6b2e52eec
select(diamonds,:Price,:Price=>(x->x.*75)=>:INR)

# ╔═╡ a2dba6b8-5030-11eb-1bdb-656ac06ecd58
md"The above functions are per column. For row-wise transformations we have the `ByRow` keyword."

# ╔═╡ 8807526a-5030-11eb-2476-411d7af8938d
select(df7, :a, :a => ByRow(sqrt))

# ╔═╡ d48515da-5030-11eb-2e6d-b51cc9f54c40
select(df7, :a, :a => ByRow(x -> 1/(1 + exp(-x))))

# ╔═╡ 8b74e2f8-74ce-11eb-31c2-6f4a42953d89
md"👉 Do you recognise the function above?"

# ╔═╡ 386e6730-7ab9-11eb-256b-9f879495ed47
md"Ans:Sigmoid"

# ╔═╡ 6c7039f8-5031-11eb-1049-1d1bef7cbf3e
plot(x->x, x->1/(1 + exp(-x)), -5, 5, legend = false, line=5)

# ╔═╡ bffd0eea-74ce-11eb-18c1-43dc5a6eec6f
md"We can also use the select command to create multiple columns in a go, for instance finding extrema row-wise."

# ╔═╡ a8bc02ca-5031-11eb-016a-6974fbe0a879
df7

# ╔═╡ b96cb2e0-5031-11eb-1be8-f90e124225f6
select(df7, AsTable(:) => ByRow(extrema) => [:lo, :hi])

# ╔═╡ c62c16f4-5031-11eb-11e1-e181d156670e
extrema([3, 2, -1, 0])

# ╔═╡ d2d84480-74ce-11eb-0f13-f1bef9d197f5
md"Extrema is a generic function you can use with any list and returns tuples. So, in the select command you could have had any other custom function which returns tuples."

# ╔═╡ 06fe9d18-74cf-11eb-0723-1dd875c22fea
md"We can also transform dataframes by outputing columns. Note that column names (like variable names) are prefixed with `:`"

# ╔═╡ d8a720dc-5031-11eb-04ac-817b4512d51a
transform(df7, AsTable(:) => ByRow(argmax) => :prediction)

# ╔═╡ 31e4d220-5032-11eb-2a98-671624a40b07
string(transform(df7, AsTable(:) => ByRow(argmax) => :prediction)[1, :prediction])

# ╔═╡ e7f28678-74ce-11eb-260a-ef3b6576bcc2
md"👉 In the diamonds dataframe, write a select command to create two new columns: `Largest` - which calculates the largest dimension amongst x, y, z, and `Largest axis` which is either x, y, z along which the largest dimension was found."

# ╔═╡ 5380a4b8-5032-11eb-18b1-b5aa0ec65677
md"#### Joins"

# ╔═╡ 5944e882-5032-11eb-150b-6153c7bbccd5
md"A common action to be performed in data manipulation is to combine the data across multiple dataframes. The different ways of joining data forms an important part in any database course. For a quick overview see [this](https://en.wikipedia.org/wiki/Join_(SQL)) helpfully detailed page on Wikipedia"

# ╔═╡ 1c0c7f38-5033-11eb-2026-05c96439cd4b
players = DataFrame(Jersey = [10, 8, 19], Name = ["Sachin Tendulkar", "Anil Kumble", "Rahul Dravid"])

# ╔═╡ 75b13424-5034-11eb-2103-d7b7e0636164
roles = DataFrame(Jersey = [10, 8, 24], Job = ["Batsman", "Leg spinner", "Captain"])

# ╔═╡ a8efdb18-5034-11eb-1d61-335fd069e273
innerjoin(players, roles, on = :Jersey)

# ╔═╡ 886d70fe-5035-11eb-287e-4bdd2388c053
md"Let us use Pluto's interactivity and some cool Julia syntax to try out different other types of joins"

# ╔═╡ 49a45892-74cf-11eb-3487-9501aab49a7e
md"Try out each of the possible joins below in the dropdown and see its effect."

# ╔═╡ 39b697f6-50a8-11eb-301a-0d829c9ea14d
begin
	prompt = Dict("innerjoin" => "The output contains rows for values of the key that exist in all passed data frames", "leftjoin" => "The output contains rows for values of the key that exist in the first (left) argument, whether or not that value exists in the second (right) argument.", "rightjoin" => "The output contains rows for values of the key that exist in the second (right) argument, whether or not that value exists in the first (left) argument.", "outerjoin" => "The output contains rows for values of the key that exist in any of the passed data frames.", "semijoin" => "Like an inner join, but output is restricted to columns from the first (left) argument.", "antijoin" => "The output contains rows for values of the key that exist in the first (left) but not the second (right) argument. As with semijoin, output is restricted to columns from the first (left) argument.")
end

# ╔═╡ 38fa429a-5035-11eb-2c28-95752c218eb1
@bind jointype Select(["innerjoin", "leftjoin", "rightjoin", "outerjoin", "semijoin", "antijoin"])

# ╔═╡ 8d878060-50a9-11eb-1e5b-1d46abf93d19
begin
	output = prompt[jointype]
	md"$output"
end

# ╔═╡ 77b0aab0-5035-11eb-3203-61cf9603c09f
getfield(DataFrames, Symbol(jointype))(players, roles, on = :Jersey)

# ╔═╡ e83b5134-5037-11eb-31f9-93a2e545a174
md"#### Split-Apply-Combine"

# ╔═╡ f1cb42a4-5037-11eb-19b3-11e1cbc3898c
md"
Many data operations involve a sequence of the following three operations:
1. _Split_ data set into groups
2. _Apply_ some functions or transformations on each group separately
3. _Combine_ results from different groups
"

# ╔═╡ 4cc32816-5038-11eb-391f-651889126b66
md"This process is described in great detail (with graphics and examples) in [this](https://www.jstatsoft.org/index.php/jss/article/view/v040i01/v40i01.pdf) paper."

# ╔═╡ 28b04e72-50ab-11eb-39fa-01758aed2871
md"To use files in Pluto, we can use a file picker."

# ╔═╡ cafde6d2-74cb-11eb-2dda-2f895a328dd2
md"You can use Pluto to work with local files, by adding a filepicker as shown below"

# ╔═╡ 246ca6ee-50ab-11eb-3d58-81843829a32b
@bind f PlutoUI.FilePicker() 

# ╔═╡ d6b2715a-74cb-11eb-2f8a-b9f6a20895f3
md"For this tutorial, we will be using the RDatasets package which has many of the interesting datasets for us"

# ╔═╡ b65971f6-74cb-11eb-3cb1-43a033b360d3
Iris = dataset("datasets", "iris")

# ╔═╡ cf2a0ff4-50ab-11eb-363d-b7aa7467876b
md"We can summarise dataframes to quickly get a sense of what the columns are like. It calculates statistics, but more on this later."

# ╔═╡ e9f09aa6-50ab-11eb-0973-bda264b6637e
describe(Iris)

# ╔═╡ 538609f6-50ac-11eb-3f36-dbc78ef740f5
md"This is not quite helpful for `string` fields. We can check the unique values with the `unique` command."

# ╔═╡ 2cf9f3d8-50ac-11eb-33ed-3fd3cfdd91c0
unique(Iris.Species)

# ╔═╡ fef98472-50ac-11eb-0992-e50602b5667c
md"To compute frequency counts, one of the good options (that works well with DataFrames) is the `FreqTables.jl` library." 

# ╔═╡ a8b8646c-50ac-11eb-1b8c-03ee856da36c
freqtable(Iris.Species)

# ╔═╡ 67f23202-50ac-11eb-0f5c-53c2579f8b93
md"But we may also want to convert this column into a categorical column. We can do this inplace with `categorical!`"

# ╔═╡ 086fe27a-50ac-11eb-2c36-73cae74cd4ea
IrisCat = categorical(Iris, :Species, compress=true)

# ╔═╡ 507fc780-50be-11eb-3bf9-9b53314547fc
freqtable(IrisCat.Species)


# ╔═╡ 62ab88a6-50ad-11eb-14a1-4f13505743c5
md"Back to split-combine-apply. First we can `groupby` the data on a specific field."

# ╔═╡ 54a8be54-50ad-11eb-15f0-fb33b5e890f9
gdf = groupby(Iris, :Species)

# ╔═╡ e5d124e8-50ad-11eb-3929-ffbe4ad5a34d
md"Once we have the data split as per `Species`, we want to apply a function and then combine the results. One simple function is to compute the `mean`. We will use the `Statistics` package to do this. This is a package we will use a lot."

# ╔═╡ 9870c276-50ad-11eb-0bbc-69a75ca01ca6
combine(gdf, :PetalLength => mean)

# ╔═╡ 02a854b8-50b0-11eb-36b6-5391455c6067
md"We can also compute multiple columns using for instance the `extrema` function that we had seen earlier."

# ╔═╡ 113fc6d2-50b0-11eb-1bd1-83ad2189b1f3
combine(gdf, :PetalLength => (x -> [extrema(x)]) => [:min, :max])

# ╔═╡ 3af1fd76-50ae-11eb-233d-c1900d65f6bd
md"We can create multiple apply functions and then combine them together."

# ╔═╡ 56fd3198-50ae-11eb-3545-79baa8e18c80
combine(gdf, :SepalLength => mean, :SepalWidth => mean, :PetalLength => mean)

# ╔═╡ c570e282-50ae-11eb-2907-3d5bfc5fb6cb
md"We can also apply functions across columns"

# ╔═╡ ccb232da-50ae-11eb-369d-fdfbc59638c6
combine(gdf, [:PetalLength, :SepalLength] => ((p, s) -> (a=mean(p)/mean(s))) => :two_lengths)

# ╔═╡ 2703f45e-50b0-11eb-139f-dfc3bf1de490
md"We can also access different parts of a grouped structure individually"

# ╔═╡ f94d01dc-50b3-11eb-00d9-c3bcc9cba289
gdf[1]

# ╔═╡ 7b390ed8-75e3-11eb-343c-b38b5fd416cc
md"👉 Try out group by two different columns"

# ╔═╡ 2694f998-75c8-11eb-280d-61943feeb8c3
md"### Differently organising the dataframe"

# ╔═╡ 63c723b4-50b5-11eb-0d5a-651ed812b699
md"There are different ways in which data can formatted. The common one is what we saw where each row is a flower and columns are all its properties."

# ╔═╡ 61c7feb8-50b4-11eb-2d14-a5a09c2cbadf
Iris

# ╔═╡ eab1b56a-50b5-11eb-362f-f72b9a5b9ad5
md"Let us add to this table an index which denotes a unique number of each flower."

# ╔═╡ f74f21f4-50b5-11eb-01ea-f32f27e075c0
insertcols!(Iris, 1, :Index => 1:150, makeunique=true)

# ╔═╡ ccb7540c-50b5-11eb-0584-1da2140322ce
md"An alternative is to have each data-item in a single row"

# ╔═╡ 5c03b2c4-50b4-11eb-3870-13459725f829
IrisStacked = stack(Iris, 2:6, :Index)

# ╔═╡ 7de8c59e-50bb-11eb-16af-4b02ba7c577a
md"A better way to see this would be to sort the dataframe"

# ╔═╡ 5bfbe84c-50bb-11eb-17db-15ac85f02f03
sort(IrisStacked)

# ╔═╡ 88a488ba-50bb-11eb-1e10-a766f21a86d8
md"Now we can see that every row contains one data-point and the details of a single flower are spread across 5 rows."

# ╔═╡ ca822d50-50bb-11eb-391b-b18f27cbe6cd
md"So with the `stack` command, we have moved from a fat short matrix to a thin tall matrix. We can now move in the reverse direction with the `unstack` command."

# ╔═╡ b0141668-50bb-11eb-1948-574d89edf39c
unstack(IrisStacked, :Index, :variable, :value)

# ╔═╡ 3a6e3e66-75c8-11eb-15b3-656eba412155
md"👉 Think through the advantages and disadvantages of the _long_ and _wide_ formats"

# ╔═╡ d74c4188-75c8-11eb-2098-5154990736ba
md"For a good overview of these choices, it is recommended that you read [this paper titled 'Tidy Data'](https://vita.had.co.nz/papers/tidy-data.pdf)"

# ╔═╡ Cell order:
# ╟─f30185a6-5015-11eb-1a8d-25603607e724
# ╟─b66b26ee-5016-11eb-01e6-694b2e39bf5d
# ╟─4ae89f8e-5016-11eb-16df-13d654d299d5
# ╟─5f4fdd02-5016-11eb-201d-1d9426646956
# ╟─16b7eac0-5017-11eb-15e5-b9f201470cbc
# ╟─c8529ea0-5016-11eb-38d9-c1ecc5550d2d
# ╠═0532232e-5017-11eb-2ee5-bd82db649d1c
# ╟─b3d48e04-5016-11eb-28f2-c71e4540a0dc
# ╟─35fabd48-5017-11eb-1a67-e90302279f9e
# ╟─4efdd714-5017-11eb-05d3-6dcec7617db1
# ╠═5ec1b85a-5017-11eb-1652-877f43479ca0
# ╟─b31b85fe-5017-11eb-22fa-13762810aa85
# ╠═c0d7126a-5017-11eb-2af4-89db7d01e57a
# ╟─083152f2-74cc-11eb-3882-8b79170cd7aa
# ╟─ec081484-5017-11eb-05a9-75fdf117f284
# ╠═f2cdcade-5017-11eb-3ecf-59e0476e76e7
# ╟─1feb0404-5019-11eb-17c6-cdf37432a2b0
# ╠═2dcaacca-5019-11eb-3691-b99785b2dce9
# ╟─a43be892-5017-11eb-1962-d30a900d1bae
# ╠═c42539c2-5019-11eb-2521-f978d2dc23a6
# ╟─5f569306-74cc-11eb-1efe-671de09ad499
# ╠═ab5fe00a-74cb-11eb-1b63-8358d1a19718
# ╠═1bd6c8c0-7969-11eb-3f1c-17cbe159a26d
# ╠═fd412c90-797a-11eb-1f71-075ec205a39f
# ╟─f005c3d0-501a-11eb-20e4-1f42902ba037
# ╟─f9b80a8c-501a-11eb-2b51-8b7ca90b99fc
# ╟─13bac0d6-501c-11eb-0c0e-1d91358a121b
# ╠═15885816-501b-11eb-3070-ff59092748e8
# ╠═75939448-501b-11eb-2a93-b1679d178b36
# ╠═7c44c238-501b-11eb-2ce0-81e458713d63
# ╠═8be7f980-501b-11eb-3f71-879d6490e0a6
# ╠═bd25434a-501b-11eb-2251-b92ecfd1e7b7
# ╠═d84c0596-501b-11eb-0a10-a768b0538384
# ╟─1c6ed2bc-501c-11eb-37a0-b7cecc35c6fe
# ╠═53458446-501c-11eb-10df-85efdd2c8e78
# ╠═25de35c2-501c-11eb-2666-5f73b1e2b004
# ╟─a02b1e7e-74cc-11eb-1400-7f702301e663
# ╠═aefc5360-7962-11eb-3e23-fbb46cdf92dd
# ╠═add1dd20-7962-11eb-1e18-7d4de9e5f0c7
# ╟─78f9d638-5028-11eb-0378-f52a1d091d11
# ╠═a2cfe2ce-5028-11eb-1341-892384a89e52
# ╠═5d86370e-501c-11eb-15bb-5f0095fc5e41
# ╠═be611380-5028-11eb-2e4e-a956b61e501f
# ╟─bae24224-74cc-11eb-1235-29eec31f5fe0
# ╠═41e0254e-7ab5-11eb-1794-0f11687dc655
# ╠═41376230-7ab5-11eb-3a37-19897d26a0e8
# ╟─0dc5a0f2-502f-11eb-23b0-89669cb10fc5
# ╠═36703c42-502f-11eb-01fe-d1b6e32454db
# ╟─58cfd450-502f-11eb-01e9-e77d7d31dcf5
# ╠═a6416e74-502f-11eb-3763-d71db19aa35d
# ╠═6819c894-502f-11eb-1502-0b8abafed9a5
# ╟─d36bfbaa-74cc-11eb-370d-f387239ee7ca
# ╠═61945f60-7b3c-11eb-1574-7da8ce075837
# ╠═53a82460-7b3a-11eb-3461-c90925f5a6be
# ╟─4c025570-7ab6-11eb-193a-99c726f6eac9
# ╠═37970c30-7b78-11eb-2783-b7e60a8dc32a
# ╠═4516dbb0-7b78-11eb-052f-0d0582e70faa
# ╟─f85c27da-502f-11eb-3628-d9e4fba3a36a
# ╠═02e69f0a-5030-11eb-376c-2909777b59ef
# ╠═09dacec6-5030-11eb-1420-2fa4b4384a7b
# ╠═0e9da3e8-5030-11eb-2595-09e52e9dc5bb
# ╠═6dd0ed84-5030-11eb-28ec-416ed6ef4e00
# ╟─92673a22-5030-11eb-0657-7583d5dfda62
# ╠═f701ade2-74cc-11eb-27cf-cfeb48f63662
# ╠═d3fdf860-7ab8-11eb-3bc0-f1e6b2e52eec
# ╟─a2dba6b8-5030-11eb-1bdb-656ac06ecd58
# ╠═8807526a-5030-11eb-2476-411d7af8938d
# ╠═d48515da-5030-11eb-2e6d-b51cc9f54c40
# ╟─8b74e2f8-74ce-11eb-31c2-6f4a42953d89
# ╟─386e6730-7ab9-11eb-256b-9f879495ed47
# ╠═5e0be22e-5031-11eb-02b1-679548ac5754
# ╠═6c7039f8-5031-11eb-1049-1d1bef7cbf3e
# ╟─bffd0eea-74ce-11eb-18c1-43dc5a6eec6f
# ╠═a8bc02ca-5031-11eb-016a-6974fbe0a879
# ╠═b96cb2e0-5031-11eb-1be8-f90e124225f6
# ╠═c62c16f4-5031-11eb-11e1-e181d156670e
# ╟─d2d84480-74ce-11eb-0f13-f1bef9d197f5
# ╟─06fe9d18-74cf-11eb-0723-1dd875c22fea
# ╠═d8a720dc-5031-11eb-04ac-817b4512d51a
# ╠═31e4d220-5032-11eb-2a98-671624a40b07
# ╟─e7f28678-74ce-11eb-260a-ef3b6576bcc2
# ╟─5380a4b8-5032-11eb-18b1-b5aa0ec65677
# ╟─5944e882-5032-11eb-150b-6153c7bbccd5
# ╠═1c0c7f38-5033-11eb-2026-05c96439cd4b
# ╠═75b13424-5034-11eb-2103-d7b7e0636164
# ╠═a8efdb18-5034-11eb-1d61-335fd069e273
# ╟─886d70fe-5035-11eb-287e-4bdd2388c053
# ╠═346e3170-5035-11eb-1d53-f3717ff82404
# ╟─49a45892-74cf-11eb-3487-9501aab49a7e
# ╟─39b697f6-50a8-11eb-301a-0d829c9ea14d
# ╠═38fa429a-5035-11eb-2c28-95752c218eb1
# ╟─8d878060-50a9-11eb-1e5b-1d46abf93d19
# ╠═77b0aab0-5035-11eb-3203-61cf9603c09f
# ╟─e83b5134-5037-11eb-31f9-93a2e545a174
# ╟─f1cb42a4-5037-11eb-19b3-11e1cbc3898c
# ╟─4cc32816-5038-11eb-391f-651889126b66
# ╟─28b04e72-50ab-11eb-39fa-01758aed2871
# ╟─cafde6d2-74cb-11eb-2dda-2f895a328dd2
# ╠═246ca6ee-50ab-11eb-3d58-81843829a32b
# ╟─d6b2715a-74cb-11eb-2f8a-b9f6a20895f3
# ╠═b65971f6-74cb-11eb-3cb1-43a033b360d3
# ╠═878ae3d0-50ab-11eb-265d-d52ac266e8a4
# ╟─cf2a0ff4-50ab-11eb-363d-b7aa7467876b
# ╠═e9f09aa6-50ab-11eb-0973-bda264b6637e
# ╟─538609f6-50ac-11eb-3f36-dbc78ef740f5
# ╠═2cf9f3d8-50ac-11eb-33ed-3fd3cfdd91c0
# ╟─fef98472-50ac-11eb-0992-e50602b5667c
# ╠═ea900542-50ac-11eb-2869-e5694b94f504
# ╠═a8b8646c-50ac-11eb-1b8c-03ee856da36c
# ╟─67f23202-50ac-11eb-0f5c-53c2579f8b93
# ╠═086fe27a-50ac-11eb-2c36-73cae74cd4ea
# ╠═507fc780-50be-11eb-3bf9-9b53314547fc
# ╟─62ab88a6-50ad-11eb-14a1-4f13505743c5
# ╠═54a8be54-50ad-11eb-15f0-fb33b5e890f9
# ╟─e5d124e8-50ad-11eb-3929-ffbe4ad5a34d
# ╠═15f6a92c-50ae-11eb-0a64-4de1f7bb490a
# ╠═9870c276-50ad-11eb-0bbc-69a75ca01ca6
# ╟─02a854b8-50b0-11eb-36b6-5391455c6067
# ╠═113fc6d2-50b0-11eb-1bd1-83ad2189b1f3
# ╟─3af1fd76-50ae-11eb-233d-c1900d65f6bd
# ╠═56fd3198-50ae-11eb-3545-79baa8e18c80
# ╟─c570e282-50ae-11eb-2907-3d5bfc5fb6cb
# ╠═ccb232da-50ae-11eb-369d-fdfbc59638c6
# ╟─2703f45e-50b0-11eb-139f-dfc3bf1de490
# ╠═f94d01dc-50b3-11eb-00d9-c3bcc9cba289
# ╟─7b390ed8-75e3-11eb-343c-b38b5fd416cc
# ╟─2694f998-75c8-11eb-280d-61943feeb8c3
# ╟─63c723b4-50b5-11eb-0d5a-651ed812b699
# ╠═61c7feb8-50b4-11eb-2d14-a5a09c2cbadf
# ╟─eab1b56a-50b5-11eb-362f-f72b9a5b9ad5
# ╠═f74f21f4-50b5-11eb-01ea-f32f27e075c0
# ╟─ccb7540c-50b5-11eb-0584-1da2140322ce
# ╠═5c03b2c4-50b4-11eb-3870-13459725f829
# ╟─7de8c59e-50bb-11eb-16af-4b02ba7c577a
# ╠═5bfbe84c-50bb-11eb-17db-15ac85f02f03
# ╟─88a488ba-50bb-11eb-1e10-a766f21a86d8
# ╟─ca822d50-50bb-11eb-391b-b18f27cbe6cd
# ╠═b0141668-50bb-11eb-1948-574d89edf39c
# ╟─3a6e3e66-75c8-11eb-15b3-656eba412155
# ╟─d74c4188-75c8-11eb-2098-5154990736ba

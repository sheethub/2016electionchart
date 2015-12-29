
err, data <- d3.tsv "./data.tsv"


ratio = data
|> _.map (->
	{
		"key": new Date(+it.year, 0, 1)
		"value": +it.ratio
	}
	)

population = data
|> _.map (->
	{
		"key": new Date(+it.year, 0, 1)
		"value": +it.population
	}
	)
		

average = data
|> _.map (->
	{
		"key": new Date(+it.year, 0, 1)
		"value": +it.average
	}
	)

thousand = d3.format "0,000"

drawRatio = lineChart!
	.data [ratio]
	.container '#line1'
	.numberFormat -> it.value * 100 |> (-> it.toFixed 0) |> (-> it + "%")

drawAverage = lineChart!
	.data [average]
	.container '#line2'
	.numberFormat -> (it.value.toFixed 0) + "歲"

drawPopulation = lineChart!
	.data [population]
	.container '#line3'
	.numberFormat -> (it.value / 10) |> Math.round |> thousand |> (-> it + "萬人") 


drawRatio!
drawAverage!
drawPopulation!

drawRatio.draw!
drawAverage.draw!
drawPopulation.draw!
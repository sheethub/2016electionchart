_ = require "prelude-ls"

lineChart = -> 

	chrt = {}

	chrt.container = null
	chrt.data = null

	chrt.margin = {top: 80, left: 80, right: 80, bottom: 80}
	chrt.w = 480 - chrt.margin.left - chrt.margin.right
	chrt.h = 480 - chrt.margin.top - chrt.margin.bottom

	chrt.duration = 500
	chrt.delay = 2000
	chrt.numberFormat = null
	chrt.color = '#41afa5'
	chrt.strokeWidth = "3px"

	chrt.xGridNumber = 5
	chrt.tickValues = null
	chrt.scaleX = null
	chrt.tickFormat = d3.time.format "%Y"

	svg = null
	


	build = ->
		if chrt.data is null or chrt.container is null then return

		svg := d3.select chrt.container
			.insert "svg", "span"
			.attr {
				"viewBox": "0 0 " + (chrt.w + chrt.margin.left + chrt.margin.right) + " " + (chrt.h + chrt.margin.top + chrt.margin.bottom)
				"width": "100%"
				"height": "100%"
				"preserveAspectRatio": "xMinYMin meet"
			}
			.append "g"
			.attr {
				"transform": "translate(" + chrt.margin.left + "," + chrt.margin.top + ")"
			}

	build.draw = ->


		extent = chrt.data
			|> _.map ((row)-> d3.extent row, -> it.key )
			|> _.flatten
			|> (-> d3.extent it)

		max = chrt.data
			|> _.map ((row)-> d3.max row, -> it.value )
			|> _.flatten
			|> (-> d3.max it)

		# scaleX = d3.scale.linear!
		# 	.domain extent
		# 	.range [0, chrt.w]

		# scaleX = d3.time.scale!
		# 	.domain extent
		# 	.range [0, chrt.w]

		if chrt.scaleX is null
			scaleX = d3.time.scale!
				.domain extent
				.range [0, chrt.w]
		else
			scaleX = chrt.scaleX

		scaleY = d3.scale.linear!
			.domain [0, max]
			.range [chrt.h, 0]


		svg
			.selectAll ".gridX"
			.data [0 to chrt.w by (chrt.w / chrt.xGridNumber)]
			.enter!
			.append "line"
			.attr {
				"x1": -> it
				"x2": -> it
				"y1": 0
				"y2": chrt.h
				"class": "gridX"
			}
			.style {
				"stroke": '#D8D5D5'
				"stroke-width": "1px"
				# "shape-rendering": "crispEdges"
			}


		svg
			.selectAll ".gridY"
			.data [0 to chrt.h by (chrt.h / 5)]
			.enter!
			.append "line"
			.attr {
				"x1": 0
				"x2": chrt.w
				"y1": -> it
				"y2": -> it
				"class": "gridY"
			}
			.style {
				"stroke": '#D8D5D5'
				"stroke-width": "1px"
				# "shape-rendering": "crispEdges"
			}




		path = d3.svg.line!
			.x -> it.key |> scaleX
			.y -> it.value |> scaleY
			.interpolate "monotone"

		line = svg
			.selectAll ".line"
			.data chrt.data

		line
			.enter!
			.append "path"
			.attr {
				"class": "line"
			}

		line
			.attr {
				"d": path
			}
			.style {
				"stroke": chrt.color
				"stroke-width": chrt.strokeWidth
				"fill": "none"
				"stroke-dasharray": -> 
					l = (d3.select @ ).node!.getTotalLength!
					(l) + " " + (l) ## in case that zooming caused path to be too short
				"stroke-dashoffset": -> (d3.select @ ).node!.getTotalLength!
			}
			.transition!
			.duration chrt.duration
			.delay chrt.delay
			.ease 'linear'
			.style {
				"stroke-dashoffset": 0
			}

		track = line
			.attr {
				"d": path
			}
			.style {
				"fill": "none"
			}



		svg
			.selectAll ".head"
			.data (chrt.data |> _.map (-> it |> _.head))
			.enter!
			.append "circle"
			.attr {
				"cx": -> it.key |> scaleX
				"cy": -> it.value |> scaleY
				"r": 3
				"class": "head"
			}
			.style {
				"fill": chrt.color
				"stroke": chrt.color
				"stroke-width": chrt.strokeWidth
			}


		circle = svg
			.selectAll ".tail"
			.data (chrt.data |> _.map (-> it |> _.head))
			.enter!
			.append "circle"
			.attr {
				"cx": 0
				"cy": 0
				"r": 3
				"class": "tail"
				# "translate": -> "transform(" + (it.key |> scaleX) + "," + (it.value |> scaleY) + ")"
			}
			.style {
				"fill": chrt.color
				"stroke": chrt.color
				"stroke-width": chrt.strokeWidth
				"opacity": 0
			}

		translateAlong = (path)->
			l = path.getTotalLength!
			(d, i, a)->
				(t)->
					p = path.getPointAtLength(t * l)
					return "translate(" + p.x + "," + p.y + ")"
		

		circle
			.transition!
			.duration chrt.duration
			.delay chrt.delay
			.ease 'linear'
			.style {
				"opacity": 1
			}
			.attrTween "transform", (it, i)->
				f = (d3.select(track[0][i]).node!) |> translateAlong
				it |> f

		svg
			.selectAll ".numberGroup"
			.data (chrt.data |> _.map (-> [(_.head it), (_.last it)])) 
			.enter!
			.append "g"
			.attr {
				"class": "numberGroup"
			}
			.selectAll "text"
			.data -> it
			.enter!
			.append "text"
			.text -> if chrt.numberFormat is null then it.value else it |> chrt.numberFormat
			.attr {
				"class": "number"
				"x": -> it.key |> scaleX
				"y": -> (it.value |> scaleY) - 20
			}
			.style {
				"text-anchor": "middle"
				"opacity": 0
			}
			.transition!
			.duration 0
			.delay (it, i)-> i * (chrt.duration + chrt.delay)
			.ease 'linear'
			.style {
				"opacity": 1
			}

		
		xAxis = d3.svg.axis!
			.scale scaleX
			.tickValues (if chrt.tickValues then chrt.tickValues else extent)
			.tickFormat chrt.tickFormat
			
			.orient "bottom"


		svg
			.append "g"
			.call xAxis
			.attr {
				"transform": "translate(0," + chrt.h + ")"
				"class": "axis"
			}


	for let it of chrt
		build[it] = (v)->
			if arguments.length is 0
				return chrt[it]
			else 
				chrt[it] := v
				build

	build


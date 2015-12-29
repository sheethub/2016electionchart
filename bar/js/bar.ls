_ = require "prelude-ls"

barChart = -> 

	chrt = {}

	chrt.container = null
	chrt.data = null

	chrt.margin = {top: 10, left: 80, right: 50, bottom: 20}
	chrt.w = 500 - chrt.margin.left - chrt.margin.right
	chrt.h = null ### will growth according to data & barHeighteight

	chrt.barHeight = 25
	chrt.barMargin = 5

	chrt.duration = 2000
	chrt.delay = 200
	gradientData = [
		{"offset": "0%", "color": "rgb(215, 235, 97)"}
		{"offset": "100%", "color": "rgb(80, 180, 115)"}
	]
	chrt.barStyle = null
	chrt.textFunc = (-> if it is 0 then "" else it.toFixed 0)
	chrt.svg = null

	build = ->
		if chrt.data is null or chrt.container is null then return
		
		chrt.h := chrt.data.length * chrt.barHeight + (chrt.data.length - 1) * chrt.barMargin

		chrt.svg := d3.select chrt.container
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
		scaleX = d3.scale.linear!
			.domain [0, d3.max chrt.data, -> it.value ]
			.range [0, chrt.w]

		scaleY = (i)->
			i * (chrt.barHeight + chrt.barMargin)

		chrt.svg
			.append "linearGradient"
			.attr {
				"id": "themeGradient"
				"gradientUnits": "userSpaceOnUse"
				"x1": 0
				"x2": chrt.w
				"y1": 0
				"y2": 0
			}
			.selectAll "stop"
			.data gradientData
			.enter!
			.append "stop"
			.attr {
				"offset": -> it.offset
				"stop-color": -> it.color
			}


		bars = chrt.svg
			.selectAll ".bars"
			.data chrt.data

		bars
			.enter!
			.append "rect"
			.attr {
				"width": 0
				"class": "bars"
			}

		bars
			.transition!
			.duration chrt.duration
			.delay (it, i)-> i * chrt.delay
			.attr {
				"width": -> it.value |> scaleX
				"height": -> chrt.barHeight 
				"x": 0
				"y": (it, i)-> (scaleY i)
			}

		if chrt.barStyle is not null then bars.call chrt.barStyle
			
		chrt.svg
			.selectAll ".name"
			.data chrt.data
			.enter!
			.append "text"
			.attr {
				"x": -30
				"y": (it, i)-> (scaleY i) + (chrt.barHeight / 2) + 7 ### font-size
				"class": "name"
			}
			.style {
				"text-anchor": "end"
			}
			.text -> it.key


		chrt.svg
			.selectAll ".number"
			.data chrt.data
			.enter!
			.append "text"
			.attr {
				"x": 5
				"y": (it, i)-> (scaleY i) + (chrt.barHeight / 2) + 7 ### font-size
				"class": "number"
			}
			.style {
				"text-anchor": "start"
			}
			.transition!
			.duration chrt.duration
			.delay (it, i)-> i * chrt.delay
			.attr {
				"x": -> (it.value |> scaleX) + 5
			}
			.tween "text", -> 
				i = d3.interpolate @textContent, it.value
				(n)->
					@textContent = n |> i |> chrt.textFunc



	for let it of chrt
		build[it] = (v)->
			if arguments.length is 0
				return chrt[it]
			else 
				chrt[it] := v
				build

	build




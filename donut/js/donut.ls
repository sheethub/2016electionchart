_ = require "prelude-ls"

donutChart = -> 

	chrt = {}

	chrt.container = null
	chrt.data = null

	chrt.margin = {top: 100, left: 50, right: 50, bottom: 50}
	chrt.w = 500 - chrt.margin.left - chrt.margin.right
	chrt.h = 500 - chrt.margin.top - chrt.margin.bottom ### will growth according to data & barHeighteight

	chrt.outerRadius = (chrt.h / 2)
	chrt.innerRadius = chrt.outerRadius - 20
	
	chrt.cornerRadius = 10
	chrt.startAngle = 0

	chrt.duration = 1500

	chrt.notes = ""
	chrt.textFunc = (-> it)
	chrt.ease = "linear"
	chrt.svg = null
	chrt.textStyle = (-> )


	svg = null
	tau = 2 * Math.PI

	foreground = undefined
	number = undefined
	scale = undefined
	arcTween = undefined
	textTween = undefined
	arc = undefined
		

	chrt.backgroundStyle = ->
		it
			.style {
				"fill": "rgb(232, 233, 121)"
			}

	chrt.foregroundStyle = ->
		it
			.style {
				"fill": "rgb(84, 179, 108)"
			}
		
	build = ->
		if chrt.data is null or chrt.container is null then return
		if chrt.svg is null
			chrt.svg := d3.select chrt.container
				.insert "svg", ".notes"
				.attr {
					"viewBox": "0 0 " + (chrt.w + chrt.margin.left + chrt.margin.right) + " " + (chrt.h + chrt.margin.top + chrt.margin.bottom)
					"width": "100%"
					"height": "100%"
					"preserveAspectRatio": "xMinYMin meet"
				}
				.append "g"
				.attr {
					"transform": "translate(" + ((chrt.w / 2) + chrt.margin.left) + "," + ((chrt.h / 2) + chrt.margin.top) + ")"
				}
				.append "g"

			scale := d3.scale.linear!
				.domain [0, chrt.data.total]
				.range [0, tau] ### arc doesn't seem to work with 0

			arc := d3.svg.arc!
				.innerRadius chrt.innerRadius
				.outerRadius chrt.outerRadius
				.cornerRadius chrt.cornerRadius
				.startAngle chrt.startAngle

			arcTween := (transition, newAngle)->
				transition.attrTween "d", -> 
					interpolate = d3.interpolate it.endAngle, newAngle
					return (t)->
						it.endAngle = interpolate t
						return arc it

			textTween := (transition, newValue)->
				transition.tween "text", ->
					interpolate = @.textContent |> parseFloat |> d3.interpolate _, newValue
					return (t)->
						@.textContent = t |> interpolate |> (-> if chrt.textFunc then it |> chrt.textFunc else it)

			build



	build.draw = ->
		
		chrt.svg
			.append "path"
			.datum {endAngle: tau}
			.attr {
				"d": arc
			}
			.call chrt.backgroundStyle

		chrt.svg
			.append "text"
			.style {
				"text-anchor": "middle"
				"font-size": "25px"	
			}
			.attr {
				"transform": "translate(0," + -(chrt.h / 2 + 30) + ")"
			}
			.text chrt.data.notes
			
		foreground :=  chrt.svg
			.append "path"
			.datum {endAngle: 0.01}
			.attr {
				"d": arc
			}
			.call chrt.foregroundStyle

		number := chrt.svg
			.append "text"
			.text (-> if chrt.textFunc then (chrt.textFunc 0) else 0)
			.attr {
				"class": "numbers"
				"font-size": "50px"
				"text-anchor": "middle"
				"transform": "translate(10,25)"
			}
			.call chrt.textStyle



		@update!
		build

				
	build.update = (data)->
		if data is undefined then data = chrt.data

		foreground
			.transition!
			.duration chrt.duration
			.ease chrt.ease
			.call arcTween, (data.value |> scale)

		number
			.transition!
			.duration chrt.duration
			.ease chrt.ease
			.call textTween, data.value
		build




	for let it of chrt
		build[it] = (v)->
			if arguments.length is 0
				return chrt[it]
			else 
				chrt[it] := v
				build

	build



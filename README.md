#Design Concept

0. A collection of common chart based on d3.js
1. Following Mike Bostock's [Reusable Chart](http://bost.ocks.org/mike/chart/) pattern
2. Responsive using SVG viewbox
3. Entering Animation
4. Flexible


#Example Bar Chart

		data = [
			{"key": '彰化碧峰里', "value": 	43}
			{"key": '花蓮森榮里', "value": 	41}
			{"key": '南投光明里', "value": 	41}
			{"key": '台灣平均', "value": 	12}
			{"key": '新竹東平里', "value": 	2}
			{"key": '新竹關新里', "value": 2}
			{"key": '新竹大鵬里', "value": 2}
		]


		margin = {top: 10, left: 120, right: 50, bottom: 20}

		colorFunc = ->
			it
				.style {
					"fill": 'url(#themeGradient)'
				}


		firstBar = barChart!
			.data data
			.container '#bar'
			.margin margin
			.barHeight 25
			.barStyle colorFunc


		firstBar!
		firstBar.draw!
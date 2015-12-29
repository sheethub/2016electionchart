_ = require "prelude-ls"

hourDonut = null
minDonut = null
secDonut = null


do firstTick = ->

	hourDonut := donutChart!
		.data {"total": 24, "value": 0}
		.container '#donut1'
		.textFunc (-> it.toFixed 0)
		.ease "elastic"
	hourDonut!.draw!

	minDonut := donutChart!
		.data {"total": 60, "value": 0}
		.container '#donut2'
		.textFunc (-> it.toFixed 0)
		.ease "elastic"
	minDonut!.draw!

	secDonut := donutChart!
		.data {"total": 60, "value": 0}
		.container '#donut3'
		.textFunc (-> it.toFixed 0)
		.ease "elastic"
	secDonut!.draw!


do tick = ->
	d = new Date! 
	h = d.getHours! 
	m = d.getMinutes!
	s = d.getSeconds!

	hourDonut.update {"value": h}
	minDonut.update {"value": m}
	secDonut.update {"value": s}


setInterval (-> tick! ), 1000






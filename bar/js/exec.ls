
interData = [
	{"key": "日本", "value": 26}
	{"key": "義大利", "value": 21}
	{"key": "香港", "value": 14}
	{"key": "台灣", "value": 12}
	{"key": "星加坡", "value": 11}
	{"key": "中國", "value": 9}
	{"key": "越南", "value": 7}
]

innerData = [
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

colorByName = ->
	it
		.style {
			"fill": -> 
				if it.key is "台灣平均" then "orange" else 'url(#themeGradient)'
		}


firstBar = barChart!
	.data interData
	.container '#bar'
	.margin margin
	.barHeight 25
	.barStyle colorFunc


firstBar!
firstBar.draw!



secondBar = barChart!
	.data innerData
	.container '#bar2'
	.margin margin
	.barHeight 25
	.barStyle colorByName

secondBar!
secondBar.draw!



thirdBar = barChart!
	.data innerData
	.container '#bar3'
	.margin margin
	.textFunc (-> it.toFixed 2)
	.barHeight 25
	.barStyle colorByName

thirdBar!
thirdBar.draw!



# .textFunc (-> (it.toFixed 0) + "日")
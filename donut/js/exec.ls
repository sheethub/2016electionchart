
emptyHouses = {
	"value": 0.2
	"total": 1
	"notes": "我是一個甜甜圈！"
}

firstDonut = donutChart!
	.data emptyHouses
	.container '#donut1'
	.textFunc (-> ((it * 100).toFixed 0) + "%" )
firstDonut!
firstDonut.draw!


lowUilization = {
	"value": 0.105
	"total": 1
	"notes": "我是另一個甜甜圈！"
}

firstDonut2 = donutChart!
	.data lowUilization
	.container '#donut2'
	.textFunc (-> ((it * 100).toFixed 0) + "%" )
firstDonut2!
firstDonut2.draw!

selfOwned = {
	"value": 0.88
	"total": 1
	"notes": "我是第三個甜甜圈"
}

firstDonut3 = donutChart!
	.data selfOwned
	.container '#donut3'
	.textFunc (-> ((it * 100).toFixed 0) + "%" )
firstDonut3!
firstDonut3.draw!




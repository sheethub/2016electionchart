var _, dayDonut, hourDonut, minDonut, secDonut, smallText, firstTick, tick;
_ = require("prelude-ls");
dayDonut = null;
hourDonut = null;
minDonut = null;
secDonut = null;
smallText = function(it){
  return it.style({
    "font-size": "35px"
  });
};
(firstTick = function(){
  dayDonut = donutChart().data({
    "total": 100,
    "value": 0
  }).container('#donut0').textFunc(function(it){
    return it.toFixed(0) + "日";
  }).textStyle(smallText).ease("elastic");
  dayDonut().draw();
  hourDonut = donutChart().data({
    "total": 24,
    "value": 0
  }).container('#donut1').textFunc(function(it){
    return it.toFixed(0) + "時";
  }).textStyle(smallText).ease("elastic");
  hourDonut().draw();
  minDonut = donutChart().data({
    "total": 60,
    "value": 0
  }).container('#donut2').textFunc(function(it){
    return it.toFixed(0) + "分";
  }).textStyle(smallText).ease("elastic");
  minDonut().draw();
  secDonut = donutChart().data({
    "total": 60,
    "value": 0
  }).container('#donut3').textFunc(function(it){
    return function(it){
      return it.toFixed(0) + "秒";
    }(
    Math.abs(
    it));
  }).textStyle(smallText).ease("elastic");
  return secDonut().draw();
})();
(tick = function(){
  var t, now, diff, days, hour, min, sec;
  t = new Date("2016/01/16");
  now = new Date();
  diff = t - now;
  days = ~~(diff / (24 * 60 * 60 * 1000));
  hour = ~~(diff % (24 * 60 * 60 * 1000) / 3600000);
  min = ~~(diff % (24 * 60 * 60 * 1000) % 3600000 / 60000);
  sec = ~~(diff % (24 * 60 * 60 * 1000) % 3600000 % 60000 / 1000);
  dayDonut.update({
    "value": days
  });
  hourDonut.update({
    "value": hour
  });
  minDonut.update({
    "value": min
  });
  return secDonut.update({
    "value": sec
  });
})();
setInterval(function(){
  return tick();
}, 1000);
var _, hourDonut, minDonut, secDonut, firstTick, tick;
_ = require("prelude-ls");
hourDonut = null;
minDonut = null;
secDonut = null;
(firstTick = function(){
  hourDonut = donutChart().data({
    "total": 24,
    "value": 0
  }).container('#donut1').textFunc(function(it){
    return it.toFixed(0);
  }).ease("elastic");
  hourDonut().draw();
  minDonut = donutChart().data({
    "total": 60,
    "value": 0
  }).container('#donut2').textFunc(function(it){
    return it.toFixed(0);
  }).ease("elastic");
  minDonut().draw();
  secDonut = donutChart().data({
    "total": 60,
    "value": 0
  }).container('#donut3').textFunc(function(it){
    return it.toFixed(0);
  }).ease("elastic");
  return secDonut().draw();
})();
(tick = function(){
  var d, h, m, s;
  d = new Date();
  h = d.getHours();
  m = d.getMinutes();
  s = d.getSeconds();
  hourDonut.update({
    "value": h
  });
  minDonut.update({
    "value": m
  });
  return secDonut.update({
    "value": s
  });
})();
setInterval(function(){
  return tick();
}, 1000);
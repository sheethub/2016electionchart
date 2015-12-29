var _, donutChart;
_ = require("prelude-ls");
donutChart = function(){
  var chrt, svg, tau, foreground, number, scale, arcTween, textTween, arc, build, i$;
  chrt = {};
  chrt.container = null;
  chrt.data = null;
  chrt.margin = {
    top: 100,
    left: 50,
    right: 50,
    bottom: 50
  };
  chrt.w = 500 - chrt.margin.left - chrt.margin.right;
  chrt.h = 500 - chrt.margin.top - chrt.margin.bottom;
  chrt.outerRadius = chrt.h / 2;
  chrt.innerRadius = chrt.outerRadius - 20;
  chrt.cornerRadius = 10;
  chrt.startAngle = 0;
  chrt.duration = 1500;
  chrt.notes = "";
  chrt.textFunc = function(it){
    return it;
  };
  chrt.ease = "linear";
  chrt.svg = null;
  chrt.textStyle = function(){};
  svg = null;
  tau = 2 * Math.PI;
  foreground = undefined;
  number = undefined;
  scale = undefined;
  arcTween = undefined;
  textTween = undefined;
  arc = undefined;
  chrt.backgroundStyle = function(it){
    return it.style({
      "fill": "rgb(232, 233, 121)"
    });
  };
  chrt.foregroundStyle = function(it){
    return it.style({
      "fill": "rgb(84, 179, 108)"
    });
  };
  build = function(){
    if (chrt.data === null || chrt.container === null) {
      return;
    }
    if (chrt.svg === null) {
      chrt.svg = d3.select(chrt.container).insert("svg", ".notes").attr({
        "viewBox": "0 0 " + (chrt.w + chrt.margin.left + chrt.margin.right) + " " + (chrt.h + chrt.margin.top + chrt.margin.bottom),
        "width": "100%",
        "height": "100%",
        "preserveAspectRatio": "xMinYMin meet"
      }).append("g").attr({
        "transform": "translate(" + (chrt.w / 2 + chrt.margin.left) + "," + (chrt.h / 2 + chrt.margin.top) + ")"
      }).append("g");
      scale = d3.scale.linear().domain([0, chrt.data.total]).range([0, tau]);
      arc = d3.svg.arc().innerRadius(chrt.innerRadius).outerRadius(chrt.outerRadius).cornerRadius(chrt.cornerRadius).startAngle(chrt.startAngle);
      arcTween = function(transition, newAngle){
        return transition.attrTween("d", function(it){
          var interpolate;
          interpolate = d3.interpolate(it.endAngle, newAngle);
          return function(t){
            it.endAngle = interpolate(t);
            return arc(it);
          };
        });
      };
      textTween = function(transition, newValue){
        return transition.tween("text", function(){
          var interpolate;
          interpolate = d3.interpolate(parseFloat(
          this.textContent), newValue);
          return function(t){
            return this.textContent = function(it){
              if (chrt.textFunc) {
                return chrt.textFunc(
                it);
              } else {
                return it;
              }
            }(
            interpolate(
            t));
          };
        });
      };
      return build;
    }
  };
  build.draw = function(){
    chrt.svg.append("path").datum({
      endAngle: tau
    }).attr({
      "d": arc
    }).call(chrt.backgroundStyle);
    chrt.svg.append("text").style({
      "text-anchor": "middle",
      "font-size": "25px"
    }).attr({
      "transform": "translate(0," + -(chrt.h / 2 + 30) + ")"
    }).text(chrt.data.notes);
    foreground = chrt.svg.append("path").datum({
      endAngle: 0.01
    }).attr({
      "d": arc
    }).call(chrt.foregroundStyle);
    number = chrt.svg.append("text").text(function(){
      if (chrt.textFunc) {
        return chrt.textFunc(0);
      } else {
        return 0;
      }
    }).attr({
      "class": "numbers",
      "font-size": "50px",
      "text-anchor": "middle",
      "transform": "translate(10,25)"
    }).call(chrt.textStyle);
    this.update();
    return build;
  };
  build.update = function(data){
    if (data === undefined) {
      data = chrt.data;
    }
    foreground.transition().duration(chrt.duration).ease(chrt.ease).call(arcTween, scale(
    data.value));
    number.transition().duration(chrt.duration).ease(chrt.ease).call(textTween, data.value);
    return build;
  };
  for (i$ in chrt) {
    (fn$.call(this, i$));
  }
  return build;
  function fn$(it){
    build[it] = function(v){
      if (arguments.length === 0) {
        return chrt[it];
      } else {
        chrt[it] = v;
        return build;
      }
    };
  }
};
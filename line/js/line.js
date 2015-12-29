var _, lineChart;
_ = require("prelude-ls");
lineChart = function(){
  var chrt, svg, build, i$;
  chrt = {};
  chrt.container = null;
  chrt.data = null;
  chrt.margin = {
    top: 80,
    left: 80,
    right: 80,
    bottom: 80
  };
  chrt.w = 480 - chrt.margin.left - chrt.margin.right;
  chrt.h = 480 - chrt.margin.top - chrt.margin.bottom;
  chrt.duration = 500;
  chrt.delay = 2000;
  chrt.numberFormat = null;
  chrt.color = '#41afa5';
  chrt.strokeWidth = "3px";
  chrt.xGridNumber = 5;
  chrt.tickValues = null;
  chrt.scaleX = null;
  chrt.tickFormat = d3.time.format("%Y");
  svg = null;
  build = function(){
    if (chrt.data === null || chrt.container === null) {
      return;
    }
    return svg = d3.select(chrt.container).insert("svg", "span").attr({
      "viewBox": "0 0 " + (chrt.w + chrt.margin.left + chrt.margin.right) + " " + (chrt.h + chrt.margin.top + chrt.margin.bottom),
      "width": "100%",
      "height": "100%",
      "preserveAspectRatio": "xMinYMin meet"
    }).append("g").attr({
      "transform": "translate(" + chrt.margin.left + "," + chrt.margin.top + ")"
    });
  };
  build.draw = function(){
    var extent, max, scaleX, scaleY, path, line, track, circle, translateAlong, xAxis;
    extent = function(it){
      return d3.extent(it);
    }(
    _.flatten(
    _.map(function(row){
      return d3.extent(row, function(it){
        return it.key;
      });
    })(
    chrt.data)));
    max = function(it){
      return d3.max(it);
    }(
    _.flatten(
    _.map(function(row){
      return d3.max(row, function(it){
        return it.value;
      });
    })(
    chrt.data)));
    if (chrt.scaleX === null) {
      scaleX = d3.time.scale().domain(extent).range([0, chrt.w]);
    } else {
      scaleX = chrt.scaleX;
    }
    scaleY = d3.scale.linear().domain([0, max]).range([chrt.h, 0]);
    svg.selectAll(".gridX").data((function(){
      var i$, step$, to$, results$ = [];
      for (i$ = 0, to$ = chrt.w, step$ = chrt.w / chrt.xGridNumber; step$ < 0 ? i$ >= to$ : i$ <= to$; i$ += step$) {
        results$.push(i$);
      }
      return results$;
    }())).enter().append("line").attr({
      "x1": function(it){
        return it;
      },
      "x2": function(it){
        return it;
      },
      "y1": 0,
      "y2": chrt.h,
      "class": "gridX"
    }).style({
      "stroke": '#D8D5D5',
      "stroke-width": "1px"
    });
    svg.selectAll(".gridY").data((function(){
      var i$, step$, to$, results$ = [];
      for (i$ = 0, to$ = chrt.h, step$ = chrt.h / 5; step$ < 0 ? i$ >= to$ : i$ <= to$; i$ += step$) {
        results$.push(i$);
      }
      return results$;
    }())).enter().append("line").attr({
      "x1": 0,
      "x2": chrt.w,
      "y1": function(it){
        return it;
      },
      "y2": function(it){
        return it;
      },
      "class": "gridY"
    }).style({
      "stroke": '#D8D5D5',
      "stroke-width": "1px"
    });
    path = d3.svg.line().x(function(it){
      return scaleX(
      it.key);
    }).y(function(it){
      return scaleY(
      it.value);
    }).interpolate("monotone");
    line = svg.selectAll(".line").data(chrt.data);
    line.enter().append("path").attr({
      "class": "line"
    });
    line.attr({
      "d": path
    }).style({
      "stroke": chrt.color,
      "stroke-width": chrt.strokeWidth,
      "fill": "none",
      "stroke-dasharray": function(){
        var l;
        l = d3.select(this).node().getTotalLength();
        return l + " " + l;
      },
      "stroke-dashoffset": function(){
        return d3.select(this).node().getTotalLength();
      }
    }).transition().duration(chrt.duration).delay(chrt.delay).ease('linear').style({
      "stroke-dashoffset": 0
    });
    track = line.attr({
      "d": path
    }).style({
      "fill": "none"
    });
    svg.selectAll(".head").data(_.map(function(it){
      return _.head(
      it);
    })(
    chrt.data)).enter().append("circle").attr({
      "cx": function(it){
        return scaleX(
        it.key);
      },
      "cy": function(it){
        return scaleY(
        it.value);
      },
      "r": 3,
      "class": "head"
    }).style({
      "fill": chrt.color,
      "stroke": chrt.color,
      "stroke-width": chrt.strokeWidth
    });
    circle = svg.selectAll(".tail").data(_.map(function(it){
      return _.head(
      it);
    })(
    chrt.data)).enter().append("circle").attr({
      "cx": 0,
      "cy": 0,
      "r": 3,
      "class": "tail"
    }).style({
      "fill": chrt.color,
      "stroke": chrt.color,
      "stroke-width": chrt.strokeWidth,
      "opacity": 0
    });
    translateAlong = function(path){
      var l;
      l = path.getTotalLength();
      return function(d, i, a){
        return function(t){
          var p;
          p = path.getPointAtLength(t * l);
          return "translate(" + p.x + "," + p.y + ")";
        };
      };
    };
    circle.transition().duration(chrt.duration).delay(chrt.delay).ease('linear').style({
      "opacity": 1
    }).attrTween("transform", function(it, i){
      var f;
      f = translateAlong(
      d3.select(track[0][i]).node());
      return f(
      it);
    });
    svg.selectAll(".numberGroup").data(_.map(function(it){
      return [_.head(it), _.last(it)];
    })(
    chrt.data)).enter().append("g").attr({
      "class": "numberGroup"
    }).selectAll("text").data(function(it){
      return it;
    }).enter().append("text").text(function(it){
      if (chrt.numberFormat === null) {
        return it.value;
      } else {
        return chrt.numberFormat(
        it);
      }
    }).attr({
      "class": "number",
      "x": function(it){
        return scaleX(
        it.key);
      },
      "y": function(it){
        return scaleY(
        it.value) - 20;
      }
    }).style({
      "text-anchor": "middle",
      "opacity": 0
    }).transition().duration(0).delay(function(it, i){
      return i * (chrt.duration + chrt.delay);
    }).ease('linear').style({
      "opacity": 1
    });
    xAxis = d3.svg.axis().scale(scaleX).tickValues(chrt.tickValues ? chrt.tickValues : extent).tickFormat(chrt.tickFormat).orient("bottom");
    return svg.append("g").call(xAxis).attr({
      "transform": "translate(0," + chrt.h + ")",
      "class": "axis"
    });
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
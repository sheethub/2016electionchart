d3.tsv("./data.tsv", function(err, data){
  var ratio, population, average, thousand, drawRatio, drawAverage, drawPopulation;
  ratio = _.map(function(it){
    return {
      "key": new Date(+it.year, 0, 1),
      "value": +it.ratio
    };
  })(
  data);
  population = _.map(function(it){
    return {
      "key": new Date(+it.year, 0, 1),
      "value": +it.population
    };
  })(
  data);
  average = _.map(function(it){
    return {
      "key": new Date(+it.year, 0, 1),
      "value": +it.average
    };
  })(
  data);
  thousand = d3.format("0,000");
  drawRatio = lineChart().data([ratio]).container('#line1').numberFormat(function(it){
    return function(it){
      return it + "%";
    }(
    function(it){
      return it.toFixed(0);
    }(
    it.value * 100));
  });
  drawAverage = lineChart().data([average]).container('#line2').numberFormat(function(it){
    return it.value.toFixed(0) + "歲";
  });
  drawPopulation = lineChart().data([population]).container('#line3').numberFormat(function(it){
    return function(it){
      return it + "萬人";
    }(
    thousand(
    Math.round(
    it.value / 10)));
  });
  drawRatio();
  drawAverage();
  drawPopulation();
  drawRatio.draw();
  drawAverage.draw();
  return drawPopulation.draw();
});
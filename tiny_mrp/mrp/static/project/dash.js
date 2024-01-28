$(function () {
  $('.pdate').pDatepicker({
          format: 'YYYY-MM-DD',
          autoClose: true,
          initialValueType: 'gregorian'
        });
        xxxDate1=new persianDate();
        dt1=xxxDate1.year().toString()+"-"+("0" + xxxDate1.month()).slice(-2)+"-01";
        $("#startdate").val(dt1);
function renderChart(dates, sums) {
            var options = {
                chart: {
                    type: 'line'
                },
                stroke: {
                    width: 2,  // Set the stroke width
                    colors: ['#FF0000']  // Red color in hex format
                },
                series: [{
                    name: 'Vazn Sum',
                    data: sums
                }],
                xaxis: {
                    categories: dates
                }
            };

            var chart = new ApexCharts(document.querySelector("#mychart"), options);
            chart.render();
  }

var draw_zayeat=function(){

  fetch('/Dashboard/Zayeat/Line/')
       .then(response => response.json())
       .then(data => {
           renderChart(data.dates, data.sums);
       })
       .catch(error => console.error('Error:', error));
}
draw_zayeat();
});

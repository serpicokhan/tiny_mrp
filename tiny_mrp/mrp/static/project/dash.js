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
                    width: 10,  // Set the stroke width
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
function renderPieChartZayeat(labels, values) {

         var options = {
             chart: {
                 type: 'donut', // Change to 'pie' for a pie chart
                 height: 400,    // Set the height of the chart
                 width: 400
             },
             series: values,
             labels: labels
         };

         var chart = new ApexCharts(document.querySelector("#pieChart"), options);
         chart.render();
     }


var draw_pie_zayeat=function(){


       fetch('/Dashboard/Zayeat/Pie/')  // Update with the correct URL
        .then(response => response.json())
        .then(data => {
            renderPieChartZayeat(data.labels, data.values);
        })
        .catch(error => console.error('Error:', error));
}
var draw_zayeat=function(){

  fetch('/Dashboard/Zayeat/Line/')
       .then(response => response.json())
       .then(data => {
           renderChart(data.dates, data.sums);
       })
       .catch(error => console.error('Error:', error));
}
var draw_line_asset_failure=function(){
  fetch('/Dashboard/AssetFailure/Line/')  // Replace with the URL of your Django view
       .then(response => response.json())
       .then(data => {
           var options = {
               chart: {
                   type: 'line'
               },
               series: [{
                   name: 'Total Duration',
                   data: data.total_durations
               }],
               xaxis: {
                   categories: data.dates
               },
               // ... other chart options ...
           };

           var chart = new ApexCharts(document.querySelector("#lineAssetFailureChart"), options);
           chart.render();
       })
       .catch(error => console.error('Error:', error));
}
var draw_pie_asset_failure=function(){
  fetch('/Dashboard/AssetFailure/Pie/')  // Replace with the URL of your Django view
  .then(response => response.json())
   .then(data => {
       var options = {
           chart: {
               type: 'pie',
               height: 400,    // Set the height of the chart
               width: 400
           },
           series: data.total_durations,
           labels: data.labels,
           // ... other chart options ...
       };

       var chart = new ApexCharts(document.querySelector("#PieAssetFailureChart"), options);
       chart.render();
   })
   .catch(error => console.error('Error:', error));
}
draw_pie_zayeat();
draw_zayeat();
draw_line_asset_failure();
draw_pie_asset_failure();
});

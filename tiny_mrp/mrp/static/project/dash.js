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
                 height: 350,    // Set the height of the chart
                 width: 350
             },
             series: values,
             labels: labels
         };

         var chart = new ApexCharts(document.querySelector("#pieChart"), options);
         chart.render();
     }


var draw_pie_zayeat=function(start_dt,end_dt){


       fetch(`/Dashboard/Zayeat/Pie/?start=${start_dt}&end=${end_dt}`)  // Update with the correct URL
        .then(response => response.json())
        .then(data => {
            console.log(data.values);
            renderPieChartZayeat(data.labels, data.values);
        })
        .catch(error => console.error(`Error:`, error));
}
var draw_zayeat=function(){

  fetch('/Dashboard/Zayeat/Line/')
       .then(response => response.json())
       .then(data => {
        
           renderChart(data.dates, data.sums);
       })
       .catch(error => console.error('Error:', error));
}
var draw_line_asset_failure=function(start_dt,end_dt){
  fetch(`/Dashboard/AssetFailure/Line/?start=${start_dt}&end=${end_dt}`)  // Replace with the URL of your Django view
       .then(response => response.json())
       .then(data => {
        
           var options = {
               chart: {
                   type: `line`
               },
               series: [{
                   name: `Total Duration`,
                   data: data.total_durations
               }],
               xaxis: {
                   categories: data.dates
               },
               // ... other chart options ...
           };
        $('#lineAssetFailureChart').remove(); // this is my <canvas> element
        $('#lineAssetFailureChartholder').append('<div id="lineAssetFailureChart"><div>');
           var chart = new ApexCharts(document.querySelector("#lineAssetFailureChart"), options);
           chart.render();
       })
       .catch(error => console.error(`Error:`, error));
}
var draw_pie_asset_failure=function(start_dt,end_dt){
  fetch(`/Dashboard/AssetFailure/Pie/?start=${start_dt}&end=${end_dt}`)  // Replace with the URL of your Django view
  .then(response => response.json())
   .then(data => {
       var options = {
           chart: {
               type: `pie`,
            //    height: 400,    // Set the height of the chart
            //    width: 4000
           },
           series: data.total_durations,
           labels: data.labels,
           // ... other chart options ...
       };
       $('#PieAssetFailureChart').remove(); // this is my <canvas> element
       $('#PieAssetFailureChartholder').append('<div id="PieAssetFailureChart"><div>');

       var chart = new ApexCharts(document.querySelector("#PieAssetFailureChart"), options);
       chart.render();
   })
   .catch(error => console.error('Error:', error));
}
var current_year_zayeatvazn_data=function(){
  fetch('/Dashboard/Zayeat/Monthly/')  // Replace with the URL of your Django view
          .then(response => response.json())
          .then(data => {
            
            var options = {
                chart: {
                    type: 'bar',
                    height: 400, // Set the height of the chart (in pixels)
                    
                },
                colors: '#ff0000',
               
                series: [{
                    name: 'مجموع وزن',
                    data: data.sums
                }],
                xaxis: {
                    categories: data.labels,
                    title: {
                        text: 'ماه'
                    }
                },
                yaxis: {
                    title: {
                        text: 'وزن'
                    }
                },
                // ... other chart options ...
            };

              var chart = new ApexCharts(document.querySelector("#lineZayeatCurrentYear"), options);
              chart.render();
          })
          .catch(error => console.error('Error:', error));
}
var stackzayeat=function(){
    fetch('/Dashboard/Zayeat/StackedMonthly/')  // Replace with the URL of your Django view
    .then(response => response.json())
    .then(data => {
        console.log(data);
        var options = {
            chart: {
                type: 'bar',
                stacked: true,
                
                stackType: '100%',
                height:400
            },
          
            series: data.series,
            xaxis: data.xaxis,
            // ... other chart options ...
        };

        var chart = new ApexCharts(document.querySelector("#stackeZayeatCurrentYear"), options);
        chart.render();
    })
    .catch(error => console.error('Error:', error));
}
var draw_monthly_assetFailure_line=function(){
    fetch(`/Dashboard/AssetFailure/Monthly/`)  // Replace with the URL of your Django view
        .then(response => response.json())
        .then(data => {
            console.log(data);
            var options = {
                chart: {
                    type: `bar`
                },
                series: [{
                    name: `Total Duration`,
                    data: data.sums
                }],
                xaxis: {
                    categories: data.labels
                },
                // ... other chart options ...
            };
            // $('#lineAssetFailureCurrentYear').remove(); // this is my <canvas> element
            // $('#lineAssetFailureCurrentYearholder').append('<div id="lineAssetFailureCurrentYear"><div>');
     
            var chart = new ApexCharts(document.querySelector("#lineAssetFailureCurrentYear"), options);
            chart.render();
        })
        .catch(error => console.error('Error:', error));

}
var draw_asset_failure_stack_zayeat=function(){
    fetch('/Dashboard/AssetFailure/StackedMonthly/')  // Replace with the URL of your Django view
    .then(response => response.json())
    .then(data => {
        var options = {
            chart: {
                type: 'bar',
                stacked: true
            },
            series: data.series,
            xaxis: {
                categories: data.xaxis.categories
            },
            // ... other chart options ...
        };

        var chart = new ApexCharts(document.querySelector("#stackeAssetFailureCurrentYear"), options);
        chart.render();
    })
    .catch(error => console.error('Error:', error));
}


$("#button-addon1").click(function(){
// draw_pie_zayeat($("#startdate").val(),$("#enddate").val());
draw_line_asset_failure($("#startdate").val(),$("#enddate").val());
draw_pie_asset_failure($("#startdate").val(),$("#enddate").val());
draw_monthly_assetFailure_line();
draw_asset_failure_stack_zayeat();





});
// draw_zayeat();
// draw_line_asset_failure($("#startdate").val(),$("#enddate").val());
// draw_pie_asset_failure();

// current_year_zayeatvazn_data();
// stackzayeat();
// draw_asset_failure_stack_zayeat();
});

$(function () {
    $('.pdate').pDatepicker({
            format: 'YYYY-MM-DD',
            autoClose: true,
            initialValueType: 'gregorian',
            onSelect: function(unixDate) {
              // const persianDate = new persianDate(unixDate);  // Convert Unix timestamp to Persian date
              // const formattedDate = persianDate.format('YYYY-MM-DD'); // Format as desired
              // console.log("Selected Persian Date:", unixDate.format('YYYY-MM-DD'));
      
              // Convert to Gregorian if needed
              // const gregorianDate = persianDate.toGregorian();
              // console.log("Converted Gregorian Date:", gregorianDate);
          }
          });
          xxxDate1=new persianDate();
          dt1=xxxDate1.year().toString()+"-"+("0" + xxxDate1.month()).slice(-2)+"-01";
          dt2=xxxDate1.year().toString()+"-"+("0" + xxxDate1.month()).slice(-2)+"-"+("0" + xxxDate1.date()).slice(-2);
          $("#startdate").val(dt1);
          $("#enddate").val(dt2);
  
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
  var draw_line_asset_failure=function(start_dt,end_dt,machine,category){
    fetch(`/Dashboard/AssetFailure/Line/?start=${start_dt}&end=${end_dt}&machine=${machine}&asset_type=${category}`)  // Replace with the URL of your Django view
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
  function calculateAverage(array) {
      if (Array.isArray(array) && array.length > 0) {
        const sum = array.reduce((acc, value) => acc + value, 0);
        return sum / array.length;
      } else {
        return 0;
      }
    }
  var draw_line_asset_production=function(start_dt,end_dt,machine,category){
      fetch(`/Dashboard/Asset/Production/Line/?start=${start_dt}&end=${end_dt}&machine=${machine}&asset_type=${category}`)  // Replace with the URL of your Django view
           .then(response => response.json())
           .then(data => {
            
              var options = {
                  chart: {
                      type: 'area',
                      height: 400,
                      
                      
                  },
                  fill: {
                      colors: [ '#9C27B0']
                    },
                  dataLabels: {
                      enabled: true,
                      offsetX: -20,
                     
                      hideOverflow: true,
                      style: {
                        fontSize: "22px",
                        fontFamily: "Helvetica, Arial, sans-serif",
                        fontWeight: "bold"
                      }
                    },
                   
                  stroke: {
                      width: 1,  // Set the stroke width
                      // colors: ['#00FF00'],
                      curve: 'smooth'  // Red color in hex format
                  },
                  series: [{
                      name: 'وزن',
                      data: data.sums
                  }],
                  xaxis: {
                      categories: data.dates
                  }
              
                   // ... other chart options ...
               };
          $("#prolinetitle").html("میزان تولید "+ $("#machines").find("option:selected").text()+"(میانگین"+calculateAverage(data.sums).toFixed(0)+" کیلوگرم)");
            $('#lineAssetProductionChart').remove(); // this is my <canvas> element
            $('#lineAssetProductionChartholder').append('<div id="lineAssetProductionChart"><div>');
               var chart = new ApexCharts(document.querySelector("#lineAssetProductionChart"), options);
               chart.render();
           })
           .catch(error => console.error(`Error:`, error));
    }
    var draw_bar_daily_asset_production=function(start_dt,end_dt){
      fetch(`/Dashboard/Asset/Production/Daily/Bar2/?stdate=${start_dt}&enddate=${end_dt}`)  // Replace with the URL of your Django view
           .then(response => response.json())
           .then(data => {
          //   console.log(data);
            var elements=[];
            for(var i in data){
              // console.log(data[i].lable);
              elements.push({
                  name: data[i].lable,
                  data: data[i].production_values
              });
            }
              var options = {
                  chart: {
                      type: 'bar',
                      height:400
                  },
                  
                  plotOptions: {
                      bar: {
                          horizontal: false,
                         
                      },
                  },
                  stroke: {
                      show: true,
                      
                      
                  },
                  series: elements,
                  xaxis: {
                      categories: data[0].machines
                  }
              };
            $('#barAssetProductionChart').remove(); // this is my <canvas> element
          //   $("#last_date").html(`تولید در ${data[0].date}`);
            $('#barAssetProductionChartholder').append('<div id="barAssetProductionChart"><div>');
               var chart = new ApexCharts(document.querySelector("#barAssetProductionChart"), options);
               chart.render();
           })
           .catch(error => console.error(`Error:`, error));
    }
    var get_card_info=function(start_dt,end_dt){
      fetch(`/Dashboard/Card/Info/?stdate=${start_dt}&enddate=${end_dt}`)  // Replace with the URL of your Django view
           .then(response => response.json())
           .then(data => {
              $('#tolid_card').text(`${data.total_production}`);
              $('#waste_card').text(`${data.waste_percentage}%`);
            
           })
           .catch(error => console.error(`Error:`, error));
    }
    var draw_line_current_month_tab_production=function(){
      fetch(`/Dashboard/Tab/CurrentMonth/Production/Daily/?asset_category=7`)
      .then(response => {
          if (!response.ok) {
              throw new Error(`HTTP error! status: ${response.status}`);
          }
          return response.json();
      })
      .then(data => {
          // Prepare data for the chart
          const dates = data.map(item => item.day);
          const productionTotals = data.map(item => item.daily_production);
          const wasteTotals = data.map(item => item.daily_waste);
  
          // Set up and render the ApexCharts line chart with two series
          const options = {
              chart: {
                  type: 'line',
                  height: 350,
              },
              series: [
                  {
                      name: 'تولید روزانه',
                      data: productionTotals
                  },
                  {
                      name: 'ضایعات روزانه',
                      data: wasteTotals
                  }
              ],
              colors: ['#008FFB', '#FF4560'], 
              xaxis: {
                  categories: dates,
                  title: {
                      text: ''
                  }
              },
              title: {
                  text: 'تولید روزانه',
                  align: 'right'
              },
              stroke: {
                  curve: 'smooth'
              }
          };
  
          const chart = new ApexCharts(document.querySelector("#barTabProductionChart"), options);
          chart.render();
      })
      .catch(error => {
          console.error("Error fetching data:", error);
      });
      
    }
  var draw_pie_asset_failure=function(start_dt,end_dt,machine,category){
    fetch(`/Dashboard/AssetFailure/Pie/?start=${start_dt}&end=${end_dt}&machine=${machine}&asset_type=${category}`)  // Replace with the URL of your Django view
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
                  plotOptions: {
                      bar: {
                          horizontal: false,
                          columnWidth: '55%',
                          endingShape: 'rounded'
                      },
                  },
                 
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
  var draw_monthly_assetFailure_bar=function(machine,asset_type){
      fetch(`/Dashboard/AssetFailure/Monthly/?machine=${machine}&asset_type=${asset_type}`)  // Replace with the URL of your Django view
          .then(response => response.json())
          .then(data => {
              console.log(data);
              var options = {
                  chart: {
                      type: `bar`
                  },
                  series: [{
                      name: `مجموع توقف`,
                      data: data.sums
                  }],
                  xaxis: {
                      categories: data.labels
                  },
                  // ... other chart options ...
              };
              $('#lineAssetFailureCurrentYear').remove(); // this is my <canvas> element
              $('#lineAssetFailureCurrentYearholder').append('<div id="lineAssetFailureCurrentYear"><div>');
       
              var chart = new ApexCharts(document.querySelector("#lineAssetFailureCurrentYear"), options);
              chart.render();
          })
          .catch(error => console.error('Error:', error));
      }
  var draw_monthly_production_bar=function(machine,asset_type){
      fetch(`/Dashboard/Production/Monthly/?machine=${machine}&asset_type=${asset_type}`)  // Replace with the URL of your Django view
          .then(response => response.json())
          .then(data => {
              console.log(data);
              var options = {
                  chart: {
                      type: `bar`,
                      height:400
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
              $('#barProductionCurrentYear').remove(); // this is my <canvas> element
              $('#barProductionCurrentYearholder').append('<div id="barProductionCurrentYear"><div>');
       
              var chart = new ApexCharts(document.querySelector("#barProductionCurrentYear"), options);
              chart.render();
          })
          .catch(error => console.error('Error:', error));
  
  }
  var draw_asset_failure_stack_zayeat=function(machine,asset_type){
      fetch(`/Dashboard/AssetFailure/StackedMonthly/?machine=${machine}&asset_type=${asset_type}`)  // Replace with the URL of your Django view
      .then(response => response.json())
      .then(data => {
          var options = {
              chart: {
                  type: 'bar',
                  stacked: true
              },
              plotOptions: {
                  bar: {
                    horizontal: true,
                    dataLabels: {
                      show: true
                    }
                  }
                },
                legend: {
                  show: false
                },
              series: data.series,
              xaxis: {
                  categories: data.xaxis.categories,
                  
  
              },
              // ... other chart options ...
          };
  
          var chart = new ApexCharts(document.querySelector("#stackeAssetFailureCurrentYear"), options);
          chart.render();
      })
      .catch(error => console.error('Error:', error));
  }
  
  
  $("#button-addon1").click(function(){
      // $(".app-content-body").show();
  // draw_pie_zayeat($("#startdate").val(),$("#enddate").val());
  // draw_line_asset_failure($("#startdate").val(),$("#enddate").val(),$("#machines").val(),$("#machines option:selected").data("type"));
  // draw_pie_asset_failure($("#startdate").val(),$("#enddate").val(),$("#machines").val(),$("#machines option:selected").data("type"));
  // draw_monthly_assetFailure_bar($("#machines").val(),$("#machines option:selected").data("type"));
  // draw_asset_failure_stack_zayeat($("#machines").val(),$("#machines option:selected").data("type"));
  // draw_line_asset_production($("#startdate").val(),$("#enddate").val(),$("#machines").val(),$("#machines option:selected").data("type"));
  draw_monthly_production_bar($("#machines").val(),$("#machines option:selected").data("type"));
  // draw_bar_daily_asset_production($("#enddate").val());
  draw_bar_daily_asset_production($("#startdate").val(),$("#enddate").val());
  
  get_card_info($("#startdate").val(),$("#enddate").val());
  
  
  
  
  
  });
  draw_line_current_month_tab_production();
  draw_bar_daily_asset_production($("#startdate").val(),$("#enddate").val());
  // console.log($("#startdate").val(),$("#enddate").val());
  get_card_info($("#startdate").val(),$("#enddate").val());
  draw_monthly_production_bar($("#machines").val(),$("#machines option:selected").data("type"));
  // draw_monthly_assetFailure_bar($("#machines").val(),$("#machines option:selected").data("type"));
  // draw_asset_failure_stack_zayeat($("#machines").val(),$("#machines option:selected").data("type"));
  
  
  
  
  // draw_zayeat();
  // draw_line_asset_failure($("#startdate").val(),$("#enddate").val());
  // draw_pie_asset_failure();
  
  // current_year_zayeatvazn_data();
  // stackzayeat();
  // draw_asset_failure_stack_zayeat();
  });
  
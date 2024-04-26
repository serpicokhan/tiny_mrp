$(function () {
    $('.pdate').pDatepicker({
            format: 'YYYY-MM-DD',
            autoClose: true,
            initialValueType: 'gregorian'
          });
          xxxDate1=new persianDate();
          dt1=xxxDate1.year().toString()+"-"+("0" + xxxDate1.month()).slice(-2)+"-01";
          $("#startdate").val(dt1);
var draw_bar_daily_asset_production=function(start_dt){
    fetch(`/Dashboard/Asset/Production/Daily/Bar/List/?date=${start_dt}`)  // Replace with the URL of your Django view
         .then(response => response.json())
         .then(data => {
          console.log(data);

            // 
            // $.each(data, function(index, shift) {
            //     $.each(shift.machines, function(machineIndex, machine) {
            //         var row = "<tr>";
            //         row += "<td scope='col'>" + shift.lable + "</td>";
            //         row += "<td scope='col'>" + shift.date + "</td>";
            //         row += "<td scope='col'>" + machine + "</td>";
            //         row += "<td scope='col'>" + shift.production_values[machineIndex] + "</td>";
            //         row += "</tr>";
            //         $('#productionTable tbody').append(row);
            //     });
            // });
            $("#productionTable thead").empty();
            $("#productionTable tbody").empty();


            // $("#productionTable thead").prepend('<tr><th colspan="' + data[0].machines.length + '">' + data.lable + ' - ' + data.date + '</th></tr>');
            
    // Populate machine names as column headers
                var machineNamesRow = "<tr>";

                $.each(data[0].machines, function(index, machine) {
                    machineNamesRow+='<th>' + machine + '</th>';
                });
                machineNamesRow+='</tr>';
                $("#productionTable thead").append(machineNamesRow);

                // Populate production values in the corresponding row
                var productionValuesRow = "<tr>";
                $.each(data[0].production_values, function(index, value) {
                    productionValuesRow+='<td>' + value + '</td>';
                });
                productionValuesRow+='</tr>';
                $("#productionTable tbody").append(productionValuesRow);


                var productionValuesRow2="<tr>";

                $.each(data[1].production_values, function(index, value) {
                    productionValuesRow2+='<td>' + value + '</td>';


                });
                productionValuesRow2+='</tr>';

                $('#productionTable tbody').append(productionValuesRow2);
                var productionValuesRow2="<tr>";

                $.each(data[2].production_values, function(index, value) {
                    productionValuesRow2+='<td>' + value + '</td>';


                });
                productionValuesRow2+='</tr>';

                $('#productionTable tbody').append(productionValuesRow2);

        
            // 


          var elements=[];
          for(var i in data){
            
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
                dataLabels: {
                    enabled: false  // Disable data labels
                },
                xaxis: {
                    categories: data[0].machines
                }
            };
          $('#barAssetProductionChart').remove(); // this is my <canvas> element
          $("#last_date").html(`تولید در ${data[0].date}`);
          $('#barAssetProductionChartholder').append('<div id="barAssetProductionChart"><div>');
             var chart = new ApexCharts(document.querySelector("#barAssetProductionChart"), options);
             chart.render();
         })
         .
         catch(error => console.error(`Error:`, error));
  }
$("#button-addon1").click(function(){
  draw_bar_daily_asset_production($("#startdate").val());


});
  draw_bar_daily_asset_production();
});
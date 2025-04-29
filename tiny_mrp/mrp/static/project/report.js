$(function () {
    $('.pdate').pDatepicker({
            format: 'YYYY-MM-DD',
            autoClose: true,
            initialValueType: 'gregorian',
            calendar:{
              persian: {
                  leapYearMode: 'astronomical'
              }
            }
          });
          xxxDate1=new persianDate();
          dt1=xxxDate1.year().toString()+"-"+("0" + xxxDate1.month()).slice(-2)+"-01";
          $("#startdate").val(dt1);
var draw_bar_daily_asset_production=function(start_dt){
    fetch(`/Dashboard/Asset/Production/Daily/Bar/List/?date=${start_dt}`)  // Replace with the URL of your Django view
         .then(response => response.json())
         .then(data => {
         

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
            console.log(data);
            $("#productionTable thead").empty();
            // $("#productionTable2 thead").empty();
            $("#productionTable tbody").empty();
            $("#productionTable2").empty();
            
            const array2 = [];

            // array2.push(...data[0].machines.slice(0, 8));
            // console.log(array2);


            // $("#productionTable thead").prepend('<tr><th colspan="' + data[0].machines.length + '">' + data.lable + ' - ' + data.date + '</th></tr>');
            
    // Populate machine names as column headers
                var machineNamesRow = "<tr>";

                $.each(data[0].machines, function(index, machine) {
                    machineNamesRow+='<th >' + machine + '</th>';
                });
                machineNamesRow+='</tr>';
                $("#productionTable thead").append(machineNamesRow);

                // Populate production values in the corresponding row
                var productionValuesRow = "<tr>";
                $.each(data[0].production_values, function(index, value) {
                    productionValuesRow+='<td >' + value + '</td>';
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


                var headers =data[0].asset_category;
                var columnSums = new Array(headers.length).fill(0);
                var values =data[0].production_values2;
                var thead = '<tr>';
                headers.forEach((header) => {
                  thead += `<th>${header}</th>`;
                });
                thead += '</tr>';
                $('#productionTable2').append(thead);
          
                // Create table row with values
                var tbody = '<tr>';
                values.forEach((value) => {
                  tbody += `<td>${value}</td>`;
                });

                tbody += '</tr>';
                $('#productionTable2').append(tbody);
                values.forEach((value, i) => {
                    columnSums[i] += value;
                });
                var values =data[1].production_values2;
                var tbody = '<tr>';
                values.forEach((value) => {
                  tbody += `<td>${value}</td>`;
                });
                $('#productionTable2').append(tbody);
                values.forEach((value, i) => {
                    columnSums[i] += value;
                });
                var values =data[2].production_values2;
                var tbody = '<tr>';
                values.forEach((value) => {
                  tbody += `<td>${value}</td>`;
                });
                $('#productionTable2').append(tbody);
                values.forEach((value, i) => {
                    columnSums[i] += value;
                });
                
                // Add font-weight-bold class to make text bold
                

                sumRow = '<tr class="font-weight-bold">';
                columnSums.forEach((sum) => {
                    sumRow += `<td>${sum}</td>`;
                });
                sumRow += '</tr>';
                $('#productionTable2').append(sumRow);
                $(".card-header").show();



        
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
                colors: ['#333333', '#888888', '#CCCCCC'],
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
$.ajax({
	url:"menu",
	//url:"http://103.28.15.75:8069/api/js/menu.json",
	dataType: "json",
	success:function(data){
       // alert(data);
       // console.log(data);
		var clickAction = function(id){
			console.log("clickAction: ", id);
		}
	   
		$( "#menuUI" ).menuUI(data, clickAction);
    } //endof success
}); //endof .ajax​​​​

Highcharts.chart('container', {

    title: {
        text: 'Data Penjualan Perhari'
    },
    
    subtitle: {
        text: 'Toko Sepatu ABC'
    },
    
    yAxis: {
        title: {
            text: 'Number of Employees'
        }
    },
    legend: {
        layout: 'vertical',
        align: 'right',
        verticalAlign: 'middle'
    },
    
    plotOptions: {
        series: {
            label: {
                connectorAllowed: false
            },
            pointStart: 2010
        }
    },
    
    series: [{
        name: 'Fashion Atas',
        data: [43934, 52503, 57177, 69658, 97031, 119931, 137133, 154175]
    }, {
        name: 'Fashion Bawah',
        data: [24916, 24064, 29742, 29851, 32490, 30282, 38121, 40434]
    }, {
        name: 'Toko Depan',
        data: [11744, 17722, 16005, 19771, 20185, 24377, 32147, 39387]
    }, {
        name: 'Toko Belakang',
        data: [null, null, 7988, 12169, 15112, 22452, 34400, 34227]
    }, {
        name: 'Other',
        data: [12908, 5948, 8105, 11248, 8989, 11816, 18274, 18111]
    }],
    
    responsive: {
        rules: [{
            condition: {
                maxWidth: 500
            },
            chartOptions: {
                legend: {
                    layout: 'horizontal',
                    align: 'center',
                    verticalAlign: 'bottom'
                }
            }
        }]
    }
    
    });
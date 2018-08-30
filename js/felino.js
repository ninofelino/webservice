function carigambar(str){
	if (str.length==0) {
    document.getElementById("gambar").innerHTML="";
    return;
    }
	    $.ajax({
        url:"images/"+str,
	    success:function(data){
			$("#gambar").html(data);
		}});
};


function menunav(){
	$.ajax({
	url:"menu",dataType: "json",
	success:function(data){
   	var clickAction = function(id){
			console.log("clickAction: ", id);
		}
	   
		$( "#menuUI" ).menuUI(data, clickAction);
    } //endof success
});

}

function buatmenu(){

$.ajax({
	url:"menu",dataType: "json",
	success:function(data){
   	var clickAction = function(id){
			console.log("clickAction: ", id);
		}
	   
		$( "#menuUI" ).menuUI(data, clickAction);
    } //endof success
});
};

function carimember(str){
	
	if (str.length==0) {
    document.getElementById("member").innerHTML="";
    return;
    }
	    $.ajax({
        url:"member/"+str,dataType: "json",
	    success:function(data){
			console.log(data);
			$.each(data, function (index, value) {
				console.log(value);
			    $('#member').append(value['name']+"<br>");
			  });
		
			
		}});
};


function carimemberlevel(str){
	
	if (str.length==0) {
    document.getElementById("member").innerHTML="";
    return;
    }
	    $.ajax({
        url:"memberlevel/list",dataType: "json",
	    success:function(data){
			console.log(data);
			$.each(data, function (index, value) {
				console.log(value);
			    $('#memberlevel').append(value['name']+"<br>");
			  });
		
			
		}});
};

function getmenu(){
	$.ajax({
		url:"menu",dataType: "json",
		success:function(data){
		   // alert(data);
		   // console.log(data);
			var clickAction = function(id){
				console.log("clickAction: ", id);
			}
		   
			$( "#menuUI" ).menuUI(data, clickAction);
		} //endof success
	});
}
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
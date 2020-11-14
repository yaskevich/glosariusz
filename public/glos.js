$(function() {   // Handler for .ready() called.
	document.getElementById('toggle').addEventListener('click', function (e) {
		document.getElementById('tuckedMenu').classList.toggle('custom-menu-tucked');
		document.getElementById('toggle').classList.toggle('x');
	});
	
	$('#linkabout').click(function(){
		$('.main').addClass('hidden');
		$('#blockabout').removeClass('hidden');
	});
	
	$('#linkcontact').click(function(){
		$('.main').addClass('hidden');
		$('#blockcontact').removeClass('hidden');
	});
	
	$('.custom-menu-brand').click(function(){
		$('.main').addClass('hidden');
		$('#blocksearch').removeClass('hidden');
	});
	
	
	
	
	
	
	// $.ajax({
		// url: "/user",
		// cache: false,
		// success: function (resp) {
			// // $('#unamelink').html('keke');
			// // $('#unamelink').html(resp);
			// // window.location.replace("http://stackoverflow.com");
			// console.log(resp);
			// $('#unamespan').html(resp);
		// },
	// });
	
	 var SgSrch = new Bloodhound({ 
		 queryTokenizer: Bloodhound.tokenizers.whitespace, 
		 datumTokenizer: Bloodhound.tokenizers.obj.whitespace('title'), 
		 identify: function(obj) { return obj.title; },
		 prefetch: '/def.json',
		 remote: { url: '/data.json?%QUERY', wildcard: '%QUERY' },
	 }); 
	 SgSrch.initialize(); 
	/*
	 SgSrch.search('al', function(s) { 
	 console.log('food='+JSON.stringify(s)); 
	 }); 
	 */
	 
	 
function SgSrchDef(q, sync, async) {
    if (q === '') {
	   // console.log(SgSrch.all().slice(0, 5));
	   sync(SgSrch.all().slice(0, 5));
	   return SgSrch.all().slice(0, 5)
    } else {
	  return SgSrch.search(q, sync, async)
    }
  }

	$('#tasearch')
		.typeahead(
		//null, // passing in `null` for the `options` arguments will result in the default options being used
		{
		  highlight: true,
		  minLength: 0,
		},
		{
		  name: 'countries2',
		  limit: 10,
		  display: 'title',
		  //source: SgSrch
		  source: SgSrchDef
		  
		})
		.on('typeahead:opened', onOpened)
		.on('typeahead:selected', onAutocompleted)
		.on('typeahead:autocompleted', onSelected)
		.on('typeahead:asyncreceive', onRec)
		.bind( "click", function() {
		  // alert( "User clicked on 'foo.'" );
		});
	
	
function onRec($e) {
    console.log($e);
	// window.location.replace("http://stackoverflow.com");
}

function onOpened($e) {
    console.log('opened');
}
 
function onAutocompleted($e, datum) {
    console.log('autocompleted');
    console.log(datum);
	
		$.getJSON( "datum.json?" + datum.id, function( data ) {
			// console.log(data);
			var o = data[0];
			// console.log(o.body);
			var reply = o.body;
			
			reply = reply.replace(/^/, "<div>");
			reply = reply.replace(/$/, "</div>");
			reply = reply.replace(/(?=Δ)/mg, "</div><div>");
			
			$('#title').html(o.title);
			if (o.qty > 0){
				$('#qty').html(o.qty);
			}
			$('#auth').html(o.auth);
			$('#entry_body').html(reply);
			$('#srclist').html(o.srclist);
			$('#pnum').html("Kolumna " + o.pnum);
			if (o.ref_targets !== ''){
				$('#ref_targets').html('→ '+o.ref_targets);
			}
			
			// console.log(reply);
			

			
		  // var items = [];
		  // $.each( data, function( key, val ) {
			// items.push( "<li id='" + key + "'>" + val + "</li>" );
		  // });
		 
		  // $( "<ul/>", {
			// "class": "my-new-list",
			// html: items.join( "" )
		  // }).appendTo( "body" );
		});
}
 
function onSelected($e, datum) {
    console.log('selected');
    console.log(datum);
	

}
});


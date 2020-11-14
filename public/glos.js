// console.log = function() {};
$(function() {   // Handler for .ready() called.
	var authors = {"WD": "Wanda Decyk-Zięba", "KDK": "Krystyna Długosz-Kurczabowa", "ZG": "Zygmunt Gałecki", "JG": "Justyna Garczyńska", "HK": "Halina Karaś", "AK": "Alina Kępińska", "AP": "Anna Pasoń", "IS": "Izabela Stąpor", "BT": "Barbara Taras", "IWG": "Izabela Winiarska-Gorska"};
	var sources;
	var list;
	var is_list_rendered = false;
	var current_id = 0;
	// var lastY;
	// history.pushState({id:1}, "Glosariusz", 1);
	// $('.ui-loader').remove();
	// $('#entry').hide();
	
	function loadRender (id, isPopstate){
		$.getJSON( "/api/datum.json?" + id, function( data ) {
		current_id = id;
		$('#entry').css('visibility', 'visible');
		console.log("got", id);
		console.log("history", history.length, JSON.stringify(history));
		
		var o = data[0];
		var reply = o.body;
		
		reply = reply.replace(/^/, "<div>");
		reply = reply.replace(/$/, "</div>");
		reply = reply.replace(/(?=Δ)/mg, "</div><div>");
		reply = reply.replace(/¶/mg, "<span class='hint--bottom' aria-label='koniec wierszu'>¶</span>");
		
		reply = reply.replace(/Δ\s+zn\./mg, "<span class='hint--bottom' aria-label='znaczenie'><i class=\"fa fa-lightbulb-o\"></i></span>");
		reply = reply.replace(/Δ\s+gram\./mg, "<span class='hint--bottom' aria-label='gramatyka'><i class=\"fa fa-book \"></i></span>");
		reply = reply.replace(/Δ\s+etym\./mg, "<span class='hint--bottom' aria-label='etymologia'><i class=\"fa fa-university \"></i></span>");
		reply = reply.replace(/Δ\s+rozwój\:/mg, "<span class='hint--bottom' aria-label='rozwój'><i class=\"fa fa-feed \"></i></span>");
		reply = reply.replace(/Δ\s+formy\s+tekstowe\:/mg, "<span class='hint--bottom' aria-label='formy tekstowe'><i class=\"fa fa-file-text-o \"></i></span>");
		reply = reply.replace(/\[p\:(\d+)\]/mg, "<span class='hint--bottom' aria-label='koniec arkusza, przejscie do strony $1'><i class=\"fa fa-chain\"></i></span>");
		reply = reply.replace(/[\.\:]\s+([A-ZĄĆĘŁŃÓŚŹŻ].*?)\s+\[(.*?)[\s\,](.*?)\,\s+(.*?)\]/mg, function(str, m0, match1, match2, match3) { 
				// console.log(match1);
				// console.log();
				var newtitle = sources[match1]?sources[match1].title: match1;
				if (!sources[match1]){
					console.log("problem with src resolution", str);
				}
				return 	"<br/>&nbsp;&nbsp;&nbsp;<span class='old'>"+ m0+ ".</span><span class=\"hint--top hint--medium\" aria-label=\""+ newtitle +": "+ match2 +", "+ match3 + "\">&nbsp;<i class=\"fa fa-asterisk \"></i></span>"; 
				// return 	"<br/>&nbsp;&nbsp;&nbsp;<button class='old pure-button'>"+ m0+ ".</button><span class=\"hint--top hint--medium\" aria-label=\""+ sources[match1].title +": "+ match2 +", "+ match3 + "\">&nbsp;<i class=\"fa fa-asterisk \"></i></span>"; 
				// return 	"&nbsp;<span class=\"dotted hint--bottom\" aria-label=\""+ sources[match1].title +": "+ match2 +", "+ match3 + "\">"+ match1+ "</span>"; 
				// return 	"&nbsp;<span class=\"hint--bottom\" aria-label=\""+ sources[match1].title +": "+ match2 +", "+ match3 + "\"><i class=\"fa fa-paperclip \"></i></span>"; 
			}
		);
		
		$('#title').html(o.title);
		if (o.qty > 0){
			$('#qty').html(o.qty);
		}
		var realname = authors[o.auth.trim()];
		$('#auth').html( realname? realname : o.auth);
		$('#entry_body').html(reply);
		var authorList =[];
		jQuery.each(o.srclist.split(','), function(index, item) {
			var cItem = item.trim();
			var srcItem = sources[cItem];
			authorList.push("<span class='cit hint--bottom' aria-label='"+ (srcItem?srcItem.title:'Problem!')+"'>"+cItem+"</span>");
			// console.log(item);	
		});
		var authorsString = authorList.join(" ");
		$('#srclist').html(authorsString);
		$('#pnum').html(o.pnum/2 >> 0);
		if (o.ref_targets !== ''){
			$('#ref_targets').html('→ '+o.ref_targets);
		} else {
			$('#ref_targets').html('');
		}
		// $('#id').html(o.id);
		$('#id').html(id);
		
		 
		 
		 if (!isPopstate){
			 console.log("push", {id:id}, o.title, id);
			 history.pushState({id:id}, o.title, id);
			 // window.location.href
		 }
		 
		// History.pushState({state:o.id}, "State "+o.id, o.title); 
		
		document.title = "“"+o.title+"” to w języku staropolskim...";
		
		
		 // History.pushState(null, document.title, $(this).attr('href'));
		//History.pushState(null, document.title, o.id);
		
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

	function loadBack(id){
		if (id > 1) {
			loadRender(id-1);
		}
	}
	function loadForward(id){
		if (id < 2000) {
			loadRender(id+1);
		}
	}
	
	// $(window).bind('popstate',  function(event) {
	window.onpopstate = function(event) {
		console.log("location: " + document.location + ", state: " + JSON.stringify(event.state));
		// console.log(JSON.stringify(event.originalEvent));
		// console.log(JSON.stringify(event));
         // console.log('pop: ' + event.originalEvent.state);		
		if (event.state && event.state.id && current_id != event.state.id){
			console.log(event.state.id);
			loadRender(event.state.id, true);			 
			// history.back()
		}
    // });	
    };	
	
	document.getElementById('toggle').addEventListener('click', function (e) {
		document.getElementById('tuckedMenu').classList.toggle('custom-menu-tucked');
		document.getElementById('toggle').classList.toggle('x');
	});
	
	$('#wordPre').click(function(){loadBack(current_id);});
	$('#wordNext').click(function(){loadForward(current_id);});
	
	
	// $(document).bind('touchmove', function (e){
		// if (e.touches) {
			// console.log("touch", e);
			// var currentY = e.touches[0].clientY;
			// if (currentY !== lastY){
				// // moved vertically
				// return;
		// }
		// lastY = currentY;
		// }
		// //insert code if you want to execute something when an horizontal touchmove is made
	// });
		
	var e = $('body')
		.touch()
		.on('tap', function(event) {
			console.log('Tapped!');
		})
		.on('doubleTap', function(event) {
			console.log('Double tapped!');
		})
		.on('swipeLeft', function(event) {
			console.log('Swiped left!');
			loadForward(current_id)
		})
		.on('swipeRight', function(event) {
			console.log('Swiped right!');
			loadBack(current_id)
		});
		
		
	// $("#entry").on("swipeleft",function(){
		// console.log("swipe next!");
		// loadForward(current_id)
	// });
	// $("#entry").on("swiperight",function(){
		// console.log("swipe pre!");
		// loadBack(current_id)
	  // });
	
		
	$.when( $.get("/api/sources.json"), $.get('/api/list.json?1') ).done(function(results1, results2) {

			sources = results1[0];
			list  = results2[0];
			///////////////////
				$('.custom-menu-brand').click(function(){
					$('.main').addClass('hidden');
					$('#blocksearch').removeClass('hidden');
					document.title = "Glosaiusz staropolski";
				});
				$('#linkabout').click(function(){
					$('.main').addClass('hidden');
					$('#blockabout').removeClass('hidden');
					document.title = "Glosaiusz staropolski – O projekcie";
				});		
				$('#linkcontact').click(function(){
					$('.main').addClass('hidden');
					$('#blockcontact').removeClass('hidden');
					document.title = "Glosaiusz staropolski – Indeks";
					
					if (!is_list_rendered){
						is_list_rendered = true;
						var html  = '';
						var letter = '';
						var gr = 0;
						jQuery.each( list, function( i, val ) {
							var word  = val.title;
							var tword = word.replace(/[I]{1,3}\s/g, '').replace(/[\(\)\-]/g, '');
							var lr  = tword.charAt(0).toLowerCase();
							if (lr !== letter){
								if (gr){
									html += '</div>'								
								}
								html += '<div class="spoiler" data-spoiler-link="'+gr+'">'+lr+'</div><div class="spoiler-content" data-spoiler-link="'+gr+'">';
								letter = lr;
								gr++;
							}
							// Content to be spoilered</div>
							html += '<div><a href="/'+val.id+'">'+word+'</a></div>';			
						});
						html += '</div>';
						$( '#index' ).html( html );
						$(".spoiler").spoiler();
					}
				});
			///////////////////
			 var SgSrch = new Bloodhound({ 
					 queryTokenizer: Bloodhound.tokenizers.whitespace, 
					 datumTokenizer: Bloodhound.tokenizers.obj.whitespace('title'), 
					 identify: function(obj) { return obj.title; },
					 prefetch: '/api/def.json',
					 remote: { url: '/api/data.json?%QUERY', wildcard: '%QUERY' },
				 }); 
				 SgSrch.initialize(); 
				 function SgSrchDef(q, sync, async) {
						if (q === '') {
						   // console.log(SgSrch.all().slice(0, 5));
						   sync(SgSrch.all().slice(0, 5));
						   return SgSrch.all().slice(0, 5)
						} else {
						  return SgSrch.search(q, sync, async)
						}
					}
				/*
				 SgSrch.search('al', function(s) { 
				 console.log('food='+JSON.stringify(s)); 
				 }); 
				 */
				$('#tasearch').typeahead(
					{ //null, // passing in `null` for the `options` arguments will result in the default options being used
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
					.on('typeahead:opened', function($e) {
						console.log('opened');
					})
					.on('typeahead:selected', 	function($e, datum) {
							// console.log('autocompleted');
							// console.log(datum);
							loadRender(datum.id);
						}
					)
					.on('typeahead:autocompleted', 	function($e, datum) {
							console.log('selected');
							console.log(datum);
						}
					)
					.on('typeahead:asyncreceive', function ($e) {
							console.log($e);
							// window.location.replace("http://stackoverflow.com");
					})
					.bind( "click", function() {
					  // alert( "User clicked on 'foo.'" );
					});			
			var num = +window.location.pathname.replace(/[^0-9.]/g,"");
			// loadRender(356);
			// loadRender(num||356);			
			if (num){				
				loadRender(num);			
			} 
			///////////////////
	
	});
	// .fail(function() {})

	
	// $.ajax({
		// url: "/api/sources.json",
		// cache: false,
		// success: function (resp) {

		// },
	// });
});


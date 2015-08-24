function createCard(title, url, id, images) {
	var elem_card = document.createElement("div");
	elem_card.id = id;
	elem_card.className = "mdl-cell mdl-cell--3-col mdl-card mdl-shadow--2dp";
	
	var elem_title = document.createElement("div");
	elem_title.className = "mdl-card__title color" + (Math.floor(Math.random() * 16 + 1)).toString();
	var elem_titlelink = document.createElement("a");
	elem_titlelink.setAttribute("href", url);
	elem_titlelink.setAttribute("target", "_blank");
	elem_titlelink.text = title;
	elem_title.appendChild(elem_titlelink);
	elem_card.appendChild(elem_title);
	
	var elem_action = document.createElement("div");
	elem_action.className = "mdl-card__actions";
	
	var elem_carousel = document.createElement("div");
	elem_carousel.className = "carousel";
	
	for (var i = 0; i < images.length; i++) {
		var e = document.createElement("img");
		e.setAttribute("src", images[i]);
		elem_carousel.appendChild(e);
	}
	
	elem_action.appendChild(elem_carousel);
	elem_card.appendChild(elem_action);
	
	$('div.mdl-grid').append(elem_card);
	$(elem_carousel).owlCarousel({
		navigation : false, // Show next and prev buttons
		autoPlay: true,
		slideSpeed : 300,
		paginationSpeed : 400,
		singleItem:true
	});
}

function loadCards(){
  $.ajax({
	type: 'GET',
	url: './qiita.json',
	scriptCharset: 'utf-8',
	dataType:'json',
	cache: false,
	success: function(json){
		  for(var i =0; i < json.length; i++) {
		    createCard(json[i].title, json[i].url, json[i].id, json[i].images);
		  }
	  }
	});
}

$(document).ready(function(){
	loadCards();
});

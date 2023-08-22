var pageController = function() {
	var anonymousClass = {
		ppPrev : '<a href="#" class="nav_paging_btn nav_paging_btn_fst"><span class="blind">처음으로</span></span></a>',
		pPrev :  '<a href="#" class="nav_paging_btn nav_paging_btn_prev"><span class="blind">이전으로</span></span></a>',
		pNext :  '<a href="#" class="nav_paging_btn nav_paging_btn_next"><span class="blind">다음으로</span></span></a>',
		ppNext : '<a href="#" class="nav_paging_btn nav_paging_btn_lst"><span class="blind">마지막으로</span></span></a>',
		getPrintPage : function(obj, total, currentPage, size, blocksize,  action, retFunc, args) {

			var allVars = anonymousClass.getUrlVars();
			var param = anonymousClass.getUrlParam(allVars);
						
			var currentPage = parseInt(currentPage, 10);
			var size = parseInt(size, 10);
			
			var totalPages = Math.ceil(total / size); //LISTUNIT
			var thisblock = Math.ceil(currentPage / blocksize); //PAGEUNIT
			var startpage, endpage;
			var chtml = "";
			
			if(thisblock > 1) {
				startpage = (thisblock - 1) * blocksize + 1;
			}else{
				startpage = 1;
			}
			
			if( (thisblock * blocksize) >= totalPages) {
				endpage = totalPages;
			}else{
				endpage = thisblock * blocksize;
			}
			
			anonymousClass.ppPrev = anonymousClass.ppPrev.replace("#", action+"?page=1" + ((param != "") ? "&" + param : ""));
			anonymousClass.pPrev = anonymousClass.pPrev.replace("#", action+"?page="+(currentPage-1) + ((param != "") ? "&" + param : ""));
			anonymousClass.pNext = anonymousClass.pNext.replace("#", action+"?page="+(currentPage+1) + ((param != "") ? "&" + param : ""));
			anonymousClass.ppNext = anonymousClass.ppNext.replace("#", action+"?page="+(totalPages) + ((param != "") ? "&" + param : ""));
			
			
			
			if (currentPage > 1) chtml += anonymousClass.ppPrev +anonymousClass.pPrev;
			for(i = startpage; i <= endpage; i++) {
					if (currentPage == i) {
						chtml += "<a class=\"nav_paging_num selected\">";
					}else{
						chtml += "<a href=\""+action+"?page="+ i + ((param != "") ? "&" + param : "") + "\" class=\"nav_paging_num\">";
					}
					chtml += "<span class=\"num_left\"></span>";
					chtml += "<span class=\"num_right\"><span class=\"num\">" + i + "</span></span>";
					
			}
			
			//alert(currentPage + "," + totalPages);
			if(currentPage != totalPages && total > 0) {
				chtml += anonymousClass.pNext + anonymousClass.ppNext;
			}
			
			$(obj).empty();
			$(obj).append(chtml);
		},
		
		getUrlVars: function(){
		    var vars = [], hash;
		    var hashes = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');
		    for(var i = 0; i < hashes.length; i++)
		    {
		      hash = hashes[i].split('=');
		      vars.push(hash[0]);
		      vars[hash[0]] = hash[1];
		    }
		    return vars;
	    },
	    getUrlVar: function(name){
	        return anonymousClass.getUrlVars()[name];
	    },
	    getUrlParam : function(allVars) {
	    	var param = "";
	    	$.each(allVars, function(index, varnm) {
	    		if(param != "") param += "&";
	    		if(varnm.substring(0, 7) != "http://" && varnm != "" && varnm != null && varnm != "page") {
	    			param += varnm + "=" + anonymousClass.getUrlVar(varnm);
	    		}
	    	});
	    	
	    	return param;
	    }
	    
	    
	};
	return anonymousClass;
};


/*$.extend({
	  getUrlVars: function(){
	    var vars = [], hash;
	    var hashes = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');
	    for(var i = 0; i < hashes.length; i++)
	    {
	      hash = hashes[i].split('=');
	      vars.push(hash[0]);
	      vars[hash[0]] = hash[1];
	    }
	    return vars;
	  },
	  getUrlVar: function(name){
	    return $.getUrlVars()[name];
	  }
});*/
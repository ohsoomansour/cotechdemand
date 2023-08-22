var pageController = function() {
	var anonymousClass = {
		pageUnit : 10,		// block cnt
		pPrev :  '<a href="#" class="prev"><</a> ',
		ppPrev :  '<a href="#" class="pprev"><<</a> ',
		pNext :  ' <a href="#" class="next">></a>',
		ppNext :  ' <a href="#" class="pnext">>></a>',
		recordCountPerPage : 10,		// single page cnt
		getPrintPage : function(obj, total, currentPage, size, blocksize,  action, retFunc, args) {
			var currentPage = parseInt(currentPage, 10);
			var size = parseInt(size, 10);
			var pPage = Math.ceil(total / size);
			var endBlock = 0;
			var startBlock = 0;
			var pBlock = Math.ceil((currentPage/blocksize));
			endBlock = (Math.ceil(( pBlock))  *blocksize);
			if (endBlock >  pPage) endBlock = pPage;
			startBlock = Math.floor(endBlock - blocksize)+1;
			if (startBlock < 1) startBlock = 1;
			var chtml = "";
			if (retFunc== undefined) {
				anonymousClass.pNext = anonymousClass.pNext.replace("#", action+"/"+(endBlock+1));
				anonymousClass.pPrev = anonymousClass.pPrev.replace("#", action+"/"+(startBlock-1));
				
				anonymousClass.ppNext = anonymousClass.ppNext.replace("#", action+"/"+(pPage));
				anonymousClass.ppPrev = anonymousClass.ppPrev.replace("#", action+"/"+1);
			}
			
			if (startBlock > 1) chtml += anonymousClass.ppPrev +anonymousClass.pPrev;
			for(i = startBlock; i <= endBlock; i++) {
				if (retFunc== undefined) {
					if (currentPage == i) chtml += " <a class=\"active\">"+i+"</a>";
					else chtml += " <a href=\""+action+"/"+i+"\" >"+i+"</a>";
				}
				else {
					if (currentPage == i) chtml += " <a href=\"#\" class=\"active\">"+i+"</a>";
					else chtml += " <a href=\"#\" >"+i+"</a>";	
				}
			}
			if (endBlock < pPage) chtml += anonymousClass.pNext + anonymousClass.ppNext;
			//chtml += "</ul>";
			$(obj).empty();
			$(obj).append(chtml);
			/* click event */
			
			if (retFunc != undefined) {
				$(obj+' a').click(function() {
					anonymousClass.pageIndex = $(this).text(); 
					if ($(this).hasClass('prev')) anonymousClass.pageIndex = startBlock -1;
					if ($(this).hasClass('next')) anonymousClass.pageIndex = endBlock +1;
					if ($(this).hasClass('pprev')) anonymousClass.pageIndex = 1;
					if ($(this).hasClass('pnext')) anonymousClass.pageIndex = pPage;
					eval(retFunc+'(' + anonymousClass.pageIndex + ', args)');
					return false;
				});
			}
		}
	};
	return anonymousClass;
};

<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<script>
	$(document).ready(function(){
		$("#list").jqGrid({
			url : "/admin/listPopup.do", 
			mtype : "POST",
			datatype : 'json',
			postData:{
				},
			colNames : [
						'번호',
						'',
						'팝업명',
						'',
						'사용여부',
						'팝업구분',
						'시작일',
						'마감일',
						'등록자',
						'수정자',
						'등록일',
						'수정일',
						'길이',
						'높이',
						'x축',
						'y축',
						'미리보기'
			],
			colModel : [
						{name:'rnum', 				index:'rnum',			align:"center",			width: 30},
						{name:'popup_seq', 			index:'popup_seq',		align:"center",			hidden: true},
						{name:'popup_title', 		index:'popup_title',	align:"center"},
						{name:'popup_img', 			index:'popup_img',		align:"center",			hidden: true},
						{name:'useyn', 				index:'useyn',			align:"center",			width: 70},
						{name:'popup_pcd', 			index:'popup_pcd',		align:"center"},
						{name:'popup_sday', 		index:'popup_sday',		align:"center"},
						{name:'popup_eday', 		index:'popup_eday',		align:"center"},
						{name:'reguid', 			index:'reguid',			align:"center"},
						{name:'moduid', 			index:'moduid',			align:"center"},
						{name:'regdtm', 			index:'regdtm',			align:"center"},
						{name:'moddtm', 			index:'moddtm',			align:"center"},
						{name:'popup_width', 		index:'popup_width',	align:"center",			hidden: true},
						{name:'popup_height', 		index:'popup_height',	align:"center",			hidden: true},
						{name:'popup_left', 		index:'popup_left',		align:"center",			hidden: true},
						{name:'popup_top', 			index:'popup_top',		align:"center",			hidden: true},
						{name:'button',				index:'button',			align:"center"}		
						],
			pager: $('#pager'),
			rowNum:10,
			rowList:[10,20,30],
			jsonReader: {
				root : 'rows',
	            total : 'total',
	            page : 'page',
	            repeatitems : false
			},
			viewrecords: true,
			imgpath : '',
			caption : '',		
			height: 'auto',
			shrinkToFit:true,
			multiboxonly : true,			
			loadComplete: function(){	
				var ids = $('#list').getDataIDs();
		        var button = "";                
		            
		        for(var i=0; i<ids.length; i++) {
		        	var rowData = $('#list').getRowData(ids[i]); 
		            var cl = ids[i];
		            
		            console.log(rowData);
		    	             
		            button = "<a href='#' id='preview"+ cl + "' onClick='preview(\""+rowData.popup_seq+"\",\""+rowData.popup_title+"\",\""+rowData.popup_width+"\",\""+rowData.popup_height+"\",\""+rowData.popup_left+"\",\""+rowData.popup_top+"\",\""+rowData.popup_img+"\")' class='btn btn-default btn-sm2'>미리보기</a>";
		            
		            $('#list').setRowData(cl,{
		            	button : button
					});    			
		        }

			}//END loadComplete1
		});	// jqgrid 끝
		
        $('#list').jqGrid( 'setGridWidth', $(".contents").width()-30 );
        $(window).on('resize.jqGrid', function () {
        $('#list').jqGrid( 'setGridWidth', $(".contents").width()-30 );
           
        });  
        
		$('#btnInsertPopup').click(function(){
			fncInsertPopup();
		});
		
		$('#btnUpdatePopup').click(function(){
			var rowData =fncGetSelectedRowData();
			fncUpdatePopup(rowData);
		});
		$('#btnDeletePopup').click(function(){
			var rowData =fncGetSelectedRowData();
			fncDeletePopup(rowData);			
		});
		
		$('.check').click(function(){
			$('.layer_popup').hide();
		});
		
		$('.btn-close').click(function(){
			$('.layer_popup').hide();
		});
	
	});//jquery

	//팝업 미리보기
/* 	function preview(title, width, height, left, top, img){

		$("#popupImg").attr("src", img);
		var myPos = "left+" + left + ", top+" + top; 
		var atPos = "left+0, top+0";
		$('#popup').dialog({	    			 
			title:title,
	        position:{my:myPos, at:"left+0, top+0"},
	        resizable:false, //크기 조절 못하게
	        width:width,
	        height:height,			        
	        close: function(){
	        	$("input:checkbox[name='check']").attr("checked", false);
	        	$("#popupImg").attr("src", "");
				$('#popup').dialog('destroy');
			} 
		 });	 
		 
		 
	}
	 */
	 
	function preview(seq, title, width, height, left, top, img){
		$('#popupImg').attr("src", img);
		$('.layer_pop_inner').css({'left':+left+'px'});
		$('.layer_pop_inner').css({'top':+top+'px'});
		$('.layer_pop_inner').css({'height':+height+'px'});
		$('.layer_pop_inner').css({'width':+width+'px'});
		$('.layer_popup').show();	
	}
	
	// jqGrid 셀 선택여부 추가 
    function fncGetSelectedRowData() {
        var selRowId = $('#list').getGridParam('selrow');
        var rowData;
        if(selRowId != null) {
        	rowData = $('#list').getRowData(selRowId);
        }
        else{
        	rowData = null;
        }
        return rowData;
    };		
	
	
	//검색
	function fncList(){
		$('#list').trigger('reloadGrid');
	};
	function fncSearch() {
		var useYn = $('#useYn').val();
		var popupTitle = $('#popupTitle').val();
		$('#list').setGridParam({datatype : 'json',
			postData : {
				useyn : useYn,
				popuptitle : popupTitle
			},		
		});
		$('#list').setGridParam({
			page : 1
		});
		fncList();
	}
		
	//팝업 등록
	function fncInsertPopup(){
		var url = '/admin/insertPopupForm.do'
			openDialog({
		        title:"팝업 등록",
		        width:1000,
		        height:600,
		        url: url
			});
	}
	
	//팝업 수정
	function fncUpdatePopup(rowData){
		if(rowData ==null){
			alert_popup('수정할 팝업 선택 후 수정 버튼을 눌러주세요');
		}
		else{
			var url='/admin/updatePopupForm.do?popup_seq=' + rowData.popup_seq;	
			openDialog({
		        title:"팝업 수정",
		        width:1000,
		        height:600,
		        url: url
	     	});
		}	
	}
	
	//팝업 삭제
	function fncDeletePopup(rowData){
		if(rowData == null){
			alert_popup('삭제할 팝업 선택후 삭제버튼을 눌러주세요!')
		}else{
			var confrm = confirm("팝업을 삭제하시겠습니까?");
	        if (confrm) {
		        $.ajax({
		            url: '/admin/deletePopup.do',
		            type: 'post',
		            data: {
		            	popup_seq : rowData.popup_seq,
		            	popup_img : rowData.popup_img
		            },
		            dataType: 'json',
		            success: function(transport){
		            	$('#list').trigger('reloadGrid');
		        	},
		            error: function(){
		            }
		        });
	        }
			$('#list').setGridParam({
				page : 1
			});
			fncList();
		}		
	}
</script>

<div class="contents">
	<div class="content_wrap">
	<!-- contents -->
	<div class="well searchDetail ">
		<table class="table1" >
			<colgroup>
				<col style="width:100px">
				<col>
				<col style="width:100px">
				<col>
			</colgroup>
			<tr>							
				<th>사용여부</th>
				<td class="form-inline">
					<select id="useYn" name="useYn" class="form-control">
						<option value="">전체</option>
						<option value="Y">사용</option>
						<option value="N">미사용</option>
					</select>
				<td>						
				<th>팝업명</th>
				<td class="form-inline">
					<input type="text" id="popupTitle" name="popupTitle" class="form-control w300">	
				</td>
				<td class="form-inline">	
					<input type="button" id= "btnSearch" class="btn btn-primary btn-sm" value="검색" onclick="fncSearch();">					
				</td>
			</tr>
		</table>
	</div>
		<!-- 버튼 -->
		<div class="btnList alignRight mTop20">
			<button type="button" id="btnInsertPopup" class="btn btn-primary btn-sm">등록</button>
			<button type="button" id="btnUpdatePopup" class="btn btn-primary btn-sm">수정</button>
			<button type="button" id="btnDeletePopup" class="btn btn-primary btn-sm">삭제</button>
		</div>
		<!-- jqGrid -->
		<div id="gridWrapper" class="mTop20">
			<table id="list" class="scroll" cellpadding="0" cellspacing="0"></table>
			<div id="pager" class="scroll"></div>
		</div>		
	</div>
</div>

<%-- <div id="popup">
	<div id="contents">
		<div id="popupTitle" class="layerPopup"> 
	 		<p><img id="popupImg" src=" ${item.popup_img }"/></p>
			<div class="bottom">
				<a id="checkbox_${item.popup_seq }" style="color:black; padding:10px;">오늘 하루 열지않음</a> 
				<a href="#" class="btn-close" name="btnPopupClose" onclick="return false;" id="${item.popup_seq }">닫기</a>			
			</div>	   		
		</div>
	</div>
</div>  --%>
<div class="layer_popup">
	<div class="layer_pop_inner" style="left:0px; top:0px;height:0px;width:0px;">
		<!--// -->
		<div id="container">
			<img id="popupImg" src="" >
		</div>
		<div class="lp_footer">
			<div class="lp_close1">
				<a href="#" class="check" onclick="return false;" >오늘 하루 열지 않기</a>
			</div>
			<div class="lp_close2">
				<a href="#" class="btn-close" onclick="return false;">닫기</a>
			</div>
		</div>
	</div>
</div>
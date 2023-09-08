<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<script>
$(document).ready(function(){
		var useAuth = ${use_auth};
		checkUseAuth(useAuth, [$('#addBoardBtn')], null, null);
	
	    var cnames = ['번호','게시판명','등록일','등록자','사용유무','카테고리'];
	    			
		$("#list").jqGrid({

	        url: '/admin/board.do', 		        
	        mtype : 'POST',	
	        postData:{site_id:$('#site_id').val()},		        
		    datatype: 'json',		    
	        loadtext : '로딩중..',		          	        	               			        	        	                    
	        colNames: cnames,        
	        colModel:[ 
	                  {name:'board_seq', index:'board_seq', width:30, key:true, align:"center"},
	                  {name:'boardnm', index:'boardnm', width:100, align:"center"},
	                  {name:'regdtm', index:'regdtm', width:30, align:"center"},			                  
	                  {name:'reguid', index:'reguid', width:30, align:"center"},	
	                  {name:'useyn', index:'useyn', width:10, align:"center"},		                  
	                  {name:'button', index:'button', width:20, align:"center"} 			                  
	                  ],
	      	jsonReader: {
	    	repeatitems : false,
	        root: "rows"
	    	        }, 			                  
	        rowNum: 10,
	        rowList: [10,20,30],
	        pager: '#Pager',	  
	        rownumbers  : false,                             
	        viewrecords : true,     	 
	        loadonce : true,   
	        height: 'auto',
			loadComplete : function(){
	            var ids = $('#list').getDataIDs();
	            var button = ""; 					            
	            
	            for(var i=0; i<ids.length; i++) {
	                var rowData = $('#list').getRowData(ids[i]);
	                var cl = ids[i];
	                var board_seq = rowData.board_seq;
	               
	                button = "<a href='#' id='categoryButton"+ cl + "' onClick='addCategory(\""+board_seq+"\")' class='btn btn-default btn-sm2'>등록</a>";
	       
	                $('#list').setRowData(cl,{
	                    button : button
	                });		                
	            }				
			} 			         							        
	    });
		
		//jqgrid width:100%
		$("#list").jqGrid( 'setGridWidth', $(".contents").width()-30 );
		$(window).on('resize.jqGrid', function () {
			$("#list").jqGrid( 'setGridWidth', $(".contents").width()-30 );
		});
		
		//게시판 추가
		$('#addBoard').click(function(){			
			var url = '/admin/addBoard.do';				
			 openDialog({
		            title:"게시판 생성",
		            width:800,
		            height:600,
		            resizable:false,
		            url: url
		     });				
		});		
		
		//게시판 수정 
		$("#updateBoard").click(function(event){		
			
			var rowData = getSelectRowData();
			updateBoard(rowData);
		});
		
		//게시판 삭제
		$("#deleteBoard").click(function(event){
			var rowData = getSelectRowData();
			deleteBoard(rowData);
		});
});  

//jqGrid 셀 선택여부 추가 
function getSelectRowData() {
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

//조회
function fncList() {				
	$("#list").setGridParam({
    	 datatype	: "json",
    	 postData	: {sc_where:$('#scWhere').val(),
    		 		   sc_keywd:$('#scKeywd').val(),
    		 		   sc_useyn:$('#scUseyn').val()},	
		 loadtext : '검색중..'								   
	});
	$("#list").trigger("reloadGrid"); 
}		

//게시판 수정
function updateBoard(rowData){
	var url="/admin/updateBoard.do";
		url += '?board_seq=' + rowData.board_seq;			
		openDialog({
            title:"게시판 수정",
            width:800,
            height:600,
            resizable:false,
            url: url
    	 });	
}

//게시판 삭제
function deleteBoard(rowData){		
	if(confirm('게시판을 삭제하시겠습니까?') == true){
	    $.ajax({
	        url     : "/admin/deleteBoard.do",
	        type    : "GET",
	        data    :{
	        	board_seq : rowData.board_seq,
	        },
	        dataType: "json",
	        success : function(){
	        	alert_popup('게시판이 삭제되었습니다.');
		        location.reload();
	        },
	        error : function(){
	        	alert_popup('게시판 삭제에 실패했습니다.');    
	        }            
	     });	
	 }else{
	 	return;
	 }
}

//카테고리 관리
function addCategory(board_seq){
	var url="/admin/addBoardCtgr.do";
		url += '?board_seq=' + board_seq; 
		openDialog({
            title:"카테고리 등록",
            width:800,
            height:600,
            resizable:false,
            url: url
    	 });	
}	

//카테고리 수정
function updateCategory(board_seq){
	var url="/admin/updateBoardctgr.do";
		url += '?board_seq=' + board_seq; 
		openDialog({
            title:"카테고리 수정",
            width:800,
            height:600,
            resizable:false,
            url: url
    	 });	
}		
</script>

<div class="contents">
  <div class="content_wrap">
	<!-- 검색 -->
	<div class="searchTextBox well type1 mTop20">
		<table class="table1">
			<colgroup><col width="7%"/><col width="43%"/><col width="7%"/><col width="43%"/></colgroup>			   
			<tr>
				<th>검색</th>
				<td class="form-inline">
					<select id="scWhere" name="sc_where" class="form-control">
						<option value="all">전체</option>			
						<option value="boardnm">게시판명</option>
						<option value="reguid">등록자</option>
						<option value="moduid">수정자</option>												
					</select>
					<input type="text" id="scKeywd" name="sc_keywd" class="form-control" size="40" placeholder="검색어를 입력하세요."> 
				</td>	
				<th>사용유무</th>						
				<td class="form-inline">
					<select id="scUseyn" name="sc_useyn" class="form-control">
						<option value="">전체</option>			
						<option value="Y">사용</option>
						<option value="N">미사용</option>											
					</select>				
				</td>
			</tr>
		</table>
		<div class="btnWrap alignRight mTop10">
			<button type="button" id="searchBtn" class="btn btn-primary btn-sm" onclick="javascript:fncList();">검색</button>		
		</div>	
	</div>
		
	<!-- 버튼 -->
	<div class="btnList alignRight mTop15">
		<button type="button" id="addBoard" class="btn btn-primary btn-sm">등록</button>		
		<button type="button" id="updateBoard" class="btn btn-primary btn-sm">수정</button>	
		<button type="button" id="deleteBoard" class="btn btn-primary btn-sm">삭제</button>			
	</div>
   
	<!-- jqGrid -->
    <div id="gridWrapper" class="mTop15">
		<!-- 게시판 목록 -->
   		<table id="list" ></table>	
 		<div id="Pager"></div>
 	</div>
 			     		   	
  </div>
</div>
		
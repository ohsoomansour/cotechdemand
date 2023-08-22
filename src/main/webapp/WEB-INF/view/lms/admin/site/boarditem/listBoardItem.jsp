<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<script>
$(document).ready(function(){
		
	initDatePicker([$('#strDate'), $('#endDate')]);
	
    var cnames = ['게시판번호','게시물번호','게시판명','제목','조회수','등록자','등록일','사용유무'];
    			
	$("#list").jqGrid({

        url: '/admin/boardItem.do', 		        
        mtype : 'POST',	
        postData:{site_id:$('#site_id').val()},		        
	    datatype: 'json',		    
        loadtext : '로딩중..',		          	        	               			        	        	                    
        colNames: cnames,        
        colModel:[
         	      {name:'board_seq', index:'board_seq', width:10, align:'center'},		        	
                  {name:'bitem_seq', index:'bitem_seq', width:10, key:true, align:"center"},
	                  {name:'boardnm', index:'boardnm', width:30, align:"center"}, 
                  {name:'bitem_title', index:'bitem_title', width:60, align:"center"},
                  {name:'bitem_seecnt', index:'bitem_seecnt', width:20, align:"center"},			                  
                  {name:'reguid', index:'reguid', width:20, align:"center"},		                  
  	         	  {name:'regdtm', index:'regdtm', width:40, align:'center'},  
  	         	  {name:'useyn', index:'useyn', width:20, align:'center'}	  	         	  
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
		multiselect: true,	        
        loadonce : true,			//페이지를 넘길 수 있음   
        height: 'auto',
		loadComplete : function(){
            var ids = $('#list').getDataIDs();
            var button = "";    //수정버튼 컬럼					            
            
            for(var i=0; i<ids.length; i++) {
                var rowData = $('#list').getRowData(ids[i]);    //그리드에서 값을 받는 컬럼이 있어야 함.
                var cl = ids[i];
    		}
		}
	});	
			
	//게시물 상태변경
	$('#updateState').click(function(){		
		updateBitemState();
	});
	
	//게시물 등록
	$('#addBitem').click(function(){		
		addBitem();
	});				
				
	//게시물 수정
	$("#updateBitem").click(function(event){
		
		var bitemSeq = new Array();
		var ids = $('#list').jqGrid('getDataIDs');
		
		for(var i = 0; i < ids.length; i++) {
			if($("input:checkbox[name='jqg_list_" + ids[i]+"']").is(":checked")) {
				
				var rowdata = $("#list").getRowData(ids[i]);
					bitemSeq.push(rowdata.bitem_seq);
			}
		}
		
		if(bitemSeq.length > 1){
			alert_popup('하나의 게시물만 선택해주세요.');
			return false;
		}
		
		var rowData = getSelectRowData();
		updateBitem(rowData);
	});
	
	//jqgrid width:100%
	$("#list").jqGrid( 'setGridWidth', $(".contents").width()-30 );
	$(window).on('resize.jqGrid', function () {
		$("#list").jqGrid( 'setGridWidth', $(".contents").width()-30 );
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

//게시물 상태 변경
function updateBitemState() {		
	var bitemSeq = new Array();
	var ids = $('#list').jqGrid('getDataIDs');
	var useyn = "";	
	
	if($('#updateUseyn > option:selected').val()) {
		useyn = $('#updateUseyn').val();				
	}	

	for(var i = 0; i < ids.length; i++) {
		if($("input:checkbox[name='jqg_list_" + ids[i]+"']").is(":checked")) {
			
			var rowdata = $("#list").getRowData(ids[i]);
				bitemSeq.push(rowdata.bitem_seq);
		}
	}
	
	if(bitemSeq.length == 0){
		alert_popup('게시물를 선택해주세요.');
		return false;
	}
	
    $.ajax({
        url     : "/admin/updateBoardItemState.do",
        type    : "POST",
        data    :{
        	bitem_seq : bitemSeq,
        	useyn : useyn
        },
        dataType: "json",
        success : function(){
        	alert_popup("게시물 상태를 변경했습니다.");
            location.reload();
        },
        error : function(){
        	alert_popup('게시물 상태 변경에 실패했습니다.');    
        }            
     });			
}

//게시물 추가
function addBitem(){
	var url="/admin/addBoardItem.do";		
		openDialog({
            title:"게시물 등록",
            width:900,
            height:700,
            resizable:false,
            url: url
    	 });	
}

//게시물 수정
function updateBitem(rowData){
	var url="/admin/updateBoardItem.do";
		url += '?bitem_seq=' + rowData.bitem_seq + '&board_seq=' + rowData.board_seq; 
		openDialog({
            title:"게시물 수정",
            width:900,
            height:700,
            resizable:false,
            url: url
    	 });	
}	
	

// 조회
function fncList() {		
	$("#list").setGridParam({
    	 datatype	: "json", 
    	 postData	: {sc_where:$('#scWhere').val(),
    		 		   sc_keywd:$('#scKeywd').val(),
    		 		   strdate : $("#strDate").val().replace(/-/gi, ""),
    	               enddate : $("#endDate").val().replace(/-/gi, ""),		
    		 	       sc_boardseq:$('#scBoardnm').val(),		
    		 		   sc_boardpcd:$('#scBoardpcd').val(),		 		  
    		 		   sc_useyn:$('#scUseyn').val()},	
		 loadtext : '검색중..'								   
	});
	$("#list").trigger("reloadGrid"); 
}		
</script>

<div class="contents">
  <div class="content_wrap">
   	<!-- 검색영역  -->	
   	<div class="well searchDetail">
   		<table class="table1" >
			<colgroup><col width="7%"/><col width="43%"/><col width="7%"/><col width="43%"/></colgroup>
			<tr>
				<th>기간</th>
				<td class="form-inline">
					<input type="text" id="strDate" name="strDate" class="form-control">
					~
					<input type="text" id="endDate" name="endDate" class="form-control">
				</td>
				<th>게시판 선택</th>
				<td class="form-inline">
					<select  id="scBoardnm" class="form-control">
 						<option value="">전체</option>		 				
						<c:forEach var="data" items="${ data }" >											
							<option value="${ data.board_seq }">${ data.boardnm }</option>
						</c:forEach>
					</select>
				</td>
			</tr>
			<tr>
				<th>검색</th>
				<td class="form-inline">
					<select id="scWhere" name="sc_where" class="form-control">
						<option value="all">전체</option>
						<option value="bitem_title">제목</option>
						<option value="reguid">작성자</option>
						<option value="bitem_body">내용</option>
					</select>
					<input type="text" id="scKeywd" name="sc_keywd" class="form-control" size="40" placeholder="검색어를 입력하세요."> 					
				</td>
				<th>사용유무</th>
				<td class="form-inline">
					<select  id="scUseyn" class="form-control">
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
   	
   	<!-- button -->	
	<div class="btnList alignRight mTop15 form-inline">
		<select id="updateUseyn" class="form-control">
			<option value="Y">사용</option>
			<option value="N">미사용</option>				
		</select>&nbsp;
		<button type="button" id="updateState" class="btn btn-primary btn-sm">변경</button>
		<button type="button" id="addBitem" class="btn btn-primary btn-sm">등록</button>
		<button type="button" id="updateBitem" class="btn btn-primary btn-sm">수정</button>
	</div>
	
	<!-- jqGrid -->
    <div id="gridWrapper" class="mTop15">
   		<table id="list"></table>	
 		<div id="Pager"></div>
 	</div>
 		 				     		   
  </div>
</div>
		
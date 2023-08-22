<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<script>
$(document).ready(function(){			
    var cnames = ['번호','제목','구분','설문 시작일','설문 종료일','등록자','등록일','수정일','사용유무'];
    			
	$("#list").jqGrid({

        url: '/admin/surveyMng.do', 		        
        mtype : 'POST',	
        postData:{site_id:$('#site_id').val()},		        
	    datatype: 'json',		    
        loadtext : '로딩중..',		          	        	               			        	        	                    
        colNames: cnames,        
        colModel:[
         	      {name:'eval_seq', index:'eval_seq', width:5, key:true, align:'center'},		        	
                  {name:'eval_title', index:'eval_title', width:30, align:"center"},
	              {name:'eval_pcd', index:'eval_pcd', width:10, align:"center"},
                  {name:'eval_sday', index:'eval_sday', width:10, align:"center"},
                  {name:'eval_eday', index:'eval_eday', width:10, align:"center"},
                  {name:'reguid', index:'reguid', width:10, align:"center"},
  	         	  {name:'regdtm', index:'regdtm', width:10, align:'center'},
  	         	  {name:'moddtm', index:'moddtm', width:10, align:'center'},  	         	  
  	         	  {name:'useyn', index:'useyn', width:5, align:'center'}	
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
        shrinkToFit: true,
		loadComplete : function(){
            var ids = $('#list').getDataIDs();
            
            for(var i=0; i<ids.length; i++) {
                var rowData = $('#list').getRowData(ids[i]);
                var cl = ids[i];  
    		}
		}
	});	
			
	//jqgrid width:100%
	$("#list").jqGrid( 'setGridWidth', $(".contents").width()-30 );
	$(window).on('resize.jqGrid', function () {
		$("#list").jqGrid( 'setGridWidth', $(".contents").width()-30 );
	});	
	
	//설문계획 등록
	$('#addSurveyMng').click(function(){	
		var url = '/admin/addSurveyMng.do';				
		 openDialog({
	            title:"설문계획 등록",
	            width:900,
	            height:800,
	            resizable:false,
	            url: url
	     });				
	});		
	
	//설문계획 수정
	$("#updateSurveyMng").click(function(event){
		var rowData = getSelectRowData();
		updateSurveyMng(rowData);
	});
	
	//설문계획 삭제
	$("#deleteSurveyMng").click(function(event){
		var rowData = getSelectRowData();
		deleteSurveyMng(rowData);
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

//설문계획 수정
function updateSurveyMng(rowData){	
	var url = '/admin/updateSurveyMng.do';	
	url += '?eval_seq=' + rowData.eval_seq; 		
	 openDialog({
            title:"설문계획 수정",
            width:900,
            height:800,
            resizable:false,
            url: url
     });				
}	

//설문계획 삭제
function deleteSurveyMng(rowData){		
	if(confirm('설문계획을 삭제하시겠습니까?') == true){
	    $.ajax({
	        url     : "/admin/deleteSurveyMng.do",
	        type    : "GET",
	        data    :{
	        	eval_seq : rowData.eval_seq,
	        },
	        dataType: "json",
	        success : function(){
	        	alert_popup('설문계획이 삭제되었습니다.');
		        location.reload();
	        },
	        error : function(){
	        	alert_popup('설문계획 삭제에 실패했습니다.');    
	        }            
	     });	
	 }else{
	 	return;
	 }
}

// 조회(검색)
function fncList() {				
	$("#list").setGridParam({
    	 datatype	: "json",
    	 postData	: {sc_where:$('#scWhere').val(),
    		 		   sc_keywd:$('#scKeywd').val(),
    		 		   eval_pcd:$('#scPcd').val(),
    		 		   eval_tcd:$('#scTcd').val(),    		 		   
    		 		   sc_useyn:$('#scUseyn').val()},	
		 loadtext : '검색중..'								   
	});
	$("#list").trigger("reloadGrid"); 
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
						<option value="">전체</option>			
						<option value="eval_title">설문 제목</option>
						<option value="eval_body">설문 내용</option>
						<option value="reguid">등록자</option>
						<option value="moduid">수정자</option>												
					</select>
					<input type="text" id="scKeywd" name="sc_keywd" class="form-control" size="40" placeholder="검색어를 입력하세요."> 
				</td>	
				<th>사용유무</th>						
				<td class="form-inline">
					<select id="scUseyn" name="sc_useyn" class="form-control">
						<option value="">선택</option>			
						<option value="Y">사용</option>
						<option value="N">미사용</option>											
					</select>				
				</td>
			</tr>

		</table>
		<div class="btnWrap alignRight mTop10">
			<button type="submit" id="searchBtn" class="btn btn-primary btn-sm" onclick="javascript:fncList();">검색</button>	
		</div>	
	</div>
   	
   	<!-- 버튼 -->	
	<div class="btnList alignRight mTop15 form-inline">
		<button type="button" id="addSurveyMng" class="btn btn-primary btn-sm">등록</button>	
		<button type="button" id="updateSurveyMng" class="btn btn-primary btn-sm">수정</button>	
		<button type="button" id="deleteSurveyMng" class="btn btn-primary btn-sm">삭제</button>
	</div>
	
	<!-- jqGrid -->
    <div id="gridWrapper" class="mTop15">
   		<table id="list" ></table>	
 		<div id="Pager"></div>
 	</div>	 				     		   
  </div>
</div>
		
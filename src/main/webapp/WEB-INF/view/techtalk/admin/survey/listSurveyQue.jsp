<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<script>
$(document).ready(function(){			
    var cnames = ['번호','제목','구분','등록자','등록일', '수정일', '사용유무'];
    			
	$("#list").jqGrid({

        url: '/admin/surveyQue.do', 		        
        mtype : 'POST',	
        postData:{site_id:$('#site_id').val()},		        
	    datatype: 'json',		    
        loadtext : '로딩중..',		          	        	               			        	        	                    
        colNames: cnames,        
        colModel:[
         	      {name:'que_seq', index:'que_seq', width:10, key:true, align:'center'},		        	
                  {name:'que_title', index:'que_title', width:40, align:"center"},
	              {name:'que_pcd', index:'que_pcd', width:20, align:"center"}, 		              
                  {name:'reguid', index:'reguid', width:10, align:"center"},
  	         	  {name:'regdtm', index:'regdtm', width:10, align:'center'},
  	         	  {name:'moddtm', index:'moddtm', width:10, align:'center'},  	         	  
  	         	  {name:'useyn', index:'useyn', width:10, align:'center'}
                  ],
      	jsonReader: {
    	repeatitems : false,
        root: "rows"
    	        }, 			                  
        rowNum: 10,
        rowList: [10,20,30],
        pager: '#Pager',	  
        rownumbers  : false,
		multiselect: true,	
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
	
	//문항 등록
	$('#addSurveyQue').click(function(){	
		var url = '/admin/addSurveyQue.do';				
		 openDialog({
	            title:"설문조사 문항 등록",
	            width:900,
	            height:800,
	            resizable:false,
	            url: url
	     });				
	});		
	
	//문항 수정
	$("#updateSurveyQue").click(function(event){

		var queSeq = new Array();
		var ids = $('#list').jqGrid('getDataIDs');

		for(var i = 0; i < ids.length; i++) {
			if($("input:checkbox[name='jqg_list_" + ids[i]+"']").is(":checked")) {
				
				var rowdata = $("#list").getRowData(ids[i]);
				queSeq.push(rowdata.que_seq);
			}
		}
		
		if(queSeq.length > 1){
			alert_popup('하나의 문항만 선택해주세요.');
			return false;
		}
		
		var rowData = getSelectRowData();
		updateSurveyQue(rowData);
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

//문항 수정
function updateSurveyQue(rowData){	
	var url = '/admin/updateSurveyQue.do';	
	url += '?que_seq=' + rowData.que_seq; 		
	 openDialog({
            title:"설문조사 문항 수정",
            width:900,
            height:800,
            resizable:false,
            url: url
     });				
}	

//문항 삭제
function deleteSurveyQue(){		
	var queSeq = new Array();
	var ids = $('#list').jqGrid('getDataIDs');

	for(var i = 0; i < ids.length; i++) {
		if($("input:checkbox[name='jqg_list_" + ids[i]+"']").is(":checked")) {
			
			var rowdata = $("#list").getRowData(ids[i]);
			queSeq.push(rowdata.que_seq);
		}
	}
	
	if(queSeq.length == 0){
		alert_popup('문항을 선택해주세요.');
		return false;
	}
	
	if(confirm('문항을 삭제하시겠습니까?') == true){
	    $.ajax({
	        url     : "/admin/deleteSurveyQue.do",
	        type    : "GET",
	        data    :{
	        	que_seq : queSeq,
	        },
	        dataType: "json",
	        success : function(){
	        	alert_popup('문항이 삭제되었습니다.');
		        location.reload();
	        },
	        error : function(){
	        	alert_popup('문항 삭제에 실패했습니다.');    
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
    		 		   sc_pcd:$('#scPcd').val(),
    		 		   sc_lvl:$('#scLvl').val(),    		 		   
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
<!-- 			<tr>
				<th>문항 구분</th>
				<td class="form-inline">
					<select id="scPcd" name="scPcd" class="form-control">
						<option value="">선택</option>			
						<option value="QUE_P001">객관식</option>
						<option value="QUE_P004">객관식 복수선택</option>							
						<option value="QUE_P002">주관식</option>
						<option value="QUE_P003">설문형 척도</option>
						<option value="QUE_P005">OX형</option>																								
					</select>				
				</td>
				<th>문항 난이도</th>						
				<td class="form-inline">
					<select id="scLvl" name="sc_lvl" class="form-control">
						<option value="">선택</option>			
						<option value="QUE_L001">상</option>
						<option value="QUE_L002">중</option>
						<option value="QUE_L003">하</option>																		
					</select>				
				</td>
			</tr>-->				   
			<tr>
				<th>검색</th>
				<td class="form-inline">
					<select id="scWhere" name="sc_where" class="form-control">
						<option value="">전체</option>			
						<option value="que_title">문항 제목</option>
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
			<button type="button" id="searchBtn" class="btn btn-primary btn-sm" onclick="javascript:fncList();">검색</button>				
		</div>	
	</div>
   	
   	<!-- 버튼 -->	
	<div class="btnList alignRight mTop15 form-inline">
		<button type="button" id="addSurveyQue" class="btn btn-primary btn-sm">등록</button>
		<button type="button" id="updateSurveyQue" class="btn btn-primary btn-sm">수정</button>
		<button type="button" id="deleteSurveyQue" class="btn btn-primary btn-sm" onclick="javascript:deleteSurveyQue();">삭제</button>
	</div>
	
	<!-- jqGrid -->
    <div id="gridWrapper" class="mTop15">
   		<table id="list" ></table>	
 		<div id="Pager"></div>
 	</div>	 				     		   
  </div>
</div>
		
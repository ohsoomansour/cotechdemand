<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<script>
$(document).ready(function(){			
	
	initDatePicker([$('#strDate'), $('#endDate')]);
	
    var cnames = ['순번','사업년도','사업명/설문제목','조사대상','조사기간','상태','응답현황','문항관리','바로가기'];
	
	$("#list").jqGrid({

        url: '/admin/surveyPaper.do', 		        
        mtype : 'POST',	
        postData:{site_id:$('#site_id').val()},		        
	    datatype: 'json',		    
        loadtext : '로딩중..',		          	        	               			        	        	                    
        colNames: cnames,        
        colModel:[ 
                  {name:'ppr_seq', index:'ppr_seq', width:30, key:true, align:"center"},
                  {name:'ppr_title', index:'ppr_title', width:100, align:"center"},
                  {name:'ppr_pcd', index:'ppr_pcd', width:40, align:"center"},
                  {name:'ppr_tcd', index:'ppr_tcd', width:40, align:"center"},	                  
                  {name:'reguid', index:'reguid', width:30, align:"center"},
                  {name:'regdtm', index:'regdtm', width:40, align:"center"},			                  
                  {name:'useyn', index:'useyn', width:20, align:"center"},
                  {name:'button', index:'button', width:20, align:"center"},
                  {name:'result', index:'result', width:20, align:"center"}
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
            var button = ""; 
            var button2 = "";	        
            
            for(var i=0; i<ids.length; i++) {
                var rowData = $('#list').getRowData(ids[i]);
                var cl = ids[i];
                var ppr_seq = rowData.ppr_seq;
                var ppr_pcd = rowData.ppr_pcd;  
                
                button = "<a href='#' id='addSurveySet"+ cl + "' onClick='addSurveySet(\""+ppr_seq+"\",\""+ppr_pcd+"\")' class='btn btn-default btn-sm2'>등록/수정</a>&nbsp;";
                result = "<a href='#' id='viewSurveyResult' onClick='viewSurveyResult(\""+ppr_seq+"\",\""+ppr_pcd+"\")'>[결과보기]</a>";
                
                $('#list').setRowData(cl,{
                     button : button,
                     result : result
				}); 
    		}
		}
	});	
			
	//jqgrid width:100%
	$("#list").jqGrid( 'setGridWidth', $(".contents").width()-30 );
	$(window).on('resize.jqGrid', function () {
		$("#list").jqGrid( 'setGridWidth', $(".contents").width()-30 );
	});	
	
	//설문조사 설문지 등록
	$('#addSurveyPaper').click(function(){	
		var url = '/admin/addSurveyPaper.do';				
		 openDialog({
	            title:"설문조사 설문지 등록",
	            width:800,
	            height:500,
	            resizable:false,
	            url: url
	     });				
	});		
	
	//설문조사 설문지 수정
	$("#updateSurveyPaper").click(function(event){
		var rowData = getSelectRowData();
		updateSurveyPaper(rowData);
	});
	
	//설문조사 설문지 삭제
	$("#deleteSurveyPaper").click(function(event){
		var rowData = getSelectRowData();
		deleteSurveyPaper(rowData);
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

//설문조사 문항 등록 폼
function addSurveySet(ppr_seq, ppr_pcd){	
	var url = '/admin/listSurveySet.do';	
	url += '?ppr_seq=' + ppr_seq + "&ppr_pcd=" + ppr_pcd; 		
	 openDialog({
            title:"설문조사 문항 등록",
            width:1050,
            height:800,
            resizable:false,
            url: encodeURI(url)
     });				
}	

//설문조사 문항 수정 폼
function updateSurveyPaper(rowData){	
	var url = '/admin/updateSurveyPaper.do';	
	url += '?ppr_seq=' + rowData.ppr_seq + "&ppr_pcd=" + rowData.ppr_pcd; 	
	 openDialog({
            title:"설문조사 문항 수정",
            width:800,
            height:500,
            resizable:false,
            url: encodeURI(url)
     });				
}

//설문조사 문항 삭제
function deleteSurveyPaper(rowData){		
	if(confirm('설문조사를 삭제하시겠습니까?') == true){
	    $.ajax({
	        url     : "/admin/deleteSurveyPaper.do",
	        type    : "GET",
	        data    :{
	        	ppr_seq : rowData.ppr_seq, ppr_pcd : rowData.ppr_pcd
	        },
	        dataType: "json",
	        success : function(){
	        	alert_popup('설문조사가 삭제되었습니다.');
		        location.reload();
	        },
	        error : function(){
	        	alert_popup('설문조사 삭제에 실패했습니다.');    
	        }            
	     });	
	 }else{
	 	return;
	 }
}

//설문조사 결과 폼
function viewSurveyResult(ppr_seq, ppr_pcd){
	var menuInfo = ${menu_info};
	location.href = '/admin/listSurveyResult.do?ppr_seq=' + ppr_seq + '&ppr_pcd=' + ppr_pcd + '&parent_uri=' + menuInfo.menu_url;	
}

// 조회(검색)
function fncList() {				
	$("#list").setGridParam({
    	 datatype	: "json",
    	 postData	: {sc_where:$('#scWhere').val(),
    		 		   sc_keywd:$('#scKeywd').val(),
    		 		   strdate : $("#strDate").val().replace(/-/gi, ""),
    	               enddate : $("#endDate").val().replace(/-/gi, ""),	
    		 	  	   ppr_pcd:$('#pprPcd').val(),
    		 	       ppr_tcd:$('#pprTcd').val(),    		 		   
    		 		   sc_useyn:$('#scUseyn').val()},	
		 loadtext : '검색중..'								   
	});
	$("#list").trigger("reloadGrid"); 
}	
</script>
<input type="hidden" id="pprSeq" name="ppr_seq" value="${ paraMap.ppr_seq }" />
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
						<option value="ppr_title">사업년도</option>
						<option value="reguid">등록자</option>
						<option value="moduid">수정자</option>												
					</select>
					<input type="text" id="scKeywd" name="sc_keywd" class="form-control" size="40" placeholder="검색어를 입력하세요."> 
				</td>	
			</tr>
			<tr>
				<th>조사대상</th>
				<td class="form-inline">
					<select id="scResearch" name="sc_research" class="form-control">
						<option value="">전체/수요기업/공급기업</option>														
					</select>
				</td>	
			<tr>
				<th>설문제목</th>
				<td class="form-inline">
					<select id="scResearch" name="sc_research" class="form-control">
						<option value="">[과학기술정보통신부 공고 제 000-00] 연구산업육성사업 (바우처사업관리시스템)</option>														
					</select>
				</td>	
			</tr>	
			<tr>
				<th>등록일자</th>
				<td class="form-inline">
					<input type="text" id="strDate" name="strDate" class="form-control">
					~
					<input type="text" id="endDate" name="endDate" class="form-control">
				</td>
			</tr>										
		</table>
		<div class="btnWrap alignRight mTop10">
			<button type="button" id="searchBtn" class="btn btn-primary btn-sm" onclick="javascript:fncList();">검색</button>				
		</div>	
	</div>
   	
   	<!-- 버튼 -->	
	<div class="btnList alignRight mTop15 form-inline">
		<button type="button" id="addSurveyPaper" class="btn btn-primary btn-sm">등록</button>
		<button type="button" id="updateSurveyPaper" class="btn btn-primary btn-sm">수정</button>
		<button type="button" id="deleteSurveyPaper" class="btn btn-primary btn-sm">삭제</button>
	</div>
	
	<!-- jqGrid -->
    <div id="gridWrapper" class="mTop15">
   		<table id="list" ></table>	
 		<div id="Pager"></div>
 	</div>				     		   
  </div>
</div>
		
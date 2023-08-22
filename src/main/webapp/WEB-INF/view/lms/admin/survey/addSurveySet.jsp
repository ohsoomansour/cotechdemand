<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<script>
var list = new LinkedList();
var ppr_seq = '${ paper.ppr_seq }';
var setQueArray = new Array(); //등록된 문항 목록
var beforeQueArray = new Array(); //기존 등록되어 있는 문항 목록
var deleteQueArray = new Array(); //기존 등록되어 있지만 체크 해제한 문항 목록
var newQueArray = new Array(); //새롭게 추가되는 문항 목록  
$(document).ready(function(){	

	//등록된 문항 리스트 배열에 담기
	<c:forEach items="${ data }" var="data" varStatus="status">
		setQueArray.push
		({
			que_seq : '${ data.que_seq }', que_title : '${ data.que_title }', que_pcd : '${ data.que_pcd }', reguid : '${ data.reguid }', regdtm : '${ data.regdtm }' 
		});
		
		beforeQueArray.push('${ data.que_seq }');
	</c:forEach>
	
	//선택된 문항 목록 데이터 셋팅
	setDataSetting();
	
	//데이터피커  셋팅
	initDatePicker([$('#strDate'), $('#endDate')]);
	
    var cnames = ['선택','번호','문항 구분','제목','항목','등록자','등록일자'];
    
	$("#list").jqGrid({

        url: '/admin/listSurveySet.do', 		        
        mtype : 'POST',	
        postData:{site_id:$('#site_id').val()},		        
	    datatype: 'json',		    
        loadtext : '로딩중..',		          	        	               			        	        	                    
        colNames: cnames,        
        colModel:[
         		  {name:'checkbox', index:'checkbox', width:5, align:'center'},
         	      {name:'que_seq', index:'que_seq', width:10, key:true, align:'center'},	
	              {name:'que_pcd', index:'que_pcd', width:15, align:"center"},
                  {name:'que_title', index:'que_title', width:40, align:"center"},
                  {name:'button', index:'button', width:10, align:"center"},
                  {name:'reguid', index:'reguid', width:15, align:"center"},
                  {name:'regdtm', index:'regdtm', width:15, align:"center"}
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
        autowidth: true,
		height: 'auto',
		shrinkToFit: true,
		loadComplete : function(){
            var ids = $('#list').getDataIDs();
            var checkbox = "";           
            var same = false;
            
            for(var i=0; i<ids.length; i++) {
            	       	
                var rowData = $('#list').getRowData(ids[i]);
                var cl = ids[i];
                var que_seq = rowData.que_seq; 
                var que_title = rowData.que_title;
                var que_pcd = rowData.que_pcd;  
                var reguid = rowData.reguid; 
                var regdtm = rowData.regdtm; 
 					
                for(var j = 0; j < setQueArray.length; j++){
                	if(que_seq == setQueArray[j].que_seq){
                		same = true;
                		checkbox = "<input type='checkbox' id='queCheck' name='radio_select' checked='checked' onClick='fncRadioClick(this, \""+que_seq+"\");'>";
                		break;
                	}
                }
	     		if(same == false){
	           		checkbox = "<input type='checkbox' id='queCheck' name='radio_select' onClick='fncNewRadioClick(this, \""+que_seq+"\",\""+que_title+"\",\""+que_pcd+"\",\""+reguid+"\",\""+regdtm+"\");'>";
	     		}	     		
	     		same = false;
	     		
	     		if(que_pcd == '객관식'){	
	     			button = "<a href='#' class='btn btn-default btn-sm2' onClick='viewQueItem(\""+que_seq+"\")'>조회</a>"
	     		}else{
	     			button = "<a class='btn btn-default btn-sm2' style='color : silver; pointer-events: none;'>조회</a>";
	     		}
	     		
                $('#list').setRowData(cl,{
                	checkbox : checkbox,
                	button : button
				}); 
    		}    
		}
	});	
	
	//설문지 문항 출제
	$('#submit').click(function(){	
	 	var newQueUncArray = [];
		
		//중복제거
		$.each(newQueArray, function(i, el){
		    if($.inArray(el, newQueUncArray) === -1) newQueUncArray.push(el);
		});
	 	
		//두 배열 비교해서 겹치는 데이터 삭제
		newQueUncArray = newQueUncArray.filter(function(val) {
			  return beforeQueArray.indexOf(val) == -1;
		});
		
		
		//새로운 출제 항목이 존재한다면 INSERT
		if(newQueUncArray.length != 0){
		    if($('input:checkbox[name="radio_select"]').is(":checked") == false){
		    	alert_popup('문항을 선택해주세요.');
				}else{			
					$('#queSeqs').val(newQueUncArray);
					
					$.ajax({
			            url : "/admin/addSurveySet.do",
			            type: "post",
			            data: $('#frm').serialize(),
			            dataType: "json",
			            success : function(){
			            	alert_popup('문항이 등록되었습니다.');          	
			            },
			            error : function(){
			            	alert_popup('문항 등록에 실패했습니다.');    
			            },
			            complete : function(){
			            	parent.fncList();
			            	parent.$("#dialog").dialog("close");
			            }
					});	
				}   
		}
		
		//기존 출제된 항목에서 제거할 데이터가 존재한다면
		if(deleteQueArray.length != 0){	 		
			$('#deleteSeqs').val(deleteQueArray);
			
	 		$.ajax({
		        url : "/admin/deleteSurveySet.do",
		        type: "post",
	            data: $('#frm').serialize(),
	            dataType: "json",
	            success : function(){
	            	alert_popup('문항이 등록 되었습니다.');          	
	            },
	            error : function(){
	            	alert_popup('문항 등록에 실패했습니다.');    
	            },
	            complete : function(){
	            	parent.fncList();
	            	parent.$("#dialog").dialog("close");
	            }
		  	});	 
		}
	});
});

//선택된 문항 목록 데이터 셋팅
function setDataSetting(){
	
	$('#resultQue').empty();
	
	var html = '';
	for(var i = 0; i < setQueArray.length; i++){
		html += '<tr>';
		html += '<td>' + setQueArray[i].que_seq + '</td>';
		html += '<td>' + setQueArray[i].que_pcd + '</td>';
		html += '<td>' + setQueArray[i].que_title + '</td>';
		html += '<td>' + setQueArray[i].reguid + '</td>';		
		html += '<td>' + setQueArray[i].regdtm + '</td>';		
		html += '</tr>';
	}
	
	$("#list").trigger("reloadGrid"); 
	$('#resultQue').append(html);
}

//객관식 항목 조회
function viewQueItem(que_seq){
	
    document.querySelector('.modal_wrap').style.display ='block';
    document.querySelector('.black_bg').style.display ='block';
    
 	$('#queitem').empty();
	$('#queitem').show();
	$.ajax({
        url : "/admin/listQueItem.do",
        type : "post",
        datatype : 'json',
        data : { que_seq : que_seq },
        success : function(result){ 
        	var data = result.result;
        	var html = '';      	
				html += '<div style="text-align : center; font-size : 22px; font-weight: bold; padding-bottom : 10px">객관식 문항</div>';         	
				html += '<div class="modal_close"><a href="javascript:offClick()">X</a></div>';
				html += '<table class="table table-hover" style="text-align: center">';
				html += '<caption class="caption_hide">객관식 문항</caption>';
				html += '<tr>';
				html += '<th class="ui-state-default" style="text-align: center">번호</th>';
				html += '<th class="ui-state-default" style="text-align: center">제목</th>';			
				html += '<th class="ui-state-default" style="text-align: center">등록자</th>';			
				html += '<th class="ui-state-default" style="text-align: center">등록일자</th>';									
				html += '</tr>';
 			for(var i = 0; i < data.length; i++){
				html += '<tr>';
				html += '<td>' + data[i].item_idx + '</td>';
				html += '<td>' + data[i].item_title + '</td>';
				html += '<td>' + data[i].reguid + '</td>';
				html += '<td>' + data[i].regdtm + '</td>';												
				html += '</tr>';		
			} 
				html += '</table>';					
			$('#queitem').append(html);
        }
	});  
}	

//객관식 항목 팝업창 닫기
function offClick() {
    document.querySelector('.modal_wrap').style.display ='none';
    document.querySelector('.black_bg').style.display ='none';
}


//팝업 닫기
function clkBtn(){ 
	$('#queitem').hide();
 }

//문항 선택
function fncNewRadioClick(obj, que_seq, que_title, que_pcd, reguid, regdtm){
	$('#resultQue').empty();
	
	//체크 해제한 문항의 배열의 길이가 0이 아니라면
	if(deleteQueArray.length != 0){
		for(var i = 0; i < deleteQueArray.length; i++){
				if(que_seq == deleteQueArray[i]){
					deleteQueArray.splice(i, 1);
				}
		}
	}
	
	setQueArray.push
	({
		que_seq : que_seq, 
		que_pcd : que_pcd,
		que_title : que_title, 
		reguid : reguid, 
		regdtm : regdtm 
	});
	
	//새로 추가되는 문제 목록에 담기
	newQueArray.push(que_seq);
	
	setDataSetting();
} 

//체크한 문항 삭제
function fncRadioClick(obj, que_seq){
	if ($(obj).is(":checked") == true){	 //체크 유무	 
	}else{
		for(var i = 0; i < setQueArray.length; i++){
			if(que_seq == setQueArray[i].que_seq){
				setQueArray.splice(i, 1);
			}
		}
		
		//기존 등록되어 있지만 체크 해제한 문항 담기
		deleteQueArray.push(que_seq);	
		
		//선택된 문항 목록 데이터 셋팅
		setDataSetting();	
	}
}

//조회(검색) (20.05.15 조예찬)
function fncList(event) {
	event.preventDefault();
	$("#list").setGridParam({
    	 datatype	: "json",
    	 postData	: {sc_where:$('#scWhere').val(),
    		 		   sc_keywd:$('#scKeywd').val(),
    		 		   strdate : $("#strDate").val().replace(/-/gi, ""),
    	               enddate : $("#endDate").val().replace(/-/gi, ""),	
    		 		   que_pcd:$('#quePcd').val(),
    		 		   que_lvl:$('#queLvl').val(),    		 		   
    		 		   sc_useyn:$('#scUseyn').val()},	
		 loadtext : '검색중..'								   
	});
	$("#list").trigger("reloadGrid"); 
}	
</script>
<style>
.modal_wrap{
        display: none;
        width: 600px;
        height: 300px;
        position: absolute;
        top:50%;
        left: 50%;
        margin: -250px 0 0 -250px;
        background:#eee;
        z-index: 2;

    }
    .black_bg{
        display: none;
        position: absolute;
        content: "";
        width: 100%;
        height: 100%;
        background-color:rgba(0, 0,0, 0.5);
        top:0;
        left: 0;
        z-index: 1;
    }
    .modal_close{
        width: 26px;
        height: 26px;
        position: absolute;
        top: -30px;
        right: 0;
    }
    .modal_close> a{
        display: block;
        width: 100%;
        height: 100%;
        background:url(https://img.icons8.com/metro/26/000000/close-window.png);
        text-indent: -9999px;
    }
</style>
<form action="#" id="frm" name="frm" method="post">
<input type="hidden" id="pprSeq" name="ppr_seq" value="${ paraMap.ppr_seq }" />
<input type="hidden" id="queSeqs" name="que_seqs" />
<input type="hidden" id="deleteSeqs" name="delete_seqs" />
<input type="hidden" id="pprPcd" name="ppr_pcd" value="${ paraMap.ppr_pcd }" />		
<input type="hidden" id="seqTblnm" name="seq_tblnm" value="${ paraMap.seq_tblnm }" />	
<div class="modal_pop_cont">
	<div class="clearFix lh10 mTop5">
		<h3 class="fL contentTit2">문항 목록</h3><br>
	</div>	
	<!-- 검색 -->
	<div class="searchTextBox well type1 mTop10">
		<table class="table1">
			<colgroup>
				<col width="7%"/>
				<col width="43%"/>
				<col width="7%"/>
				<col width="43%"/>
			</colgroup>	
			<tr>
				<th>문항 구분</th>
				<td class="form-inline">
					<select id="quePcd" name="que_pcd" class="form-control">
						<option value="">선택</option>			
						<option value="QUE_P001">객관식</option>							
						<option value="QUE_P002">주관식</option>												
					</select>				
				</td>
			</tr>
			<tr>
				<th>검색</th>
				<td class="form-inline">
					<select id="scWhere" name="sc_where" class="form-control">
						<option value="">전체</option>			
						<option value="que_title">문항 제목</option>
						<option value="reguid">등록자</option>											
					</select>
					<input type="text" id="scKeywd" name="sc_keywd" class="form-control" size="30" placeholder="검색어를 입력하세요."> 
				</td>	
			</tr>		
			<tr>
				<th>등록일자</th>
				<td class="left form-inline">
					<input type="text" id="strDate" name="strDate" class="form-control">
					~
					<input type="text" id="endDate" name="endDate" class="form-control">
				</td>
			</tr>											   
		</table>
		<div class="btnWrap alignRight mTop10">
			<button id="searchBtn" class="btn btn-primary btn-sm" onclick="javascript:fncList(event);">검색</button>		
		</div>	
	</div><br>	
	<!-- jqGrid -->
  	<table id="list"></table>	
	<div id="Pager"></div><br>	
	
	<div class="clearFix lh10">
		<h3 class="fL contentTit2">선택된 문항 목록</h3><br>
	</div>	
	<!-- 출제 문항 -->
	<div class="mTop10" style="overflow-y:auto; overflow-x:hidden; width:100%; height:300px; border:2px solid #c9c9c9;min-height:50px;text-align: center">
		<table class="table table-hover">
			<tr>
				<th class="ui-state-default" style="text-align: center">번호</th>
				<th class="ui-state-default" style="text-align: center">제목</th>		
				<th class="ui-state-default" style="text-align: center">문항구분</th>			
				<th class="ui-state-default" style="text-align: center">등록자</th>			
				<th class="ui-state-default" style="text-align: center">등록일자</th>									
			</tr>
			<tbody id="resultQue">
			</tbody>																
		</table>
	</div>	 
  	<div class="btnList alignRight mTop10">
		<button type="button" id="submit" class="btn btn-primary btn-sm">등록</button>
	</div>	
	
	<div class="black_bg"></div>	
	<div id="queitem" class="modal_wrap"></div>
	
	</div>			     		   
</form>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<script src="${pageContext.request.contextPath}/plugins/ckeditor/ckeditor.js"></script>
<script>
$(document).ready(function(){
	
		initDatePicker([$('#evalSday'), $('#evalEday')]);
	
		//설문지등록
		$('#submit').click(function(){	
				$.ajax({
		            url : "/admin/updateSurveyPaper.do",
		            type: "post",
		            data: $('#frm').serialize(),
		            dataType: "json",
		            success : function(){
		            	alert_popup('설문지가 수정되었습니다.');          	
		            },
		            error : function(){
		            	alert_popup('설문지 수정에 실패했습니다.');    
		            },
		            complete : function(){
		            	parent.fncList();
		            	parent.$("#dialog").dialog("close");
		            }
				}); 
		});	
		
		CKEDITOR.replace('pprBody',{
			filebrowserUploadUrl:'/admin/uploadImgCmptnQue'
		}); 
		CKEDITOR.on('dialogDefinition', function (ev) {
			var dialogName = ev.data.name;
			var dialog = ev.data.definition.dialog;
			var dialogDefinition = ev.data.definition;
		
				if (dialogName == 'image') {
					dialog.on('show', function (obj) {
						this.selectPage('Upload'); //업로드텝으로 시작
					});
					
			        var infoTab = dialogDefinition.getContents('info'); 
				        infoTab.remove('txtHSpace'); 
				        infoTab.remove('txtVSpace');
				        infoTab.remove('txtBorder');
				        infoTab.remove('txtWidth');
				        infoTab.remove('txtHeight');
				        infoTab.remove('ratioLock');	        
						dialogDefinition.removeContents('advanced'); // 자세히탭 제거
						dialogDefinition.removeContents('Link'); // 링크탭 제거					
				}
		}); 
		
		//평가계획 목록 데이터 로드
	    var cnames = ['평가 번호','평가 제목','평가 구분','설문 시작일','설문 종료일'];
		
		$("#listMng").jqGrid({
	        url: '/admin/surveyMng.do', 		        
	        mtype : 'POST',	
	        postData:{site_id:$('#site_id').val()},		        
		    datatype: 'json',		    
	        loadtext : '로딩중..',		          	        	               			        	        	                    
	        colNames: cnames,        
	        colModel:[
	         	      {name:'eval_seq', index:'eval_seq', width:10, key:true, align:'center'},		        	
	                  {name:'eval_title', index:'eval_title', width:30, align:"center"},
		              {name:'eval_pcd', index:'eval_pcd', width:10, align:"center"},
		              {name:'eval_sday', index:'eval_sday', width:10, align:"center"}, 	
		              {name:'eval_eday', index:'eval_eday', width:10, align:"center"},
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
	        width: '830',
	        height: '180',
	    	multiboxonly : true,        
			onSelectRow : function(rowid, status, e){
				$('#noMng').empty();
				var rowData = $('#listMng').getRowData(rowid);
				$('#evalSeq').val(rowData.eval_seq);
				$('#cmpntMngTitle').html('[ ' + rowData.eval_title + ' ]');
			}, 	        
			loadComplete: function(rowid, status, e){
				var evalseqData = '${ data.eval_seq }';
				var data = $('#listMng').getRowData();
				for(var i = 0; i < data.length; i++) {
					if(data[i].eval_seq == evalseqData) {
						$("#listMng").jqGrid("setSelection", data[i].eval_seq);
					}
				}
			}
		});			
});

//배점기준 삭제
function deleteCmptnScore(ppr_seq, ppr_pcd, grade_pcd){
	$.ajax({
		url : "/admin/deleteCmptnScore.do?ppr_seq=" + ppr_seq + "&ppr_pcd=" + ppr_pcd + "&grade_pcd=" + grade_pcd,
		type: "GET",
		success : function(){
			alert_popup('배점 기준이 삭제되었습니다.');
		},
		error : function(){
			alert_popup('배점 기준에 실패했습니다.');
		},
        complete : function(){
            location.reload();
        }			
	});
};
</script>
<form action="#" id="frm" name="frm" method="post">
	<input type="hidden" id="pprSeq" name="ppr_seq" value="${ paraMap.ppr_seq }" />	
	<input type="hidden" id="evalSeq" name="eval_seq" value=""/>					
	<div class="modal_pop_cont">
		<div class="table2 mTop10">
		<table>
			<colgroup>
				<col style="width:10%" />
				<col />
			</colgroup>
			<tbody class="line">	
				<tr>
					<th>사업명</th>
					<td class="left form-group">
						<select id="scWhere" name="sc_where" class="form-control w200">
							<option value="">전체</option>			
							<option value="ppr_title">사업년도</option>
							<option value="reguid">등록자</option>
							<option value="moduid">수정자</option>												
						</select>
						<input type="text" id="scKeywd" name="sc_keywd" class="form-control w400" size="40" placeholder="검색어를 입력하세요."> 
					</td>	
				</tr>			  	
		  		<tr>
		  			<th>설문제목</th>
		  			<td class="left">
		  				<input type="text" id="pprTitle" name="ppr_title" class="form-control" value="${ data.ppr_title }" />
		  			</td>
		  		</tr>	
		  		<tr>
		  			<th>설문대상</th>
		  			<td class="left form-group">
						<select id="research" name="research" class="form-control">
							<option value="all">전체/수요기업/공급기업</option>
						</select>
					</td>
		  		</tr>	
				<tr>
					<th>설문기간</th>
					<td class="left form-group">
						<input type="text" id="evalSday" name="eval_sday" class="form-control w300" value="${ data.eval_sday }">
						~
						<input type="text" id="evalEday" name="eval_eday" class="form-control w300" value="${ data.eval_eday }">
					</td>
				</tr>			  			  			  					  				  				  				  					  		        	 		 		
		  	</table><br><br> 	
		  	<div class="btnList alignRight mTop10">
				<button type="button" id="submit" class="btn btn-primary btn-sm">수정</button>
			</div>	
		</div>
	</div>
</form>
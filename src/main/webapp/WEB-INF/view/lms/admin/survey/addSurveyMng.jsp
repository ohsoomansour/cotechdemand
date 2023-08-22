<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<script src="${pageContext.request.contextPath}/plugins/ckeditor/ckeditor.js"></script>
<script>
$(document).ready(function(){
		//설문계획 등록
		$('#submit').click(function(){		
			for (instance in CKEDITOR.instances) {
		        CKEDITOR.instances[instance].updateElement();
		    }
			
			if(!isBlank('설문계획 제목', '#evalTitle'))	
				if(!isBlank('설문 배점', '#evalScore'))
				if(!isBlank('재시험 감점률', '#reappSubrt'))	
				if(!isBlank('설문 소요시간', '#evalUsetm'))				
				if(!isBlank('응시 인원수', '#aplCount'))
				if(!isBlank('설문계획 내용', '#evalBody'))
				if(!isBlank('설문 오픈날짜', '#openDate'))
				if(!isBlank('설문 시작날짜', '#startDate'))	
				if(!isBlank('설문 종료날짜', '#endDate')){	
					
				$.ajax({
		            url : "/admin/addSurveyMng.do",
		            type: "post",
		            data: $('#frm').serialize(),
		            dataType: "json",
		            success : function(){
		            	alert_popup('설문계획이 등록되었습니다.');          	
		            },
		            error : function(){
		            	alert_popup('설문계획 등록에 실패했습니다.');    
		            },
		            complete : function(){
		            	parent.fncList();
		            	parent.$("#dialog").dialog("close");
		            }
				}); 
			}
		});		
		
		initDatePicker(['#startDate', '#endDate', '#openDate']);	
		
		CKEDITOR.replace('evalBody',{
			filebrowserUploadUrl:'/admin/uploadEditorImg'
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
});
</script>
<form action="#" id="frm" name="frm" method="post" enctype="multipart/form-data">
	<input type="hidden" id="pprSeq" name="ppr_seq" value="${ paraMap.ppr_seq }" />	
	<input type="hidden" id="seqTblnm" name="seq_tblnm" value="${ paraMap.seq_tblnm }" />			
	<div class="modal_pop_cont">
		<div class="table2 mTop10">
		<table>
			<colgroup>
				<col style="width:10%" />
				<col />
			</colgroup>
			<tbody class="line">
		  		<!-- 설문계획 제목-->		  	
		  		<tr>
		  			<th>설문계획 제목</th>
		  			<td class="left">
		  				<input type="text" id="evalTitle" name="eval_title" class="form-control"/>
		  			</td>
		  		</tr>		  				  				  					  				  				  		
		  		<!-- 설문계획 내용 -->		  			  		  		
		  		<tr>
		  			<th>설문계획 내용</th>
		  			<td class="left">
 						<textarea id="evalBody" name="eval_body" class="form-control" style="height: 200px"></textarea>
		  			</td>
		  		</tr>	
		  		<!-- 설문 날짜 -->
		  		<tr>
					<th>설문 날짜</th>
					<td class="left form-inline">
						<input type="text" id="startDate" class="form-control w110" name="eval_sday">
						&nbsp;~&nbsp;
						<input type="text" id="endDate" class="form-control w110" name="eval_eday">
					</td>
				</tr>		  					  		        	
		  		<!-- 설문계획 사용여부 -->			        		  		
		  		<tr>
		  			<th>사용여부</th>
					<td class="left form-inline">
			            <select id="useYn" name="useyn" class="form-control">
					         <option value="Y">사용</option>
					         <option value="N">미사용</option>		                	
				        </select>
		  			</td>
		  		</tr>   		 		
		  	</table><br> 	
		  	<div class="btnList alignRight mTop10">
				<button type="button" id="submit" class="btn btn-primary btn-sm">등록</button>
			</div>	
		</div>
	</div>
</form>
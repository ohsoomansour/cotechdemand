<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<script src="${pageContfile_ext.request.contfile_extPath}/plugins/ckeditor/ckeditor.js" ></script>
<script src="${pageContfile_ext.request.contfile_extPath}/plugins/multifile-master/jquery.MultiFile.js" ></script>
<script>
$(document).ready(function(){	
	
	var attach_yn = '${ board.attach_yn }';
	var bitem_seq = $('#bitemSeq').val();
	var board_seq = $('#boardSeq').val();
	
	//게시물 수정
	$('#submit').click(function(){
		if(!isBlank('제목', '#bitemTitle'))	
		if(!isBlank('내용', '#bitemBody')){
			for (instance in CKEDITOR.instances) {
		        CKEDITOR.instances[instance].updateElement();
		    }
			
			if(attach_yn == 'Y'){ //파일 첨부기능 Y
				var form = $('#frm')[0];
			    var data = new FormData(form);	    
			    var fileCnt = $("input[name='attach']").length-1;

		        for(var i = 0; i < fileCnt; i++) {
		        	data.append('attachments', $("input[name='attach']")[i].files[0]);
		        }
				
				$.ajax({
		            url : "/admin/updateBoardItem.do?bitem_seq=" + bitem_seq + "&board_seq=" + board_seq,
		            type: "post",
		            enctype: 'multipart/form-data',
		            data: data,
		            processData: false,
		            contentType: false,
		            cache: false,
		            success : function(result){ 
		            	alert_popup('게시물이 수정되었습니다.');
		            },
		            error : function(result){ 
		            	alert_popup('게시물 수정중 오류가 발생했습니다.');
		            },
		            complete : function(){
		            	parent.$("#dialog").dialog("close");
		                location.reload();
		            }
				}); 
			}else{ // 파일 첨부기능 N
				$.ajax({
		            url : "/admin/updateBoardItem.do?bitem_seq=" + bitem_seq + "&board_seq=" + board_seq,
		            type: "post",
		            data: $('#frm').serialize(),
		            dataType: "json",
		            complete : function(){
		            	parent.$("#dialog").dialog("close");
		                location.reload();
		            }
				});     
			}
		}
	});		
	
	CKEDITOR.replace('bitemBody',{
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
	
	var maxSize = $('#maxSize').val(); //파일 크기
	var maxCnt = $('#maxCnt').val(); //파일 수		
	var availExt = $('#availExt').val(); //파일 확장자	
   
   $('input.attach').MultiFile({
	    maxfile: maxSize,				       
		max: maxCnt,
		accept: availExt,			
		STRING:{			
		remove:'<img src="/images/admin/ico/trash.png">',
		denied : "$ext 는(은) 업로드 할수 없는 파일확장자입니다.\n(업로드 가능 확장자 : 'png|jpg|jpeg|bmp|')",				
		toomany: "업로드할 수 있는 파일의 최대 갯수는 $max개 입니다.",
		toobig: "$file 파일은 업로드 가능한 크기를 초과했습니다.($size)"		
		},
   		list:'#fileList'
   });	
	
});

function deleteBoardAttach(bitemSeq, attfSeq, boardSeq){
	
	$.ajax({
        url : "/admin/deleteBoardAttach.do",
        type : "POST",
        dataType : 'json',
        data : 
        { 
        	bitem_seq : bitemSeq,
        	attf_seq : attfSeq,
        	board_seq : boardSeq
        },
        success : function(result){ 
        	alert_popup('선택하신 첨부파일이 삭제되었습니다.');
        	$('#'+attfSeq).remove();
        },
        error : function(e) {
        	alert_popup(e);
        }
	});     
}

</script>
<form action="#" id="frm" name="frm" method="post" enctype="multipart/form-data">		
<input type="hidden" id="boardSeq" class="board_seq" value="${ paraMap.board_seq }">	
<input type="hidden" id="bitemSeq" class="bitem_seq" value="${ paraMap.bitem_seq }">
<input type="hidden" id="maxCnt" class="max_cnt" value="${ board.attf_maxcnt }">	
<input type="hidden" id="maxSize" class="max_size" value="${ board.attf_maxsize }">	
<input type="hidden" id="availExt" class="avail_ext" value="${ board.attf_availext }">						
	<div class="modal_pop_cont">
			<table>
				<colgroup>
					<col style="width:10%" />
				</colgroup>
			  		<!-- 제목 -->		  	
			  		<tr>
			  			<th>제목</th>
			  			<td class="left">
			  				<input type="text" id="bitemTitle" name="bitem_title" class="form-control" value="${ data.bitem_title }"/><br>
			  			</td>
			  		</tr>	
			  		<!-- 카테고리 -->	
					<c:if test="${ !empty ctgr }">				  			  	
			  		<tr>
			  			<th>카테고리</th>
			  			<td class="left form-inline">
							<select name="ctgr_seq" class="form-control">
								<c:forEach var="ctgr" items="${ ctgr }" >							
									<option value="${ ctgr.ctgr_seq }">${ ctgr.ctgrnm }</option>
								</c:forEach>
							</select>				  				
			  			</td>
			  		</tr>
			  		</c:if>			  		
			  		<!-- 파일 -->	
	    			<c:if test="${ board.attach_yn eq 'Y'}">  					  
			  		<tr>
			  			<th>파일</th>
			  			<td class="left form-inline">                
	 		            <input type="file" class="attach with-preview" name="attach"> 
							<div id="fileList" style="border:2px solid #c9c9c9;min-height:50px">
								<c:forEach var="file" items="${ file }" varStatus="i">		 								
									<a href="#" id="${file.attf_seq}" onclick="deleteBoardAttach('${file.bitem_seq}', '${file.attf_seq}', '${board.board_seq}'); return false;">								             			 
										<img src="/images/admin/ico/trash.png">${file.file_name}								  			
										<img class="image_preview" src="${ file.file_path }/${ file.real_name }" onerror="this.style.display='none'">	
									</a><br>					 	
								</c:forEach>										
							</div><br>	
						</td>	              	  			              	  	                
			  		</tr>		
			  		</c:if>	  			  		  			
			  		<!-- 내용-->		  			  		  		
			  		<tr>
			  			<th>내용</th>
			  			<td class="left form-inline">
			                <textarea id="bitemBody" name="bitem_body" class="form-control" style="width:580px">${ data.bitem_body }</textarea>		  			
			  			</td>
			  		</tr>
			  		<!-- 비밀글 -->		  	
			  		<tr>
			  			<th>비밀글</th>
			  			<td class="left form-inline">
			  				<input type="radio" id="pcdUseN" name="bitem_pcd" value="BITEM_P001" <c:if test="${ data.bitem_pcd eq 'BITEM_P001'}">checked</c:if>/>미사용
			  				<input type="radio" id="pcdUseY" name="bitem_pcd" value="BITEM_P002" <c:if test="${ data.bitem_pcd eq 'BITEM_P002'}">checked</c:if>/>사용<br>
			  			</td>
			  		</tr>			  				        	  		 		
			  	</table>  
		  		<div class="btnList alignLeft mTop10">
					<button type="button" id="submit" class="btn btn-primary btn-sm">수정</button>
					<button type="button" id="cancelItemBtn" class="btn btn-default btn-sm" onClick="history.back()">취소</button>							
				</div>	
	</div>
</form>
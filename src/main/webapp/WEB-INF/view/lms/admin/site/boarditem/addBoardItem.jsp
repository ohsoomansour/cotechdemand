<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<script src="${pageContext.request.contextPath}/plugins/ckeditor/ckeditor.js" ></script>
<script src="${pageContext.request.contextPath}/plugins/multifile-master/jquery.MultiFile.js" ></script>
<script>
$(document).ready(function(){	
	
	//선택 게시판 데이터 로드
 	$("#scBoardnm").change(function() { 		
 		var optVal = $(this).val();
 		
		if(optVal == null ){
			return false;
		}
		
		$.ajax({
            url : "/admin/getBoardItem.do",
            type : "post",
            datatype : 'json',
            data : { board_seq : optVal },
            success : function(result){ 
            	var ctgr = result.ctgr;
            	
            	$('#boardSeq').val(result.board.board_seq);
            	$('#maxCnt').val(result.board.maxCnt);
            	$('#maxSize').val(result.board.maxSize);
            	$('#availExt').val(result.board.availExt);
            	
            	$('#option').empty();
       			var html = "";
       			if(result.ctgr != null && result.ctgr.length > 0){ //카테고리
	       			html += '<tr>';
	       			html += '<th>카테고리</th>';
	       			html += '<td class="left form-inline">';
	       			html += '<select name="ctgr_seq" class="form-control">';       			
	       			for(var i = 0; i < ctgr.length; i++){
	       				html += '<option value=' + ctgr[i].ctgr_seq + '>' + ctgr[i].ctgrnm + '</option>';
	       			}
	       			html += '</select>';				  				
	       			html += '</td>';
	       			html += '</tr>';	
       			}
       			$('#option').append(html);
       			
       			if(result.board.attach_yn == 'Y'){ //파일	
					$('#file').show();
       			}else{
					$('#file').hide();       				
       			}
            }
		});     		
	}); 
	
	$('#insertItemBtn').click(function(){
	    	
		if($('#scBoardnm').val() == ''){
			alert_popup('게시판을 선택해주세요.');
			setTimeout(function(){
				$('#scBoardnm').focus();
	       	}, 500);
		}else if($('#bitemTitle').val() == ''){
			alert_popup('제목을 입력 해주세요.');
			setTimeout(function(){
				$('#bitemTitle').focus();
			}, 500);
		}else{
			
			for (instance in CKEDITOR.instances) {
		        CKEDITOR.instances[instance].updateElement();
		    }
			
			var form = $('#frm')[0];
		    var data = new FormData(form);	    
		    var fileCnt = $("input[name='attach']").length-1;

	        for(var i = 0; i < fileCnt; i++) {
	        	data.append('attachments', $("input[name='attach']")[i].files[0]);
	        }
	        
			$.ajax({
	            url : "/admin/addBoardItem.do",
	            type: "post",
	            enctype: 'multipart/form-data',
	            data: data,
	            processData: false,
	            contentType: false,
	            cache: false,
	            complete : function(){
	            	parent.fncList();
	            	parent.$("#dialog").dialog("close");
	            }
			});  
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
            denied : "$ext 는(은) 업로드 할수 없는 파일확장자입니다.\n(업로드 가능 확장자 : " + availExt + ")",
			duplicate : "$file 은 이미 선택된 파일입니다.", 					
			toomany: "업로드할 수 있는 파일의 최대 갯수는 $max개 입니다.",
			toobig: "$file 파일은 업로드 가능한 크기를 초과했습니다.($size)"
		},
   		list:"#fileList" 		
   });				   
});	
</script>
<form action="#" id="frm" name="frm" method="post" enctype="multipart/form-data">	
	<input type="hidden" id="boardSeq" name="board_seq" value="" />	
	<input type="hidden" id="maxCnt" class="max_cnt" value="">	
	<input type="hidden" id="maxSize" class="max_size" value="">				
	<input type="hidden" id="availExt" class="avail_ext" value="">	 						
	<div class="modal_pop_cont">
		<table>
			<colgroup>
				<col style="width:10%" />
			</colgroup>
		  		<!-- 게시판 선택 -->
		  		<tr>
		  			<th>게시판</th>
					<td class="left form-inline">
					<select id="scBoardnm" class="form-control">
						<option value="">선택해주세요</option>		 				
						<c:forEach var="data" items="${ data }" >											
							<option value="${ data.board_seq }">${ data.boardnm }</option>
						</c:forEach>
					</select>
		  			</td>
		  		</tr>		  		
		  		<!-- 제목 -->		  	
		  		<tr>
		  			<th>제목</th>
		  			<td class="left">
		  				<input type="text" id="bitemTitle" name="bitem_title" class="form-control"/><br>
		  			</td>
		  		</tr>	
		  		<!-- 옵션 -->
		  		<tbody id="option"></tbody>	
		  		<!-- 파일 -->
		  		<tr id="file" style="display: none">
		  			<th>파일</th>
		  			<td class="left form-inline">                
			            	<input type="file" class="attach with-preview" name="attach" style="height:25px;padding-bottom: 5px"> 
						<div id="fileList" style="border:2px solid #c9c9c9;min-height:50px"></div><br>
					</td>			              	  			              	  	                
		  		</tr>		  			  		  			
		  		<!-- 내용 -->		  			  		  		
		  		<tr>
		  			<th>내용</th>
		  			<td class="left form-inline">
		                <textarea id="bitemBody" name="bitem_body" class="form-control" style="width:580px"></textarea><br>		  			
		  			</td>
		  		</tr>	
		  		<!-- 비밀글 -->		  	
		  		<tr>
		  			<th>비밀글</th>
		  			<td class="left form-inline">
		  				<input type="radio" id="pcdUseN" name="bitem_pcd" value="BITEM_P001" checked/>미사용
		  				<input type="radio" id="pcdUseY" name="bitem_pcd" value="BITEM_P002" />사용<br>
		  			</td>
		  		</tr>			  					  				        	  		 		
		  	</table>  	
		 <div class="btnList alignRight mTop10">
			<button type="button" id="insertItemBtn" class="btn btn-primary btn-sm" >등록</button>								
		</div>	
	</div>
</form>
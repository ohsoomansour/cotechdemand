<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<script src="${pageContext.request.contextPath}/plugins/file-uploader/jquery.dm-uploader.min.js?v=1"></script>
<script src="${pageContext.request.contextPath}/plugins/file-uploader/file-uploader.js?v=1"></script>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/plugins/file-uploader/style.css?v=1"/>

<!-- CKEditor -->
<script src="${pageContext.request.contextPath}/plugins/ckeditor/ckeditor.js?v=1" ></script>
<script src="${pageContext.request.contextPath}/plugins/multifile-master/jquery.MultiFile.js?v=1" ></script>

<script>
$(document).ready(function(){	
	var list = new Array();
	//해당부분 추후 db초기화시 삭제 예정
	var etc = {};
	etc.text = '기타'; etc.value='ETC',etc.isRequired="false";
	list.push(etc);
	//여기까지삭제
	console.log(list);
	 var options = {
    	fmstSeq:  0,
    	//fmstSeq: 11,
        types: list,
        callback: function(data){
        	if(data == 0 || data == undefined){
        		alert_popup("파일등록에 실패하였습니다. 동일 상황이 반복되면 관리자에게 문의해주세요.");
		    	return false;
		    	}
	    	doAddBoard(status,data);
		},
    };
    window.uploadSrc.create($('#uploadArea'), options);	  
    
    CKEDITOR.replace('bitemBody',{
    	filebrowserUploadUrl:'/admin/uploadEditorImg',
    		uploadUrl:'/admin/uploadEditorImg'
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

function validataCheck(){
	console.log("확인1")
	var bitemTitle = $('#bitemTitle').val();
	var bitemBody = CKEDITOR.instances.bitemBody.getData();
	if(bitemTitle == ""){
		alert_popup_focus("제목을 입력해주세요","#bitemTitle");
		return;
		}
	if(bitemBody == ""){
		alert_popup_focus("내용을 입력해주세요.","#bitemBody");
		return;
		}
	console.log("확인1",bitemTitle,bitemBody);
	uploadFile();
}

//파일업로드
function uploadFile(){
	var empty = document.getElementsByClassName('file-empty')[0];
	console.log(empty);
	if(empty==undefined){
		//파일전송후 공고등록
		uploadSrc.startUpload();
	}
	else{
		//공고등록
		doAddBoard();
	}
} 

function doAddBoard(status,fmst_seqno){
	var url = "/front/doAddBoardItem.do"
		var form = $('#frm')[0];
		var data = new FormData(form);
		if(fmst_seqno != undefined){
			data.append("fmst_seqno",fmst_seqno);
			}
		data.append("bitem_body",CKEDITOR.instances.bitemBody.getData());
		//var data = $('#frm').serialize();
			$.ajax({
			       url : url,
			       type: "post",
			       processData: false,
			       contentType: false,
			       data: data,
			       dataType: "json",
			       success : function(res){
				      if(res.result >= 0){
				    	  var action="/front/listBoardItem.do"
				    		   	
		    		   	var form = document.createElement('form');

		    		   	form.setAttribute('method', 'post');

		    		   	form.setAttribute('action', action);

		    		   	document.charset = "utf-8";

		    			var hiddenField = document.createElement('input');
		    			hiddenField.setAttribute('type', 'hidden');
		    			hiddenField.setAttribute('name', 'board_seq');
		    			hiddenField.setAttribute('value', '${ paraMap.board_seq}');
		    			
		    			form.appendChild(hiddenField);
		    		   	document.body.appendChild(form);
		    		   	alert_popup('등록 되었습니다',undefined,form);
				    	  return false;
				    	  
					      }
				      else{
				    	  alert_popup("실패 했습니다.");
					      }
			       	console.log("결과",res);   
			       },
			       error : function(){
			    	   alert_popup('게시판 등록에 실패했습니다.');    
			       },
			       complete : function(){
				       
			       	//parent.fncList();
			       	//parent.$("#dialog").dialog("close");
			       }
			});

	
}
</script>
<form action="/front/doAddBoardItem.do" id="frm" name="frm" method="post" enctype="multipart/form-data">	
<input type="hidden" id="board_seq" name="board_seq" value="${paraMap.board_seq }" />
<input type="hidden" id="seqTblnm" name="seq_tblnm" value="${ paraMap.seq_tblnm }" />
<input type="hidden" id="maxCnt" class="max_cnt" value="${ board.attf_maxcnt }">	
<input type="hidden" id="maxSize" class="max_size" value="${ board.attf_maxsize }">				
<input type="hidden" id="availExt" class="avail_ext" value="${ board.attf_availext }">	 						
<div id="compaVcContent" class="cont_cv">
  <div id="mArticle" class="assig_app">
  	<h2 class="screen_out">본문영역</h2>
  	<div class="wrap_cont">
  		<div class="area_tit" style="margin-top:40px;margin-bottom:30px;">
			<h2>문의하기</h2>
		</div>
	  	<div class="area_cont" style="border-top:1px solid;">
	  		<div class="tbl_view_tbl_public">
	  			<table class="tbl">
	  				<caption>문의게시판 문의 작성화면 페이지</caption>
					<colgroup>
						<col style="width:10%" />
						<col />
					</colgroup>
					<tbody class="view">
				  		<!-- 제목 -->		  	
				  		<tr>
				  			<th>제목</th>
				  			<td class="ta_left">
				  				<input type="text" id="bitemTitle" name="bitem_title" class="form-control" title="제목" /><br>
				  			</td>
				  		</tr>	
				  		<!-- 카테고리 -->	
						<c:if test="${ !empty ctgr }">				  		
				  		<tr>
				  			<th>카테고리</th>
				  			<td class="ta_left">
							<select name="ctgr_seq" class="form-control" title="카테고리">
								<c:forEach var="ctgr" items="${ ctgr }" >							
									<option value="${ ctgr.ctgr_seq }" title="${ ctgr.ctgrnm }">${ ctgr.ctgrnm }</option>
								</c:forEach>
							</select>				  				
				  			</td>
				  		</tr>	
				  		</c:if>			  		
				  		<!-- 내용 -->		  			  		  		
				  		<tr>
				  			<th>내용</th>
				  			<td class="ta_left">
				                <textarea id="bitemBody" name="bitem_body_re" class="form-control" style="width:580px" title="내용"></textarea><br>		  			
				  			</td>
				  		</tr>
				  		<!-- 비밀글 -->		  	
				  		<tr>
				  			<th>비밀글</th>
				  			<td class="left form-inline" style="text-align:left;">
				  				<div class="box_radioinp">
									<input type="radio" class="inp_radio" id="pcdUseN" name="bitem_pcd" value="BITEM_P001" title="비밀글 미사용" checked />
									<label for="pcdUseN" class="lab_radio"><span class="icon ico_radio"></span>미사용</label>
								</div>
								<div class="box_radioinp">
									<input type="radio" class="inp_radio" id="pcdUseY" name="bitem_pcd" value="BITEM_P002" title="비밀글 사용" />
									<label for="pcdUseY" class="lab_radio"><span class="icon ico_radio"></span>사용</label>
								</div>
				  				<!-- <input type="radio" id="pcdUseN" name="bitem_pcd" value="BITEM_P001" checked/><label for="pcdUseN">미사용</label>
				  				<input type="radio" id="pcdUseY" name="bitem_pcd" value="BITEM_P002" /><label for="pcdUseY">사용</label> -->
				  			</td>
				  		</tr>					  				        	  		 		
				  	</table>
			  		<!-- 파일 -->	
			  		<c:if test="${ board.attach_yn eq 'Y'}">
			  			<div class="ui segment">           
	       					<div id="uploadArea"></div>
	  					 </div> 
			  		</c:if>		
				  	<div class="wrap_btn _center">
				  		<a href="javascript:void(0);" onClick="validataCheck();" class="btn_appl" title="등록">등록</a> 
				  		<a href="javascript:void(0);" onClick="history.back()" class="btn_list" title="취소">취소</a> 
				  	</div> 
				  	<!-- <div class="btnList alignRight mTop10" style="float: right">
						<button id="submit" type="submit" class="btn btn-primary btn-sm" onclick="isBlank()">등록</button>
						<button type="button" id="cancelItemBtn" class="btn btn-default btn-sm" onClick="history.back()">취소</button>								
					</div>	 -->
	  		</div>
	  	</div>
		</div>
	</div>
</div>
</form>
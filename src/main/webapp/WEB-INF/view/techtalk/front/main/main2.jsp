<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<script>
function test(){
	var url = "/techtalk/check.do";
	var form = $('#frm')[0];
	var data = new FormData(form);
	$.ajax({
		url : url,
       type: "post",
       processData: false,
       contentType: false,
       data: data,
       dataType: "json",
       success : function(res){
          console.log(res);
          console.log(res.dataMap.id);
          $('#result').append(res.dataMap.id);
       },
       error : function(){
    	alert('실패했습니다.');    
       },
       complete : function(){

       }
	});  
}


</script>
<form id="frm" name="frm" action="/techtalk/check.do" method="post">
	<div id="compaVcContent" class="cont_cv">
		<div id="mArticle" class="assig_app">
			<h2 class="screen_out">본문영역</h2>
			<div class="wrap_cont">
				<!-- page_content s:  -->
				<div style="padding-top:300px;">
					<a href= "javascript:void(0);" >연구자검색 </a>
					<a href="javascript:void(0);">수요기업검색</a>
				</div>
				
				<div>
				<input type="text" id="id" name="id" value="" />
				<br/>
				<a href=javascript:void(0); onclick="test();"  >버튼</a>
				</div>
				
				
				<div>
				<textarea id="result" name="result" value=""></textarea>
				</div>
				<!-- //page_content e:  -->
			</div>
		</div>
	</div>
</form>
	

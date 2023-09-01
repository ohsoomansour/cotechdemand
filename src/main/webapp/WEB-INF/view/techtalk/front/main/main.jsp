<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<script>
function test(){
	var url = "/techtalk/tttttest.do";
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
<form id="frm" name="frm" action="/techtalk/tttttest.do" method="post" class="main_form">
	<div id="compaVcContent" class="cont_cv main_wrap">
		<div id="mArticle" class="assig_app">
			<h2 class="screen_out">본문영역</h2>
			<div class="wrap_cont">
				<!-- page_content s:  -->
				<div class="main_vi_wrap">
					<div class="main_txt_wrap">
						<h2 class="main_title_txt"><span>미래 모빌리티 분야</span><br/>기술이전 · 거래 플랫폼</h2>
						<p class="main_sub_txt">기술분야 별, 키워드 별로 연구자와 기업수요 정보를 검색,매칭하여 기술이전 및 거래를 이루어 보세요.</p>
					</div>
					<div class="main_btn_wrap">
						<a href= "/techtalk/searchResearcher.do" class="main_btn">
							<span class="main_btn_obj mbo_01">연구자검색 이미지</span>
							<span class="main_btn_title">연구자검색 </span>
						</a>
						<a href="/techtalk/searchBusiness.do" class="main_btn">
							<span class="main_btn_obj mbo_02">수요기업검색 이미지</span>
							<span class="main_btn_title">수요기업검색 </span>
						</a>
					</div>
				</div>
				
				<!-- <div>
				<input type="text" id="id" name="id" value="" />
				<br/>
				<a href=javascript:void(0); onclick="test();"  >버튼</a>
				</div> 
				
				
				<div>
				<textarea id="result" name="result" value=""></textarea>
				</div>-->
				<!-- //page_content e:  -->
			</div>
		</div>
	</div>
</form>
	

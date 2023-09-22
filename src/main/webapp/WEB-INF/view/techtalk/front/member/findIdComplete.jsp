<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<script>
$(document).on('ready', function() {
});

	//[회원가입] - 로그인 화면 이동 -> 2023/09/13 박성민
	function fncLoginPage() {
		location.href="/techtalk/login.do";
	}
</script>
<!-- compaVcContent s:  -->
<div id="compaVcContent" class="cont_cv">
	<div id="mArticle" class="assig_app">
		<h2 class="screen_out">본문영역</h2>
		<div class="wrap_cont">
			<!-- page_title s:  -->
			<div class="area_tit">
				<h3 class="tit_corp">아이디 찾기</h3>
			</div>
			<!-- //page_title e:  -->
			<!-- page_content s:  -->
			<div class="area_cont ">
	             <div class="box_complete">
	             		<h2>아이디 찾기 결과</h2>
	                 <p class="bc_list">고객님의 아이디는 ${id }입니다 </p>
	             </div>
			</div>      
            <div class="wrap_btn _center">
           		<!-- <a href="javascript:void(0);" class="btn_cancel">이메일 확인</a> -->
            	<a href="javascript:fncLoginPage();" class="btn_confirm" title="로그인하기" id="btnLogin">로그인 하기 </a>
            </div>
		</div>
	</div>
</div>

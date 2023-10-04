<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<script>
var excel = "";	// 엑셀 데이터 전역변수

$(document).ready(function(){
	$("#my-page-btn").click(function(){
		$(".my-dropdown").toggleClass('on')
	})
});

		//링크태우기 23.09.06 박성민
    function doHref(href){
				location.href = href
    }
    //로그아웃
    function doLogout() {
    	$.ajax({
    		url : "/techtalk/logoutx.do",
    		type : "POST",
    		dataType : "json",
    		success : function(resp) {
    			if (resp.result_code == "0") {
    				//alert('로그아웃 되었습니다.')
    				location.href = "/techtalk/login.do";
    			}
    			else {
    				alert_popup(resp.result_mesg);
    			}
    		}
    	});
    	return false;
    };
</script>
<div id="skip_navigation">
	<a href="#compaVcGnb" class="skip_navi sn_sub" title="주메뉴 바로가기">주메뉴 바로가기</a>
	<a href="#compaVcContent" class="skip_navi sn_sub" title="본문 바로가기">본문 바로가기</a>
</div>
<header id="compaVcHead">
	<div class="wrap_head">
		<div class="box_gnb">
			<h1 class="tit_logo">
				<a href="/techtalk/mainView.do" class="link_cv" title="메인화면">
					<span class="tit_service">TECH TALK</span>
				</a>
			</h1>
			
			<div class="user_info">
				<c:if test="${empty member_seqno}">
					<button id="loginButton" onclick="doHref('/techtalk/memberJoinFormPage.do');" title="회원가입버튼"><span class="user_name">회원가입</span></button>
					<button id="loginButton" onclick="doHref('/techtalk/login.do');" title="로그인버튼"><span class="user_name">로그인</span></button>
				</c:if>
				<c:if test="${not empty member_seqno && member_type =='R'}">
					<button id="loginButton" onclick="doHref('/techtalk/matchList.do');" title="매칭정보조회" class="user_info_n1 bell_on"><!-- <---- 클래스  bell_on:노란종 ,  bell_off: 클래스 회색종 --><span class="icon_bell"></span><span class="user_name">매칭 정보 조회</span></button>
					<!-- <button id="loginButton" onclick="javscript:void();" title="연구자"  class="user_info_n1"><span class="user_name">연구자</span></button> -->
					<div class="my-dropdown">
						<button title="user_name" id="my-page-btn" ><span class="user_name">${user_name }(${id })</span></button>
						<div class="my-dropdown-content">
						    <a href="javascript:doHref('/techtalk/memberUpdatePage.do');">내 정보 관리</a>
						    <a href="javascript:doHref('/techtalk/researchMyPage.do');">연구자 목록</a>
						    <a href="javascript:doHref('/techtalk/doChangePwdPage.do');">비밀번호 변경</a>
						</div>
					</div>
					<button id="loginButton" onclick="doLogout();" title="로그인버튼"><span class="user_name">로그아웃</span></button>
				</c:if>
				<c:if test="${not empty member_seqno && member_type =='B'}">
					<button id="loginButton" onclick="javscript:doHref('/techtalk/matchList.do');" title="매칭정보조회" class="user_info_n1 bell_on"><!-- <---- 클래스  bell_on:노란종 ,  bell_off: 클래스 회색종 --><span class="icon_bell"></span><span class="user_name">매칭 정보 조회</span></button>
					<!-- <button id="loginButton" onclick="javscript:void();" title="기업"  class="user_info_n1"><span class="user_name">기업</span></button> -->
					<div class="my-dropdown">
						<button title="user_name" id="my-page-btn" ><span class="user_name">${user_name }(${id })</span></button>
						<div class="my-dropdown-content">
						    <a href="javascript:doHref('/techtalk/memberUpdatePage.do');">내 정보 관리</a>
						    <a href="javascript:doHref('/techtalk/doChangePwdPage.do');">비밀번호 변경</a>
						</div>
					</div>
					<button id="loginButton" onclick="doLogout();" title="로그인버튼"><span class="user_name">로그아웃</span></button>
				</c:if>
				<c:if test="${not empty member_seqno && member_type =='TLO'}">
					<button id="loginButton" onclick="javscript:doHref('/techtalk/matchList.do');" title="매칭정보조회" class="user_info_n1 bell_on"><!-- <---- 클래스  bell_on:노란종 ,  bell_off: 클래스 회색종 --><span class="icon_bell"></span><span class="user_name">매칭 정보 조회</span></button>
					<!-- <button id="loginButton" onclick="javscript:void();" title="TLO"  class="user_info_n1"><span class="user_name">TLO</span></button> -->
					<div class="my-dropdown">
						<button title="user_name" id="my-page-btn" ><span class="user_name">${user_name }(${id })</span></button>
						<div class="my-dropdown-content">
						    <a href="javascript:doHref('/techtalk/memberUpdatePage.do');">내 정보 관리</a>
						    <a href="javascript:doHref('/techtalk/doChangePwdPage.do');">비밀번호 변경</a>
						    <a href="javascript:doHref('/techtalk/tloResearchMyPage.do');">연구자 목록</a>
						    <a href="#">기업수요 목록</a>
						    <a href="javascript:doHref('/techtalk/tloMatchList.do');">매칭 목록</a>
						</div>
					</div>
					<button id="loginButton" onclick="doLogout();" title="로그인버튼"><span class="user_name">로그아웃</span></button>
				</c:if>
				<c:if test="${not empty member_seqno && member_type =='ADMIN'}">
					<div class="my-dropdown">
						<button title="user_name" id="my-page-btn" ><span class="user_name">${user_name }(${id })</span></button>
						<div class="my-dropdown-content">
								<a href="javascript:doHref('/admin/member.do');">회원목록</a>
						    <a href="javascript:doHref('/techtalk/tloResearchMyPage.do');">연구자 목록</a>
						    <a href="#">기업수요 목록</a>
						    <a href="javascript:doHref('/techtalk/tloMatchList.do');">매칭 목록</a>
						</div>
					</div>
					<button id="loginButton" onclick="doLogout();" title="로그인버튼"><span class="user_name">로그아웃</span></button>
				</c:if>
			</div>
			<!-- //user_info e:  -->
		</div>
		

		<!-- 메인페이지일때만 안나오게 변경 -->
		<c:if test="${not empty navi.one}">
			<div class="box_info">
			<div class="inner_info">
				<strong class="screen_out">페이지 네비게이션</strong>
				<ul class="info_path">
					<li>
						<button type="button"  id="btnHome"  class="link_path link_home" title="홈바로가기">
							<svg version="1.1" id="Capa_3"  focusable="false" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" viewBox="0 0 512 512" style="enable-background:new 0 0 512 512;" xml:space="preserve">
								<g>
									<g>
										<path d="M475.4,200.2L262.1,4.7c-7-6.4-17.6-6.2-24.4,0.3L36.2,200.6c-3.4,3.3-5.4,8-5.4,12.8v280.9c0,9.8,8,17.8,17.8,17.8h148.1
											c9.8,0,17.8-8,17.8-17.8V363.9h83v130.4c0,9.8,8,17.8,17.8,17.8h148.1c9.8,0,17.8-8,17.8-17.8V213.3
											C481.2,208.3,479.1,203.6,475.4,200.2z M445.6,476.4H333V346.1c0-9.8-8-17.8-17.8-17.8H196.7c-9.8,0-17.8,8-17.8,17.8v130.4H66.4
											V220.9L250.4,42.2l195.2,178.9L445.6,476.4L445.6,476.4z"></path>
									</g>
								</g>
							</svg>
							<span class="screen_out" >홈</span>
						</button>
						<span class="icon ico_arr" focusable="false">&gt;</span>
					</li>
					<li> 
						<button type="button" tabindex="-1"   title="네비게이션 현재위치  - ${navi.one }" class="link_path">${navi.one }</button>
						<span class="icon ico_arr"  focusable="false">&gt;</span>
					</li>
					<li class="on">
						<em class="link_path" tabindex="-1">${navi.two }</em>
					</li>
				</ul>
			</div>
		</div>
		</c:if>
		
		<!-- 메인페이지일때만 안나오게 변경 -->
	</div>
</header>
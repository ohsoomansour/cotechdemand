<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<script>
    function doLogin(){
				location.href = "/techtalk/login.do";
    }
    function doJoin(){
		location.href = "/techtalk/memberJoinFormPage.do";
}
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
				<button id="loginButton" onclick="doLogin();" title="로그인버튼">
						<i class="icon_user">
							<svg version="1.1" id="Capa_2" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" viewBox="0 0 512 512" style="enable-background:new 0 0 512 512;" xml:space="preserve" tabindex="-1">
								<g>
									<g>
										<path d="M437,331c-27.9-27.9-61.1-48.5-97.3-61c38.8-26.7,64.3-71.4,64.3-122C404,66.4,337.6,0,256,0S108,66.4,108,148
											c0,50.5,25.5,95.3,64.3,122c-36.2,12.5-69.4,33.1-97.3,61C26.6,379.3,0,443.6,0,512h40c0-119.1,96.9-216,216-216s216,96.9,216,216
											h40C512,443.6,485.4,379.3,437,331z M256,256c-59.6,0-108-48.4-108-108S196.4,40,256,40s108,48.4,108,108S315.6,256,256,256z"></path>
									</g>
								</g>
							</svg>
						</i>
						<span class="user_name">로그인</span>
				</button>
				</div>
				<div class="user_info">
				<button id="loginButton" onclick="doJoin();" title="회원가입버튼">
						<i class="icon_user">
							<svg version="1.1" id="Capa_2" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" viewBox="0 0 512 512" style="enable-background:new 0 0 512 512;" xml:space="preserve" tabindex="-1">
								<g>
									<g>
										<path d="M437,331c-27.9-27.9-61.1-48.5-97.3-61c38.8-26.7,64.3-71.4,64.3-122C404,66.4,337.6,0,256,0S108,66.4,108,148
											c0,50.5,25.5,95.3,64.3,122c-36.2,12.5-69.4,33.1-97.3,61C26.6,379.3,0,443.6,0,512h40c0-119.1,96.9-216,216-216s216,96.9,216,216
											h40C512,443.6,485.4,379.3,437,331z M256,256c-59.6,0-108-48.4-108-108S196.4,40,256,40s108,48.4,108,108S315.6,256,256,256z"></path>
									</g>
								</g>
							</svg>
						</i>
						<span class="user_name">회원가입</span>
				</button>
			</div>
			<!-- //user_info e:  -->
		</div>
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
	</div>
</header>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<script src="/js/lms/comlib/popupLib.js"></script>
<script>
var menuList = ${requestScope.menu_list};
var menuInfo = ${menu_info};
var isShowGnb = false;

$window = $(window);

    $(document).ready(function(){
    	 $window.on('mousewheel', toggleGnb);
         toggleGnb();

        $("#btnHome").click(function(){
            location.href="/front/mainView.do";
            })
         
        $("#skip_navigation a").click(function(){
      	    $($(this).attr("href"))
      	      .attr("tabindex","0")
      	      .css("outline","0")
      	      .focus();
      	});
    	
    	
    	$('#menu4').click(function(){
			if($(this).hasClass("on") == true){
				$(".link_gnb").css("color","#1e1e1e");
				$(this).children(".link_gnb").css("color","#1e1e1e");
			}else{
				$(".link_gnb").css("color","#90a8e4");
				$(this).children(".link_gnb").css("color","#1e1e1e");
			}
			var layer = $(this);
			layer.toggleClass("on");
			$('#menu5').removeClass("on");
		});
    	$('#menu5').click(function(){
			if($(this).hasClass("on") == true){
				$(".link_gnb").css("color","#1e1e1e");
				$(this).children(".link_gnb").css("color","#1e1e1e");
			}else{
				$(".link_gnb").css("color","#90a8e4");
				$(this).children(".link_gnb").css("color","#1e1e1e");
			}
			var layer = $(this);
			layer.toggleClass("on");
			$('#menu4').removeClass("on");
		});

		// Top Button Scroll
		$(window).scroll(function(){
			if($(this).scrollTop() >= "100") {
				$(".scroll-top").addClass("fixed");
				$(".scroll-top button").attr("tabindex","0");
				 
			} else {
				$(".scroll-top").removeClass("fixed");
				$(".scroll-top button").attr("tabindex","-1");
			}
		})

		$('.scroll-top button').click(function(){
		
			$('body,html').animate({scrollTop:0}, 300);
		});

		$('#user_dropdown').click(function(){
			$('.user_info').toggleClass('on' );
		});

		$("#btnLogout").click(function() {
			doLogout();
		});

		$("#btnUpdateMember").click(function() {
			doUpdateMember();
		});

		$(".clickN").click(function(){
			alert_popup("현재 해당기능을 사용할 수 없습니다.");
		 });
    });
    function doUpdateMember(){
		location.href="/front/memberUpdatePage.do";
        }
    function doLogout() {
    	$.ajax({
    		url : "/front/logoutx.do",
    		type : "POST",
    		dataType : "json",
    		success : function(resp) {
    			if (resp.result_code == "0") {
    				//alert('로그아웃 되었습니다.')
    				location.href = "/front/login.do";
    			}
    			else {
    				alert_popup(resp.result_mesg);
    			}
    		}
    	});
    	return false;
    };
    function doLogin(){
	location.href = "/front/login.do";
        }

	/* function fncAttendCheck(){
    	$.ajax({
			url: '/front/doCountCheckAttendPoint.do',
			type: 'post',
			data: {
            },
			dataType: 'json',
			success: function(result){
				var data = result.check;
 				if(parseInt(data) > 0) {		
					alert("오늘의 출석체크는 이미 하셨습니다.");	
				}else {	 		
		 		var url = '/front/attendCheck.do';
			    openDialog({
			        title:'출석퀴즈',
			        width:600,
			        height:600,
			        url: url,  
			        closebtn : 'remove'
			    	});		
				} 
			}
		});
    }
	
	function fncPointRank(){
 		var url = '/front/rankPoint.do';
	    openDialog({
	        title:"포인트 랭크",
	        width:920,
	        height:920,
	        url: url
	     });		
	}
	
	function fncGlobal(){
		var url = '/front/global.do';
	    openDialog({
	        width:400,
	        height:250,
	        url: url,
	     });
	}
	
	 function fncLogin(){
 		var url = '/login/login.do';
	    openDialog({
	        title:"로그인",
	        width:600,
	        height:400,
	        url: url
	     });		
	} 
	
	function fncLogout() {
		$.ajax({
			url : "/front/logoutx.do",
			type : "POST",
			dataType : "json",
			success : function(resp) {
				if (resp.result_code == "0") {
					alert('로그아웃 되었습니다.')
					location.href = "/front/login.do";
				}
				else {
					alert(resp.result_mesg);
				}
			}
		});
		return false;
	}
	
	function fncSubMenu(){
		str = "";		
		$.each(menuList, function(key, menu){
			for(var i = 0; i < menu.length; i++){
				 if(menu[i].menulvl == 2){
			     	str += '<a class="main_menu" href="'+ menu[i].menuurl +'">'+ menu[i].menunm + '</a>';
				 }
			}
		});
		console.log(str);
		$('#submenuArea').append(str);
	}
	function toggleGnb(e){
        if($('body').css('overflow') == 'hidden') return;
        if(!(e && $(e.target).is('textarea'))) {
            // var top = $window.scrollTop();
            var top = getCurrentScroll();
            var delta = e ? e.originalEvent.wheelDelta || -e.originalEvent.deltaY || -e.originalEvent.detail : -top;

            if (delta >= 2 || delta <= -2) {
                if (delta < 0 && top > 1) {
                    if (!isShowGnb) {
                        isShowGnb = true;
                        $("#compaVcHead").addClass('hide-gnb');
                    }
                } else {
                    if (isShowGnb) {
                        isShowGnb = false;
                        $("#compaVcHead").removeClass('hide-gnb');
                    }
                }
            }
        }
    }

    function getCurrentScroll() {
        return $window.scrollTop();
    } */


function moveBoard(board_seq){
		var action="/front/listBoardItem.do"
    	
    	var form = document.createElement('form');

    	form.setAttribute('method', 'post');

    	form.setAttribute('action', action);

    	document.charset = "utf-8";

   		var hiddenField = document.createElement('input');
   		hiddenField.setAttribute('type', 'hidden');
   		hiddenField.setAttribute('name', 'board_seq');
   		hiddenField.setAttribute('value', board_seq);
   		
   		form.appendChild(hiddenField);
    	document.body.appendChild(form);

    	form.submit(); 	
    }

function needLogin(op){
	alert_popup_focus("로그인이 필요한 기능입니다.",op);
}
</script>
<form id="moveHeade" action="?board_seq=100" method="POST">
	<input type="hidden" id="board_seq" name="board_seq" value="" />
</form>
<div id="skip_navigation">
	<a href="#compaVcGnb" class="skip_navi sn_sub" title="주메뉴 바로가기">주메뉴 바로가기</a>
	<a href="#compaVcContent" class="skip_navi sn_sub" title="본문 바로가기">본문 바로가기</a>
</div>
<header id="compaVcHead">
	<div class="wrap_head">
		<div class="box_gnb">
			<h1 class="tit_logo">
				<c:if test="${!empty user_name}">
					<a href="/front/mainView.do" class="link_cv" title="메인화면">
						<span class="tit_service">과학기술일자리진흥원 바우처사업관리시스템</span>
					</a>
				</c:if>
				<c:if test="${empty user_name}">
					<a href="/front/login.do" class="link_cv" title="로그인">
						<span class="tit_service">과학기술일자리진흥원 바우처사업관리시스템</span>
					</a>
				</c:if>
			</h1>
			<!-- gnb s:  -->
			<c:if test="${empty user_name }">
			<nav id="compaVcGnb">
				<h2 class="screen_out">메인메뉴</h2>
				<ul class="list_gnb">
					<li class="fst_current">
						<a href="javascript:void(0);" onclick="needLogin('#tbl_project');" id="tbl_project" class="link_gnb" title="사업공고">사업공고<span class="line"></span></a>
					</li>
					<li class="fst_current">
						<a href="javascript:void(0);" onclick="needLogin('#tbl_apply');" id="tbl_apply" class="link_gnb" title="사업신청">사업신청<span class="line"></span></a>
					</li> 
					<li class="fst_current" id="menu4">
						<a href="javascript:void(0);" onclick="needLogin('#tbl_subject');" id="tbl_subject" class="link_gnb" title="사업신청">사업수행<span class="line"></span></a>
					</li>
					<li class="fst_current" id="menu5">
						<button type="button" class="link_gnb" title="사업공통">사업공통<span class="line"></span></button>
						<div class="box_sub sub_type1" style="width:300px; left:-85px;">
							<ul class="list_sub">
								<li>
									<button type="button" onclick="moveBoard('100');" title="공지사항">공지사항</button>
								</li>
								<li>
									<a href="javascript:void(0);" onclick="needLogin('#notice');" id="notice" title="통지">통지</a>
								</li>
								<li>
									<a href="javascript:void(0);" onclick="needLogin('#account');" id="account" title="사업비 집행내역">사업비 집행내역</a>
								</li>
							</ul>						
						</div>
					</li>
					<li class="fst_current">
						<button type="button" title="문의게시판" onclick="moveBoard('101');" class="link_gnb">문의게시판<span class="line"></span></button>
					</li> 
					<!-- <li class="fst_current">
						<a href="#" class="link_gnb">사업공통<span class="line"></span></a>
					</li> -->
				</ul>
			</nav>
			</c:if>
			<c:if test="${!empty user_name }">
			<nav id="compaVcGnb">
				<h2 class="screen_out">메인메뉴</h2>
				<ul class="list_gnb">
					<li class="fst_current">
						<a href="/project/list.do" class="link_gnb" title="사업공고">사업공고<span class="line"></span></a>
					</li>
					<li class="fst_current">
						<a href="/subject/applyList.do" class="link_gnb" title="사업신청">사업신청<span class="line"></span></a>
					</li> 
					<li class="fst_current" id="menu4">
						<button type="button" class="link_gnb" title="사업수행">사업수행<span class="line"></span></button>
						<div class="box_sub sub_type1">
							<ul class="list_sub">
								<li>
									<a href="/subject/contractList.do" title="협약체결">협약체결</a>
								</li>
								<li>
									<a href="/subject/permitList.do" title="사용권한부여">사용권한부여</a>
								</li>
								<li>
									<a href="/subject/settleList.do" title="사업비신청">사업비신청</a>
								</li>
								<li>
									<a href="/subject/checkList.do" title="진도점검">진도점검</a>
								</li>
								<li>
									<a href="/subject/addcheckList.do" title="현장실태조사">현장실태조사</a>
								</li>
								<li>
									<a href="/subject/surveyList.do" title="서비스만족도조사">서비스만족도조사</a>
								</li>
								<li>
									<a href="/subject/evalList.do" title="최종평가">최종평가</a>
								</li>
								<li>
									<a href="/subject/calcList.do" title="사업비정산">사업비정산</a>
								</li>
								<li> 
									<a href="/subject/traceList.do" title="추적조사">추적조사</a>
								</li>
							</ul>						
						</div>
					</li>
					<li class="fst_current" id="menu5">
						<button type="button" class="link_gnb" title="사업공통">사업공통<span class="line"></span></button>
						<div class="box_sub sub_type1" style="width:300px; left:-85px;">
							<ul class="list_sub">
								<li>
									<button type="button" onclick="moveBoard('100');" title="공지사항">공지사항</button>
								</li>
								<li>
									<a href="/front/noticeList.do" title="통지">통지</a>
								</li>
								<li>
									<a href="/front/accountBookList.do" title="사업비 집행내역">사업비 집행내역</a>
								</li>
							</ul>						
						</div>
					</li>
					<li class="fst_current">
						<button type="button" title="문의게시판" onclick="moveBoard('101');" class="link_gnb">문의게시판<span class="line"></span></button>
					</li> 
					<!-- <li class="fst_current">
						<a href="#" class="link_gnb">사업공통<span class="line"></span></a>
					</li> -->
				</ul>
			</nav>
			</c:if>
			<!-- //gnb e:  -->
			<!-- user_info s:  -->
			<c:if test="${!empty user_name}">
			<div class="user_info">
				<button id="user_dropdown" title="user">
						<i class="icon_user">
							<svg version="1.1" id="Capa_1" focusable="false" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" viewBox="0 0 512 512" style="enable-background:new 0 0 512 512;" xml:space="preserve">
								<g>
									<g>
										<path d="M437,331c-27.9-27.9-61.1-48.5-97.3-61c38.8-26.7,64.3-71.4,64.3-122C404,66.4,337.6,0,256,0S108,66.4,108,148
											c0,50.5,25.5,95.3,64.3,122c-36.2,12.5-69.4,33.1-97.3,61C26.6,379.3,0,443.6,0,512h40c0-119.1,96.9-216,216-216s216,96.9,216,216
											h40C512,443.6,485.4,379.3,437,331z M256,256c-59.6,0-108-48.4-108-108S196.4,40,256,40s108,48.4,108,108S315.6,256,256,256z"></path>
									</g>
								</g>
							</svg>
						</i>
						<span class="user_name">${user_name }</span>
				</button>
				<div class="ly_dropdown">
					<ul>
						<li tabindex="-1">
							<button type="button" id="btnUpdateMember" title="개인정보변경">
								<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512" tabindex="-1" focusable="false">
									<path d="M437 75a254 254 0 00-362 0 254 254 0 000 362 254 254 0 00362 0 254 254 0 000-362zm-21 341a225 225 0 01-320 0 225 225 0 010-320 225 225 0 01320 0 225 225 0 010 320z" tabindex="-1"></path>
									<path d="M256 90a57 57 0 100 114 57 57 0 000-114zm0 84a27 27 0 110-54 27 27 0 010 54zM256 231c-32 0-57 26-57 57v76a57 57 0 00114 0v-76c0-31-25-57-57-57zm27 133a27 27 0 01-54 0v-76a27 27 0 0154 0v76z" tabindex="-1"></path>
								  </svg>
								개인정보변경</button>
						</li>
						<li tabindex="-1">
							<button type="button"  id="btnLogout" title="로그아웃">
								<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 489.9 489.9" tabindex="-1" focusable="false">
									<path d="M468 256h1v-1l1-1v-1l1-1v-1l1-1v-2-1-2-2-1-2l-1-1v-1l-1-1-1-1v-1-1h-1l-1-1-99-99a17 17 0 00-24 24l70 70H137a17 17 0 100 34h277l-69 69a17 17 0 0012 30c4 0 8-2 12-5l98-99 1-1z" tabindex="-1"></path>
									<path d="M111 34h128a17 17 0 100-34H111C59 0 18 42 18 93v304c0 51 41 93 93 93h126a17 17 0 100-34H111c-33 0-59-27-59-59V93c0-32 26-59 59-59z" tabindex="-1"></path>
								</svg>
								로그아웃</button>
							</li>
						<!-- <li>
							<a href="#" title="시스템관리">
								<svg xmlns="http://www.w3.org/2000/svg" id="레이어_1" x="0" y="0" version="1.1" viewBox="0 0 768 768" xml:space="preserve">
									<path d="M713 301c-22 0-41-13-49-32-8-20-3-43 13-57 18-17 20-44 5-63-17-23-38-44-60-61a47 47 0 00-64 5 54 54 0 01-57 13c-20-9-33-29-32-50 2-25-16-47-41-49-28-4-57-4-85-1-25 3-43 24-42 48 1 22-12 42-32 50a55 55 0 01-57-13 47 47 0 00-63-5c-23 17-44 38-62 60a47 47 0 005 64c16 15 21 38 13 58-8 19-28 31-52 31S9 316 6 340c-3 29-4 58 0 87 3 25 28 41 50 41h1c20 0 39 13 46 32 9 20 3 43-13 57a47 47 0 00-5 63c18 23 38 43 61 61 8 7 18 11 29 11 13 0 25-6 34-16a54 54 0 0158-13c20 9 33 29 31 51-1 24 17 46 41 49a376 376 0 0086 0c24-3 42-24 42-48-1-22 12-42 31-50l18-3c15 0 30 6 40 17a47 47 0 0063 5c23-18 43-39 61-61 16-19 14-47-4-64a51 51 0 0134-89h6c23 0 43-18 46-41 3-29 3-58 0-87-3-25-28-41-49-41zm-4 115a105 105 0 00-75 178c-13 16-27 30-43 43a110 110 0 00-113-22c-38 16-64 54-65 95-20 2-41 2-61 0 0-42-25-80-64-96-12-6-25-8-39-8-28 0-55 11-75 29-15-13-30-27-42-43a105 105 0 00-73-178c-2-20-2-41 0-61 43-2 80-27 96-64 16-39 7-84-22-114 13-16 28-30 44-43a110 110 0 00113 22c38-16 64-54 65-95 20-2 40-2 60 0 1 42 26 80 65 96 12 5 25 8 39 8 28 0 55-11 74-29 16 13 30 27 43 43-29 29-37 74-22 112 16 39 53 64 95 65 2 21 2 42 0 62z" class="st0"/>
									<path d="M384 240a145 145 0 101 291 145 145 0 00-1-291zm0 236a91 91 0 111-182 91 91 0 01-1 182z" class="st0"/>
								  </svg>
								시스템관리
							</a>
							<ul>
								<li><a href="#" title="depth2">depth2</a></li>
								<li><a href="#" title="depth2">depth2</a></li>
								<li><a href="#" title="depth2">depth2</a></li>
							</ul>
						
						</li> -->
					</ul>
				</div>
			</div>
			</c:if>
			<c:if test="${empty user_name }">
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
				<div class="ly_dropdown">
					<ul>
						<li>
							<a href="/front/memberPrivacyPage.do" title="개인정보변경">
								<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512">
									<path d="M437 75a254 254 0 00-362 0 254 254 0 000 362 254 254 0 00362 0 254 254 0 000-362zm-21 341a225 225 0 01-320 0 225 225 0 010-320 225 225 0 01320 0 225 225 0 010 320z"></path>
									<path d="M256 90a57 57 0 100 114 57 57 0 000-114zm0 84a27 27 0 110-54 27 27 0 010 54zM256 231c-32 0-57 26-57 57v76a57 57 0 00114 0v-76c0-31-25-57-57-57zm27 133a27 27 0 01-54 0v-76a27 27 0 0154 0v76z"></path>
								  </svg>
								개인정보변경</a>
						</li>
						<li>
							<button type="button"  id="btnLogout" title="로그아웃">
								<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 489.9 489.9">
									<path d="M468 256h1v-1l1-1v-1l1-1v-1l1-1v-2-1-2-2-1-2l-1-1v-1l-1-1-1-1v-1-1h-1l-1-1-99-99a17 17 0 00-24 24l70 70H137a17 17 0 100 34h277l-69 69a17 17 0 0012 30c4 0 8-2 12-5l98-99 1-1z"></path>
									<path d="M111 34h128a17 17 0 100-34H111C59 0 18 42 18 93v304c0 51 41 93 93 93h126a17 17 0 100-34H111c-33 0-59-27-59-59V93c0-32 26-59 59-59z"></path>
								</svg>
								로그아웃</button>
							</li>
						<!-- <li>
							<a href="#" title="시스템관리">
								<svg xmlns="http://www.w3.org/2000/svg" id="레이어_1" x="0" y="0" version="1.1" viewBox="0 0 768 768" xml:space="preserve">
									<path d="M713 301c-22 0-41-13-49-32-8-20-3-43 13-57 18-17 20-44 5-63-17-23-38-44-60-61a47 47 0 00-64 5 54 54 0 01-57 13c-20-9-33-29-32-50 2-25-16-47-41-49-28-4-57-4-85-1-25 3-43 24-42 48 1 22-12 42-32 50a55 55 0 01-57-13 47 47 0 00-63-5c-23 17-44 38-62 60a47 47 0 005 64c16 15 21 38 13 58-8 19-28 31-52 31S9 316 6 340c-3 29-4 58 0 87 3 25 28 41 50 41h1c20 0 39 13 46 32 9 20 3 43-13 57a47 47 0 00-5 63c18 23 38 43 61 61 8 7 18 11 29 11 13 0 25-6 34-16a54 54 0 0158-13c20 9 33 29 31 51-1 24 17 46 41 49a376 376 0 0086 0c24-3 42-24 42-48-1-22 12-42 31-50l18-3c15 0 30 6 40 17a47 47 0 0063 5c23-18 43-39 61-61 16-19 14-47-4-64a51 51 0 0134-89h6c23 0 43-18 46-41 3-29 3-58 0-87-3-25-28-41-49-41zm-4 115a105 105 0 00-75 178c-13 16-27 30-43 43a110 110 0 00-113-22c-38 16-64 54-65 95-20 2-41 2-61 0 0-42-25-80-64-96-12-6-25-8-39-8-28 0-55 11-75 29-15-13-30-27-42-43a105 105 0 00-73-178c-2-20-2-41 0-61 43-2 80-27 96-64 16-39 7-84-22-114 13-16 28-30 44-43a110 110 0 00113 22c38-16 64-54 65-95 20-2 40-2 60 0 1 42 26 80 65 96 12 5 25 8 39 8 28 0 55-11 74-29 16 13 30 27 43 43-29 29-37 74-22 112 16 39 53 64 95 65 2 21 2 42 0 62z" class="st0"/>
									<path d="M384 240a145 145 0 101 291 145 145 0 00-1-291zm0 236a91 91 0 111-182 91 91 0 01-1 182z" class="st0"/>
								  </svg>
								시스템관리
							</a>
							<ul>
								<li><a href="#" title="depth2">depth2</a></li>
								<li><a href="#" title="depth2">depth2</a></li>
								<li><a href="#" title="depth2">depth2</a></li>
							</ul>
						
						</li> -->
					</ul>
				</div>
			</div>
			</c:if>
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
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<script src="/js/lms/comlib/popupLib.js"></script>
<script type="text/javascript">
var menuList = ${requestScope.menu_list};
var menuInfo = ${menu_info};

    $(document).ready(function(){
    	// 관리자 메뉴생성
		var str = '<ul>';
		var subStr = '';
		var allmenu = '';
		$.each(menuList, function(key, menu){
			
			if(menuInfo != null && menuInfo.up_cd == menu[0].menucd){
				
				$('.page_navi_area').css('display', 'block');
				
				subStr = '<h2>' + menu[0].menunm + '</h2>';			
				subStr += '<p class="pathIndicator">';
				subStr += '<span class="home"><i class="fa fa-home"></i></span>';
				subStr += '<span class="separator">&gt;</span>';
				subStr += '<span class="category">' + menu[0].menunm + '</span>';
				subStr += '<span class="separator">&gt;</span>';
				subStr += '<span class="current category">' + menuInfo.menunm + '</span>';
				subStr += '</p>';
				
				$('.page_title').append(subStr);
				
				/* str +='<li class="sidebar-dropdown active">';
				$('.category').html(menu[0].menunm);	
				$('.page-header').html(menuInfo.menunm);
				$('.current').html(menuInfo.menunm); */
			}else{
				//str +='<li class="sidebar-dropdown">';
			}

			for(var i = 0; i < menu.length; i++){
				 if(menu[i].menulvl == 1){
			     	str += '<li><a id="'+menu[i].emnunm+'">'+ menu[i].menunm + '</a>';
			     	str += '			<div class="sub_navigation">                   ';           
					str += '				<ul class="sub_inner">                     '; 
					
					//모든메뉴

					allmenu += '<li class="depth1">                                ';
					allmenu += '		<span>'+ menu[i].menunm + '</span>                ';
					allmenu += '		<ul class="depth2">                        ';
					
					for(var j = i; j < menu.length; j++){
			     		if((menu[j].menulvl == 2) && (menu[i].menucd == menu[j].upcd)){
			     			str += '<li><a id="'+menu[j].emnunm+'" class="sub_menu" href="'+ menu[j].menuurl +'">'+ menu[j].menunm + '</a><li>';
			     			allmenu += '<li><a id="'+menu[j].emnunm+'" href="'+ menu[j].menuurl +'">'+ menu[j].menunm + '</a><li>';
			     		}
			     	}
			     	str += '				</ul>                                      ';  
					str += '			</div>                                         '; 
					str += '		</li>                                              ';
					
					allmenu += '		</ul>                                      ';
					allmenu += '	</li>                                          ';
				 }
			}
				
			
		});
		
		str += '</ul>';

		$('.header_menu').append(str);	
		$('#allMenuBox').append(allmenu);	

    	$(".header_menu > ul > li").bind("mouseenter focusin", function(){ 
    		$(".header_menu > ul > li").removeClass("on");
    		$(this).find(".sub_navigation").stop().slideDown("fast");
    		$(this).addClass("on");
    	}).bind("mouseleave focusout", function(){
    		$(this).find(".sub_navigation").stop().slideUp("fast");
    		$(this).removeClass("on");
    	});

    	$("#btn_allMenu").bind("click", function(){ 
    		$(this).hide();
    		$("#btn_allClose").show();
    		$("#allMenus").stop().slideDown("fast");
    		$('html, body').css({'overflow': 'hidden', 'height': '100%'});

    		$('#element').on('scroll touchmove mousewheel', function(e) {
    		   e.preventDefault();
    		   e.stopPropagation();
    		   return false;
    		});

    	});

    	$("#btn_allClose").bind("click", function(){ 
    		$(this).hide();
    		$("#btn_allMenu").show();
    		$("#allMenus").stop().slideUp("fast");
    		$('html, body').css({'overflow': '', 'height': ''});
    		$('#element').off('scroll touchmove mousewheel');
    	});
    	
    	$('#userid').html('${sessionScope.userid}');

    	$('#langType').change(function(){
    		var lang = $(this).children('option:selected').val();	
    		fncChangeLang(lang);
    	});
    });

	function fncAttendCheck(){
    	$.ajax({
			url: '/front/doCountCheckAttendPoint.do',
			type: 'post',
			data: {
            },
			dataType: 'json',
			success: function(result){
				var data = result.check;
 				if(parseInt(data) > 0) {		
 					alert_popup("오늘의 출석체크는 이미 하셨습니다.");	
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
	
	/* function fncLogin(){
 		var url = '/login/login.do';
	    openDialog({
	        title:"로그인",
	        width:600,
	        height:400,
	        url: url
	     });		
	} */
	
	function fncLogout() {
			
		$.ajax({
			url : "/login/logoutx.do",
			type : "POST",
			dataType : "json",
			success : function(resp) {
				if (resp.result_code == "0") {

					location.href = "/";
				}
				else {
					alert_popup(resp.result_mesg);
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
	
		
</script>
<div class="top_area"> 
	<div class="header_top_menu_area">
		<div class="header_top_menu">
			<div class="header_top_menu_left">
				<c:if test="${roleyn eq 'Y'}">
					<a href="/admin/mainView.do">관라자페이지 이동</a>
				</c:if>
			</div>
			<div class="header_top_menu_right">
				<span id="userid"></span>
				<c:if test="${sessionScope.userid eq NULL}">
					<a href="/login/login.do">로그인</a>
				</c:if>
				<c:if test="${sessionScope.userid ne NULL}">
					<a href="#" onclick="fncLogout(); return false;">로그아웃</a>
				</c:if>      

				<a href="#" onclick="fncGlobal(); return false;"><img src="${pageContext.request.contextPath}/images/front/common/global.png" style="width:30px; height:30px; margin-top:3px "></a>
			</div>
		</div>
	</div>
	
	<div class="page_navi_area" style="display:none">
		<div class="page_navi_box">
			<div class="page_title">
				<!-- <h2>마이페이지</h2>
				<p class="pathIndicator">
					<span class="home"><i class="fa fa-home"></i></span>
					<span class="separator">&gt;</span>
					<span class="category">마이페이지</span>
					<span class="separator">&gt;</span>
					<span class="current category">마이페이지</span>
				</p> -->
			</div>
		</div>
	</div>		
</div>
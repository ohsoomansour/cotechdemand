<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<script>
	$(document).ready(function () {

		var menuInfo = ${menu_info};
		var menuList = ${requestScope.menu_list};	
		
		// 페이지 정보
		var str = '<h1 class="page-header"></h1>';
		
		str += '<p class="pathIndicator">';
		str +=  '<span class="home"><span class="glyphicon glyphicon-home"></span></span>';
		str +=  '<span class="separator">&gt;</span>';
		str +=  '<span class="category"></span>';
		str +=  '<span class="separator">&gt;</span>';
		str +=  '<span class="current category"></span>';
		str += '</p>';

		$('.content_wrap').prepend(str);
		
		// 관리자 메뉴생성
		str = '<ul class="nav nav-sidebar">';
		
		$.each(menuList, function(key, menu){
			
			if(menuInfo != null && menuInfo.up_cd == menu[0].menucd){
				str +='<li class="sidebar-dropdown active">';
				$('.category').html(menu[0].menunm);	
				$('.page-header').html(menuInfo.menunm);
				$('.current').html(menuInfo.menunm);
			}else{
				str +='<li class="sidebar-dropdown">';
			}
				
			str += '<a href="#"><span class="glyphicon ' + menu[0].menuicon + '"></span>' + menu[0].menunm + '</a>';
			str +=  '<div class="sidebar-submenu">';
			str +=   '<ul>';

			for(var i = 1; i < menu.length; i++){
			     str += '<li><a href="'+ menu[i].menuurl +'"><span class="glyphicon glyphicon-menu-right"></span>' + menu[i].menunm + '</a></li>';
			}
			
			str +=   '</ul>';
			str +=  '</div>';
			str +='</li>';
		});
		
		str += '</ul>';
		
		$('.sidebar').append(str);
		
		$(".nav>li").click(function(){
			$(".nav>li").removeClass("active");
			$(this).addClass("active");
		});
		
	});
</script>

<div class="sidebar"></div>


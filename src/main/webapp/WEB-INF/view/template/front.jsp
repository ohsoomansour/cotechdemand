<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ page import="java.util.Date" %>
<%
	String locale = response.getLocale().toString();
	Date dt = new Date(); long tstamp = dt.getTime();
	session = request.getSession(true);
%>
<!DOCTYPE html>
<html lang="<%=locale%>">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=1240">
    <title>TECHTALK - TBIZ</title>
    <meta name="description" content="TECHTALK - TBIZ">
    
    <script src="${pageContext.request.contextPath}/js/jquery-2.2.3.min.js?v=1"></script>
	<script>
	var isShowGnb = false;
    $window = $(window);
    
		$(document).ready(function() {
			$window.on('mousewheel', toggleGnb);
	        toggleGnb();
	        
			// family site
	        var titRelation = document.getElementsByClassName('tit_relation')[0];
	        if(titRelation.addEventListener) {
	            titRelation.addEventListener('click', function (event) {
	                if (this.parentNode.classList.contains('relation_open')) {
	                    this.parentNode.classList.remove('relation_open');
	                    this.childNodes[0].setAttribute('aria-expanded', 'false');
	                } else {
	                    this.parentNode.classList.add('relation_open');
	                    this.childNodes[0].setAttribute('aria-expanded', 'true');
	                }
	            });
	        } else {
	            titRelation.attachEvent('onclick', function (event) {
	                if (this.parentNode.classList.contains('relation_open')) {
	                    this.parentNode.classList.remove('relation_open');
	                    this.childNodes[0].setAttribute('aria-expanded', 'false');
	                } else {
	                    this.parentNode.classList.add('relation_open');
	                    this.childNodes[0].setAttribute('aria-expanded', 'true');
	                }
	            });
	        }

	        //페이지 헤더 타이틀
	        var baseTitle = "TECHTALK";
	        var checkTitleH2 = $('.area_tit').has('h2').length;
	        var checkTitleH3 = $('.area_tit').has('h3').length;
	        var headTitleH2 = $('.area_tit h2').text();
	        var headTitleH3 = $('.area_tit h3').text();
	        var setTitle = "";
	        if(checkTitleH2 > 0){
	        	setTitle = headTitleH2 + " | " + baseTitle;
		    }else if(checkTitleH3 > 0){
		    	setTitle = headTitleH3 + " | " + baseTitle;
			}else{
				setTitle = baseTitle;
			}
			
	        $('html > head > title').text(setTitle);
		});
		
		jQuery.curCSS = function(element, prop, val) {
			return jQuery(element).css(prop, val);
		} 
	    
	    jQuery.browser = {};
	    (function () {
	        jQuery.browser.msie = false;
	        jQuery.browser.version = 0;
	        if (navigator.userAgent.match(/MSIE ([0-9]+)\./)) {
	            jQuery.browser.msie = true;
	            jQuery.browser.version = RegExp.$1;
	        }
	    })();
	    
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
        }
    </script>
	<!-- Jquery Datepicker -->
	<script src="${pageContext.request.contextPath}/js/jquery-ui-1.12.1/jquery-ui.js?v=1"></script>
	<script src="${pageContext.request.contextPath}/js/jquery.mask.js?v=1"></script>
	<link href="${pageContext.request.contextPath}/js/jquery-ui-1.12.1/jquery-ui.css?v=1" rel="stylesheet"/>
	<!-- CK Editor  -->
	<script src="${pageContext.request.contextPath}/plugins/ckeditor/ckeditor.js?v=1" ></script>
	<!-- MultiFile  -->
	<script src="${pageContext.request.contextPath}/plugins/multifile-master/jquery.MultiFile.js?v=1"></script>
	
	<!-- 2021-05-18 추가 -->
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/front/common.css?v=1">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/front/font.css?v=1">
	
	<!-- common.js -->
	<script src="/js/lms/common.js?v=1"></script>
	
	
	<!-- daum address api -->
	<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
 </head>
 <body>
	<div id="compaVc">
		<tiles:insertAttribute name="head" />
		<%-- <tiles:insertAttribute name="menu" /> --%>
		<tiles:insertAttribute name="body" />
		<tiles:insertAttribute name="footer" />
	</div>
</body>
</html>